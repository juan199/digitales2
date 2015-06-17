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

// contador hacia arriba

module UP_COUNTER #( parameter INIT_VALUE = 4'b0) (
	input wire       Reset,
	input wire       clock,
	output reg [3:0] Q
);

	always @ (posedge clock)
	begin
		if(Reset)
			Q = INIT_VALUE;
		else
			Q = Q + 1;
	end
	
endmodule

// Sub-bloque eléctrico del transmisor

module TX_I_O(
	input wire  TRANSCLK,
	input wire  data,
	input wire  TXIDLE,
	input wire  RXDET,
	output reg  RXDET_O,
	output wire TX_P,
	output wire TX_N
);

	reg tmp;
	
	assign TX_P = TXIDLE ? 1'b1 : data;
	assign TX_N = TXIDLE ? 1'b1 : ~data;
	
	always @ (posedge TRANSCLK)
		RXDET_O <= #7 RXDET & tmp;

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

module K285DET(
	input wire TRANSCLK,
	input wire [9:0] data_in,
	output reg SYMBOL_CLK,
	output reg RXVALID
);

endmodule

module status(

	input wire       SKP_ADDED,
	input wire       SKP_REMOVED,
	input wire       RXDET_O, /////////////Check!! It should be PhyStatus not RxDet_O
	input wire       DECODE_ERROR,
	input wire       BUFF_OVERFLOW,
	input wire       BUFF_UNDERFLOW,
	input wire       DISPARITY_ERROR,
	output reg [2:0] RXSTATUS
);
	always @(*)
		//in order of priority
		if(RXDET_O) 
			RXSTATUS = 3'b011;
		else if(DECODE_ERROR)
		    RXSTATUS = 3'b100;
		else if(BUFF_OVERFLOW)   
			RXSTATUS = 3'b101;
		else if(BUFF_UNDERFLOW)  
			RXSTATUS = 3'b110;
		else if(DISPARITY_ERROR) 
			RXSTATUS = 3'b111;
		else if(SKP_ADDED) 		 
			RXSTATUS = 3'b001;
		else if(SKP_REMOVED) 	 
			RXSTATUS = 3'b010;
		else 		 
			RXSTATUS = 3'b000;
endmodule


