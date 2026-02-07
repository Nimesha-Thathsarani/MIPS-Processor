`include "alu.v"
`include "reg_file.v"
`include "controlunit.v"
`include "mux2x1.v"
`include "pc.v"
`include "decoder.v"
`include "2scompement.v"

module cpu(PC, INSTRUCTION, CLK, RESET);
    input CLK,RESET;
    input [31:0] INSTRUCTION;
    output wire [31:0] PC;

    wire [7:0] opcode, immediate;
    wire [2:0] readreg2, readreg1, writereg;
    wire [31:0] pcvalue;

    wire writeanable,istwoscomp,isregout;
    wire [2:0] ALUop;

    wire [7:0] writedata,regout1,regout2;
    wire [7:0] regout2ORimmediate;

    wire [7:0] twoscompout,I12;

    //modules
    decoder dec(INSTRUCTION,opcode,immediate,readreg2,readreg1,writereg);
    pc pc1(CLK,RESET,PC);
    controlunit controlUnit1(opcode,writeanable,istwoscomp,isregout,ALUop);
    reg_file regfile(readreg2,readreg1,writereg,writedata,writeanable,CLK,RESET,regout1,regout2);
    twocomp twoscom(regout2,twoscompout);
    mux2x1 mux1(regout2,twoscompout,isregout,I12);
    mux2x1 mux2(immediate,I12,isregout,regout2ORimmediate);
    ALUUnit alu(regout1,regout2ORimmediate,ALUop,writedata);
endmodule