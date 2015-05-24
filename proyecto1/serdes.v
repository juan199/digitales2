
module par2ser(
	input wire       TRANSCLK,
	input wire [9:0] data_in,
	output reg       data_out
);

    reg        [9:0] temp;              //10 FFs para guardar el dato valido
    integer contps;
    
    initial
    contps = 0;
    
always @(posedge TRANSCLK) begin

  
    if(contps == 10)begin
       contps = 0;                    // resetea el contador
       temp = data_in;            // se guarda una copia en FF del valor del stream
   	end
   	 
    if(contps < 10)begin
      data_out = temp [contps];      
      contps = contps + 1;           
	end

end 
endmodule


module ser2par(
	input wire       CRC_CKL,
	input wire       data_in,
	input wire       RXPOL,     // changes data polarity. RXPOL = 0 introduces data as it comes. RXPOL = 1 introduces data negated. 
	output reg [9:0] data_out
);

    reg        [9:0] preout;    //10 FFs para guardar el dato valido
    integer contsp;
    
    initial
    contsp = 0;
    
always @(posedge CRC_CKL) begin

    if(contsp == 10)begin
       contsp =0;
                                   //OJO HAY DOS MANERAS DE CONTROLAR EL NEG... NEGANDO LA ENTRADA O LA SALIDA
       if(RXPOL)                            //SE DEBE GARANTINZAR QUE NEG NO VARIE EN 10 CICLOS
       data_out = preout;          // la salida toma el valor valido de los 10 bits

       else
       data_out = ~preout; 
    end
   	 
    else begin
	  //if(RXPOL) 
       preout[contsp] = data_in;     // se empieza a llenar una serie de FF con el valor valido 
      //else
      // preout[contsp] = ~data_in;     // se empieza a llenar una serie de FF con el valor valido 
       
       contsp = contsp + 1;            //cada flanco positivo (mientras que no se hayan llenado los FF) se aumenta en uno la direccion del puntero para salvar
	end
end
endmodule

