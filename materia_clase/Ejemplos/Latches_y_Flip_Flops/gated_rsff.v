//`timescale 1us / 1ns

//Set-Reset Latch
module srff (s, r, q, qb);
  parameter Ta = 1,
            Tb = 1,
            Tbas = 1;
  input s, r;
  output q, qb;
  wire aux_q, aux_qb;

  nor #(Ta) c1 (qb, s, q);
  nor #(Tb) c2 (q, r, qb);

  nor #(Tbas) aux1 (aux_qb, s, q);
  nor #(Tbas) aux2 (aux_q, r, qb);
  
  //Codigo de instrumentacion ****************************************************************************
  //Medicion de tiempos de propagacion
  time Ts_q;
  //Medicion de tiempo de propagacion de entrada set a salida q
  always @ (posedge s)
    begin
	  if (testbench.s_rise == 1 && testbench.r_rise == 0 && q == 0)
	    begin
	      @ (posedge q);
	      Ts_q = $time - testbench.TsCH;
	      $display($time,,"** - %m - Tiempo de propagacion de set a q: %0t", Ts_q);
		end
	end

  //Avisa cuando las salidas del FF no son complementarias
  always @ (negedge (q ^ qb))
    $display($time,,"** - %m - Salidas q y qb son iguales.");

  //Avisa cuando las salidas del FF no son complementarias
  always @ (posedge (q ^ qb))
    $display($time,,"** - %m - Salidas q y qb son complementarias.");

endmodule

//Gated Set-Reset Latch
module gsrff (s, r, g, q, qb);
  parameter Ta = 1,
            Tb = 1,
            Tbas = 1;
  input s, r, g;
  output q, qb;

  nor #(Ta) c1 (qb, x, q);
  nor #(Tb) c2 (q, y, qb);
  and #(Tbas) c3 (x, s, g);
  and #(Tbas) c4 (y, r, g);

endmodule

//Set-Reset Master/Slave Flip Flop
module MSff (s, r, clk, q, qb);
  parameter Ta = 1,
            Tb = 1,
            Tbas = 1;
  input s, r, clk;
  output q, qb;

  gsrff #(Ta, Tb, Tbas) master (s, r, clk, q_m, qb_m);
  not #(Tbas) inv1 (clkb, clk);
  gsrff #(Ta, Tb, Tbas) slave (q_m, qb_m, clkb, q, qb);

endmodule

//Edge-Triggered Set-Reset Flip Flop
module ETff (s, r, clk, q, qb);
  parameter Ta = 1,
            Tb = 1,
            Tbas = 1;
  input s, r, clk;
  output q, qb;

  //Main latch
  nor #(Ta) ns1 (qb, qs, q);
  nor #(Tb) nr2 (q, qr, qb);

  //Set side input latch
  nor #(Tbas) ns3 (qsb, s, sblk, qs);
  nor #(Tbas) ns4 (qs, qsb, qr, clk);

  //Reset side input latch
  nor #(Tbas) nr5 (qrb, r, rblk, qr);
  nor #(Tbas) nr6 (qr, qrb, qs, clk);

  //Blocking logic for set and reset side
  nor #(Tbas) ns7 (sblk, qb, r);
  nor #(Tbas) nr8 (rblk, q, s);

endmodule

//Top Module
module testbench;
  reg s, r, g;
  reg [1:0] vecs_entrada[0:25];
  reg [4:0] i;

//Dispositivos con los retardos balanceados - Estos deben oscilar
  srff  #(20, 20, 19) ff0 (s, r,    q_rs_bal,  qb_rs_bal);
  gsrff #(20, 20, 19) ff1 (s, r, g, q_grs_bal, qb_grs_bal);
  MSff  #(20, 20, 19) ff2 (s, r, g, q_MS_bal,  qb_MS_bal);
  ETff  #(20, 20, 19) ff3 (s, r, g, q_ET_bal,  qb_ET_bal);

//Dispositivos con Ta ligeramente mayor que Tb - No oscila, salida q se mantiene y estabiliza al dispositivo
  srff  #(21, 20, 19) ff4 (s, r,    q_rs_Ta21,  qb_rs_Ta21);
  gsrff #(21, 20, 19) ff5 (s, r, g, q_grs_Ta21, qb_grs_Ta21);
  MSff  #(21, 20, 19) ff6 (s, r, g, q_MS_Ta21,  qb_MS_Ta21);
  ETff  #(21, 20, 19) ff7 (s, r, g, q_ET_Ta21,  qb_ET_Ta21);

//Dispositivos con Tb ligeramente mayor que Ta - No oscila, salida qb se mantiene y estabiliza al dispositivo
  srff  #(20, 21, 19) ff8  (s, r,    q_rs_Tb21,  qb_rs_Tb21);
  gsrff #(20, 21, 19) ff9  (s, r, g, q_grs_Tb21, qb_grs_Tb21);
  MSff  #(20, 21, 19) ff10 (s, r, g, q_MS_Tb21,  qb_MS_Tb21);
  ETff  #(20, 21, 19) ff11 (s, r, g, q_ET_Tb21,  qb_ET_Tb21);

//Dispositivos con Ta mucho mayor que Tb - No oscila, salida q se mantiene y estabiliza al dispositivo
  srff  #(66, 20, 19) ff12 (s, r,    q_rs_Ta66,  qb_rs_Ta66);
  gsrff #(66, 20, 19) ff13 (s, r, g, q_grs_Ta66, qb_grs_Ta66);
  MSff  #(66, 20, 19) ff14 (s, r, g, q_MS_Ta66,  qb_MS_Ta66);
  ETff  #(66, 20, 19) ff15 (s, r, g, q_ET_Ta66,  qb_ET_Ta66);

