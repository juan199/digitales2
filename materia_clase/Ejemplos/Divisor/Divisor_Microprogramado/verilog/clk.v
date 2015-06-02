module clk(clk);
  parameter
    Tclk=200;

  output  clk;
  reg     clk;

  initial 
    clk=0;

  always
    #(Tclk)
    clk=~clk;

endmodule
