`timescale 1us / 1ns

module INSTR_setup (data, reference, notify);
  input data, reference;
  output notify;
  reg notify;
  parameter Tsu = 0,
            Edge = "pos";
  //Verificacion de tiempo de setup con flanco creciente en la referencia
  //----------------------------------------------------------------------
  //Algunas definiciones segun el Verilog LRM 1995
  //El data_event es el "Timestamp event", esto dispara el proceso de verificacion.
  //El reference_event es el "Timecheck event" que concluye el proceso calculando si existe una violacion
  //El limit es una constante positiva.
  //La medicion de setup se hace dentro de una ventana definida como:
  //  (inicio de la ventana) = (tiempo del "timecheck event") - limit
  //  (final de la ventana)  = (tiempo del "timecheck event")
  //La violacion se da si se cumple que:
  //  (inicio de la ventana) < (tiempo del "timestamp event") < (final de la ventana)
  //
  //EJEMPLOS DE USO:
  //Para invocar un chequeo de "setup" por 1.8 unidades de
  //tiempo del dato "data" con respecto al flanco creciente
  //de la senal "reference".
  //     INSTR_setup #(1.8,"pos") su1(data, reference, notify);
  //
  //Para invocar un chequeo de "setup" por 2.8 unidades de
  //tiempo del dato "data" con respecto al flanco decreciente
  //de la senal "reference".
  //     INSTR_setup #(2.8,"neg") su2(data, reference, notify2);
  
  realtime Tdata_ev, Tref_ev, Tlimit, Tinicio_vent, Tfin_vent;
  
  initial
    Tlimit = Tsu;
  
  //Registrar el tiempo del "timestamp event" --Cualquier cambio en data
  //La variable "notify" se pone a cero para iniciar el proceso de verificacion
  always @ (data)
    begin
      Tdata_ev = $realtime;
	  notify = 0;
	end
  //Registrar el tiempo del "timecheck event" --Para cualquier flanco
  //Se calcula la variable "notify" de acuerdo a si hay violacion o no
  always @ (reference)
    begin
      Tref_ev = $realtime;
	  Tinicio_vent = Tref_ev - Tlimit;
	  Tfin_vent = Tref_ev;
	  if ((Tinicio_vent < Tdata_ev) && (Tdata_ev < Tfin_vent) &&
	      ((Edge == "pos") && (reference == 1) || ((Edge == "neg") && (reference == 0))))
		begin
	    notify = 1;
	    $display($time,,,,"Ini: %0t  Data: %0t  Fin_vent: %0t  notify: %b",Tinicio_vent,Tdata_ev,Tfin_vent,notify);
		end
      else
	    notify = 0;
	end
    
endmodule

module GenG (g);
  parameter TH = 1, //Tiempo en alto
            TL = 2; //Tiempo en bajo
  output reg g;
  initial
    g = 0;
	
  always begin
    #TL g = 1;
	#TH g = 0;
  end
endmodule

module GenD (d);
  parameter TH = 1, //Tiempo en alto
            TL = 2; //Tiempo en bajo
  output reg d;
  
  initial begin
    d = 0;
  end
	
  always begin
    #TL d = 1;
	#TH d = 0;
	#0.1 d = 0;
  end
endmodule


module testbench;
  wire data, reference;
  
  //Invocar los generadores de pulsos para datos y habilitacion del latch
  GenG #(15, 45) GenHabLatch (reference);
  GenD #(30, 90) GenDato (data);

  //Invocar las pruebas de setup
  INSTR_setup #(1.7,"pos") su1(data, reference, notify);
  INSTR_setup #(1.8,"pos") su2(data, reference, notify2);
  INSTR_setup #(2.2,"neg") su3(data, reference, notify3);
  INSTR_setup #(2.3,"neg") su4(data, reference, notify4);
  
  initial
    begin
      //Prepare el archivo *.vcd
      $dumpfile ("timechecks.vcd");
      $dumpvars;
	  
/*	  #5 data = 0;
	  #10 reference = 0;
	  
	  #5 data = 1;
	  #1 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.1 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.2 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.3 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.4 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.5 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.6 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.7 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.8 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #1.9 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.1 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.2 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.3 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.4 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.5 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.6 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.7 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.8 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #2.9 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
	  
	  #5 data = 1;
	  #3 reference = 1;
	  #1 reference = 0;
	  #1 data = 0;
*/	  
	  #40000 $finish;
    end
endmodule
