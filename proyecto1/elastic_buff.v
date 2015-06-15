module elastic_buffer(
	input wire       SYMBOL_CLK, //contador +1
	input wire       INTERCLK, //contador -1
	input wire [9:0] data_in,
	input wire       iRXVALID,
	output reg       BUFF_OVERFLOW,
	output reg       SKP_ADDED,
	output reg       SKP_REMOVED,
	output reg [9:0] data_out,
	output reg       oRXVALID
);





always @(posedge SYMBOL_CKL) begin
              
 
     data[0] = data[1];
     data[1] = data[2];
     data[2] = data[3];
     data[3] = data[4];
     data[4] = data[5];
     data[5] = data[6]; 
     data[6] = data[7]; 
     data[7] = data[8];
     data[8] = data[9];
     data[9] = data_in;   
        				
       end
					






endmodule



module FF_EN (
input wire clock,
input wire Data,
input wire EN,
output reg Out

);

	if(EN) begin
        always @(posedge clock)begin
			Out = Data;
        end
end

endmodule


module fila_FF(
input clock,
input wire fila_data [10:0],
input wire enable,
output reg fila_out [10:0]

);


FF_EN  e0(clock, fila_data[0],  enable, fila_out[0]); //data
FF_EN  e1(clock, fila_data[1],  enable, fila_out[1]);
FF_EN  e2(clock, fila_data[2],  enable, fila_out[2]);
FF_EN  e3(clock, fila_data[3],  enable, fila_out[3]);
FF_EN  e4(clock, fila_data[4],  enable, fila_out[4]);
FF_EN  e5(clock, fila_data[5],  enable, fila_out[5]);
FF_EN  e6(clock, fila_data[6],  enable, fila_out[6]);
FF_EN  e7(clock, fila_data[7],  enable, fila_out[7]);
FF_EN  e8(clock, fila_data[8],  enable, fila_out[8]);
FF_EN  e9(clock, fila_data[9],  enable, fila_out[9]);
FF_EN e10(clock, fila_data[10], enable, fila_out[10]); //Valid


endmodule

module B11 (
input wire clock,
input wire [10:0] data_IN, //incluye RxValid
input wire [2:0] point_IN, // puntero meta
input wire [2:0] point_OUT, //puntero saque
input wire enable,
output wire [10:0] data_OUT
);


wire [10:0] temp [7:0]; // son las salidas del arreglo de FF
wire [10:0] out_mux [7:0]; // es la salida del mux de entrada, para el arreglo de FF

fila_FF fila0 (clock,  out_mux[0], enable, temp[0]);
fila_FF fila1 (clock,  out_mux[1], enable, temp[1]);
fila_FF fila2 (clock,  out_mux[2], enable, temp[2]);
fila_FF fila3 (clock,  out_mux[3], enable, temp[3]);
fila_FF fila4 (clock,  out_mux[4], enable, temp[4]);
fila_FF fila5 (clock,  out_mux[5], enable, temp[5]);
fila_FF fila6 (clock,  out_mux[6], enable, temp[6]);
fila_FF fila7 (clock,  out_mux[7], enable, temp[7]);




case (point_IN) begin //mux controlado por el puntero meta

   3b'000: assign out_mux[0] = data_IN;
   3b'001: assign out_mux[1] = data_IN;
   3b'010: assign out_mux[2] = data_IN;
   3b'011: assign out_mux[3] = data_IN;
   3b'100: assign out_mux[4] = data_IN;
   3b'101: assign out_mux[5] = data_IN;
   3b'110: assign out_mux[6] = data_IN;
   3b'111: assign out_mux[7] = data_IN;
   

end



case (point_out) begin //mux controlado por el puntero saque

   3b'000: assign data_OUT = temp[0];
   3b'001: assign data_OUT = temp[1];
   3b'010: assign data_OUT = temp[2];
   3b'011: assign data_OUT = temp[3];
   3b'100: assign data_OUT = temp[4];
   3b'101: assign data_OUT = temp[5];
   3b'110: assign data_OUT = temp[6];
   3b'111: assign data_OUT = temp[7];
   

end



endmodule 


module Control(
input wire CLK_IN,
input wire CLK_OUT,
input wire Valid,
output wire [2:0] point_in,
output wire [2:0] point_out,
output wire [9:0] skp_command


);

if(Valid) begin



end

else   begin
		 
  assign skp_command = 10b'1010101010;
  point_out = point_out+1;

end


		always @(posedge CLK_IN)begin

				point_in = point_in+1;

		end

		always @(posedge CLK_OUT)begin

				point_out = point_out+1;

		end
		
		
		

endmodule
