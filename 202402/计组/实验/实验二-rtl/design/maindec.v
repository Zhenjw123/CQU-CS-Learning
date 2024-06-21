`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 15:40:25
// Design Name: 
// Module Name: maindec
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


module maindec (
input [5:0] op , // ָ �� Inst �� �� 6 λ op
output wire regwrite , // �� �� �� Ҫ д �� �� �� ��
output wire regdst , // д �� �� �� �� �� �� �� ַ �� rt �� �� rd
output wire alusrc , // �� �� ALU B �� �� �� ֵ �� �� �� �� �� 32 λ �� չ / �� �� �� �� �� ȡ �� ֵ
output wire pcsrc , // �� ʾ �� һ �� pc �� �� ת 1/ �� �� 0
output wire branch , // �� �� Ϊ branch ָ �� �� �� �� �� branch �� ��
output wire memwrite , // �� �� �� Ҫ д �� �� �� �� ��
output wire memtoreg , // �� ʶ �� д �� �� �� �� �� �� ALU �� �� / �� �� �� �� ȡ �� �� ��
output wire jump , //jump ָ ��
output wire [1:0] alu_op // �� �� 2 λ �� aluop
);
reg [1:0] aluop_reg ; // �� �� alu_op 
reg [7:0] sigs ;
assign alu_op = aluop_reg ;
assign { regwrite , regdst , alusrc , pcsrc , branch , memwrite , memtoreg , jump } =
sigs ; // �� �� 
// �� �� 
always@ (*) begin
case (op)
6'b000000 : begin
aluop_reg <= 2'b10;
sigs <= 8'b1100_0000 ;
end
6'b100011 : begin
aluop_reg <= 2'b00;
sigs <= 8'b1010_0010 ;
end
6'b101011 : begin
aluop_reg <= 2'b00;
sigs <= 8'b0x10_01x0 ;
end
6'b000100 : begin
aluop_reg <= 2'b01;
sigs <= 8'b0x01_10x0 ;
end
6'b001000 : begin
aluop_reg <= 2'b00;
sigs <= 8'b1010_0000 ;
end
6'b000010 : begin
aluop_reg <= 2'bxx;
sigs <= 8'b0xxx_x0x1 ;
end
default : begin
// �� �� û �� ָ �� �� �� ��
aluop_reg <= 2'b00;
sigs <= 8'b0000_0000 ;
end
endcase
end
endmodule

