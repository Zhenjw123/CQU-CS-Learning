`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 15:40:45
// Design Name: 
// Module Name: controller
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
module controller (
input [31:0] instruction ,
output wire jump ,
output wire branch ,
output wire alusrc ,
output wire memwrite ,
output wire memtoreg ,
output wire regwrite ,
output wire regdst ,
output wire pcsrc ,
output wire [2:0] alu_control
);
wire [1:0] alu_op ;
wire [5:0] inst_high ;
wire [5:0] inst_low ;
assign inst_high = instruction [31:26];
assign inst_low = instruction [5:0];
//指令类型
maindec maindec (
.op( inst_high ), //高6位
. jump ( jump ),
. branch ( branch ),
. alusrc ( alusrc ),
. memwrite ( memwrite ),
. memtoreg ( memtoreg ),
. regwrite ( regwrite ),
. regdst ( regdst ),
. pcsrc ( pcsrc ),
. alu_op ( alu_op )); //ALU模块指令
// alu控制信号alu_control
aludec aludec (. funct ( inst_low ) ,. alu_op ( alu_op ) ,. alu_control ( alu_control ));
endmodule
