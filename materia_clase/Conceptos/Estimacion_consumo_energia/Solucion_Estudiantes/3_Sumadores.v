//Definicion de retardos para las compuertas usadas
`define Tinv  1
`define Tand2 2
`define Tand3 3
`define Tand4 4
`define Tand5 5
`define Tor2  2
`define Tor3  3
`define Tor4  4
`define Tor5  5
`define Txor2 2
`define Txor3 4

//Definicion de "ponderaciones" de potencia para las compuertas usadas
`define Pinv  60 //minimo comun multiplo
`define Pand2 2*`Pinv
`define Pand3 3*`Pinv
`define Pand4 4*`Pinv
`define Pand5 5*`Pinv
`define Por2  1/2*`Pinv
`define Por3  1/3*`Pinv
`define Por4  1/4*`Pinv
`define Por5  1/5*`Pinv
`define Pxor2 1*`Pinv
`define Pxor3 2*`Pinv


//Definicion del numero de contadores de transiciones a usar
//NumPwrCntr debe tener el numero de contadores N, menos uno: NumPwrCntr = N - 1
//Ndir debe ser tal que (2^(Ndir+1) - 1) > NumPwrCntr. De lo contrario los "for" nunca se detienen.
`define NumPwrCntr 2
`define Ndir 1

//Compuertas especiales que reportan la transiciones de 0 a 1
//a un contador central en el banco de pruebas

//*************************************************************************
//Compuerta inversora

module inv_p(a, b);
  parameter
    PwrC = 0;

  input b;
  output a;

  assign #`Tinv a = ~b;

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Pinv;
endmodule

//*************************************************************************
//Compuerta and de 2 entradas

module and2_p(a, b, c);
  parameter
    PwrC = 0;

  input b, c;
  output a;

  assign #`Tand2 a = &{b,c};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Pand2;
endmodule

//*************************************************************************
//Compuerta and de 3 entradas

module and3_p(a, b, c, d);
  parameter
    PwrC = 0;

  input b, c, d;
  output a;

  assign #`Tand3 a = &{b,c,d};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Pand3;

endmodule

//*************************************************************************
//Compuerta and de 4 entradas

module and4_p(a, b, c, d, e);
  parameter
    PwrC = 0;

  input b, c, d, e;
  output a;

  assign #`Tand4 a = &{b,c,d,e};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Pand4;

endmodule

//*************************************************************************
//Compuerta and de 5 entradas

module and5_p(a, b, c, d, e, f);
  parameter
    PwrC = 0;

  input b, c, d, e, f;
  output a;

  assign #`Tand5 a = &{b,c,d,e,f};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Pand5;

endmodule

//*************************************************************************
//Compuerta or de 2 entradas

module or2_p(a, b, c);
  parameter
    PwrC = 0;

  input b, c;
  output a;

  assign #`Tor2 a = |{b,c};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Por2;
endmodule

//*************************************************************************
//Compuerta or de 3 entradas

module or3_p(a, b, c, d);
  parameter
    PwrC = 0;

  input b, c, d;
  output a;

  assign #`Tor3 a = |{b,c,d};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Por3;
endmodule


//*************************************************************************
//Compuerta or de 4 entradas

module or4_p(a, b, c, d, e);
  parameter
    PwrC = 0;

  input b, c, d, e;
  output a;

  assign #`Tor4 a = |{b,c,d,e};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Por4;
endmodule


//*************************************************************************
//Compuerta or de 5 entradas

module or5_p(a, b, c, d, e, f);
  parameter
    PwrC = 0;

  input b, c, d, e, f;
  output a;

  assign #`Tor5 a = |{b,c,d,e,f};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Por5;
endmodule

//*************************************************************************
//Compuerta xor de 2 entradas

module xor2_p(a, b, c);
  parameter
    PwrC = 0;

  input b, c;
  output a;

  assign #`Txor2 a = ^{b,c};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Pxor2;
endmodule

//*************************************************************************
//Compuerta xor de 3 entradas

module xor3_p(a, b, c, d);
  parameter
    PwrC = 0;

  input b, c, d;
  output a;

  assign #`Txor3 a = ^{b,c,d};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + `Pxor3;
endmodule

//*************************************************************************
//Sumador completo de un bit que utiliza las compuertas especiales

