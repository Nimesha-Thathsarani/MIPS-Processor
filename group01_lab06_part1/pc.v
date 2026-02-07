module pc(CLK, RESET , leftshiftout,muxcontrol,PC_data, busywait);
  input CLK, RESET,busywait;
  output reg [31:0] PC_data, PC;
  input [31:0] leftshiftout;
  input muxcontrol; 

  always @(posedge CLK) 
  begin
    if (RESET == 1'b1) 
    begin
      PC_data <= #1 0;
    end
    else if (busywait == 1'b1)
    begin
      PC_data <= #1 PC_data;
    end
    else if (muxcontrol == 1'b0)
    begin
      PC_data <= #1 PC_data + 4;
    end
    else
    begin
      PC_data <= #1 leftshiftout + PC_data + 4;
    end
  end
endmodule