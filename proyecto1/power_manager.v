`timescale 1ns/100ps

module clock(reloj);

  output reloj;
  reg reloj;
  
  initial #3 reloj = 0;
	
  always
  
  if (reloj)
   #15 reloj = 0;
   else
   #15 reloj =1;

endmodule
