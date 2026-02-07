module signextend(
    input [7:0] data,
    output reg [31:0] result
);

 always @(*) begin
    if (data[7] == 1'b1)
        result = {24'b111111111111111111111111, data};
    else
        result = {24'b00000000, data};
 end

endmodule
