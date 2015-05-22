module elastic_buffer(
	input wire       SYMBOL_CLK,
	input wire       INTERCLK,
	input wire [9:0] data_in,
	input wire       iRXVALID,
	output reg       BUFF_OVERFLOW,
	output reg       SKP_ADDED,
	output reg       SKP_REMOVED,
	output reg [9:0] data_out,
	output reg       oRXVALID
);

endmodule
