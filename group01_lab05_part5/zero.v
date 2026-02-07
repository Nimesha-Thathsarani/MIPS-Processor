module zero_out(
    input [7:0] result,
    output reg data
);
    
        always @(*) begin
            if (result == 8'b00000000) begin
                data = 1'b1;
            end
            else begin
                data = 1'b0;
            end
        end 
endmodule    
