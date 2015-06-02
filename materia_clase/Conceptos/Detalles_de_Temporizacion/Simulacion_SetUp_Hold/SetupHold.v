//`timescale 1us / 1ns

//D Latch
module DLatch (d, g, q, qb);
  parameter Ta = 1,
            Tb = 1,
            Tbas = 1;
  input d, g;
  output q, qb;
  wire db, s, r;
  
  //El latch con dos NOR
  nor #(Ta) c1 (qb, s, q);
  nor #(Tb) c2 (q, r, qb);
  //El control de entrada
  not #(Tbas) invD (db, d);
  and #(Tbas) gate1 (s,  d, g);
  and #(Tbas) gate2 (r, db, g);
  
endmodule

module GenG (g);
  parameter TH = 1, //Tiempo en alto
            TL = 2; //Tiempo en bajo
  output reg g;
  initial
    g = 0;
	
  always begin
    #TL g = 1;
	#TH g = 0;
  end
endmodule

module GenD (d);
  parameter TH = 1, //Tiempo en alto
            TL = 2; //Tiempo en bajo
  output reg d;
  
  initial begin
    d = 0;
  end
	
  always begin
    #TL d = 1;
	#TH d = 0;
	#1 d = 0;
  end
endmodule

//Top Module
module testbench;
  wire d, g;

  //Invocar una instancia del latch
  DLatch #(3, 3, 3) DL1 (d, g, q, qb);
  //Invocar los generadores de pulsos para datos y habilitacion del latch
  GenG #(15, 45) GenHabLatch (g);
  GenD #(30, 90) GenDato (d);

  initial
    begin
      //Prepare el archivo *.vcd
      $dumpfile ("SetUp_Hold.vcd");
      $dumpvars;
	  
	  #12000
	  $finish;

    end
endmodule
	