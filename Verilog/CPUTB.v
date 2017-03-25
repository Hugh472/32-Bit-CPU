`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:43:04 12/04/2015
// Design Name:   CPU
// Module Name:   C:/Users/ojanoudi/finalproj/CPUTB.v
// Project Name:  finalproj
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CPUTB;

	// Inputs
	reg Reset;
	reg Clk;

	// Outputs
	wire [31:0] ALUOUT;
	wire [31:0] PCOUT;
	wire [5:0] CURROP;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.Reset(Reset), 
		.Clk(Clk), 
		.ALUOUT(ALUOUT), 
		.PCOUT(PCOUT), 
		.CURROP(CURROP)
	);

always #5 Clk = ~Clk;
	initial begin
		// Initialize Inputs
		Reset = 1;
		Clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		Reset=0;
        
		// Add stimulus here

	end
     
endmodule


