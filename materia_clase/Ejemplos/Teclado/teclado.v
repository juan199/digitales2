module teclado (teclas, valido);
  output reg [4:0] teclas;
  output reg valido;
  reg [5:0] t; //Variable de 6 bits para definir el tiempo que dura la tecla presionada
  integer semilla;
  
  initial
    begin
      semilla = 1234; //Semilla de inicio del generador de numeros aleatorios
	  $monitor($time,,"semilla = %d   teclas = %b  t = %b", semilla, teclas, t);
	  $dumpfile("senales.vcd");
	  $dumpvars;
	
	  repeat (8)
	    begin
		  teclas = 5'bx; //Al cambiar de tecla presionada se indetermina el valor de teclas
		  valido = 0;
		  #11 //Tiempo que aparece indeterminada la salida teclas
	      teclas = $random(semilla); //Valor de la tecla
		  valido = 1;
		  t = $random(semilla);
		  repeat (t) #1; //tiempo en que esta presionada la tecla
	    end
	  $finish;
	end
endmodule
