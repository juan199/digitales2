`include "ParGlobal.v"

module BancoPruebas;

  wire [`DdLen:0] dividendo;
  wire [`DvLen:0] divisor;
  wire [`QLen:0] cociente;
  wire [2:0] EstPresente;

  divide d1(dividendo, divisor, cociente, inicie, termino, reloj, reset, EstPresente);
  probador p1(dividendo, divisor, cociente, inicie, termino, reloj, reset);

 
endmodule
