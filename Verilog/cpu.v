module CPU(Reset, Clk, ALUOUT, PCOUT,STATE, CURROP);
//-------------Input Ports------------------------------
input Reset,Clk;
//-------------Output Ports-----------------------------
output[31:0] ALUOUT, PCOUT;
output[5:0] CURROP;
output [4:0] STATE;
//-------------Wires------------------------------------
wire PCWriteCond,PCWrite,MemWrite,IRWrite,RegRead,RegWrite,MemtoRegMDRWrite;
wire [1:0] PCSource,SZS,ALUSrcB,BranchCond,RegDst;
wire[2:0] ALUSrcA;
wire[5:0] OPCODE;
wire [3:0] ALUOp;
//-------------Modules------------------------------------
Datapath DP(PCWriteCond,PCWrite,MemWrite,MemtoReg,IRWrite,BranchCond,PCSource,ALUOp,ALUSrcB,ALUSrcA,RegRead,RegWrite,SZS,RegDst,OPCODE,Reset,Clk,ALUOUT,PCOUT,MDRWrite); //MULTICYCLE DATAPATH
control CT(PCWriteCond,PCWrite,MemWrite,MemtoReg,IRWrite,BranchCond,PCSource,ALUOp,ALUSrcB,ALUSrcA,RegRead,RegWrite,SZS,RegDst,OPCODE,Reset,Clk, STATE,MDRWrite); //DETERMINES CONTROL SIGNALS FOR DATAPATH
//-------------Connections--------------------------------
assign CURROP = OPCODE;

endmodule 