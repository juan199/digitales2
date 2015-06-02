module probador (dividendo, divisor, inicie, termino, cociente);

  input termino;
  input [`QLen:0] cociente;
  
  output inicie;
  output [`DdLen:0] dividendo;
  output [`DvLen:0] divisor;
  
  reg [`DdLen:0] dividendo;
  reg [`DvLen:0] divisor;
  reg inicie;

  //Arreglos para guardar los datos de las pruebas
  reg [`DvLen:0] PDv [0:`Pruebas];
  reg [`DdLen:0] PDd [0:`Pruebas];
  reg [`QLen:0]  PCt [0:`Pruebas];
  integer MaxPrueba, iPrueba;

  initial
    begin
	  //Orden para generar el archivo de transiciones de senales
      $dumpfile("divisor.vcd");
      $dumpvars;
	  //Monitoreo automatico de algunas variables del diseno
      $monitor($time,,, "done: %b   go: %b   dividendo: %h   divisor: %h   cociente: %h", termino, inicie, dividendo, divisor, cociente);
	  //Lectura de los datos para las pruebas y los resultados esperados
	  $readmemh("DatosDivisor.dat", PDv);
	  $readmemh("DatosDivdend.dat", PDd);
	  $readmemh("DatosCocient.dat", PCt);
     
      //Suponemos que la primera linea del arreglo PDv tiene el numero total de pruebas incluidas
	  MaxPrueba = PDv[0];
	  
	  //Esperamos a que el divisor este listo antes de solicitar la primera division
	  wait(termino);
	  for(iPrueba = 1; iPrueba <= MaxPrueba; iPrueba = iPrueba + 1)
	    begin
		  //10 unidades de tiempo despues de que termino==1 se ponen los datos y se inicia otra division
		  #10 dividendo = PDd[iPrueba];
			  divisor = PDv[iPrueba];
			  inicie = 1;
          //Esperamos a que nos indique que empezo a hacer la division
		  wait(~termino);
		  //*** El divisor esta trabajando ***
		  //*** El probador podria dedicarse a hacer otras cosas
          //Esperamos a que termine de hacer la division
		  wait(termino);
		  
		  //Ya el cociente esta disponible, se puede verificar si la respuesta es correcta
		  if (cociente == PCt[iPrueba])
		    $display("Resultado correcto!!");
	      else
		    $display($time,,"**ERROR** Esperando cociente igual a %h pero resultado es %h",PCt[iPrueba],cociente);
		  //Indiquele al divisor que ya tomo el resultado poniendo "inicie" en cero
		  #5 inicie = 0;
		  
		end

     #10 $finish;
    end

endmodule
