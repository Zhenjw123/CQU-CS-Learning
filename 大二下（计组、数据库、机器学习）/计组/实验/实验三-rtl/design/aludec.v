`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/15 19:48:20
// Design Name: 
// Module Name: aludec
// Project Name: 
// Target Devices: ANBAI52
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

// 输入maindec的输出aluop和指令第6位
// 输出alu控制码
module aludec(
    input [5:0]funct,
    input [1:0]alu_op,
    output [2:0]alu_control
    );

assign alu_control = (alu_op == 2'b00)? 3'b010:
                (alu_op == 2'b01)? 3'b110:
                (alu_op == 2'b10 && funct == 6'b100000)? 3'b010:
                (alu_op == 2'b10 && funct == 6'b100010)? 3'b110:
                (alu_op == 2'b10 && funct == 6'b100100)? 3'b000:
                (alu_op == 2'b10 && funct == 6'b100101)? 3'b001:
                (alu_op == 2'b10 && funct == 6'b101010)? 3'b111:
                3'bxxx;

endmodule


