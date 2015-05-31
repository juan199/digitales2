`default_nettype none
`timescale 1ns/100ps

// 250 MHz -> 4 ns
// 2.5 GHz -> 0.4 ns
module inter_clock(
		 output reg clock
);
  
  initial 
      clock = 1'b1;
	
  always
      #(4) clock = ~clock;
      
endmodule

module trans_clock(
		 output reg clock
);
  
  initial 
      clock = 1'b1;
	
  always
      #(0.4) clock = ~clock;
      
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
