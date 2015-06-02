`include "mem_celda.v"

module mem_fila(Do, Di, SEL, Wri);

parameter
WS = 4;

//output wand [WS-1:0] Do;// Original. rhsteinv
//inout wand [WS-1:0] Do;//rhsteinv
output wire [WS-1:0] Do;//rhsteinv
input 	[WS-1:0] Di; // Dato de entrada
input 	SEL; // Entrada del decodificador en alto
input	Wri; // Línea de control, en alto

mem_celda fila[WS-1:0] (Do,Di,SEL,Wri);

endmodule

