module mux2x1(input1, input2, select, out);
  input [7:0] input1, input2;
  input select;
  output reg [7:0] out;
  always @(input1, input2, select) 
  begin
    if (select == 1'b0) 
    begin
      out = input1;
    end
    else 
    begin
      out = input2;
    end
  end
endmodule