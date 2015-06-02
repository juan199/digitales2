//Lectura de un archivo
module LecturaArchivoTexto;
  integer archEntrada;
  reg [8:0] caracter;
  
  initial
    begin
	  archEntrada = $fopen("TextoEntrada.txt", "r");
	  caracter = 0;
	  while (caracter != 9'h1ff)
	    begin
	      caracter = $fgetc(archEntrada);
		  $write("%c", caracter);
		end
	end
endmodule
