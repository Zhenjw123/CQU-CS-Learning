`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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
// 备注
// 增加输出instr, pc

module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite,
	output [31:0]instr,
	output [31:0] pc
    );
wire ena;
	
	wire[31:0] readdata;
    //输出pc，输入instruction
	mips mips(.clk(clk),
	           .rst(rst),
	           .pc(pc),
	           .instr(instr),
	           .memwrite(memwrite),
	           .dataaddr(dataadr),
	           .writedata(writedata),
	           .readdata(readdata),
	           .ena(ena));
	           
	inst_ram imem(.addra(pc),.clka(~clk),.dina(32'h00000000),.douta(instr),.ena(ena),.wea(4'b0000));
	data_ram dmem(.clka(~clk),.wea({{3{1'b0}},memwrite}),.addra(dataadr),.dina(writedata),.douta(readdata),.ena(1'b1));
endmodule
