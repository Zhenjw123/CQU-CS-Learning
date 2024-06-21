`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 15:40:08
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

module aludec (
input [5:0] funct ,
input [1:0] alu_op ,
output [2:0] alu_control
);
assign alu_control = ( alu_op == 2'b00 )? 3'b010 : //lw»òsw
( alu_op == 2'b01 )? 3'b110 : //beq
// R- type
( alu_op == 2'b10 && funct == 6'b100000 )? 3'b010 : // add
( alu_op == 2'b10 && funct == 6'b100010 )? 3'b110 : // substact
( alu_op == 2'b10 && funct == 6'b100100 )? 3'b000 : // and
( alu_op == 2'b10 && funct == 6'b100101 )? 3'b001 : // or
( alu_op == 2'b10 && funct == 6'b101010 )? 3'b111 : // SLT
3'bxxx ;
endmodule
