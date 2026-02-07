module decoder(instruction, opcode, immediate, readreg2, readreg1, writereg);
    input [31:0] instruction;
    output reg [7:0] opcode, immediate;
    output reg [2:0] readreg2, readreg1, writereg;


always @ (instruction)
begin
    /*
     opcode bits    31-24
     RD/immediate   23-16 (immediate value for the jump instruction)
     RT bits        15-8
     RS/immediate   7-0 
    */
    opcode = instruction[31:24];
    writereg = instruction[18:16]; // Adjusting to the correct bits for RD as per updated comment
    readreg1 = instruction[10:8]; // Adjusting to the correct bits for RT
    readreg2 = instruction[2:0]; // Adjusting to the correct bits for RS
    immediate = instruction[7:0]; // Using the least significant 8 bits as immediate
end

endmodule
