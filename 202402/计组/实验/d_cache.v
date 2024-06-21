module d_cache (
    input wire clk, rst,
    //mips core
    input         cpu_data_req     ,
    input         cpu_data_wr      ,
    input  [1 :0] cpu_data_size    ,
    input  [31:0] cpu_data_addr    ,
    input  [31:0] cpu_data_wdata   ,
    output [31:0] cpu_data_rdata   ,
    output        cpu_data_addr_ok ,
    output        cpu_data_data_ok ,

    //axi interface
    output         cache_data_req     ,
    output         cache_data_wr      ,
    output  [1 :0] cache_data_size    ,
    output  [31:0] cache_data_addr    ,
    output  [31:0] cache_data_wdata   ,
    input   [31:0] cache_data_rdata   ,
    input          cache_data_addr_ok ,
    input          cache_data_data_ok 
);
    //Cache配置
    parameter  INDEX_WIDTH  = 10, OFFSET_WIDTH = 2;
    localparam TAG_WIDTH    = 32 - INDEX_WIDTH - OFFSET_WIDTH;
    localparam CACHE_DEEPTH = 1 << INDEX_WIDTH;
    
    //Cache存储单元
    reg                     cache_valid [CACHE_DEEPTH - 1 : 0];
    reg [TAG_WIDTH-1:0]     cache_tag   [CACHE_DEEPTH - 1 : 0];
    reg [31:0]              cache_block [CACHE_DEEPTH - 1 : 0];

    reg                     cache_written [CACHE_DEEPTH - 1 : 0];
    reg [OFFSET_WIDTH-1:0]  cache_offset [CACHE_DEEPTH - 1 : 0];

    //访问地址分解
    wire [OFFSET_WIDTH-1:0] offset;
    wire [INDEX_WIDTH-1:0] index;
    wire [TAG_WIDTH-1:0] tag;
    
    assign offset = cpu_data_addr[OFFSET_WIDTH - 1 : 0];
    assign index = cpu_data_addr[INDEX_WIDTH + OFFSET_WIDTH - 1 : OFFSET_WIDTH];
    assign tag = cpu_data_addr[31 : INDEX_WIDTH + OFFSET_WIDTH];

    //访问Cache line
    wire c_valid;                       //有效位
    wire [TAG_WIDTH-1:0] c_tag;         //标记位
    wire [31:0] c_block;                //数据位
    wire c_written;                     //脏位
    wire [OFFSET_WIDTH-1:0] c_offset;   //字节偏移
    wire [31:0] c_addr;                 //存到内存中的地址

    assign c_valid = cache_valid[index];
    assign c_tag   = cache_tag  [index];
    assign c_block = cache_block[index];
    assign c_written = cache_written[index];
    assign c_offset = cache_offset[index];
    assign c_addr = {c_tag,index,c_offset};//标记+索引+字节偏移

    //判断是否命中
    wire hit, miss;
    assign hit = c_valid & (c_tag == tag);  //cache line的valid位为1，且tag与地址中tag相等
    assign miss = ~hit;

    //读或写
    wire read, write;
    assign write = cpu_data_wr;//写使能
    assign read = ~write;

    //FSM
    parameter IDLE = 2'b00, RM = 2'b01, WM = 2'b11;
    reg [1:0] state;
    always @(posedge clk) begin
        if(rst) begin
            state <= IDLE;
        end
        else begin
            case(state)
                //状态保持：命中始终是IDLE；
                //写缺失读缺失，都要写入cache，判断脏位；
                //无论有无脏位,读缺失还需要读内存
                /*IDLE:   state <= cpu_data_req & read & miss ? RM :
                                 cpu_data_req & read & hit  ? IDLE :
                                 cpu_data_req & write       ? WM : IDLE;*/
                IDLE:   state <= cpu_data_req & hit  ? IDLE :
                                 cpu_data_req & miss & c_written ? WM :
                                 cpu_data_req & read & miss? RM: IDLE;
                RM:     state <= cache_data_data_ok ? IDLE : RM;
                WM:     state <= ~cache_data_data_ok ? WM : 
                                 read ? RM : IDLE;
            endcase
        end
    end

    //读内存
    //变量read_req, addr_rcv, read_finish用于构造类sram信号。
    wire read_req;      //1次完整的读事务，从发出读请求到结束
    reg addr_rcv;       //地址接收成功(addr_ok)后到结束
    wire read_finish;   //数据接收成功(data_ok)，即读请求结束
    always @(posedge clk) begin
        addr_rcv <= rst ? 1'b0 :
                    read & cache_data_req & cache_data_addr_ok ? 1'b1 :
                    read_finish ? 1'b0 : addr_rcv;
    end
    assign read_req = state==RM;
    assign read_finish = read_req & cache_data_data_ok;

    //写内存
    wire write_req;   //wm状态，则置1     
    wire write_finish;   
    assign write_req = state==WM;
    assign write_finish = write_req & cache_data_data_ok;

    //output to mips core
    assign cpu_data_rdata   = hit ? c_block : cache_data_rdata;
    assign cpu_data_addr_ok = cpu_data_req & hit ;//| cache_data_req & cache_data_addr_ok;
    assign cpu_data_data_ok = cpu_data_req & hit ;//| cache_data_data_ok;

    //output to axi interface
    assign cache_data_req = read_req | write_req;
    //assign cache_data_req   = read_req & ~addr_rcv | write_req & ~waddr_rcv;
    //写入内存的的数据：wdata，写使能：wr，写入的地址：addr
    assign cache_data_wr    = write_req?1:0;
    //assign cache_data_wr    = cpu_data_wr;
    assign cache_data_size  = cpu_data_size;

    assign cache_data_addr  = write_req?c_addr:cpu_data_addr;
    //assign cache_data_addr  = cpu_data_addr;
    //内存地址
    assign cache_data_wdata = write_req?c_block:cpu_data_wdata;
    //assign cache_data_wdata = cpu_data_wdata;
    //写入内存的数据

    //写入Cache
    //保存地址中的tag, index，防止addr发生改变
    /*reg [TAG_WIDTH-1:0] tag_save;
    reg [INDEX_WIDTH-1:0] index_save;
    reg [OFFSET_WIDTH-1:0] offset_save;
    always @(posedge clk) begin
        tag_save   <= rst ? 0 :
                      cpu_data_req ? tag : tag_save;
        index_save <= rst ? 0 :
                      cpu_data_req ? index : index_save;
        offset_save<= rst ? 0 :
                      cpu_data_req ? offset : offset_save;
    end
    */
    wire [31:0] write_cache_data;
    wire [3:0] write_mask;

    
     //根据地址低两位和size，生成写掩码（针对sb，sh等不是写完整一个字的指令），4位对应1个字（4字节）中每个字的写使能
    assign write_mask = cpu_data_size==2'b00 ?
                            (cpu_data_addr[1] ? (cpu_data_addr[0] ? 4'b1000 : 4'b0100):
                                                (cpu_data_addr[0] ? 4'b0010 : 4'b0001)) :
                            (cpu_data_size==2'b01 ? (cpu_data_addr[1] ? 4'b1100 : 4'b0011) : 4'b1111);

    //掩码的使用：位为1的代表需要更新的。
    //位拓展：{8{1'b1}} -> 8'b11111111
    //new_data = old_data & ~mask | write_data & mask
    assign write_cache_data = cache_block[index] & ~{{8{write_mask[3]}}, {8{write_mask[2]}}, {8{write_mask[1]}}, {8{write_mask[0]}}} | 
                              cpu_data_wdata & {{8{write_mask[3]}}, {8{write_mask[2]}}, {8{write_mask[1]}}, {8{write_mask[0]}}};
    
    //assign write_cache_data = cpu_data_wdata;
    integer t;
    always @(posedge clk) begin
        if(rst) begin
            for(t=0; t<CACHE_DEEPTH; t=t+1) begin   //刚开始将Cache置为无效
                cache_valid[t] <= 0;
                cache_written[t] <= 0;
            end
        end
        else begin
            if(read_finish) begin //读缺失，访存结束
                cache_valid[index] <= 1'b1;             //将Cache line置为有效
                cache_tag  [index] <= tag;
                cache_offset[index] <= offset;
                cache_block[index] <= cache_data_rdata; //写入Cache line
                cache_written[index] <= 1'b0;
            end
            
            //接下来是写，写命中和写缺失都是写入cache，区别是写命中时如果替换了已经修改的值，写入内存
            //写回策略中，写命中写入cache，不写入内存，除非被替换；写缺失时写入cache不写入内存
            else if (write_finish & write) begin                //写缺失+有脏位，写入内存和cache
                cache_block[index] <= write_cache_data;      
                cache_written[index] <= 1'b1;
                cache_valid[index] <= 1'b1;   
                cache_tag  [index] <= tag;
                cache_offset[index] <= offset;
            end
            else if(write & hit) begin   //写命中时要写Cache
                cache_block[index] <= write_cache_data;  //写入Cache line，使用index而不是index_save
                cache_written[index] <= 1;
                cache_offset[index] <= offset;
            end
            else if(write & (state == IDLE) & miss) begin   //写缺失时写Cache,当不存在脏位时（一般是Miss）
                cache_block[index] <= write_cache_data;      
                cache_written[index] <= 1'b1;
                cache_valid[index] <= 1'b1;   
                cache_tag  [index] <= tag;
                cache_offset[index] <= offset;
            end
        end
    end
endmodule