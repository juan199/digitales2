`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16
`define Pruebas 9 //Indica el numero maximo de pruebas que maneja menos uno

module BancoPruebas;

  wire [`DdLen:0] dividendo;
  wire [`DvLen:0] divisor;
  wire [`QLen:0] cociente;

  divide d1(dividendo, divisor, cociente, inicie, termino);
  probador p1(dividendo, divisor, inicie, termino, cociente);
  
endmodule
