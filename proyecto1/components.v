`default_nettype none
`timescale 1ns/100ps

// Banco de flip-flops
module FFD_POSEDGE #( parameter SIZE = 8) (
	input wire                clock,
	input wire [SIZE - 1 : 0] D,
	output reg [SIZE - 1 : 0] Q	
);
	
	always @ (posedge clock)
		Q <= D;
		
endmodule

// Mux de 2 a 1

module mux2to1 #( parameter SIZE = 10) (
	input wire                 select,
	input wire  [SIZE - 1 : 0] data0,
	input wire  [SIZE - 1 : 0] data1,	
	output wire [SIZE - 1 : 0] data_out
);

	assign data_out = select ? data1 : data0 ;
	
endmodule

// Sub-bloque eléctrico del transmisor

module TX_I_O(
	input wire TRANSCLK,
	input wire data,
	input wire TXIDLE,
	input wire RXDET,
	output reg RXDET_O,
	output reg TX_P,
	output reg TX_N
);

	reg tmp;

	always @ (posedge TRANSCLK)
	begin
		tmp = $random;
		if(TXIDLE)
			begin
			TX_P <= 1'b1;
			TX_N <= 1'b1;
			end
		else
			begin
			TX_P <= data;
			TX_N <= ~data;
			end	
		
		RXDET_O <= #7 RXDET & tmp;
	end

endmodule

// Sub-bloque eléctrico del receptor

module RX_I_O(
	input wire RX_P,
	input wire RX_N,
	output reg RXIDLE,
	output reg data_out
);

	always @ (RX_P or RX_N)
	begin
		data_out <= RX_P;
		
		if(RX_P == RX_N)
			RXIDLE <= 1'b1;
		else
			RXIDLE <= 1'b0;
	end

endmodule

// Este es un PLL
module clock_recovery(
	input wire TRANSCLK,
	input wire data,
	output reg CRC_CKL
);

endmodule

module K285DET(
	input wire TRANSCLK,
	input wire [9:0] data_in,
	output reg SYMBOL_CLK,
	output reg RXVALID
);

endmodule

module status(
	input wire       BUFF_OVERFLOW,
	input wire       SKP_ADDED,
	input wire       SKP_REMOVED,
	input wire       DECODE_ERROR,
	input wire       DISPARITY_ERROR,
	input wire       RXDET_O,
	output reg [2:0] RXSTATUS
);

endmodule


