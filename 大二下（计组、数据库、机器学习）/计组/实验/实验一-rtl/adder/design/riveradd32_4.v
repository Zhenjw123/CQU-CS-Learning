`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/22 19:46:15
// Design Name: 
// Module Name: riveradd32_4
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


module riveradd32_4(
input [31:0]a,
input [31:0]b,
output [31:0]c,//输出
input clk,
input cin,//进位
input stop,//暂停
input cout,//进位
input new//刷新
    );
    reg cout1,cout2,cout3,cout4;//4级溢出
    reg [7:0]sum1;
    reg [15:0]sum2;
    reg [23:0]sum3;
    reg [31:0]sum4;
    //1
    always@(posedge clk)
    begin
        if(new)
        begin
        cout1=0;
        sum1=0;
        end
        else if(stop)
        begin
        cout1<=cout1;
        sum1<=sum1;
        end
         else
        begin
        {cout1,sum1}<={1'b0,a[7:0]}+{1'b0,b[7:0]}+{7'b0000000,cin};
        end
    end
    //2
    always@(posedge clk)
    begin
        if(new)
        begin
        cout2<=0;
        sum2<=0;
        end
        else if(sum2)
        begin
        cout2<=cout2;
        sum2<=sum2;
        end
        else
        begin
        {cout2,sum2}<={{1'b0,a[15:8]}+{1'b0,b[15:8]}+cout1,sum1};
        end
    
    end
    //3
    always@(posedge clk)
    begin
        if(new)
        begin
        cout3<=0;
        sum3<=0;
        end
        else if(stop)
        begin
        cout3<=cout3;
        sum3<=sum3;
        end
     else
        begin
        {cout3,sum3}<={{1'b0,a[23:16]}+{1'b0,b[23:16]}+cout2,sum2};
        end
    end
    //4
    always@(posedge clk)
    begin
        if(new)
        begin
        cout4<=0;
        sum4<=0;
        end
        else if(stop)
        begin
        cout4<=cout4;
        sum4<=sum4;
        end
        else
        begin
        {cout4,sum4}<={{1'b0,a[31:24]}+{1'b0,b[31:24]}+cout3,sum3};
        end
    end
    assign c=sum4;
    assign cout=cout4;
    
endmodule
