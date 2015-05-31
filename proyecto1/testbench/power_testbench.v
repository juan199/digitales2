`default_nettype none
`timescale 1ns/100ps

module testbench;
	wire clk;
	
	generic_clock #(4, 1) uut(
               .clock(clk)
	);

	initial
		begin
		$dumpfile("power_dump.vco");
		$dumpvars;
		end
	
endmodule 
