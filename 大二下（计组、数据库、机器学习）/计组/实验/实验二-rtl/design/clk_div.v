`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 15:39:26
// Design Name: 
// Module Name: clk_div
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

module clk_div (
input Mhz ,
input RST ,
output reg hz
);
reg [27:0] count ;
always@ ( posedge Mhz or posedge RST) begin
if( RST) begin
hz <= 1'b0;
count <= 27'b0;
end
else begin
if( count + 1 >= 27'd100_000_000 ) begin
count <= 27'b0;
hz <= ~hz;
end
else
count <= count + 27'b1;
end
end
endmodule