
module par2ser(
	input wire       TRANSCLK,
	input wire [9:0] data_in,
	output reg       data_out
);

endmodule


module ser2par(
	input wire       CRC_CKL,
	input wire       data_in,
	input wire       RXPOL,     // changes data polarity (I don't really know what that means....)
	output reg [9:0] data_out
);

endmodule


// Si los datos del stream se deben de enviar en un flanco de reloj, se debe crear un reloj 10 veces mas rapido para enviar y recibir el dato
// de 10 bits a tiempo, si los datos se envia con cada clockazo del reloj general no hay que hacer modificaciones....



module par_ser (reloj, out, in, enable); //input parallel to output serial

  input wire reloj;
  input wire [9:0] in;
  input wire [9:0] posin; //10 FFs para guardar el dato valido
  reg wire [4:0] cont;
  output wire out;

    
always @(posedge reloj)

  
    if(cont==10)begin
       cont =0;             // resetea el contador
        assign posin = in; // se guarda una copia en FF del valor del stream
   	end
   	 
    if(cont < 10)
      out = posin[cont]; // la salida toma el valor del stream segun el FF selecionado por el contador
      cont = cont + 1;  // se aumenta en 1 el puntero al FF de selecion
	end


endmodule 


module ser_par (reloj, out, in, enable);  //input serial to output parallel

  input wire reloj;
  input wire in;
  reg wire [4:0] cont;
  output wire [9:0] out;
  output reg [9:0] preout;  //10 FFs para guardar el dato valido

    
always @(posedge reloj)

    if(cont==10)begin
       cont =0;              // se resetea el contador 
       assign out = preout;  // la salida toma el valor valido de los 10 bits
    end
   	 
    else begin
       preout[cont] = in;     // se empieza a llenar una serie de FF con el valor valido 
       cont = cont + 1;      //cada flanco positivo (mientras que no se hayan llenado los FF) se aumenta en uno la direccion del puntero para salvar
	end
	

endmodule

