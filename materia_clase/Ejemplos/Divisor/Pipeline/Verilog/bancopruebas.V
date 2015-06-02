`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module BancoPruebas;

  wire [`DdLen:0] dividendo;
  wire [`DvLen:0] divisor;
  wire [`QLen:0] cociente;
  wire reset, reloj;

  divide d1(dividendo, divisor, cociente, inicie, termino, reloj, reset);
  probador p1(dividendo, divisor, cociente, inicie, termino, reloj, reset);
 
endmodule
