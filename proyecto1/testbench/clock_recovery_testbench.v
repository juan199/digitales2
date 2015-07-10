`default_nettype none
`timescale 1ns/1ps

module testbench;

	reg data; 
	wire CRC_CLK;

	// Engancha si 3.6 < T/2 < 7.9
	always
		#5.1 data = ~data;
		
	clock_recovery #( .T(10) ) cr_circuit (
		.data(data),
		.CRC_CLK(CRC_CLK)
	);
		
	initial
		begin
		$dumpfile("clock_recovery_dump.vco");
		$dumpvars;
        data = 0;
		#1000 $finish;
		end		
endmodule
