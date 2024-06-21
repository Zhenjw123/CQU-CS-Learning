`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/22 20:18:34
// Design Name: 
// Module Name: sim
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


module sim();
reg [31:0]a=32'b0011_0100_1010_1010_1111_1000_1101_0101;
reg [31:0]b=32'b0011_0100_1010_1010_1111_1000_1101_0101;
reg clk=1;
reg stop=0;
reg cin=0;
reg new=0;
wire cout;
wire [31:0]c;
reg [4:0]count=5'b00000;

riveradd32_4 aha(a,b,c,clk,stop,new,cin,cout);
    always
    begin
    #5 clk=~clk;
    end
    initial begin
    #1 a=32'b0011_0100_1010_1010_1111_1000_1101_0101;b=32'b0011_0100_1010_1010_1111_1000_1101_0101;count=5'b00000;
    
    end
    
    always @(posedge clk )
    begin
    count=count+1;
   if(count==5'b01010)
   begin
   stop=1;
   end
  else if(count==5'b01100)
   begin
   stop=0;
   end
  else if(count==5'b01111)
   begin
 new=1;
   end
   else if(count==5'b10000)
   $stop;
 
    end





endmodule
