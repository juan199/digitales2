module inc (s, e);
  parameter tamData = 0;
  input [tamData:0] e;
  output [tamData:0] s;

  assign s = e + 1;
endmodule


module memROM (dat, dir);
  input [2:0] dir;
  output [13:0] dat;

  reg [13:0] dat;

  reg [13:0] mem[0:7];

  initial
    $readmemb ("MemUcodigo.dat", mem);

  always @ (dir)
    dat = mem[dir];
endmodule


module Ctrl_uProg (go, Cont16NoCero, divisorNoCero, reloj, reset, Est, EstPresente);
  input go, Cont16NoCero, divisorNoCero, reloj, reset;
  output [2:0]  EstPresente;
  wire [2:0]  EstPresente;

  output [7:0] Est;
  wire [7:0] Est;  //Salidas indicando el estado de la maquina

  //Necesario para ver el estado codificado pero no contribuye al control
  or g0(EstPresente[0], Est[1], Est[3], Est[5], Est[7]);
  or g1(EstPresente[1], Est[2], Est[3], Est[6], Est[7]);
  or g2(EstPresente[2], Est[4], Est[5], Est[6], Est[7]);

  reg [2:0] uPC;
  reg [13:0] uIns;
  wire [2:0] Prox_uDir, Prox_uDirReset, uDir, uDirmas1;
  wire [13:0] Prox_uIns;
  wire uCond;

  //Forzar con la senal de reset las lineas de prox_uDir a cero, para comenzar en el estado cero
  and g3 (Prox_uDirReset[2], reset, Prox_uDir[2]);
  and g4 (Prox_uDirReset[1], reset, Prox_uDir[1]);
  and g5 (Prox_uDirReset[0], reset, Prox_uDir[0]);

  not g6 (goB, go);
  not g7 (divisorNoCeroB, divisorNoCero);

  mux8a1      selecCond (uCond, {1'b1, 1'b1, goB, Cont16NoCero, divisorNoCeroB, go, 1'b1, 1'b0}, uIns[13], uIns[12], uIns[11]);
  mux2a1 #(2) selecDir  (Prox_uDir, uDirmas1, uIns[2:0], uCond);
  inc    #(2) inc_uDir  (uDirmas1, uPC);
  memROM mem_uProg (Prox_uIns, Prox_uDirReset);

  always @ (negedge reloj)
    uPC = Prox_uDirReset;

  always @ (negedge reloj)
    uIns = Prox_uIns;

  assign Est = uIns[10:3];
endmodule
