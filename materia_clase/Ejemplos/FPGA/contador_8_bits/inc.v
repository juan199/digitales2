module registro (d, q, clk, reset);
  input [7:0] d;
  //input setB, reset, clk;
  input clk, reset;
  output [7:0] q;
  reg [7:0] q;

(* ivl_synthesis_on *)
  always @(posedge clk or posedge reset)
    begin	  
      if (reset)
        q <= 0;
      else
        q <= d;
    end
endmodule

module inc (sal, ent);
  input [7:0] ent;
  output [7:0] sal;
  
  assign sal = ent + 8'd1;
endmodule

`ifndef POST_MAP //Este es el modulo antes de mapear al FPGA
module contador (q, clk, reset);
  input clk, reset;
  output [7:0] q;
  wire [7:0] Dentrada;
  
  registro regA (Dentrada, q, clk, reset);
  inc incrA (Dentrada, q);
endmodule  
`endif //  `ifndef POST_MAP

`ifdef SIMULAR  //Incluya esta parte para hacer la simulacion
`timescale 1 ns/1 ps

module BancoPruebas;
  reg reset, clk;
  wire [7:0] q;
  
`ifdef POST_MAP
  reg        GSR;
  assign      glbl.GSR = GSR;
`endif
  
`ifdef POST_MAP //Use el modulo contador_chip si esta hecho el mapeo al FPGA
  contador_chip dut(.q(q), .clk(clk), .reset(reset));
`else
  contador contA (.q(q), .clk(clk), .reset(reset));
`endif
  
(* ivl_synthesis_off *)
  initial
    begin
      $dumpfile("inc.vcd");
      $dumpvars;
      
      /* Para simular despues de mapear al FPGA, se necesita hacer
         que el bit GSR pase de 1 a 0 para simular el encendido del chip. */
`ifdef POST_MAP
      GSR = 1;
      #100 GSR = 0;
`endif
      #10 clk = 0;
      #10 reset = 1;
      #10 reset = 0;
      #300 $finish;
    end
    
(* ivl_synthesis_off *)
    always
      #15 clk = ~clk;
      
endmodule  //BancoPruebas

`endif //SIMULAR

`ifdef HAGA_CHIP  //Incluya esta parte para asignar entradas/salidas a patillas del chip
module contador_chip(q, clk, reset);
  input clk, reset;
  output [7:0] q;

   wire 	 clk_int;  //Alambre para conectar el reloj del contador a la fuente de reloj en el chip

   (* cellref="BUFG:O,I" *)
   buf gbuf (clk_int, clk);

   contador dut(.q(q), .clk(clk_int), .reset(reset));

   /* Assign the clk to GCLK0, which is on pin P39. */
   $attribute(clk, "PAD", "P39");

   // We don't care where the remaining pins go, so set the pin number
   // to 0. This tells the implementation tools that we want a PAD,
   // but we don't care which. Also note the use of a comma (,)
   // separated list to assign pins to the bits of a vector.
   $attribute(reset, "PAD", "");
   $attribute(q, "PAD", ",,,,,,,");

endmodule // contador_chip

`endif  //HAGA_CHIP
