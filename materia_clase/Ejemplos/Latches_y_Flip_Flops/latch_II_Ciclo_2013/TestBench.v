`include "Globales.v"

module TestBench;

	// Prueba de latch hecha con comandos "assign"
	LogicaComb LC1 (
	    .iSignal(Q1),
		.oNSignal(D1)
		);
		
	LatchD L1 (
		.Clock(Clock), 
		.Reset(Reset),
		.D(D1),
		.Q(Q1)
		);
	
	// Prueba de latch sencillo
	LogicaComb LC2 (
	    .iSignal(Q2),
		.oNSignal(D2)
		);
		
	LatchD_simple L2 (
		.Clock(Clock), 
		.Reset(Reset),
		.D(D2),
		.Q(Q2)
		);
	
	//Detalles de la simulación	================================
	// Definición de Señales
	reg Clock;
	reg Reset;

	//Definición de un reloj asimétrico
	always
	  begin
	    if (Clock)
		  #`Tclk1 Clock =  0;
		else
		  #`Tclk0 Clock = 1;
	  end
	
	//Exitación
	initial 
	begin
	  //Primero el archivo para GTKwave
	  $dumpfile("Simulacion.vcd");
	  $dumpvars;
	  //Monitoreo de ciertas variables
	  $monitor ($time,,"Reset = %b  Clock = %b", Reset, Clock);
	  // Inicializar señales primarias
	  #`Tind Clock = 0;
         Reset = 0;
	  // Hacer un reset suficientemente largo
	  // para cubrir la propagación en la lógica combinacional y latches
	  #`Tres0 Reset = 1;
	  #`Tres1 Reset = 0;
        
	  // Deje que la simulación corra por un rato suficiente para
	  // ver el comportamiento del circuito
	  #500 $finish;

	end
   
endmodule
