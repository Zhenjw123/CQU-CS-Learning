`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/22 19:50:09
// Design Name: 
// Module Name: ALU
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


module ALU(
    input wire [2:0]op,
    input [7:0]num1,
    output reg [31:0]s
    );
    wire [31:0] A;
    assign A = {24'b0 , num1};
    wire [31:0]B = 32'h01;
    reg outflow;
    always@ (*)
    begin
        case(op)
            3'b000:begin
                 {outflow,s}=A+B;
                end
            3'b001:begin
                 s=A-B;
                end
            3'b010:begin
                 s=A&B;
            end 
            3'b011:begin
                 s=A|B;
            end 
            3'b100:begin
                 s=~A;
            end 
            3'b101:begin
                 s={A[30:0],1};
            end 
            default:begin
                s=0;
            end
        endcase
    end
endmodule
