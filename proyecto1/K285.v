module K285(
	input wire CRCLK,
	input wire [9:0] data_in,
	input wire Reset,
	output wire SYMBOL_CLK,
	output reg RXVALID
);

//1. CHECK SIEMPRE ESTA EN 0 -.- Y NI PUTA IDEA PORQUE
//2. HAY QUE RESETEAR EL CONTADOR APENAS HAYA UN POSEDGE RXVALID Y COMO ES WIRE SE DESMADRA



wire [3:0] Q;
wire rst;
wire check;

UP_COUNTER count(rst, CRCLK, Q);

initial begin
RXVALID = 0;

end

assign rst = (SYMBOL_CLK | Reset); //| check; sera aca?? para resetear el cont

assign check = (~data_in[9] & ~data_in[8] & data_in[7] & data_in[6] & data_in[5] & data_in[4] & ~data_in[3] & data_in[2] & ~data_in[1] & data_in[1]) | (data_in[9] & data_in[8] & ~data_in[7] & ~data_in[6] & ~data_in[5] & ~data_in[4] & data_in[3] & ~data_in[2] & data_in[1] & ~data_in[1]);

assign SYMBOL_CLK = ( check | (Q[0] & ~Q[1] & ~Q[2] & Q[3]) ) &  RXVALID; //TRIGGER IF VALID?



always @(posedge check) begin // SI K28.5 DETECTADO => VALIDO

 RXVALID = 1;  //rst =1;     //SE RESETEA COUNTADOR GUILLE HELP!!!!!
   
end

always @(posedge Reset) begin  // SI RESET DETECTADO => INVALIDO VIENE BASURA, NO ESTAMOS SINCRONIZADOS

 RXVALID = 0;
   
end

endmodule
