// Circuitos Digitales II
// Marco V. Chacon Taylor, Roberto Herrera, Robert Quiros
// Proyecto No 3. Multiplicador/Divisor

module BancoPruebas();
  
  // Se define el semiperiodo del reloj del sistema
  `define Tclk 1

  wire  [31:0]  sal_32_ideal, sal_32, ent_32;
  wire  [15:0]  ent_16;
  wire          done_ideal, done, go, div_mult, reloj;

  reg reset;


  // Instanciacion de los modulos principales del sistema:
  // multiplicador/divisor conductual ideal para realizar la corroboracion de los
  // resultados 
  mult_div_ideal mult_div_ideal_0 (sal_32_ideal, done_ideal, ent_32, ent_16, go, div_mult);

  // cascaron: encierra al multiplicador/divisor microprogramado --
  // controlador, registros, 
  cascaron cascaron_0 (sal_32, done, ent_16, ent_32, go, div_mult,reloj,reset);

  // reloj del sistema
  clk #(`Tclk) clk_0 (reloj);

  // modulo probador: controla la simulacion
  // parametro 1: seed; parametro 2: numero de operaciones a realizar;
  probador #(1, 100) probador_0 (ent_32, ent_16, go, div_mult,	  // salidas
                                 sal_32_ideal, done_ideal,        // entradas de referencia (del mult/div ideal)
                                 sal_32, done,			  // entradas bajo prueba  
                                 reloj);

  initial begin
    reset = 0;
    #(`Tclk+1)
    reset = 1;
  end
    
endmodule
