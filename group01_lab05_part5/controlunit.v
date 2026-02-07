module controlunit(
    input [7:0] opcode,
    output reg writeanable,
    output reg istwoscomp,
    output reg isregout,
    output reg [2:0] ALUop,
    output reg beq, 
    output reg jump,
    output reg [1:0] islogicalorisleft,
    output reg bne
);

    always @(*)  // Using @(*) for combinational logic sensitivity list
    begin
        case (opcode)
            // loadi
            8'b00000000: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;  // Choosing 0 for "don't care" to keep output defined
                isregout = 1'b0;
                ALUop = 3'b000;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;

                
            end

            // add
            8'b00000010: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b001;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;

            end

            // sub
            8'b00000011: begin
                writeanable = 1'b1;
                istwoscomp = 1'b1;
                isregout = 1'b1;
                ALUop = 3'b001;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;

            end

            // and
            8'b00000100: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b010;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
            end

            // or
            8'b00000101: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b011;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
            end

            // mov
            8'b00000001: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b000;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
            end

            //Jump
            8'b00000110: begin
                writeanable = 1'b0;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b000;
                beq = 1'b0;
                jump = 1'b1;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
            end
            //beq equal
            8'b00000111: begin
                writeanable = 1'b0;
                istwoscomp = 1'b1;
                isregout = 1'b1;
                ALUop = 3'b001;
                beq = 1'b1;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
                
            end

            //bne not equal
            8'b00001000: begin
                writeanable = 1'b0;
                istwoscomp = 1'b1;
                isregout = 1'b1;
                ALUop = 3'b001;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b1;
                islogicalorisleft = 2'b00;
            end

            //arithmetic shift right
            8'b00001001: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b100;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
            end

            //arithmetic shift left
            8'b00001010: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b100;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b01;
            end

            //logical shift right
            8'b00001011: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b100;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b10;
            end

            //logical shift left
            8'b00001100: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b100;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b11;
            end

            //rotation right
            8'b00001101: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b101;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
            end

            //rotation left
            8'b00001110: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b101;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b01;
            end

            8'b00001111: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b110;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
            end
            
            // Default case to handle undefined opcodes
            default: begin
                writeanable = 1'b0;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b000;
                beq = 1'b0;
                jump = 1'b0;
                bne = 1'b0;
                islogicalorisleft = 2'b00;
                
            end
        endcase
    end
endmodule
