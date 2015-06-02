module BancoPruebas;

  wire [2:0] Q;

  relojito r1(clk);
  cont3bC c1(clk, Q);

  initial
    begin
	  $dumpfile("senales.vcd");
	  $dumpvars;
      $display ("Hola Mundo!!");
	  $monitor ($time,,"clk = %b  Q = %d", clk, Q);
	  #500 $finish;
	end
endmodule 

module relojito(reloj);
  output reloj;
  reg reloj;

  initial #29 reloj = 0;
	
  always
   #6 reloj = ~reloj;
   
  //~ assign #6 reloj = ~reloj;
  
endmodule

module cont3bC (reloj, Q);
  input reloj;
  output [2:0] Q;
  reg [2:0] Q;
  
  initial Q = 0;
  
  always @ (negedge reloj)
    #5 Q = Q + 1;
  
endmodule 
