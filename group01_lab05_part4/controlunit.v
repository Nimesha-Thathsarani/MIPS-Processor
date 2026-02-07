module controlunit(
    input [7:0] opcode,
    output reg writeanable,
    output reg istwoscomp,
    output reg isregout,
    output reg [2:0] ALUop,
    output reg branch, 
    output reg jump
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
                branch = 1'b0;
                jump = 1'b0;
                
            end

            // add
            8'b00000010: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b001;
                branch = 1'b0;
                jump = 1'b0;
                
            end

            // sub
            8'b00000011: begin
                writeanable = 1'b1;
                istwoscomp = 1'b1;
                isregout = 1'b1;
                ALUop = 3'b001;
                branch = 1'b0;
                jump = 1'b0;
                
            end

            // and
            8'b00000100: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b010;
                branch = 1'b0;
                jump = 1'b0;
            end

            // or
            8'b00000101: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b011;
                branch = 1'b0;
                jump = 1'b0;
            end

            // mov
            8'b00000001: begin
                writeanable = 1'b1;
                istwoscomp = 1'b0;
                isregout = 1'b1;
                ALUop = 3'b000;
                branch = 1'b0;
                jump = 1'b0;
            end

            //Jump
            8'b00000110: begin
                writeanable = 1'b0;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b000;
                branch = 1'b0;
                jump = 1'b1;
                
            end
            //branch
            8'b00000111: begin
                writeanable = 1'b0;
                istwoscomp = 1'b1;
                isregout = 1'b1;
                ALUop = 3'b001;
                branch = 1'b1;
                jump = 1'b0;
                
                
            end
            // Default case to handle undefined opcodes
            default: begin
                writeanable = 1'b0;
                istwoscomp = 1'b0;
                isregout = 1'b0;
                ALUop = 3'b000;
                branch = 1'b0;
                jump = 1'b0;
                
            end
        endcase
    end
endmodule
