module reg_file(OUT2ADDRESS, OUT1ADDRESS,INADDRESS,IN,WRITE,CLOCK,RESET,OUT1,OUT2,busywait);
    // (readreg2, readreg1 , writereg, writedata, writeenable, clk, reset, regout1, regout2)
    input [2:0] OUT2ADDRESS, OUT1ADDRESS, INADDRESS;
    input [7:0] IN;
    
    input WRITE, CLOCK, RESET,busywait;
    output [7:0] OUT1, OUT2;

    reg [7:0] REGISTER [7:0];

    integer i;
    
    assign #1  OUT1 =  REGISTER[OUT1ADDRESS]; // readreg1
    assign #1  OUT2 =  REGISTER[OUT2ADDRESS]; // readreg2

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
        else if (WRITE == 1'b1 && busywait==1'b0) // write - writeenable
        begin
            #1 REGISTER[INADDRESS] <= IN; // IN - writedata
        end
    end 
endmodule

