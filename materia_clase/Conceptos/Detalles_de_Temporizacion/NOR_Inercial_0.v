//Archivo: NOR_Inercial_0.v

`timescale 1ns / 100ps

primitive NOR_udpDef(f, b, a);
  output f;
  input b, a;

  table
  // a  b   f
     0  0 : 1;
     x  0 : x;
     0  x : x;
     ?  1 : 0;
     1  ? : 0;
  endtable
endprimitive

module NOR_assg(f, b, a);
  input a, b;
  output f;

  assign #2 f = ~(a | b);
endmodule

//Este tipo de asignacion continua con retardos
// produce error de sintaxis
//module NOR_assgSn(f, b, a);
//  input a, b;
//  output f;

//  assign f = #2 ~(a | b); // <-- Error de sintaxis
//endmodule

module NOR_prim(f, b, a);
  input a, b;
  output f;

  nor #2 (f, b, a);
endmodule

module NOR_prBuf(f, b, a);
  input a, b;
  output f;
  wire x;

  nor (x, b, a);
  buf #2 (f, x);
endmodule

module NOR_blk(f, b, a);
  input a, b;
  output f;
  reg f;

  always @ (a or b)
    #2 f = ~(a | b);
endmodule

module NOR_blkSn(f, b, a);
  input a, b;
  output f;
  reg f;

  always @ (a or b)
    f = #2 ~(a | b);
endmodule

module NOR_nblk(f, b, a);
  input a, b;
  output f;
  reg f;

  always @ (a or b)
    #2 f <= ~(a | b);
endmodule

module NOR_nblkSn(f, b, a);
  input a, b;
  output f;
  reg f;

  always @ (a or b)
    f <= #2 ~(a | b);
endmodule

module NOR_udp(f, b, a);
  input a, b;
  output f;

  NOR_udpDef #2 g1(f, b, a);
endmodule

module SRFF_prim(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_prim c1(qb, s, q),
	   c2(q,  r, qb);
endmodule

//El siguiente modulo es igual al SRFF_prim pero el orden
// de las compuertas se cambio para ver si esto alteraba
// el orden en que se evaluan las compuertas y por lo tanto
// alteran la salida. --> No hubo cambio en Icarus 8.6!
module SRFF_prim2(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_prim c1(q,  r, qb),
	   c2(qb, s, q);
endmodule

module SRFF_prbuf(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_prBuf c1(qb, s, q),
	    c2(q, r, qb);
endmodule

module SRFF_blk(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_blk   c1(qb, s, q),
	    c2(q, r, qb);
endmodule

module SRFF_blkSn(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_blkSn   c1(qb, s, q),
	      c2(q, r, qb);
endmodule

module SRFF_nblk(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_nblk  c1(qb, s, q),
	    c2(q, r, qb);
endmodule

module SRFF_nblkSn(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_nblkSn  c1(qb, s, q),
	    c2(q, r, qb);
endmodule

module SRFF_udp(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_udp   c1(qb, s, q),
	    c2(q, r, qb);
endmodule

module SRFF_As(q, qb, s, r);
  input s, r;
  output q, qb;

  NOR_assg   c1(qb, s, q),
	    c2(q, r, qb);
endmodule

module SRFF_Boole(q, qb, s, r);
  input s, r;
  output q, qb;
  wire Y;

  //Se ha insertado un "buffer" con 2 unidades de retardo para
  //  romper el lazo de realimentacion. Esto hace que el latch
  //  no responda simetricamente a cambios simultaneos en s y r,
  //  y entonces no oscila.
  assign qb = ~(s | q);
  assign q  = ~(r | Y);
  assign #2 Y = qb;
endmodule


module ElementosVarios(s, r, Pr, PrAs, PrBf, Blk, BlkSn, nBlk, nBlkSn, udp, qPrim, qPrim2, qPrBuf, qBlk, qBlkSn, qnBlk, qnBlkSn, qUdp, qAs, qBoole);
  output Pr, PrAs, PrBf, Blk, BlkSn, nBlk, nBlkSn, udp, qPrim, qPrim2, qPrBuf, qBlk, qBlkSn, qnBlk, qnBlkSn, qUdp, qAs, qBoole;
  input s, r;
  wire pr_risefall;

  //Computertas NOR
  nor #(3.4, 2.2) g0(pr_risefall, s, r);
  NOR_prim	g1(Pr,   s, r);
  NOR_assg	g11(PrAs,   s, r);
  NOR_prBuf	g2(PrBf, s, r);
  NOR_blk	g3(Blk,  s, r);
  NOR_blkSn	g31(BlkSn,  s, r);
  NOR_nblk	g4(nBlk, s, r);
  NOR_nblkSn	g41(nBlkSn, s, r);
  NOR_udp       g5(udp,  s, r);

  //Latches SR
  SRFF_prim     g6(qPrim,  qbPrim,  s, r);
  SRFF_prim2    g62(qPrim2,  qbPrim2,  s, r);
  SRFF_prbuf    g7(qPrBuf, qbPrBuf, s, r);
  SRFF_blk      g8(qBlk,   qbBlk,   s, r);
  SRFF_blkSn    g81(qBlkSn,   qbBlkSn,   s, r);
  SRFF_nblk     g9(qnBlk,  qbnBlk,  s, r);
  SRFF_nblkSn   g91(qnBlkSn,  qbnBlkSn,  s, r);
  SRFF_udp     g10(qUdp,   qbUdp,   s, r);
  SRFF_As      g20(qAs,   qbAs,   s, r);
  SRFF_Boole   g30(qBoole,   qbBoole,   s, r);
endmodule

module probador (s, r, Pr, PrAs, PrBf, Blk, BlkSn, nBlk, nBlkSn, udp, qPrim, qPrim2, qPrBuf, qBlk, qBlkSn, qnBlk, qnBlkSn, qUdp, qAs, qBoole);
  input Pr, PrAs, PrBf, Blk, BlkSn, nBlk, nBlkSn, udp, qPrim, qPrim2, qPrBuf, qBlk, qBlkSn, qnBlk, qnBlkSn, qUdp, qAs, qBoole;
  output s, r;
  reg s, r;

  initial #0
    begin
      //Generacion de archivo de senales
      $dumpfile("NOR_Inercial_0.vcd");
      $dumpvars;
      $monitor($time,,,"s= %b,  r= %b,  Pr= %b,  PrBf= %b",s,r,Pr,PrBf);

      //Damos 10 unidades de tiempo para ver x en todas las senales
      #20
      s = 0;
      r = 0;

      #20 //Set en 1
      s = 1;
      r = 0;

      #20
      s = 0;
      r = 0;

      #20 //Reset en 1
      s = 0;
      r = 1;

      #20
      s = 0;
      r = 0;

      #20 //Set y Reset en 1
      s = 1;
      r = 1;

      #20
      s = 0;
      r = 0;

      #20 //Reset en 1
      s = 0;
      r = 1;

      #20
      s = 0;
      r = 0;

      #20 //Set en 1
      s = 1;
      r = 0;

      #1  //Provoca pulso de 1 ut en s
      s = 0;
      r = 0;

      #20 //Reset en 1
      s = 0;
      r = 1;

      #20
      s = 0;
      r = 0;

      #20 //Set en 1
      s = 1;
      r = 0;

      #2  //Provoca pulso de 2 ut en s
      s = 0;
      r = 0;

      #20 //Reset en 1
      s = 0;
      r = 1;

      #20
      s = 0;
      r = 0;

      #20 //Set en 1
      s = 1;
      r = 0;

      #3  //Provoca pulso de 3 ut en s
      s = 0;
      r = 0;

      #20 //Reset en 1
      s = 0;
      r = 1;

      #10 $finish;
    end

endmodule

module BancoPruebas;
  wire s, r, Pr, PrAs, PrBf, Blk, BlkSn, nBlk, nBlkSn, udp, qPrim, qPrim2, qPrBuf, qBlk, qBlkSn, qnBlk, qnBlkSn, qUdp, qAs, qBoole;

  ElementosVarios circ (s, r, Pr, PrAs, PrBf, Blk, BlkSn, nBlk, nBlkSn, udp, qPrim, qPrim2, qPrBuf, qBlk, qBlkSn, qnBlk, qnBlkSn, qUdp, qAs, qBoole);
  probador tester      (s, r, Pr, PrAs, PrBf, Blk, BlkSn, nBlk, nBlkSn, udp, qPrim, qPrim2, qPrBuf, qBlk, qBlkSn, qnBlk, qnBlkSn, qUdp, qAs, qBoole);

endmodule

