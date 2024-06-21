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


module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite,
	output [31:0] instr,pc,readdata
);

wire[31:0] pc,instr,readdata;

mips mips(
	.clk(clk),
	.rst(rst),
	.pcF(pc),
	.instrF(instr),
	.memwriteM(memwrite),
	.aluoutM(dataadr),
	.writedataM(writedata),
	.readdataM(readdata)
);

inst_ram inst_ram (
  .clka(~clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(),      // input wire [3 : 0] wea
  .addra(pc),  // input wire [31 : 0] addra
  .dina(32'b0),    // input wire [31 : 0] dina
  .douta(instr)  // output wire [31 : 0] douta
);

//inst_mem imem(~clk,pc[31:0],instr);
//data_mem dmem(~clk,memwrite,dataadr,writedata,readdata);
data_ram data_ram (
  .clka(~clk),    // input wire clka
  .ena(memwrite),      // input wire ena
  .wea({4{memwrite}}),      // input wire [3 : 0] wea
  .addra(dataadr),  // input wire [31 : 0] addra
  .dina(writedata),    // input wire [31 : 0] dina
  .douta(readdata)  // output wire [31 : 0] douta
);
endmodule
