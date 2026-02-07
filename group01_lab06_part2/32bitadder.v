module adder32bit(
    input [31:0] data1,
    input [31:0] data2,
    output [31:0] result
);

assign #2 result = data1 + data2;
endmodule