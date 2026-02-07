module pc(CLK, RESET , leftshiftout,muxcontrol,PC_data, busywait);
  input CLK, RESET,busywait;
  output reg [31:0] PC_data, PC;
  input [31:0] leftshiftout;
  input muxcontrol; 

  always @(posedge CLK)
 
  begin
    
    #1;
    if (RESET == 1'b1) 
    begin
      PC_data <=  0;
    end
    else if (busywait == 1'b0)
    begin
      if (muxcontrol == 1'b0)
      begin
        PC_data =  PC_data + 4;
      end
      else
      begin
        PC_data = leftshiftout + PC_data + 4;
      end
    end
    
  end
endmodule