`include "Globales.v"

//Latch D Simple
module LatchD_simple (
	input wire				Clock,
	input wire				Reset,
	input wire				D,
	output reg		 		Q
);
always @ (Clock, Reset)
  begin
	if ( Reset )
		Q = 0;
	else if (Clock)
		Q = D; 
  end

endmodule
