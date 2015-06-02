`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module etapa5 #(
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
			   
  wire [`DvLen:0] DdMasDv, DdSupSel;
  wire [`QLen:0] QMas1;
			   
  //Senal de "go" se utiliza para hablilitar escritura en los otros registros
  reg_en #(1) go (goIn, 1, clk, reset, goOut);

  //Registro "divisor"
  reg_en #(AnchoDv + 1) divisor (divisorIn, goIn, clk, reset, divisorOut);

  //Sumar "divisor" a la parte superior de "dividend"
  assign DdMasDv = dividendIn[AnchoDd:SupDvMn] + divisorIn;
  
  //Seleccionar restablecer parte superior de "dividend" o no
  assign DdSupSel = dividendIn[AnchoDd] ? DdMasDv : dividendIn[AnchoDd:SupDvMn];
  
  //Registro "dividend"
  reg_en #(AnchoDd + 1) dividend ({DdSupSel,dividendIn[SupDvMn - 1:0]}, goIn, clk, reset, dividendOut);

  //Incrementar "quotient" en uno si no hubo debo en la resta del dividendo en la etapa anterior
  assign QMas1 = dividendIn[AnchoDd] ? quotientIn : quotientIn + 1;
  
  //Registro "quotient"
  reg_en #(AnchoQ + 1) quotient (QMas1, goIn, clk, reset, quotientOut);
  
  //Registro "negDivisor"
  reg_en #(1) negDivisor (negDivisorIn, goIn, clk, reset, negDivisorOut);

  //Registro "negDividend"
  reg_en #(1) negDividend (negDividendIn, goIn, clk, reset, negDividendOut);

  //Registro "DivisorNoCero"
  reg_en #(1) DivisorNoCero (DivisorNoCeroIn, goIn, clk, reset, DivisorNoCeroOut);

endmodule 