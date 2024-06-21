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


module controller(
    input [5:0]opcode,  
    input [5:0]funct,
    output wire jump,
    output wire branch,
    output wire alusrc,
    output wire memwrite,
    output wire memtoreg,
    output wire regwrite,
    output wire regdst,
    output wire [2:0] alu_control
    );

wire [1:0] alu_op;

maindec maindec(
    .opcode(opcode),
    .jump(jump),
    .branch(branch),
    .alusrc(alusrc),
    .memwrite(memwrite),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .regdst(regdst),
    .alu_op(alu_op));
    
aludec aludec(.funct(funct),.alu_op(alu_op),.alu_control(alu_control));
    
endmodule
    