module Sum_comp (a, b, ci, s, co);
  parameter
    PwrC = 0;

  input a, b, ci;
  output s, co;

  //Salida del sumador
  //assign s = a ^ b ^ ci;
  xor3_p #(PwrC) g1(s, a, b, ci);
  //xor2_p #(PwrC) g2(s, x, ci); eliminado para usar compuerta de 3 entradas

  //Salida del llevo
  //assign co = a & b | a & ci | b & ci;
  and2_p #(PwrC) g3(z1, a, b);
  and2_p #(PwrC) g4(z2, a, ci);
  and2_p #(PwrC) g5(z3, b, ci);
  or3_p  #(PwrC) g6(co, z1, z2, z3);
  //or2_p  #(PwrC) g7(co, z3, z4); eliminado para usar compuerta de 3 entradas
endmodule

//*************************************************************************
//Sumador de rizado de 8 bits

module SUM8(a, b, ci, s, co);
  parameter
    PwrC = 0;

  input [7:0] a, b;
  input ci;
  output [7:0] s;
  output co;
  wire [6:0] carry;

  //8 sumadores completos con el llevo pasado de etapa a etapa
  Sum_comp #(PwrC) sum0(a[0], b[0], ci,       s[0], carry[0]);
  Sum_comp #(PwrC) sum1(a[1], b[1], carry[0], s[1], carry[1]);
  Sum_comp #(PwrC) sum2(a[2], b[2], carry[1], s[2], carry[2]);
  Sum_comp #(PwrC) sum3(a[3], b[3], carry[2], s[3], carry[3]);
  Sum_comp #(PwrC) sum4(a[4], b[4], carry[3], s[4], carry[4]);
  Sum_comp #(PwrC) sum5(a[5], b[5], carry[4], s[5], carry[5]);
  Sum_comp #(PwrC) sum6(a[6], b[6], carry[5], s[6], carry[6]);
  Sum_comp #(PwrC) sum7(a[7], b[7], carry[6], s[7], co);

endmodule

//*************************************************************************
//Sumador de 4 bits basado en el sumador MSI 74x283

module SUM4_logico(a, b, c0, s, c4);
  parameter
    PwrC = 0;

  /***********************************
  a:  sumando a
  b:  sumando b
  co: carry in
  c4: carry out
  s:  resultado
  ***********************************/

  input [3:0] a, b;
  input c0;

  output [3:0] s;
  output c4;

  //gk= a[k]*b[k]
  and2_p  #(PwrC)   g_00(g3, a[3], b[3]);
  and2_p  #(PwrC)   g_02(g2, a[2], b[2]);
  and2_p  #(PwrC)   g_04(g1, a[1], b[1]);
  and2_p  #(PwrC)   g_06(g0, a[0], b[0]);

  //pk= a[k]+b[k]
  or2_p   #(PwrC)   g_01(p3, a[3], b[3]);
  or2_p   #(PwrC)   g_03(p2, a[2], b[2]);
  or2_p   #(PwrC)   g_05(p1, a[1], b[1]);
  or2_p   #(PwrC)   g_07(p0, a[0], b[0]);

  //c4= p3*(g3+p2)*(g3+g2+p1)*(g3+g2+g1+p0)*(g3+g2+g1+g0+c0)
  or2_p   #(PwrC)   g_08(x0, g3, p2);
  or3_p   #(PwrC)   g_09(x1, g3, g2, p1);
  or4_p   #(PwrC)   g_10(x2, g3, g2, g1, p0);
  or5_p   #(PwrC)   g_11(x3, g3, g2, g1, g0, c0);
  and5_p  #(PwrC)   g_12(c4, p3, x0, x1, x2, x3);

  //c3= p2*(g2+p1)*(g2+g1+p0)*(g2+g1+g0+c0)
  or2_p   #(PwrC)   g_13(x4, g2, p1);
  or3_p   #(PwrC)   g_14(x5, g2, g1, p0);
  or4_p   #(PwrC)   g_15(x6, g2, g1, g0, c0);
  and4_p  #(PwrC)   g_16(c3, p2, x4, x5, x6);

  //c2= p1*(g1+p0)*(g1+g0+c0)
  or2_p   #(PwrC)   g_17(x7, g1, p0);
  or3_p   #(PwrC)   g_18(x8, g1, g0, c0);
  and3_p  #(PwrC)   g_19(c2, p1, x7, x8);

  //c1= p0*(g0+c0)
  or2_p   #(PwrC)   g_20(x9, g0, c0);
  and2_p  #(PwrC)   g_21(c1, p0, x9);

  //_gk= gk'
  inv_p   #(PwrC)   g_22(_g3, g3);
  inv_p   #(PwrC)   g_24(_g2, g2);
  inv_p   #(PwrC)   g_26(_g1, g1);
  inv_p   #(PwrC)   g_28(_g0, g0);

  //hsk= pk*gk'
  and2_p  #(PwrC)   g_23(hs3, _g3, p3);
  and2_p  #(PwrC)   g_25(hs2, _g2, p2);
  and2_p  #(PwrC)   g_27(hs1, _g1, p1);
  and2_p  #(PwrC)   g_29(hs0, _g0, p0);

  //s[k]= hsk^ck
  xor2_p  #(PwrC)   g_30(s[3], hs3, c3);
  xor2_p  #(PwrC)   g_31(s[2], hs2, c2);
  xor2_p  #(PwrC)   g_32(s[1], hs1, c1);
  xor2_p  #(PwrC)   g_33(s[0], hs0, c0);
                       
