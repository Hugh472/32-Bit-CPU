# 32-Bit-CPU
Omar Janoudi U48041715 Kyle Hughes
Final Project Report: Overview:
The enclosed code is for a 32 bit multicycle CPU capable of implementing the following instructions followed by their Opcodes:
MOV 010000 NOT 010001 ADD 010010 SUB 010011 OR 010100 AND 010101 XOR 010110 SLT 010111 JUMP 000001 ADDI 110010 SUBI 110011 SLTI 110111 ORI 110100 ANDI 110101 LI 111001 SWI 111100 LW 111101 SW 111110 LWI 111011 BEQ 100000 BNE 100001 NOOP 000000 LUI 111010

BLT 100010
BLE 100011
JAL 000011
XORI 110110
The following is a description of each of the enclosed modules:
ALU: 32 bit signed ALU implementing MOV, NOT, ADD, SUB, OR, AND, XOR, SLT, and has an extra output named zero that changes logical value based on an input named BranchCond that decides whether this value should correspond to a BEQ, BNE, BLT, or BLE branch type. The case statement above the ALU functions decide the value of this zero output, which is later further processed to determine whether a value should be written to the PC register.
Control: This is the module that receives an opcode from the current instruction and then moves through a state machine that changes the current control signals to the datapath based on the current state and with every clock cycle.
Cpu: This module ties together the control and datapath modules.
CPUTB: Testbench for the CPU, starting with a high reset, waiting 100ns, and then beginning execution
of the program stored in IMEM.
Datapath: This datapath, consisting of all modules besides the controller and behavioral muxes, is designed with registers to execute instructions with multiple clock cycles.
DFF: d flip flop.
DMem: Data memory
Imem: Instruction memory
Instruction_Register: Register that resides right after the Imem that spits it back out into several wires. Nbit_reg: 32 bit by default
Nbit_register_file: 32 bit Register file by default
SE_ZE_SHIFT: this module was created to tie together all possibly needed shift, sign extend, and zero extend operations. This was increasingly needed after increasing the amount of instructions that we are implementing, and I decided that it was neater to control these operations with an extra control signal.
Waveforms:
The PNG files included in the tar file are not easily viewable here, so I have decided to instead keep them separately enclosed in the tar file with descriptions here.
Customtest_p1.PNG: This is the first half of the execution of the instructions that were in the CPU_tb file on blackboard, copied into IMEM and then executed instead of the default Progam_1. The Imem file that was edited to include this is stored in the extra folder as Imem_new.

Custom_test_p2.png: This is the second half of the custom CPU_tb instruction execution. The register file values are dragged out in order for you to compare them to the actual values. As you can see, the second SLTI (last instruction) did not return the proper value and I am not sure why.. but the SLTI that preceded it did in fact return the correct value, proving the function of SLTI.
Prog2_p1test.png: Testing program 2, first part up until instruction 20
Prog3test: waveform of the simulation of the default program_3, which evidently loops a few times
before halting execution. The register values are again shown to prove proper execution of the program.
State Machine :
The repository also includes a PDF version of the state diagram for the controller with all control signals. A very select few values were modified in order to fix issues (such as resetting certain values to zero at S0 in order to operate properly), but it is a proper depiction of the programmed logic.
Schematic: A schematic of the datapath and controller is included in Reference/schematic.jpg.
Difficulties and Adaptations:
The final version of the project was remodeled and completely redone after the original attempt, included in the repository is an original_milestone3.tar, which includes our files and schematic for the OLD version of the project, which we realized had to completely change in order to account for the implementation of the newer instructions, and because there were hidden bugs that convinced us that it was a good idea to scrap it all together and start all over again.
