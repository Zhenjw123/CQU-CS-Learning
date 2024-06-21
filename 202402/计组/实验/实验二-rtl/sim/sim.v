`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 15:41:04
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

module sim ();
    reg clk ;
    reg RST ;
    wire ena ;
    wire jump ;
    wire branch ;
    wire alusrc ;
    wire memwrite ;
    wire memtoreg ;
    wire regwrite ;
    wire regdst ;
    wire pcsrc ;
    wire [2:0] alu_control ;
    wire [31:0] addr ;
    wire [31:0] douta ;

    pc pc (. clk (clk ) ,. RST( RST) ,. ins_addr ( addr ) ,. inst_ce (ena));

    blk_mem_gen_0 ram (
        . clka (clk),
        . addra ( addr ),
        . douta ( douta ),
        . ena( ena),
        . wea (4'b0000 ),
        . dina (0)
    );

    controller controller (
        . instruction ( douta ),
        . jump ( jump ),
        . branch ( branch ),
        . alusrc ( alusrc ),
        . memwrite ( memwrite ),
        . memtoreg ( memtoreg ),
        . regwrite ( regwrite ),
        . regdst ( regdst ),
        . pcsrc ( pcsrc ),
        . alu_control ( alu_control ));

    initial begin
        clk = 1;
        RST = 1;
        #10 RST = 0;
    end

    always #5 clk = ~ clk ;
    
endmodule