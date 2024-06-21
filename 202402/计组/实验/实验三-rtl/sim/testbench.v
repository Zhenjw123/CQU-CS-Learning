`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/04 12:34:33
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


module testbench();

reg clk;
reg rst;

wire[31:0] writedata,dataadr;
wire memwrite;


initial begin 
	clk = 1;rst <= 1;
	#50;
	rst <= 0;
end

always #10 clk <= ~clk;

top dut(clk,rst,writedata,dataadr,memwrite);

always @(posedge clk) begin
	if(memwrite) begin
		/* code */
		if(dataadr === 84 & writedata === 7) begin
			/* code */
			$display("================>Simulation succeeded");
			$stop;
		end else if(dataadr !== 80) begin
			/* code */
			$display("================>Simulation Failed");
			$stop;
		end
	end
end

endmodule
