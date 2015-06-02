`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module etapa1 #(
                parameter AnchoDv = `DvLen,
				          AnchoDd = `DdLen,
						  AnchoQ  = `QLen
			   )
              (
               input goIn,
			   input [`DvLen:0] divisorIn,
			   input [`DdLen:0] dividendIn,
			   output goOut,
			   output [`DvLen:0] divisorOut,
			   output [`DdLen:0] dividendOut,
			   output negDivisorOut,
			   output negDividendOut,
			   output DivisorNoCeroOut,
			   input reset, clk
			   );
			   
  //Senal de "go" se utiliza para hablilitar escritura en los otros registros
  reg_en #(1) go (goIn, 1, clk, reset, goOut);

  //Registro "divisor"
  reg_en #(AnchoDv + 1) divisor (divisorIn, goIn, clk, reset, divisorOut);

  //Registro "dividend"
  reg_en #(AnchoDd + 1) dividend (dividendIn, goIn, clk, reset, dividendOut);

  //Condicion para ver si el divisor es distinto de cero
  assign condDivNoCero = |divisorIn;
  
  //Registro "negDivisor"
  reg_en #(1) negDivisor (divisorIn[`DvLen], goIn, clk, reset, negDivisorOut);

  //Registro "negDividend"
  reg_en #(1) negDividend (dividendIn[`DdLen], goIn, clk, reset, negDividendOut);

  //Registro "DivisorNoCero"
  reg_en #(1) DivisorNoCero (condDivNoCero, goIn, clk, reset, DivisorNoCeroOut);

endmodule 