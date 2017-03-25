`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:21 11/16/2015 
// Design Name: 
// Module Name:    control
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
module control(PCWriteCond,PCWrite,MemWrite,MemtoReg,IRWrite,BranchCond,PCSource,ALUOp,ALUSrcB,ALUSrcA,RegRead,RegWrite,SZS,RegDst,OPCODE,Reset,Clk, STATE,MDRWrite);

//-------------Input Ports-----------------------------
input Clk, Reset; //global
input [5:0] OPCODE; //6 bits from input instruction
//-------------Output Ports-----------------------------
output reg PCWriteCond,PCWrite,MemWrite,IRWrite,RegRead,RegWrite,MemtoReg,MDRWrite;
output reg [1:0] PCSource,SZS,ALUSrcB,BranchCond,RegDst;
output reg [2:0] ALUSrcA;
output reg [3:0] ALUOp;
output [4:0] STATE;
//-------------Internal Vars------------------------------------
reg [4:0] state;
reg [4:0] nextstate;	
assign STATE = state;
//-------------Code-----------------------------

//STATES
	parameter S0=0;
	parameter S1=1;
	parameter S2=2;
	parameter S3=3;
	parameter S4=4;
	parameter S5=5;
	parameter S6=6;
	parameter S7=7;
	parameter S8=8;
	parameter S9=9;
	parameter S10=10;
	parameter S11=11;
	parameter S12=12;
	parameter S13=13;
	parameter S14=14;
	parameter S15=15;
	parameter S16=16;

//INSTRUCTIONS	
	parameter MOV = 6'b010000;
	parameter NOT = 6'b010001;
	parameter ADD = 6'b010010;
	parameter SUB = 6'b010011;
	parameter OR  = 6'b010100;
	parameter AND = 6'b010101;
	parameter XOR = 6'b010110;
	parameter SLT = 6'b010111;
	parameter JUMP = 6'b000001;
	parameter ADDI = 6'b110010;
	parameter SUBI = 6'b110011;
	parameter SLTI = 6'b110111;
	parameter ORI = 6'b110100;
	parameter ANDI = 6'b110101;
	parameter LI = 6'b111001;
	parameter SWI = 6'b111100;
	parameter LW =6'b111101;	
	parameter SW = 6'b111110;
	parameter LWI = 6'b111011;
	parameter BEQ = 6'b100000;
	parameter BNE = 6'b100001;
	parameter NOOP = 6'b000000;
	parameter LUI = 6'b111010;
	parameter BLT = 6'b100010;
	parameter BLE = 6'b100011;
	parameter JAL = 6'b000011;
	parameter XORI = 110110;
	
//ALU OPERATIONS
	parameter aluMOV = 4'b0000;
	parameter aluNOT = 4'b0001;
	parameter aluADD = 4'b0010;
	parameter aluSUB = 4'b0011;
	parameter aluOR = 4'b0100;
	parameter aluAND = 4'b0101;
	parameter aluXOR = 4'b0110;
	parameter aluSLT = 4'b0111;
	
 
	always@(posedge Clk)
	begin
	state <= nextstate;
	end
	
	always@(*)
	begin
		if(Reset)
			begin
			   ALUOp <= aluMOV;
				ALUSrcB <= 2'b00;
				ALUSrcA <= 3'b000;
				PCSource <= 2'b00;
				RegWrite <= 1'b1;
				RegDst <= 2'b00;
				PCWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				BranchCond <= 2'b00;
				RegRead <= 1'b0;
				IRWrite <= 1'b0;
				MemtoReg <= 1'b0;
				MemWrite <= 1'b0;
				SZS <= 2'b11;
			   nextstate <= 0;
			end
			
		else 
			begin
			 case(state)
					S0: //IF
						begin	
								 ALUSrcA <= 3'b000;
								 ALUSrcB <= 2'b01;
								 ALUOp <= aluADD;
								 IRWrite <= 1'b1;
								 PCWrite <= 1'b1;
								 PCSource <= 2'b00;
								 RegRead <= 1'b1;
								 MemtoReg <= 1'b0;
								 PCWriteCond <= 1'b0;
								 MemWrite <= 1'b0;
								 RegWrite <= 1'b0;
								 BranchCond <= 2'b00;
								 SZS <= 2'b11;
								 RegDst <= 2'b00;
								 nextstate <= S1;
								 MDRWrite <= 1'b0;
								 
						end

					S1: begin //ID  
								ALUSrcB <= 2'b10;
								ALUOp <= aluADD;
								IRWrite <= 1'b0;
								PCWrite <= 1'b0;
								RegRead <= 1'b0;
								RegWrite <= 1'b0;
									PCWriteCond <= 1'b0;
									IRWrite <= 1'b0;
						 
						 case(OPCODE)
									//BRANCH INSTRUCTIONS
									BEQ: nextstate <= S2;
									BNE: nextstate <= S2;
									BLT: nextstate <= S2;
									BLE: nextstate <= S2;
									//RTYPE INSTRUCTIONS
									MOV:    begin nextstate <= S3;
												RegRead <= 1'b1; end
									NOT:    begin nextstate <= S3;
												RegRead <= 1'b1; end
									ADD:    begin nextstate <= S3;
												RegRead <= 1'b1; end
									SUB:    begin nextstate <= S3;
												ALUSrcA <= 3'b001;//dfasdf
												RegRead <= 1'b1; end
									OR:    begin nextstate <= S3;
												RegRead <= 1'b1; end
									AND:    begin nextstate <= S3;
												RegRead <= 1'b1; end
									SLT:    begin nextstate <= S3;
												RegRead <= 1'b1; end
									//JUMP, JAL, AND NOOP
									JUMP: nextstate <= S16;
									JAL:    begin nextstate <= S8;
												ALUSrcB <= 2'b01; end
									NOOP: nextstate <= S14;
									//lOGICAL ARITHMETIC I TYPE 
									ADDI: nextstate <= S5;
									SUBI: nextstate <= S5;
									SLTI: nextstate <= S5;
									ORI: nextstate <= S5;
									ANDI: nextstate <= S5;
									XORI: nextstate <= S5;
									//REST
									//LWI/SWI/LI/LUI/LW
									LW: nextstate <= S6;   
									SWI: nextstate <= S6;
									LWI: nextstate <= S6;
									LI: nextstate <= S6;
									LUI: nextstate <= S6;
									SW: nextstate <= S7;
						 endcase
						 end

					S2:begin//END OF BRANCH INSTRUCTIONS
					ALUSrcA <= 3'b001;
					ALUSrcB <= 2'b00;
					PCSource <= 2'b01;
					PCWriteCond <= 1'b1;
					SZS <= 2'b11;
					case(OPCODE)
							BEQ:begin
							BranchCond <= 2'b00;		
							ALUOp <= aluSUB;
						end
							BNE:begin
							BranchCond <= 2'b01;		
							ALUOp <= aluSUB;
						end
							BLT:begin
							BranchCond <= 2'b10;		
							ALUOp <= aluSLT;
						end
							BLE:begin
							BranchCond <= 2'b11;		
							ALUOp <= aluSLT;
						end
					endcase
					nextstate <= S0;
				end
						
					S3: begin//EX RTYPE
					RegRead <= 1'b0;
					ALUSrcB <= 2'b00;
					case(OPCODE)
						MOV: begin 
						ALUOp <= aluMOV;
						ALUSrcA <= 3'b001;
						end
						NOT:begin 
						ALUOp <= aluNOT;
						ALUSrcA <= 3'b001;//was 001
						end
						ADD: begin 
						ALUOp <= aluADD;
						ALUSrcA <= 3'b001;//was 001
						end
						SUB: begin 
						ALUOp <= aluSUB;
						ALUSrcA <= 3'b001;//was 001
						end
						OR:begin
						ALUOp <= aluOR;
						ALUSrcA <= 3'b001;
						end
						AND:begin
						ALUOp <= aluAND;
						ALUSrcA <= 3'b001;//was 001
						end
						XOR: begin 
						ALUOp <= aluXOR;
						ALUSrcA <= 3'b001;//was 001
						end
						SLT: begin 
						ALUOp <= aluSLT;
						ALUSrcA <= 3'b001;//was 001
						end
					endcase
					nextstate <= S11;
					end
					
					
					S5: begin
					case(OPCODE)
						ADDI:begin
							ALUSrcA <= 3'b100;
							ALUSrcB <= 2'b10;
							ALUOp <= aluADD;
							SZS <= 2'b11;
						end
						SUBI:begin
							ALUSrcA <= 3'b011;//WAS 100
							ALUSrcB <= 2'b11;
							ALUOp <= aluSUB;
							SZS <= 2'b11;
						end
						ORI:begin
							ALUSrcA <= 3'b100;
							ALUSrcB <= 2'b10;
							ALUOp <= aluOR;
							SZS <= 2'b11;
						end
						ANDI:begin
							ALUSrcA <= 3'b100;
							ALUSrcB <= 2'b10;
							ALUOp <= aluAND;
							SZS <= 2'b11;
						end
						XORI:begin
							ALUSrcA = 3'b100;
							ALUSrcB <= 2'b10;
							ALUOp <= aluXOR;
							SZS <= 2'b11;
						end
						SLTI:begin
							ALUSrcA <= 3'b100;
							ALUSrcB <= 2'b10;
							ALUOp <= aluSLT;
							SZS <= 2'b11;
						end
					endcase
					nextstate <= S15;
					end

					S6: begin //EX
					case(OPCODE)
					LW:begin
						ALUSrcA <= 3'b011;
						ALUSrcB <= 2'b00;
						ALUOp <= aluADD;
						nextstate <= S9;
					end
					LWI:begin
						ALUSrcA <= 3'b010;
						ALUSrcB <= 2'b10;
						ALUOp <= aluADD;
						nextstate <= S9;
					end
					LI:begin
						ALUSrcA <= 3'b010;
						ALUSrcB <= 2'b10;
						ALUOp <= aluOR;
						nextstate <= S9;
					end
					LUI:begin
						ALUSrcA <= 3'b001;
						ALUSrcB <= 2'b10;
						ALUOp <= aluOR;
						nextstate <= S9;
					end
					SWI:begin
						ALUSrcA <= 3'b010;
						ALUSrcB <= 2'b10;
						ALUOp <= aluOR;
						nextstate <= S10;
					end
					endcase
					end


					S7: begin
					   SZS <= 2'b11;
						ALUSrcA <= 3'b001;
						ALUSrcB <= 2'b10;
						ALUOp <= aluADD;
						nextstate <= S13;
					end

					S8: begin//END OF JAL
						PCSource <= 2'b10;
						PCWrite <= 1'b1;
						RegDst <= 2'b10;
						RegWrite <= 1'b1;
						MemtoReg <= 1'b0;
						nextstate <= S0;
					end

					S9: begin
					case(OPCODE)
							LI: begin
							SZS <= 2'b00;
						end
							LWI: begin
							SZS <= 2'b00;
						end
							LUI: begin
							SZS <= 2'b10;
						end
					endcase
					MDRWrite <= 1'b1;
					nextstate <= S12;
					end
					
					S10:begin//SWI END 
					   SZS <= 2'b00;
						MemWrite <= 1'b1;
						nextstate <= S0;
					end
					
					S11:begin//END OF RTYPE
						RegDst <= 2'b00;
						RegWrite <= 1'b1;
						MemtoReg <= 1'b0;
						nextstate <= S0;
					 end
					 
					S12:begin
					MDRWrite <= 1'b0;
						case(OPCODE)
							LI:begin
							RegDst <= 2'b00;
							MemtoReg <= 1'b0;
							RegWrite <= 1'b1;
							end
							LUI:begin
							RegDst <= 2'b00;
							MemtoReg <= 1'b0;
							RegWrite <= 1'b1;
							end
							LWI:begin
							RegDst <= 2'b00;
							MemtoReg <= 1'b1;
							RegWrite <= 1'b1;
							end
							LW:begin 
							RegDst <= 2'b00;
							MemtoReg <= 1'b1;
							RegWrite <= 1'b1;
							end
						endcase
						nextstate <= S0;	
					end
						 
					S13:begin//SW END
							MemWrite <= 1'b1;
							nextstate <= S0;
						end
					S14: begin//END OF NOOP
							nextstate <= S0;
					end
					S15:begin
							RegDst <= 2'b00;
							RegWrite <= 1'b1;
							MemtoReg <= 1'b0;
							nextstate <= S0;
					end
					
					S16: begin//END OF JUMP
					PCWrite <= 1'b1;
					PCSource <= 2'b10;
					nextstate <= S0;
					end
					
					 
				endcase
			end
		end
	endmodule 
