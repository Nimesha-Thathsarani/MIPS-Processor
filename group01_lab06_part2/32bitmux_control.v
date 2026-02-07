module mux32bit_control(
    input zero,jump,branch,bne,
    output reg result    
);

    always @(*) begin
        //result = (zero & branch) | jump| (~zero & bne);
        if (zero & branch)
        begin 
            result = 1'b1;
        end
        else if (jump)
        begin
            result = 1'b1;
        end
        else if (~zero & bne)
        begin
            result = 1'b1;
        end
        else
        begin
            result = 1'b0;
        end
    end

endmodule