endmodule

//*************************************************************************
//Sumador logico de 8 bits (formado por 2 sumadores de 4 bits 74x283)

module SUM8_logico(a, b, ci, s, co);
  parameter
    PwrC = 0;

  input   [7:0]   a, b;
  input           ci;
  output  [7:0]   s;
  output          co;

  wire    [7:0]   a, b, s;
  wire    [3:0]   a_L, a_H, b_L, b_H, s_L, s_H;
  wire            ci, co;

  SUM4_logico  #(PwrC)   sum4_L(a_L, b_L, ci, s_L, co_L);
  SUM4_logico  #(PwrC)   sum4_H(a_H, b_H, co_L, s_H, co);

  assign a_L[3:0]=a[3:0];
  assign b_L[3:0]=b[3:0];
  assign a_H[3:0]=a[7:4];
  assign b_H[3:0]=b[7:4];
  assign s[3:0]=s_L[3:0];
  assign s[7:4]=s_H[3:0];

endmodule

//*************************************************************************
//Sumador de 4 bits con anticipacion de acarreo (carry look-ahead)

module SUM4_lookahead(a, b, ci, s, co);
  parameter
    PwrC = 0;

  input [3:0] a,b;
  input ci;
  output [3:0] s;
  output co;

  //g[k] = a[k]&b[k]
  and2_p #(PwrC) g_0(g0,a[0],b[0]);
  and2_p #(PwrC) g_1(g1,a[1],b[1]);
  and2_p #(PwrC) g_2(g2,a[2],b[2]);
  and2_p #(PwrC) g_3(g3,a[3],b[3]);

  //p[k] = a[k]|b[k]
  or2_p #(PwrC) g_4(p0,a[0],b[0]);
  or2_p #(PwrC) g_5(p1,a[1],b[1]);
  or2_p #(PwrC) g_6(p2,a[2],b[2]);
  or2_p #(PwrC) g_7(p3,a[3],b[3]);

  //c0 = g0 + p0*Cin
  and2_p #(PwrC) g_8(x8,ci,p0);
  or2_p #(PwrC)   g_9(c0,g0,x8);

  //c1 = g1 + p1*g0 + p1*p0*Cin
  and3_p #(PwrC) g_10(x10,p1,p0,ci);
  and2_p #(PwrC) g_11(x11,p1,g0);
  or3_p #(PwrC)  g_12(c1,x10,x11,g1);

  //c2 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*Cin
  and4_p #(PwrC) g_13(x13,p2,p1,p0,ci);
  and3_p #(PwrC) g_14(x14,p2,p1,g0);
  and2_p #(PwrC) g_15(x15,p2,g1);
  or4_p  #(PwrC) g_16(c2,x13,x14,x15,g2);

  //c3 = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*cin
  and5_p #(PwrC) g_17(x17,p3,p2,p1,p0,ci);
  and4_p #(PwrC) g_18(x18,p3,p2,p1,g0);
  and3_p #(PwrC) g_19(x19,p3,p2,g1);
  and2_p #(PwrC) g_20(x20,p3,g2);
  or5_p  #(PwrC) g_21(co,x20,x19,x18,x17,g3);

  //s[k] = p[k]^g[k]^c[k-1]
  xor3_p #(PwrC) g_22(s[0],p0,g0,ci);
  xor3_p #(PwrC) g_23(s[1],p1,g1,c0);
  xor3_p #(PwrC) g_24(s[2],p2,g2,c1);
  xor3_p #(PwrC) g_25(s[3],p3,g3,c2);

endmodule

//*************************************************************************
//Sumador de 8 bits a partir de modulos con anticipacion de acarreo de 4 bits(carry look-ahead)

