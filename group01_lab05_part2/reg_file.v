module reg_file(OUT2ADDRESS, OUT1ADDRESS,INADDRESS,IN,WRITE,CLOCK,RESET,OUT1,OUT2);
    input [2:0] OUT2ADDRESS, OUT1ADDRESS, INADDRESS;
    input [7:0] IN;
    input WRITE, CLOCK, RESET;
    output [7:0] OUT1, OUT2;

    reg [7:0] REGISTER [7:0];

    integer i;

    assign #2 OUT1 = REGISTER[OUT1ADDRESS];
    assign #2 OUT2 = REGISTER[OUT2ADDRESS];

    always @(posedge CLOCK)
    begin
    // Synchronous register operations (Write and Reset)
        if (RESET == 1'b1)
        begin
            #1 for (i = 0; i < 8; i = i + 1)
            begin
                REGISTER[i] <= 8'b00000000;
            end
        end
        else if (WRITE == 1'b1)
        begin
            #1 REGISTER[INADDRESS] <= IN;
        end
    end 
endmodule

