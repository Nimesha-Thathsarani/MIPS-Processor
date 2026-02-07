module MuxUnit4(I1, I2, I3, I4, select, result);
    input [7:0] I1, I2, I3, I4;
    input [1:0] select;
    output reg [7:0] result;
    
    always @(*) begin // Changed sensitivity list to *
       case(select)
           3'b000: result <= I1;
           3'b001: result <= I2;
           3'b010: result <= I3;
           3'b011: result <= I4;
           // It's good practice to have a default case
           default: result = 8'bx; // Undefined in case of an unexpected select
       endcase
    end
endmodule