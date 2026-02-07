module ForwardUnit(data2 , result);
    input [7:0] data2;
    output [7:0] result; // Changed to wire as this output directly assigns input to output
    assign #1 result = data2; // Using assign for direct assignment
endmodule

module AddUnit(data1, data2, result);
    input [7:0] data1, data2;
    output [7:0] result; // Changed to wire, output directly driven by procedural block
    assign #2 result = data1 + data2; // Using assign for direct addition
endmodule

module AndUnit(data1, data2, result);
    input [7:0] data1, data2;
    output [7:0] result; // Changed to wire
    assign #1 result = data1 & data2; // Using assign for bitwise AND
endmodule

module OrUnit(data1, data2, result);
    input [7:0] data1, data2;
    output [7:0] result; // Changed to wire
    assign #1 result = data1 | data2; // Using assign for bitwise OR
endmodule

module MuxUnit(I1, I2, I3, I4, select, result);
    input [7:0] I1, I2, I3, I4;
    input [2:0] select;
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

module ALUUnit(data1, data2, select, result);
    input [7:0] data1, data2;
    input [2:0] select;
    output wire [7:0] result; // Changed to wire because it is directly driven by MuxUnit
    
    wire [7:0] Ii1, Ii2, Ii3, Ii4; // Already correctly defined as wire

    ForwardUnit forward(data2, Ii1);
    AddUnit add(data1, data2, Ii2);
    AndUnit and1(data1, data2, Ii3);
    OrUnit or1(data1, data2, Ii4);
    MuxUnit mux(Ii1, Ii2, Ii3, Ii4, select, result);
endmodule
