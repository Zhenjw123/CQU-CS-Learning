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


module maindec(
    input [5:0]opcode,
    output wire jump,
    output wire branch,
    output wire alusrc,
    output wire memwrite,
    output wire memtoreg,
    output wire regwrite,
    output wire regdst,
    output wire pcsrc,
    output wire [1:0] alu_op
    );

assign alu_op = (opcode == 6'b000000) ? 2'b10:   // R-type
              (opcode == 6'b100011) ? 2'b00:       // lw
              (opcode == 6'b101011) ? 2'b00:       // sw
              (opcode == 6'b000100) ? 2'b01:       // beq
              (opcode == 6'b001000) ? 2'b00:       // addi
              (opcode == 6'b000010) ? 2'bxx:       // j
              2'bxx;

assign regwrite = (opcode == 6'b000000) ? 1'b1:   // R-type
              (opcode == 6'b100011) ? 1'b1:       // lw
              (opcode == 6'b101011) ? 1'b0:       // sw
              (opcode == 6'b000100) ? 1'b0:       // beq
              (opcode == 6'b001000) ? 1'b1:       // addi
              (opcode == 6'b000010) ? 1'b0:       // j
              1'bx;

assign regdst = (opcode == 6'b000000) ? 1'b1:
              (opcode == 6'b100011) ? 1'b0:
              (opcode == 6'b101011) ? 1'bx:
              (opcode == 6'b000100) ? 1'bx:
              (opcode == 6'b001000) ? 1'b0:
              (opcode == 6'b000010) ? 1'bx:
              1'bx;

assign alusrc = (opcode == 6'b000000) ? 1'b0:
              (opcode == 6'b100011) ? 1'b1:
              (opcode == 6'b101011) ? 1'b1:
              (opcode == 6'b000100) ? 1'b0:
              (opcode == 6'b001000) ? 1'b1:
              (opcode == 6'b000010) ? 1'bx:
              1'bx;

assign branch = (opcode == 6'b000000) ? 1'b0:
              (opcode == 6'b100011) ? 1'b0:
              (opcode == 6'b101011) ? 1'b0:
              (opcode == 6'b000100) ? 1'b1:
              (opcode == 6'b001000) ? 1'b0:
              (opcode == 6'b000010) ? 1'b0:
              1'bx;

assign memwrite = (opcode == 6'b000000) ? 1'b0:
              (opcode == 6'b100011) ? 1'b0:
              (opcode == 6'b101011) ? 1'b1:
              (opcode == 6'b000100) ? 1'b0:
              (opcode == 6'b001000) ? 1'b0:
              (opcode == 6'b000010) ? 1'b0:
              1'bx;

assign memtoreg = (opcode == 6'b000000) ? 1'b0:
              (opcode == 6'b100011) ? 1'b1:
              (opcode == 6'b101011) ? 1'bx:
              (opcode == 6'b000100) ? 1'bx:
              (opcode == 6'b001000) ? 1'b0:
              (opcode == 6'b000010) ? 1'bx:
              1'bx;

assign jump = (opcode == 6'b000000) ? 1'b0:
              (opcode == 6'b100011) ? 1'b0:
              (opcode == 6'b101011) ? 1'b0:
              (opcode == 6'b000100) ? 1'b0:
              (opcode == 6'b001000) ? 1'b0:
              (opcode == 6'b000010) ? 1'b1:
              1'bx;
endmodule