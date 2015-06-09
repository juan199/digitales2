`default_nettype none
`timescale 1ns/100ps

module testbench;

	wire trans_clock; 	
	reg vco_clk;
	wire up, down;
	
	initial
		vco_clk = 1'b1;
	always
		#0.5 vco_clk = ~ vco_clk;
	
	trans_clock tc(
		.clock(trans_clock)
	);
	
	phase_detector pd(
		.ref_clk(trans_clock),
		.vco_clk(vco_clk),
		.up(up),
		.down(down)
	);
	
	initial
		begin
		$dumpfile("clock_recovery_dump.vcd");
		$dumpvars;
		#20 $finish;
		end		
endmodule
