`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 15:39:45
// Design Name: 
// Module Name: pc
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

module pc(
input clk ,
input RST ,
output [31:0] ins_addr , //µØÖ·
output reg inst_ce //Ê¹ÄÜ
);
reg [31:0] data = 32'b0;
always@ ( posedge clk or posedge RST) begin
if( RST) begin 
inst_ce <= 0;
data <= 32'b0;
end
else begin
inst_ce <= 1;
if( data >= 32'h00000014 && clk) begin
data <= 0;
end
else if(clk) begin
data <= data + 32'h00000004 ;
end
end
end
assign ins_addr = data ;
endmodule
