module K285(
	input wire CRCLK,
	input wire [9:0] data_in,
	input wire Reset,
	output wire SYMBOL_CLK,
	output reg RXVALID
);


wire [3:0] Q;
wire rst;
wire check;
assign rst = SYMBOL_CLK | Reset;

UP_COUNTER count(rst, CRCLK, Q);

assign rst =1;

assign check = ~data_in[9] & ~data_in[8] & data_in[7] & data_in[6] & data_in[5] & data_in[4] & ~data_in[3] & data_in[2] & ~data_in[1] & data_in[1] ||
               data_in[9] & data_in[8] & ~data_in[7] & ~data_in[6] & ~data_in[5] & ~data_in[4] & data_in[3] & ~data_in[2] & data_in[1] & ~data_in[1];

assign SYMBOL_CLK = check | (Q[0] & ~Q[1] & ~Q[2] & Q[3]);

//always @(posedge CRCLK) begin


   

//end

endmodule
