module twocomp(input_nupm, output_nupm);
  input [7:0] input_nupm;
  output reg signed [7:0] output_nupm;
  always @(input_nupm) 
  begin
    #1
    output_nupm = ~input_nupm + 1;
  end
endmodule