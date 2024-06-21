`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/22 20:47:57
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    reg clk, reset;
    reg [7:0] ins;
    reg [2:0] op;
    wire [6:0] seg;
    wire [7:0] ans;
    
    top dut (
        .clk(clk),
        .reset(reset),
        .ins(ins),
        .op(op),
        .seg(seg),
        .ans(ans)
    );
    
    initial begin
        clk = 0;
        reset = 1;
        ins = 8'b00000000;
        op = 3'b000;
        #10 reset = 0; 
        #50 begin ins = 8'b00000001;op = 3'b001; end;
        #50 ins = 8'b00000010;
        #50 ins = 8'b00000110;
        #50 begin ins = 8'b00000001;op = 3'b010; end;
        #50 ins = 8'b01000010;
        #50 ins = 8'b00000110;
        #50 begin ins = 8'b00000001;op = 3'b011; end;
        #50 ins = 8'b00000010;
        #50 ins = 8'b01000110;
        #50 begin ins = 8'b00000001;op = 3'b100; end;
        #50 ins = 8'b00010010;
        #50 ins = 8'b00000110;
        #50 begin ins = 8'b00000001;op = 3'b101; end;
        #50 ins = 8'b00000010;
        #50 ins = 8'b10000110;
        #50 begin ins = 8'b00000001;op = 3'b110; end;
        #50 ins = 8'b00100010;
        #50 ins = 8'b01000110;
    end
    
    always #5 clk <= ~clk;
    
endmodule
