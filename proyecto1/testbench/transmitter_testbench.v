`default_nettype none
`timescale 1ns/100ps

`define T_TRANS 0.4
`define T_INTER 4

module testbench;

reg Reset, TXDATAK, TXCOMP, RXLOOPB, TXIDLE, RXDET;
reg [7:0] TXDATA;
reg [9:0] DATALOOPB;
wire TRANSCLK, INTERCLK, TXCLK;
wire RXDET_O, TX_P, TX_N;


trans_clock transmission_clk(
    .clock(TRANSCLK)
);

inter_clock internal_clk(
	.clock(INTERCLK)
);

transmitter uut(
    .Reset(Reset),
	.TXCLK(TXCLK),
	.INTERCLK(INTERCLK),
	.TRANSCLK(TRANSCLK),
	.TXDATA(TXDATA),
	.TXDATAK(TXDATAK),
	.TXCOMP(TXCOMP),
	.DATALOOPB(DATALOOPB),
	.RXLOOPB(RXLOOPB),
	.TXIDLE(TXIDLE),
	.RXDET(RXDET),
	.RXDET_O(RXDET_O),
	.TX_P(TX_P),
	.TX_N(TX_N)	
);

assign TXCLK = ~ INTERCLK;

always @ (posedge INTERCLK)
	DATALOOPB = $random;

always @ (posedge TXCLK)
	TXDATA = $random;

initial
	begin
	$dumpfile("transmitter_dump.vco");
	$dumpvars;
	
	Reset = 1'b1;
	TXDATAK = 1'b0;
	TXCOMP = 1'b0;
	RXLOOPB = 1'b0;
	TXIDLE = 1'b0;
	RXDET = 1'b0;
	#(`T_INTER*2) Reset = 1'b0;
	
	#(`T_INTER*20) $finish;
	end

endmodule
