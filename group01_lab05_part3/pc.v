module pc(CLK, RESET, pc);
  input CLK, RESET;
  output reg [31:0] pc;

  always @(posedge CLK) 
  begin
    if (RESET == 1'b1) 
    begin
      pc <= #1 0;
    end
    else 
    begin
      pc <= #1 pc + 4;
    end
  end
endmodule