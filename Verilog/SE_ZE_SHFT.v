`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:32:52 12/06/2015 
// Design Name: 
// Module Name:    SE_ZE_SHFT 
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
module SE_ZE_SHFT(in, out, sel);
input [15:0] in;
input [1:0] sel;
output reg [31:0] out;
//
always@(*)
	begin
		case(sel)
			2'b00: out <= {16'b0000000000000000,in}; //ZERO EXTEND
			2'b01: out <= {14'b00000000000000,in,2'b00}; //2 SHIFT LEFT
			2'b10: out <= {in,16'b0000000000000000};//ZERO EXTEND OPTION 2 FOR LUI
			2'b11: begin case(in[15]) //SIGN EXTEND
								1'b1: out <= {16'b1111111111111111,in};
								1'b0: out <= {16'b0000000000000000,in};
							 endcase
					 end
		endcase
	end	
endmodule 