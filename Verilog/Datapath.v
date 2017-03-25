`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:37:21 11/20/2015 
// Design Name: 
// Module Name:    Datapath 
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
module Datapath(PCWriteCond,PCWrite,MemWrite,MemtoReg,IRWrite,BranchCond,PCSource,ALUOp,ALUSrcB,ALUSrcA,RegRead,RegWrite,SZS, RegDst,OPCODE,Reset,Clk,ALUOUT,PCOUT,MDRWrite);

parameter DATA_WIDTH = 32;
parameter DATA_SELECT_WIDTH = 5;
parameter IMMEDIATE = 16;

//-------------Input Ports------------------------------
input PCWriteCond,PCWrite,MemWrite,IRWrite,RegRead,RegWrite,MemtoReg,MDRWrite;
input [1:0] PCSource,SZS,ALUSrcB,BranchCond,RegDst;
input[2:0] ALUSrcA;
input [3:0] ALUOp;
input Reset,Clk;
//-------------Output Ports-----------------------------
output [5:0] OPCODE;
output [31:0] ALUOUT;
output[31:0] PCOUT;
//-------------Wires------------------------------------
//PC
wire [DATA_WIDTH-1:0] PC_Out;
wire ACTU_PC_WRITE;
assign PCOUT = PC_Out;
assign ACTU_PC_WRITE = ((PCWriteCond & ALUzero_Out) | PCWrite); //PCWRITE LOGIC
//IMEM
wire [DATA_WIDTH-1:0] IMEM_Out;
//DATA_MEM_REG
wire [DATA_WIDTH-1:0]DMEM_Data_Out, DATA_MEM_REG_Out;
//IREG
assign OPCODE = IREG_Opcode_Out;
wire [5:0] IREG_Opcode_Out;
wire [4:0] IREG_Read1_Out, IREG_Read2_Out, IREG_Read3_Out;
wire [15:0] IREG_Imm_Out;
//REG_FILE
wire [DATA_WIDTH-1:0] REG_FILE_Read1_Out,REG_FILE_Read2_Out;
//MUX_REG_FILE_READ
wire [4:0] MUX_REG_FILE_READ_Out;
//MUX_REG_FILE_WRITE
wire [DATA_WIDTH-1:0]  MUX_REG_FILE_WRITE_Out;
//A_REG
wire [DATA_WIDTH-1:0] A_REG_Out;
//B_REG
wire [DATA_WIDTH-1:0] B_REG_Out;
//MUX_ALUSRCA
wire [DATA_WIDTH-1:0] MUX_ALUSRCA_Out;
//MUX_ALUSRCB
wire [DATA_WIDTH-1:0]  MUX_ALUSRCB_Out;
//MUX_WRITE_REG
wire[4:0]  MUX_WRITE_REG_OUT;
//ALU
assign ALUOUT = ALU_Out;
wire [DATA_WIDTH-1:0] ALU_Out;
wire ALUzero_Out;
//ALU_RESULT_REG
wire [DATA_WIDTH-1:0] ALU_RESULT_REG_Out;
//MUX_PCSOURCE
wire [DATA_WIDTH-1:0] MUX_PCSOURCE_Out;
//SHIFT AND EXTEND
wire [DATA_WIDTH-1:0] SZS_Out;
//ZE_JUMP
wire [DATA_WIDTH-1:0] ZE_JUMP_Out;
assign ZE_JUMP_Out = {8'b00000000,IREG_Read1_Out,IREG_Read2_Out,IREG_Imm_Out};  //JUMP ADDRESS FOR PC

//-------------MODULES------------------------------------
//ALU_RESULT_REG
nbit_reg aluresultreg(ALU_Out,ALU_RESULT_REG_Out,1'b1,Reset,Clk);
//PC
nbit_reg PC(MUX_PCSOURCE_Out,PC_Out,ACTU_PC_WRITE,Reset,Clk);
//A_REG
nbit_reg RegA (REG_FILE_Read1_Out,A_REG_Out,1'b1,Reset,Clk);
//B_REG
nbit_reg RegB (REG_FILE_Read2_Out,B_REG_Out,1'b1,Reset,Clk);
//IREG
IREG Instruction_Register(IREG_Opcode_Out,IREG_Read1_Out,IREG_Read2_Out,IREG_Read3_Out,IREG_Imm_Out,IMEM_Out,IRWrite,Reset,Clk);
//DATA_MEM_REG
nbit_reg Data_Mem_Reg(DMEM_Data_Out,DATA_MEM_REG_Out,MDRWrite,Reset,Clk);
//IMEM
IMem Instruction_Memory(PC_Out[15:0],IMEM_Out);
//SHIFT/EXTEND
SE_ZE_SHFT szss(IREG_Imm_Out,SZS_Out,SZS);
//DMEM
DMem Data_Memory(A_REG_Out,DMEM_Data_Out,ALU_RESULT_REG_Out,MemWrite,Clk);
//ALU
ALU alu(MUX_ALUSRCA_Out,MUX_ALUSRCB_Out,ALUOp,ALU_Out,BranchCond,ALUzero_Out);
//REG_FILE
nbit_register_file REGFILE(MUX_REG_FILE_WRITE_Out,REG_FILE_Read1_Out,REG_FILE_Read2_Out,MUX_REG_FILE_READ_Out,IREG_Read2_Out,MUX_WRITE_REG_OUT,RegWrite,Clk);
//-------------MUXES------------------------------------
//MUX_WRITE_REG
assign MUX_WRITE_REG_OUT = (RegDst == 2'b00)? IREG_Read1_Out :
										(RegDst == 2'b10)? 5'b11111: IREG_Read3_Out ;
//MUX_REG_FILE_READ
assign MUX_REG_FILE_READ_Out = (RegRead == 1'b0) ? IREG_Read1_Out : IREG_Read3_Out;
//MUX_REG_FILE_WRITE
assign MUX_REG_FILE_WRITE_Out = (MemtoReg == 1'b0) ? ALU_RESULT_REG_Out : DATA_MEM_REG_Out;
//MUX_ALUSRCA
assign MUX_ALUSRCA_Out = (ALUSrcA == 3'b000) ? PC_Out : 
									(ALUSrcA == 3'b001) ? A_REG_Out :
									(ALUSrcA == 3'b010) ? 32'b00000000000000000000000000000000 : 
										(ALUSrcA == 3'b011)? SZS_Out : B_REG_Out ;
//MUX_ALUSRCB
assign MUX_ALUSRCB_Out = (ALUSrcB == 2'b00) ? B_REG_Out : 
								 (ALUSrcB == 2'b01) ? 32'b00000000000000000000000000000001 :
								 (ALUSrcB == 2'b10) ? SZS_Out: A_REG_Out;
//MUX_PCSOURCE
assign MUX_PCSOURCE_Out = (PCSource == 2'b00) ? ALU_Out : //PC +1
								(PCSource == 2'b01) ? ALU_RESULT_REG_Out : ZE_JUMP_Out; //ALU_RESULT_REG_Out IS FOR BRANCH, ZE_JUMP_Out for JUMP

endmodule
