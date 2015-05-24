
module par2ser(
	input wire       TRANSCLK,
	input wire [9:0] data_in,
	output reg       data_out
    reg        [9:0] temp;              //10 FFs para guardar el dato valido
    reg        [4:0] contps;
);



always @(posedge TRANSCLK)

  
    if(contps == 10)begin
       contps =0;                    // resetea el contador
       temp = data_in;            // se guarda una copia en FF del valor del stream
   	end
   	 
    if(contps < 10)
      data_out = temp[contps];      // la salida toma el valor del stream segun el FF selecionado por el contador
      contps = contps + 1;           // se aumenta en 1 el puntero al FF de selecion
	end


endmodule


module ser2par(
	input wire       CRC_CKL,
	input wire       data_in,
	input wire       RXPOL,     // changes data polarity. RXPOL = 0 introduces data as it comes. RXPOL = 1 introduces data negated. 
	output reg [9:0] data_out
    reg        [9:0] preout;    //10 FFs para guardar el dato valido
    reg        [4:0] contsp;
);

    
always @(posedge CRC_CKL)

    if(contsp == 10)begin
       contsp =0;                     // se resetea el contador 
       data_out = preout;          // la salida toma el valor valido de los 10 bits
    end
   	 
    else begin
       preout[contsp] = data_in;     // se empieza a llenar una serie de FF con el valor valido 
       contsp = contsp + 1;            //cada flanco positivo (mientras que no se hayan llenado los FF) se aumenta en uno la direccion del puntero para salvar
	end
	
endmodule

