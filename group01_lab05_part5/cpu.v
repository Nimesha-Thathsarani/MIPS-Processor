`include "alu.v"
`include "reg_file.v"
`include "controlunit.v"
`include "mux2x1.v"
`include "pc.v"
`include "decoder.v"
`include "2scompement.v"
`include "32bitmux.v"
`include "32bitmux_control.v"
`include "signextend.v"
`include "32bitadder.v"
`include "zero.v"
`include "leftshift.v"


module cpu(PC_data, INSTRUCTION, CLK, RESET);
    input CLK,RESET;
    input [31:0] INSTRUCTION;
    output wire [31:0] PC_data;

    wire [7:0] opcode, immediate;
    wire [2:0] readreg2, readreg1, writereg;
    wire [31:0] extendedvalue;

    wire writeanable,istwoscomp,isregout;
    wire [2:0] ALUop;

    wire [7:0] writedata,regout1,regout2;
    wire [7:0] regout2ORimmediate;

    wire [7:0] twoscompout,I12;
    wire [7:0] jumpOrbranch;
    wire [31:0] leftshiftout;
    wire [31:0] jumpOrbranchPC;
    wire muxcontrol,zero,jump,beq;
    wire [31:0] PC;
    wire [1:0] islogicalorisleft;  
    

    //modules
    decoder dec(INSTRUCTION,opcode,immediate,readreg2,readreg1,writereg,jumpOrbranch);
    pc pc1(CLK,RESET,leftshiftout,muxcontrol,PC_data);
    controlunit controlUnit1(opcode,writeanable,istwoscomp,isregout,ALUop,beq,jump,islogicalorisleft,bne); 
    reg_file regfile(readreg2,readreg1,writereg,writedata,writeanable,CLK,RESET,regout1,regout2);
    twocomp twoscom(regout2,twoscompout);
    mux2x1 mux11(regout2,twoscompout,istwoscomp,I12);
    mux2x1 mux22(immediate,I12,isregout,regout2ORimmediate);
    ALUUnit alu(regout1,regout2ORimmediate,ALUop,writedata,zero,islogicalorisleft);

    signextend signextend1(jumpOrbranch,extendedvalue);
    leftshift leftshift1(extendedvalue,leftshiftout);
    //adder32bit adder1(PC,leftshiftout,jumpOrbranchPC);
    //mux32bit mux32bit1(PC,jumpOrbranchPC,muxcontrol,PC_data);
    //zero_out zero1(writedata,zero);
    mux32bit_control mux32bit_control1(zero,jump,beq,bne,muxcontrol);    
endmodule