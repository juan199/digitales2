
module transmitter(
	input wire       TXCLK,
	input wire       INTERCLK,
	input wire       TRANSCLK,
	input wire [7:0] TXDATA,
	input wire       TXDATAK,
	input wire       TXCOMP,
	input wire [9:0] DATALOOPB,
	input wire       RXLOOPB,
	input wire       TXIDLE,
	input wire       RXDET,
	output wire      RXDET_O,
	output wire      TX_P,
	output wire      TX_N	
);

wire [7:0] sync_ffd, encoder_in;
wire [9:0] encoder_out, parser_in;
wire       parser_out;

FFD_POSEDGE #(8) sync_register(
                      .clock(TXCLK),
                      .D(TXDATA),
                      .Q(sync_ffd)	
);

FFD_POSEDGE #(8) tx_register(
                      .clock(INTERCLK),
                      .D(sync_ffd),
                      .Q(encoder_in)	
);

encoder tx_encoder(
            .INTERCLK(INTERCLK),
            .iData(encoder_in),
            .TXDATAK(TXDATAK),
            .TXCOMP(TXCOMP),
            .oData(encoder_out)
);

mux2to1 #(10) loopb_mux(
	                 .select(RXLOOPB),
	                 .data0(encoder_out),
	                 .data1(DATALOOPB),	
	                 .data_out(parser_in)
);

par2ser tx_serdes(
	          .TRANSCLK(TRANSCLK),
	          .data_in(parser_in),
	          .data_out(parser_out)
);

TX_I_O tx_electrical(
                .TRANSCLK(TRANSCLK),
                .data(parser_out),
                .TXIDLE(TXIDLE),
                .RXDET(RXDET),
                .RXDET_O(RXDET_O),
                .TX_P(TX_P),
                .TX_N(TX_N)
);

endmodule
