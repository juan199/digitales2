`default_nettype none
`timescale 1ns/100ps

module par2ser(
	input wire       TRANSCLK,
	input wire [9:0] data_in,
	output reg       data_out
);

    reg        [9:0] temp;              //10 FFs para guardar el dato valido
    integer contps;
    
    initial
    contps = 10;
    
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


    
always @(posedge CRC_CKL) begin
              
     if(RXPOL)    begin
     data_out[0] = data_out[1];
     data_out[1] = data_out[2];
     data_out[2] = data_out[3];
     data_out[3] = data_out[4];
     data_out[4] = data_out[5];
     data_out[5] = data_out[6]; 
     data_out[6] = data_out[7]; 
     data_out[7] = data_out[8];
     data_out[8] = data_out[9];
     data_out[9] = data_in;      
					end
					
     else 			begin
     
     data_out[0] = data_out[1];
     data_out[1] = data_out[2];
     data_out[2] = data_out[3];
     data_out[3] = data_out[4];
     data_out[4] = data_out[5];
     data_out[5] = data_out[6]; 
     data_out[6] = data_out[7]; 
     data_out[7] = data_out[8];
     data_out[8] = data_out[9];
     data_out[9] = ~data_in;   
					end
   	 
end
endmodule

