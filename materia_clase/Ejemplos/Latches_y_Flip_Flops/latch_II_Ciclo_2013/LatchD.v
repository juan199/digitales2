`include "Globales.v"

//Latch D
module LatchD (
	input wire				Clock,
	input wire				Reset,
	input wire				D,
	output reg		 		Q
);

always @ (Clock, Reset) //Reset debe hace
  begin
    $display ($time,,,"==Entra always ======");
	if ( Reset )
		begin
			assign Q = 0;
			$display ($time,,,"   RESET");
		end
	else if (Clock)
	begin
		assign Q = D; 
		$display ($time,,,"    TRANSPARENTE");	
	end
	else
		begin
		  deassign Q;
		  $display ($time,,,"    DE-ASIGNA");
		end
    $display ($time,,,"==Sale always ======");
	end	
 
always @ (negedge Clock)
  begin
    $display ($time,,,"----NEGEDGE----");
	Q = D;
  end
endmodule
