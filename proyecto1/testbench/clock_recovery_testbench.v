`default_nettype none
`timescale 1ns/100ps

`define clock_t 0.8

module testbench;

	wire trans_clk; 	
	reg recover_clk;
	wire up, down;
	real tic;
	time up_tmp, down_tmp;
	
	initial
		begin
		tic = `clock_t/2.0;
		recover_clk = 1'b1;
		#0.2;
		forever
			#(tic) recover_clk = ~ recover_clk;
		end
		
	always @ (negedge down)
		down_tmp = $time;
/*		
	always @ (posedge down)
		begin
		down_tmp = $time - down_tmp;
		#(`clock_t/4.0) tic = `clock_t - down_tmp/2.0;
		end
*/
	
	trans_clock tc(
		.clock(trans_clk)
	);
	
	phase_detector pd(
		.internal_clk(trans_clk),
		.external_clk(recover_clk),
		.up(up),
		.down(down)
	);
	
	initial
		begin
		$dumpfile("clock_recovery_dump.vco");
		$dumpvars;
		#20 $finish;
		end		
endmodule
