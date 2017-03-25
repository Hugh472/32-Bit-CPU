`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:19 11/20/2015 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALU(A,B,ALUOp,ALUOut,BranchCond,zero);
	
parameter DATA_WIDTH = 32;
parameter ALU_SELECT_WIDTH = 4;
	
//-------------Input Ports-----------------------------
input signed [DATA_WIDTH-1:0] A;
input signed [DATA_WIDTH-1:0] B;
input[1:0] BranchCond;
input [ALU_SELECT_WIDTH-1:0] ALUOp;
//-------------Output Ports-----------------------------
output reg [DATA_WIDTH-1:0] ALUOut;
output reg zero;

always@(*)
begin
case(BranchCond)
	2'b00: zero = (B==A)? 1'b1: 1'b0; //EQUAL FLAG
	2'b01: zero = (B!=A)? 1'b1: 1'b0; //NOT EQUAL FLAG
	2'b10: zero = (B < A)? 1'b1: 1'b0; //BLT FLAG
	2'b11: zero = (B <= A)? 1'b1: 1'b0; //BLE FLAG
endcase
end


always@(A or B or ALUOp)
	begin
	case(ALUOp)
		4'b0000: ALUOut <= B;
		4'b0001: ALUOut <= ~B;
		4'b0010: ALUOut <= B+A;
		4'b0011: ALUOut <= B-A;
		4'b0100: ALUOut <= A|B;
		4'b0101: ALUOut <= B&A;
		4'b0110: ALUOut <= B^A;
		4'b0111: ALUOut <= (A<=B)? 32'd1:32'd0;
		
		endcase
	end

endmodule
