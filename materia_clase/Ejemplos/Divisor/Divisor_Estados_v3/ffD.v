module ffD (d, q, setB, resetB, clk);
  input d, setB, resetB, clk;
  output q;
  reg q;

  always @(negedge clk or negedge setB or negedge resetB)
    begin
      if (~setB)
        q = 1;
      else if (~resetB)
        q = 0;
      else
        q = d;
    end
endmodule
