module latch_SR (Q, S, R);
output Q;
input S, R;
wire Qn;
nor #1
	n1(Qn, S, Q),
	n2(Q, R, Qn);

endmodule

////////////////////////*********************************//////////////////////

module mem_celda (Do, Di, SEL, Wri);
//output wand Do;// Original. rhsteinv
//inout wand Do;// rhsteinv
output wire Do;// rhsteinv
input SEL; // Entrada del decodificador en alto
input Wri; // Línea de control, en alto
input Di; // Dato de entrada
wire wiS, wiR, wiQ; 

and #4
	Gs(wiS, SEL, Di, Wri),
	Gr(wiR, SEL, ~Di, Wri);

latch_SR SR(wiQ, wiS, wiR);

nand #1
	Go(Do, SEL, wiQ, ~Wri);

endmodule

