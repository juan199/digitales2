`include "mem_fila.v"

module mem_completa(Do, Di, SEL, Wri);

parameter
WS = 4,
MS = 16;

//output wand  [WS-1:0] Do; //Original. rhsteinv
//inout wand  [WS-1:0] Do; //rhsteinv
output wire  [WS-1:0] Do; //rhsteinv
input 	[WS-1:0] Di; // Dato de entrada

//wand  [WS-1:0]  Do;

input 	[MS-1:0] SEL ; // Entradas del decodificador en alto
input	Wri; // Línea de control, en alto

mem_fila memoria[MS-1:0] (Do,Di,SEL,Wri);

endmodule

