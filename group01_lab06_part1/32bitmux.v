module mux32bit(
    input [31:0] I0,I1,
    input select,
    output reg [31:0] result
);

    always @(*) begin
        if (select == 1'b0) begin
            result = I1;
        end
        else begin
            result = I0;
        end
    end

endmodule