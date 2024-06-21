`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/22 11:52:57
// Design Name: 
// Module Name: datapath
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


module datapath(
    input clk,
    input rst,
    input [31:0]instr,
    input memtoreg,
    input pcsrc,
    input alusrc,
    input branch,
	input regdst,
	input regwrite,
	input jump,
	input [2:0]alucontrol,
	input [31:0]readdata,//dataram的输出
	output ena,
	output overflow,
	output [31:0]pc,//program counter
	output [31:0]aluout,
	output [31:0]writedata,//写入dataram的数据
	output [31:0]dataaddr,
	output [4:0]WA3//写入dataram的地址
    );
// pc
wire [31:0] pc_, PCPlus4;
adder pcplus(.a(pc),.b(32'h00000004),.c(PCPlus4));
pc program_counter(.clk(clk),.RST(rst),.pc_(pc_),.ins_addr(pc),.inst_ce(ena));

// reg
//wire [4:0]WA3;
wire [31:0]RD1, RD2, WD3;
// mux to reg
defparam mux_regwrite.WIDTH = 5;
mux2 mux_regwrite(.zero(instr[20:16]),.one(instr[15:11]),.mux(regdst),.c(WA3));

regfile register(.clk(clk),.we3(regwrite),.ra1(instr[25:21]),.ra2(instr[20:16]),.wa3(WA3),.wd3(WD3),.rd1(RD1),.rd2(RD2));

// SrcB
wire [31:0]Signlmm;
signext SignExtend(.constant(instr[15:0]),.sign_extend(Signlmm));
wire [31:0]SrcB;
mux2 mux_ALUsrc(.zero(RD2),.one(Signlmm),.mux(alusrc),.c(SrcB));

// ALU
wire zero;
alu ALU(.num1(RD1),.num2(SrcB),.alu_control(alucontrol),.result(aluout),.overflow(overflow),.zero(zero));
//pcsrc
assign pcsrc = zero & branch;

// dataram
assign writedata = RD2;
assign dataaddr = aluout;
mux2 mux_regwriteData(.zero(aluout),.one(readdata),.mux(memtoreg),.c(WD3));

// PCbranch
wire [31:0]PCBranch, PCJump,PCSrc;
adder pcbranch(.a(Signlmm<<2),.b(PCPlus4),.c(PCBranch));
assign PCJump = {PCPlus4[31:28],instr[25:0]<<2};
// mux pcsrc
mux2 mux_PCSrc(.zero(PCPlus4),.one(PCBranch),.mux(pcsrc),.c(PCSrc));
// mux jump
mux2 mux_PCJump(.zero(PCSrc),.one(PCJump),.mux(jump),.c(pc_));

endmodule
