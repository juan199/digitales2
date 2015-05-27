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


module power_manager(
	input wire       REFCLK,
	input wire [1:0] PWRDDWN,
	input wire       RXDET_LOOPB, 
	input wire       RXDET_O,
	output reg       INTERCLK,
	output reg       TRANSCLK,
	output reg       RXLOOPB,
	output reg       TXIDLE,
	output reg       RXDET, 
	output reg       PHYSTATUS
);

endmodule
