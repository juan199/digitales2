/*
Este protocolo funciona cuando se da la secuencia de estados que
se presenta abajo. Nótese que en cada estado solo cambia uno
de los actores a la vez. Este comportamiento funciona siempre
porque en cada estado uno de los actores está esperando al otro.
Ninguno inicia una acción si el otro no completa una acción. En el
estado inicial, o de descanso, (0) le toca al Amo iniciar la acción
poniendo un nuevo dato a disposición.

Estado
 A E  - Descripción
 0 1  - (0) Estado de descanso: El amo no tiene un dato nuevo. El esclavo espera listo.
 1 1  - (1) El amo coloca un nuevo dato. El esclavo sigue listo.
 1 0  - (2) El amo mantiene el dato. El esclavo indica que lo tomó.
 0 0  - (3) El amo retira el dato. El esclavo continúa ocupado.
 0 1  - (0) Se retorna al estado inicial. El esclavo terminó con el primer dato.

Este comportamiento se puede verificar automáticamente haciendo una
máquina de estados que siga la secuencia mostrada arriba.

A continuación se dan varios parametros temporales para correr la simulación bajo
distintas condiciones.
*/
`define TresA 0 //Tiempo transcurrido antes de resetear el amo
`define Tgo   0 //Tiempo para generar un cambio en la senal go
`define Tamo  0 //Tiempo que toma la rutina del amo
`define TresE 0 //Tiempo transcurrido antes de resetear al esclavo
`define Tdone 0 //Tiempo para generar un cambio en la senal done
`define Tesc  0 //Tiempo que toma la rutina del esclavo

/*
Se sugieren las siguientes pruebas minimas:
TresA Tgo Tamo TresE Tdone Tesc
  0    0    0    0     0     0   - Simulacion 100% conductual sin retardos
  1    1    1    1     1     1   - Retardos unitarios. Amo y esclavo iguales
  1    1   10    1     1     1   - Amo es mas lento que el esclavo
  1    1    1    1     1    10   - Esclavo es mas lento que el amo
 10    1    1    1     1     1   - Amo se resetea despues que el esclavo
  1    1    1   10     1     1   - Esclavo se resetea despues que el amo

¿En cuales pruebas tiene problema el protocolo?
*/

module BancoDePruebas;
  wire [5:0] i;
  amo A(done, go, i);
  esclavo B(go, done, i);
  initial
    begin
      //$monitor($time,,,"go: %b  done: %b", go, done);
      $dumpfile("handshake.vcd");
      $dumpvars;
	end
endmodule

module amo(done, go, i);
  input done;
  output reg go;
  output reg [5:0] i;

  initial
    begin
      #`TresA go = 0; //Amo no está listo con el primer dato
	  i = 0; //Contador de iteraciones
	end
  
  always
    begin
	  wait(done);
	  //Rutina interna del amo------------------------------------------
	  //Primero preparo el dato que necesito procesar.
	    if (i == 5) //Ya se terminó el trabajo que había que hacer
		  #100
		  $finish;
	    else
	      begin //Este es el trabajo que hace el amo
	        #`Tamo i = i + 1;
	        $display($time,,,"Amo: i=%d", i);
		  end
	  //Fin de Rutina interna-------------------------------------------
	  #`Tgo go = 1; //Luego, le pido al esclavo que inicie su procesamiento
	  wait(~done);
	  #`Tgo go = 0;
	end
endmodule

module esclavo(go, done, i);
  input go;
  output reg done;
  input [5:0] i;
  reg [5:0] j;

  initial
    begin
	  #`TresE done = 1; //El esclavo se despierta listo
	end
  
  always
    begin
	  wait(go);
	  #`Tdone done = 0; //Primero digo que estoy ocupado, para evitar nuevo dato
	  //Luego comienzo a trabajar.
	  //Rutina interna del esclavo--------------------------------------
	    #`Tesc j = i;
	    $display($time,,,"Esclavo: j=%d", j);
	  //Fin de Rutina interna-------------------------------------------
	  wait(~go);
	  #`Tdone done = 1;
	end
endmodule
