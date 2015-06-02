`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module etapa2 #(
                parameter AnchoDv = `DvLen,
				          AnchoDd = `DdLen,
						  AnchoQ  = `QLen
			   )
              (
               input goIn,
			   input [`DvLen:0] divisorIn,
			   input [`DdLen:0] dividendIn,
			   input negDivisorIn,
			   input negDividendIn,
			   input DivisorNoCeroIn,
			   output goOut,
			   output [`DvLen:0] divisorOut,
			   output [`DdLen:0] dividendOut,
			   output [`QLen:0] quotientOut,
			   output negDivisorOut,
			   output negDividendOut,
			   output DivisorNoCeroOut,
			   input reset, clk
			   );
			   
  wire [`DvLen:0] divisorInB, divisorSel;
  wire [`DdLen:0] dividendInB, dividendSel;
  
  //Senal de "go" se utiliza para hablilitar escritura en los otros registros
  reg_en #(1) go (goIn, 1, clk, reset, goOut);

  //Complemento a 2 de "divisor"
  assign divisorInB = - divisorIn;
  
  //Selector de datos basado en el signo de "divisor"
  assign divisorSel = negDivisorIn ? divisorInB: divisorIn;
  
  //Registro "divisor"
  reg_en #(AnchoDv + 1) divisor (divisorSel, goIn, clk, reset, divisorOut);

  //Complemento a 2 de "dividend"
  assign dividendInB = - dividendIn;
  
  //Selector de datos basado en el signo de "dividend"
  assign dividendSel = negDividendIn ? dividendInB: dividendIn;
  
  //Registro "dividend"
  reg_en #(AnchoDd + 1) dividend (dividendSel, goIn, clk, reset, dividendOut);

  //Registro "quotient"
  assign quotientOut = 0;
  
  //Registro "negDivisor"
  reg_en #(1) negDivisor (negDivisorIn, goIn, clk, reset, negDivisorOut);

  //Registro "negDividend"
  reg_en #(1) negDividend (negDividendIn, goIn, clk, reset, negDividendOut);

  //Registro "DivisorNoCero"
  reg_en #(1) DivisorNoCero (DivisorNoCeroIn, goIn, clk, reset, DivisorNoCeroOut);

endmodule 