//Dispositivos con Tb mucho mayor que Ta - No oscila, salida qb se mantiene y estabiliza al dispositivo
  srff  #(20, 66, 19) ff16 (s, r,    q_rs_Tb66,  qb_rs_Tb66);
  gsrff #(20, 66, 19) ff17 (s, r, g, q_grs_Tb66, qb_grs_Tb66);
  MSff  #(20, 66, 19) ff18 (s, r, g, q_MS_Tb66,  qb_MS_Tb66);
  ETff  #(20, 66, 19) ff19 (s, r, g, q_ET_Tb66,  qb_ET_Tb66);

  initial
    begin
      //Prepare el archivo *.vcd
      $dumpfile ("gated_sr_ff.vcd");
      $dumpvars;
      //Lea los vectores de entrada
      $readmemb ("vecs_entrada.dat", vecs_entrada);
	  //Iniciacion de algunas variables de instrumentacion
	  TsCH_old = $time; //Almacena el ultimo tiempo en que cambio la senal s
	  TrCH_old = $time; //Almacena el ultimo tiempo en que cambio la senal r
      //Inice la secuencia de entrada
      //Borde creciente del reloj coincide con cambio de entradas s y r
      #1000
      i = 0;
      #0 g = 1; //t3
      {s, r} = vecs_entrada[i];
      #21 g = 0; //t1
      #979 g = 1; //t2
      for (i = 1; i < 26; i = i + 1)
        begin
          #0 g = 1; //t3
          {s, r} = vecs_entrada[i];
          #21 g = 0; //t1
          #979 g = 1; //t2
        end
      //Cambio de entradas s y r antes del borde decreciente
      #1000
      i = 0;
      #481 g = 1; //t3
      {s, r} = vecs_entrada[i];
      #19 g = 0;  //t1 = Tiempo antes del borde decreciente
      #500 g = 1; //t2
      for (i = 1; i < 26; i = i + 1)
        begin
          #481 g = 1; //t3
          {s, r} = vecs_entrada[i];
          #19 g = 0;  //t1 = Tiempo antes del borde decreciente
          #500 g =1;  //t2
        end
      //Cambio de entradas s y r despues del borde decreciente
      #1000
      i = 0;
      #1 g = 0; //t3 = Tiempo despues del borde decreciente
      {s, r} = vecs_entrada[i];
      #499 g = 1;  //t1
      #500 g = 0; //t2
      for (i = 1; i < 26; i = i + 1)
        begin
          #1 g = 0; //t3 = Tiempo despues del borde decreciente
          {s, r} = vecs_entrada[i];
          #499 g = 1;  //t1
          #500 g =0;  //t2
        end
      $finish;
    end
	  
  //Codigo de instrumentacion ****************************************************************************
  //Variables para guardar el tiempo en que cambian las senales r, s, y g.
  time TsCH, TrCH;
  reg s_rise, r_rise;
  
  //Deteccion de flancos en entrada s
  always @ (negedge s)  //Detecta flancos decrecientes en s y registra tiempo
    begin
	  TsCH = $time;
	  s_rise = 0;
	end
  always @ (posedge s)  //Detecta flancos crecientes en s y registra tiempo
    begin
	  TsCH = $time;
	  s_rise = 1;
	end
	
  //Deteccion de flancos en entrada r
  always @ (negedge r)  //Detecta flancos decrecientes en r y registra tiempo
    begin
	  TrCH = $time;
	  r_rise = 0;
	end
  always @ (posedge r)  //Detecta flancos crecientes en r y registra tiempo
    begin
	  TrCH = $time;
	  r_rise = 1;
	end
	
  //Establece cual deberia ser el estado de q y qb partiendo de los cambios en s y r
  time TsCH_old, TrCH_old;
  reg sr_both;
  always @ (TsCH or TrCH)
    begin
	  //Revisar cuales entradas cambiaron y actualizar registro de s y r
	  if (TsCH > TsCH_old && TrCH > TrCH_old) //Ambas entradas cambiaron
	    begin
		  $display("** - Cambio en s(%0t)= %b y r(%0t)= %b.",TsCH,s,TrCH,r);
		  sr_both = 1; //Ambas cambiaron
	      TsCH_old = TsCH;
	      TrCH_old = TrCH;
		end
	  else if (TsCH > TsCH_old) //Solo cambio la senal s
	    begin
	      $display("** - Cambio en s(%0t)= %b.",TsCH,s);
		  sr_both = 0; //Solo una cambio
	      TsCH_old = TsCH;
		end
	  else //Solo cambio la senal r
	    begin
	      $display("** - Cambio en r(%0t)= %b.",TrCH,r);
		  sr_both = 0; //Solo una cambio
	      TrCH_old = TrCH;
		end
		
	  //Valoracion de la salida esperada del latch
	  if (s_rise == 1 && r_rise == 1)
		$display("** - Salidas q y qb ambas a 0.");
	  else if (s_rise == 0 && r_rise == 0 && sr_both == 1)
		$display("** - Salidas q y qb pueden oscilar.");
	  else if (s_rise == 0 && r_rise == 0 && sr_both == 0)
		$display("** - Salidas q y qb mantienen valor anterior.");
	  else if (s_rise == 1 && r_rise == 0)
		$display("** - Salidas correctas q=1 y qb=0.");
	  else if (s_rise == 0 && r_rise == 1)
		$display("** - Salidas correctas q=0 y qb=1.");
	  else
		$display("**ERROR** - Todas las combinaciones estan consideradas.");
		
	end
  
endmodule
