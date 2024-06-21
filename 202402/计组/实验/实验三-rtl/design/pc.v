`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/15 19:48:20
// Design Name: 
// Module Name: aludec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//PC。D 触发器结构，用于储存 PC(一个周期)。需实现 2 个输入，分别为 clk, rst, 分别连接时
//钟和复位信号；需实现 2 个输出，分别为 pc, inst_ce, 分别连接指令存储器的 addra, ena 端
//口。其中 addra 位数依据 coe 文件中指令数定义；

module pc(
    input clk,
    input RST,
    input [31:0]pc_,
    output reg [31:0]ins_addr,
    output reg inst_ce
    );
// PC在每个时钟上升沿+1
reg start;
reg [1:0]count;
always@(posedge clk or posedge RST) begin
    if(RST) begin
        inst_ce<=0;
        ins_addr <= 32'h00000000;
        start <= 0;
    end
    else begin
        if(start == 0) begin
           start <= 1;
           inst_ce<=1;
           ins_addr <= 32'h00000000;
        end
        else begin
            inst_ce<=1;
            if(clk) begin
               ins_addr<=pc_;
            end               
        end
    end
end
 
/*    if(RST) begin
        inst_ce<=0;
        ins_addr <= 32'h00000000;
        start <= 0;
        count <= 0;
    end
    else begin
        if(start == 0) begin
           start <= 1;
           inst_ce<=1;
           count <= 0;
           ins_addr <= 32'h00000000;
        end
        else begin
            inst_ce<=1;
            if(clk) begin
                if(count == 3) begin
                    ins_addr<=pc_;
                    count <= 0;
                end
                else if(count < 3) begin
                    count<=count+1;
                end               
            end
        end
    end*/
//adder pcplus(.a(ins_addr),.b(32'h00000004),.c(pc_));
endmodule
