module FFD (d, q, clk);
  input d, clk;
  output q;
  reg q;
  
  always @(posedge clk)
    q <= #3 d;
endmodule
