module mux32bit_control(
    input zero,jump,branch,
    output reg result    
);

    always @(*) begin
        result = (zero & branch) | jump;
    end

endmodule