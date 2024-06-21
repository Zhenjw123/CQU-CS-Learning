`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/22 20:41:20
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
    input wire clk,reset,
    input wire [7:0] ins,
    input wire [2:0] op,
    output wire [6:0]seg,
    output wire [7:0]ans
    );
    wire [31:0] s;
    
    ALU U1(op,ins,s);
    display U2(clk,reset,s,seg,ans);
endmodule
