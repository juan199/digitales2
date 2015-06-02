`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module etapa6 #(
                parameter AnchoDv = `DvLen,
				          AnchoDd = `DdLen,
						  AnchoQ  = `QLen,
						  SupDvMn = `HiDdMin
			   )
              (
               input goIn,
			   input [`DvLen:0] divisorIn,
			   input [`DdLen:0] dividendIn,
			   input [`QLen:0] quotientIn,
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
			   
  wire [`QLen:0] quotientInB, quotientSel;
			   
  //Senal de "go" se utiliza para hablilitar escritura en los otros registros
  reg_en #(1) go (goIn, 1, clk, reset, goOut);

  //Registro "divisor"
  reg_en #(AnchoDv + 1) divisor (divisorIn, goIn, clk, reset, divisorOut);

  //Registro "dividend"
  reg_en #(AnchoDd + 1) dividend (dividendIn, goIn, clk, reset, dividendOut);

  //Complemento a 2 de "quotient"
  assign quotientInB = - quotientIn;
  
  //Compara signos del dividendo y el divisor
  assign invierta = negDividendIn ^ negDivisorIn;
  
  //Selector de datos basado en los signos del dividendo y el divisor
  assign quotientSel = invierta ? quotientInB: quotientIn;
  
  //Registro "quotient"
  reg_en #(AnchoQ + 1) quotient (quotientSel, goIn, clk, reset, quotientOut);
  
  //Registro "negDivisor"
  reg_en #(1) negDivisor (negDivisorIn, goIn, clk, reset, negDivisorOut);

  //Registro "negDividend"
  reg_en #(1) negDividend (negDividendIn, goIn, clk, reset, negDividendOut);

  //Registro "DivisorNoCero"
  reg_en #(1) DivisorNoCero (DivisorNoCeroIn, goIn, clk, reset, DivisorNoCeroOut);

endmodule 