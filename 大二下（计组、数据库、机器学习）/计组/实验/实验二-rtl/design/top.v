`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 15:39:09
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
input Mhz ,
input rst2 , //ÊýÂë¹Ü
input RST , //controller
output wire jump ,
output wire branch ,
output wire alusrc ,
output wire memwrite ,
output wire memtoreg ,
output wire regwrite ,
output wire regdst ,
output wire pcsrc ,
output wire [2:0] alu_control ,
output wire [6:0] seg ,
output wire [7:0] ans
);
wire [31:0] douta ;
wire [31:0] addr ;
wire clk ;
wire ena ;
clk_div clk_div (. RST ( RST ) ,. Mhz( Mhz) ,.hz(clk));
pc pc (. RST (RST ) ,. clk( clk) ,. ins_addr ( addr ) ,. inst_ce (ena));
blk_mem_gen_0 ram (. clka (clk),
. addra ( addr ),
. douta ( douta ),
. ena( ena),
. wea (4'b0000 ),
. dina (0) ,
. rsta ( RST)
);
controller controller (
. instruction ( douta ),
. jump ( jump ),
. branch ( branch ),
. alusrc ( alusrc ),
. memwrite ( memwrite ),
. memtoreg ( memtoreg ),
. regwrite ( regwrite ),
. regdst ( regdst ),
. pcsrc ( pcsrc ),
. alu_control ( alu_control ));
display display0 (. clk (Mhz), . reset (rst2), .s( douta ), .seg (seg), . ans(ans));
endmodule
