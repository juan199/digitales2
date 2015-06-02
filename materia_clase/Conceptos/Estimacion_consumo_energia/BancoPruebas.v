//Definicion de retardos para las compuertas usadas
`define Tand2 3
`define Tor2  3
`define Txor2 3

//Definicion del numero de contadores de transiciones a usar
//NumPwrCntr debe tener el numero de contadores N, menos uno: NumPwrCntr = N - 1
//Ndir debe ser tal que (2^(Ndir+1) - 1) > NumPwrCntr. De lo contrario los "for" nunca se detienen.
`define NumPwrCntr 2
`define Ndir 1

//Compuertas especiales que reportan la transiciones de 0 a 1
//a un contador central en el banco de pruebas

module and2_p(a, b, c);
  parameter
    PwrC = 0;

  input b, c;
  output a;

  assign #`Tand2 a = &{b,c};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + 1;
endmodule


module or2_p(a, b, c);
  parameter
    PwrC = 0;

  input b, c;
  output a;

  assign #`Tor2 a = |{b,c};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + 1;
endmodule


module xor2_p(a, b, c);
  parameter
    PwrC = 0;

  input b, c;
  output a;

  assign #`Txor2 a = ^{b,c};

  //En las transiciones de 0 a 1 en las salidas se consume energia
  always @(posedge a)
    BancoPruebas.m1.PwrCntr[PwrC] = BancoPruebas.m1.PwrCntr[PwrC] + 1;
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
  xor2_p #(PwrC) g1(x, a, b);
  xor2_p #(PwrC) g2(s, x, ci);

  //Salida del llevo
  //assign co = a & b | a & ci | b & ci;
  and2_p #(PwrC) g3(z1, a, b);
  and2_p #(PwrC) g4(z2, a, ci);
  and2_p #(PwrC) g5(z3, b, ci);
  or2_p  #(PwrC) g6(z4, z1, z2);
  or2_p  #(PwrC) g7(co, z3, z4);
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
  integer semilla;
  wire [31:0] dato;
  wire [7:0] Suma;
  wire llevo;

  //Conexion a la memoria de contadores de transicion
  memTrans m1 (dir, LE, dato);
  //Control de E/S del puerto de dato de la memoria de contadores
  assign dato = (~LE)? Contador : 32'bz;

  //Sumador de rizado de 8 bits
  //El resultado de las transiciones se guarda en el contador 1
  SUM8 #(1) sumadorRizado (oprA, oprB, 1'b0, Suma, llevo);

  initial
    begin
      //Borre memoria con contadores de transicion
      #1 LE = 0;
      Contador = 0;
      for (dir=0; dir<=`NumPwrCntr; dir=dir+1)
        #1 Contador = 0;
      //Semilla inicial para el generador de numeros aleatorios
      semilla = 0;
      //Primer par de operandos para los sumadores
      #50
      oprA = $random(semilla);
      oprB = $random(semilla);
      repeat (5000)
        begin
          #50
          oprB = $random(semilla);
          oprA = $random(semilla);
        end
      //Lea y despliegue la memoria con contadores de transicion
      #100 LE = 1;
      for (dir=0; dir<=`NumPwrCntr; dir=dir+1)
        begin
          #1 Contador = dato;
          $display(,,"PwrCntr[%d]: %d", dir, Contador);
        end
      #1 $finish;
    end

endmodule
