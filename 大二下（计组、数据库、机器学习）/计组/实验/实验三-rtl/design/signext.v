`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/22 11:52:57
// Design Name: 
// Module Name: signext
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


module signext(
    input [15:0]constant,
    output [31:0]sign_extend
    );
assign sign_extend = (constant[15] == 0)?{{16{1'b0}},constant[15:0]}:{{16{1'b1}},constant[15:0]};
endmodule