module SUM8_lookahead(a, b, ci, s, co);
  parameter
    PwrC = 0;

  input   [7:0]   a, b;
  input           ci;
  output  [7:0]   s;
  output          co;

  wire    [7:0]   a, b, s;
  wire    [3:0]   a_L, a_H, b_L, b_H, s_L, s_H;
  wire            ci, co;

  SUM4_lookahead  #(PwrC)   sum4look_L(a_L, b_L, ci, s_L, co_L);
  SUM4_lookahead  #(PwrC)   sum4look_H(a_H, b_H, co_L, s_H, co);

  assign a_L[3:0]=a[3:0];
  assign b_L[3:0]=b[3:0];
  assign a_H[3:0]=a[7:4];
  assign b_H[3:0]=b[7:4];
  assign s[3:0]=s_L[3:0];
  assign s[7:4]=s_H[3:0];

endmodule

//*************************************************************************
//Memoria con contadores de transicion

module memTrans (dir, LE, dato);
  input [`Ndir:0] dir;
  input LE;
  inout [31:0] dato;
  reg [31:0] PwrCntr [`NumPwrCntr:0];

  //Control de E/S del puerto de datos
  assign dato = (LE)? PwrCntr[dir] : 32'bz;

  //Ciclo de escritura para la memoria
  always @(dir or negedge LE or dato)
    begin
      if (~LE) //escritura
        PwrCntr[dir] = dato;
    end

endmodule

//*************************************************************************
//Banco de pruebas con las distintas configuraciones de sumadores

module BancoPruebas;
  reg [7:0] oprA, oprB;
  reg [31:0] Contador;
  reg [`Ndir:0] dir;
  reg LE;
  integer semilla,Contador_sumas;
  wire [31:0] dato;
  wire [7:0] Suma, Suma_logico, Suma_look;
  wire llevo, llevo_logico, llevo_look;

  //Conexion a la memoria de contadores de transicion
  memTrans m1 (dir, LE, dato);
  //Control de E/S del puerto de dato de la memoria de contadores
  assign dato = (~LE)? Contador : 32'bz;

  //Sumador de rizado de 8 bits
  //El resultado de las transiciones se guarda en el contador 0
  SUM8        #(0)  sumadorRizado   (oprA, oprB, 1'b0, Suma, llevo);

  //Sumador en grupos de 4 bits de 74x283
  //El resultado de las transiciones se guarda en el contador 1
  SUM8_logico #(1)  sumadorLogico   (oprA, oprB, 1'b0, Suma_logico, llevo_logico);

  //Sumador carry look-ahead en grupos de 4 bits
  //El resultado de las transiciones se guarda en el contador 2
  SUM8_lookahead #(2) sumadorLookAhead  (oprA, oprB, 1'b0, Suma_look, llevo_look);

  initial
    begin
      $dumpfile ("Sumadores.vcd");
      $dumpvars;
      //Borre memoria con contadores de transicion
      #1 LE = 0;
      Contador = 0;
      Contador_sumas = 0;
      for (dir=0; dir<=`NumPwrCntr; dir=dir+1)
        #1 Contador = 0;
      //Semilla inicial para el generador de numeros aleatorios
      semilla = 0;
      //Primer par de operandos para los sumadores
      #50
      Contador_sumas = Contador_sumas + 1;
      //oprA = $random(semilla);
      //oprB = $random(semilla);
      //para validar el tiempo de propagacion de cada sumador
      oprA = 8'h01;
      oprB = 8'hFF;
      repeat (4999)
        begin
          #50
	  $display ("No. Suma = %d: Operador A = %d, Operador B = %d, Sumador_1 = %d, Sumador_2 = %d, Sumador_3=%d",Contador_sumas,oprA,oprB,Suma,Suma_logico,Suma_look);
	  Contador_sumas = Contador_sumas + 1;
          oprB = $random(semilla);
          oprA = $random(semilla);
        end
      # 50 $display ("No. Suma = %d: Operador A = %d, Operador B = %d, Sumador_1 = %d, Sumador_2 = %d, Sumador_3=%d",Contador_sumas,oprA,oprB,Suma,Suma_logico,Suma_look);
      //Lea y despliegue la memoria con contadores de transicion
      #50 LE = 1;
	  
      for (dir=0; dir<=`NumPwrCntr; dir=dir+1)
        begin
          #1 Contador = dato;
          $display(,,"PwrCntr[%d]: %d", dir, Contador);
        end
      #1 $finish;
    end

endmodule
