`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/22 11:52:57
// Design Name: 
// Module Name: mux2
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


module mux2
(
    zero,
    one,
    mux,
    c
    );
parameter WIDTH = 32;

input wire [WIDTH-1:0]zero;
input wire [WIDTH-1:0]one;
input wire mux;
output wire [WIDTH-1:0]c;
    
assign c = (mux==0)? zero:one;

endmodule
