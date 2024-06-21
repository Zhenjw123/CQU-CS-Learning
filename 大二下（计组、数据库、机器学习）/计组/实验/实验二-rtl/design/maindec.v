`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 15:40:25
// Design Name: 
// Module Name: maindec
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


module maindec (
input [5:0] op , // 指 令 Inst 的 高 6 位 op
output wire regwrite , // 是 否 需 要 写 寄 存 器 堆
output wire regdst , // 写 入 寄 存 器 堆 的 地 址 是 rt 还 是 rd
output wire alusrc , // 送 入 ALU B 端 口 的 值 是 立 即 数 的 32 位 扩 展 / 寄 存 器 堆 读 取 的 值
output wire pcsrc , // 表 示 下 一 个 pc 是 跳 转 1/ 正 常 0
output wire branch , // 是 否 为 branch 指 令 并 且 满 足 branch 条 件
output wire memwrite , // 是 否 需 要 写 数 据 存 储 器
output wire memtoreg , // 标 识 回 写 的 数 据 来 自 于 ALU 计 算 / 存 储 器 读 取 的 数 据
output wire jump , //jump 指 令
output wire [1:0] alu_op // 输 出 2 位 的 aluop
);
reg [1:0] aluop_reg ; // 存 储 alu_op 
reg [7:0] sigs ;
assign alu_op = aluop_reg ;
assign { regwrite , regdst , alusrc , pcsrc , branch , memwrite , memtoreg , jump } =
sigs ; // 合 并 
// 译 码 
always@ (*) begin
case (op)
6'b000000 : begin
aluop_reg <= 2'b10;
sigs <= 8'b1100_0000 ;
end
6'b100011 : begin
aluop_reg <= 2'b00;
sigs <= 8'b1010_0010 ;
end
6'b101011 : begin
aluop_reg <= 2'b00;
sigs <= 8'b0x10_01x0 ;
end
6'b000100 : begin
aluop_reg <= 2'b01;
sigs <= 8'b0x01_10x0 ;
end
6'b001000 : begin
aluop_reg <= 2'b00;
sigs <= 8'b1010_0000 ;
end
6'b000010 : begin
aluop_reg <= 2'bxx;
sigs <= 8'b0xxx_x0x1 ;
end
default : begin
// 如 果 没 有 指 令 的 情 冿
aluop_reg <= 2'b00;
sigs <= 8'b0000_0000 ;
end
endcase
end
endmodule

