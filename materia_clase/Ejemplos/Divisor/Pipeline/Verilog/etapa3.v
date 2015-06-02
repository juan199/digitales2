`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module etapa3 #(
                parameter AnchoDv = `DvLen,
				          AnchoDd = `DdLen,
						  AnchoQ  = `QLen
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
			   
  //Senal de "go" se utiliza para hablilitar escritura en los otros registros
  reg_en #(1) go (goIn, 1, clk, reset, goOut);

  //Registro "divisor"
  reg_en #(AnchoDv + 1) divisor (divisorIn, goIn, clk, reset, divisorOut);

  //Registro "dividend" -- El contenido de la etapa anterior se desplaza a la izquierda
  reg_en #(AnchoDd + 1) dividend ({dividendIn[AnchoDd - 1:0],1'b0}, goIn, clk, reset, dividendOut);

  //Registro "quotient" -- El contenido de la etapa anterior se desplaza a la izquierda
  reg_en #(AnchoQ + 1) quotient ({quotientIn[AnchoQ - 1:0],1'b0}, goIn, clk, reset, quotientOut);
  
  //Registro "negDivisor"
  reg_en #(1) negDivisor (negDivisorIn, goIn, clk, reset, negDivisorOut);

  //Registro "negDividend"
  reg_en #(1) negDividend (negDividendIn, goIn, clk, reset, negDividendOut);

  //Registro "DivisorNoCero"
  reg_en #(1) DivisorNoCero (DivisorNoCeroIn, goIn, clk, reset, DivisorNoCeroOut);

endmodule 