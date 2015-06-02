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
	  //Seleccione el archivo de salida con variables de ambiente
	  `ifdef ME
      $dumpfile("div_ME.vcd");
	  `endif
	  `ifdef Uff
      $dumpfile("div_Uff.vcd");
	  `endif
	  `ifdef CR
      $dumpfile("div_CR.vcd");
	  `endif
	  `ifdef CuP
      $dumpfile("div_Cup.vcd");
	  `endif
      $dumpvars;
      $monitor($time,,,  "done: %b   go: %b   dividendo: %d   divisor: %d   cociente: %d", termino, inicie, dividendo, divisor, cociente);
      
      reloj = 0;

      #3 reset = 1;
      inicie = 0;
      #3 reset = 0;
      #12 reset = 1;

      wait(termino);
      #10 dividendo = 32'h352;
          divisor = 16'h3;
          inicie = 1;

      wait(~termino);
      #5 inicie = 0;

      wait(termino);
      #10 dividendo = 32'd1024;
          divisor = 16'h20;
          inicie = 1;

      wait(~termino);
      #5 inicie = 0;

      wait(termino);

     #10 $finish;
    end

    always
      #5 reloj = ~reloj;

endmodule
