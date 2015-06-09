`default_nettype none
`timescale 1ns/100ps

module clock_recovery(
	input wire TRANSCLK,
	input wire data,
	output reg CRC_CLK
);

	

endmodule

module phase_detector(
	input wire  ref_clk,
	input wire  vco_clk,
	output wire up,
	output wire down
);
	wire rst;
	assign rst = up & down;
		
	ffd_rst ref_ff(
		.D(1'b1),
		.clk(ref_clk),
		.rst(rst),
		.Q(up)
	);

	ffd_rst vco_ff(
		.D(1'b1),
		.clk(vco_clk),
		.rst(rst),
		.Q(down)
	);
endmodule

module ffd_rst(
	input wire D,
	input wire clk,
	input wire rst,
	output reg Q
);
	initial 
		Q <= 1'b0;
		
	always @ (posedge clk or posedge rst)
		begin
			if(rst)
				Q <= 1'b0;
			else
				Q <= D;
		end	
endmodule
