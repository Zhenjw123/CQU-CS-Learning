`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] pc,
	input wire[31:0] instr,
	output ena,
	output wire memwrite,
	output wire[31:0] aluout,writedata,dataaddr,
	input wire[31:0] readdata
    );

	wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,branch,overflow;
	wire[2:0] alucontrol;
// put in instruction
controller c(.opcode(instr[31:26]),
           .funct(instr[5:0]),
           .branch(branch),
           .memtoreg(memtoreg),
           .memwrite(memwrite),
           .alusrc(alusrc),
           .regdst(regdst),
           .regwrite(regwrite),
           .jump(jump),
           .alu_control(alucontrol));
// out put pc	           
datapath dp(.clk(clk),
	        .rst(rst),
	        .memtoreg(memtoreg),
	        .pcsrc(pcsrc),
	        .alusrc(alusrc),
	        .branch(branch),
	        .ena(ena),
		    .regdst(regdst),
		    .regwrite(regwrite),
		    .jump(jump),
		    .alucontrol(alucontrol),
		    .overflow(overflow),
		    .pc(pc),//Êä³öpc
		    .instr(instr),
		    .aluout(aluout),
		    .writedata(writedata),
		    .readdata(readdata),
		    .dataaddr(dataaddr));

endmodule
