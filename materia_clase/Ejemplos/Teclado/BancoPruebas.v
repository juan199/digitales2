module BancoPruebas;
  wire [4:0] teclas;
  wire valido, clk, val;
  wire [31:0] R1;
  
  //Sincronizador
  FFD ff1 (valido, q1, clk);
  FFD ff2 (q1, val, clk);
  
  reloj r1(clk);
  teclado tks (teclas, valido);
  MaqEstados MQ1 (teclas, val, clk, R1);
endmodule
