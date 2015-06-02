// Circuitos Digitales II
// Marco V. Chacon Taylor, Roberto Herrera, Robert Quiros
// Proyecto No 3. Multiplicador/Divisor

module probador (ent_32, ent_16, go, div_mult,	 // salidas
                 sal_32_ideal, done_ideal,       // entradas del sistema de referencia "ideal"
                 sal_32, done,			 // entradas del sistema bajo prueba
                 clk);
parameter
    seed = 1,
    num_pruebas = 20;

// salidas
output  [31:0]  ent_32;			// operando 1
output  [15:0]  ent_16;			// operando 2
output          go, div_mult;		// handshake, seleccion de operacion

// entradas
input   [31:0]  sal_32_ideal, sal_32;	// resultado de las operaciones
input           done_ideal, done, clk;	// handshake, reloj del sistema

// registros
reg     [31:0]  ent_32;
reg     [15:0]  ent_16;
reg             go, div_mult;
          
integer i;				// variables para la generacion de pruebas
reg n16, n32, nsal_ideal, nsal_up;	

initial begin
    $dumpfile ("mult_div_prog.vcd");
    $dumpvars;

    div_mult = 0;			// valor inicial de senales de control
    go = 0;
     
    for(i = 1; i <= num_pruebas; i = i + 1) begin	// realiza este ciclo num_pruebas veces
	@(negedge clk);					// espera flanco negativo
	go = 0;						// coloca go en bajo para hacer cambios
	ent_32 = $random;
	ent_16 = $random;
	div_mult = ~div_mult;				// las operaciones se hacen de manera alterna

	wait(~done_ideal & ~done);		        // espera que done este en bajo para continuar      
	@(negedge clk);					// espera el flanco negativo
	go = 1;						// pone go en alto para que comience el procesamiento
	wait(done_ideal & done);			// espera que las senales done indiquen que la operacion
							// se ha terminado
	// Despliega los resultados segun el tipo de operacion
	if (div_mult) begin
	    $display("Prueba No. %0d. Operacion: multiplicacion", i);
	    $display("multiplicando 1 = %b", ent_32[15:0]);
	    $display("multiplicando 2 = %b", ent_16);
	    $display("producto esperado = %b", sal_32_ideal);
	    $display("producto obtenido = %b\n", sal_32);
	end
	if (!div_mult) begin
	    $display("Prueba No. %0d. Operacion: division", i);
	    $display("dividendo = %b", ent_32);
	    $display("  divisor = %b", ent_16);
	    $display("cociente esperado = %b", sal_32_ideal);
	    $display("cociente obtenido = %b\n", sal_32);
	end
	if(sal_32_ideal != sal_32) begin
	    $display("ERROR: resultado obtenido es diferente al esperado. Abortando simulacion");
	    $finish;
        end
    end
    $finish;
end

endmodule
