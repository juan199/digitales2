module reloj (rlj);
  output  rlj;
  reg     rlj;

  initial
    rlj = 0;

  always
    rlj = #5 ~rlj;

endmodule
