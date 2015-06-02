module probador (dividendo, divisor, cociente, inicie, termino, reloj, reset);

  input termino;
  input [`QLen:0] cociente;
  
  output reset, reloj;
  output inicie;
  output [`DdLen:0] dividendo;
  output [`DvLen:0] divisor;
  
  reg [`DdLen:0] dividendo;
  reg [`DvLen:0] divisor;
  reg inicie;
  reg reset;
  reg reloj;
    
  initial
    begin
      $dumpfile("divisor.vcd");
      $dumpvars;
      $monitor($time,,,"done: %b   go: %b   dividendo: %d   divisor: %d   cociente: %d", termino, inicie, dividendo, divisor, cociente);
      
      reloj = 0;

      #3 reset = 1;
      #3 reset = 0;
	     inicie = 0;
      #3 reset = 1;

	  //Inicia transaccion
      wait(termino);
      #10 dividendo = 32'h352;
          divisor = 16'h3;
          inicie = 1;

      wait(!termino);
      #5 inicie = 0;

	  //Inicia transaccion
      wait(termino);
      #10 dividendo = 32'hFFFFF1FD;
          divisor = 16'hFFF0;
          inicie = 1;

      wait(!termino);
      #5 inicie = 0;

	  //Inicia transaccion
      wait(termino);
      #10 dividendo = 32'd1024;
          divisor = 16'h20;
          inicie = 1;
		  
      wait(!termino);
      #5 inicie = 0;

	//Espere para que se pierdan unos ciclos de reloj
      #423    inicie = 0;

	  //Inicia transaccion
      wait(termino);
      #10 dividendo = 32'hffffff24;
          divisor = 16'h21;
          inicie = 1;

      wait(!termino);
      #5 inicie = 0;

      wait(termino);

     #6000 $finish;
    end

    always
      #50 reloj = ~reloj;

endmodule
