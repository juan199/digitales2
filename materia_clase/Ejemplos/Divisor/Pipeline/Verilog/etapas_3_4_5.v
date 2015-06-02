module etapas_3_4_5
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

wire [`DvLen:0]	divisorOut3, divisorOut4;
wire [`DdLen:0]	dividendOut3, dividendOut4;
wire [`QLen:0]	quotient3, quotient4;

etapa3 Est3 (goIn, divisorIn, dividendIn, quotientIn, negDivisorIn, negDividendIn, DivisorNoCeroIn,
             goOut3, divisorOut3, dividendOut3, quotient3, negDivisorOut3, negDividendOut3, DivisorNoCeroOut3, reset, clk);
			 
etapa4 Est4 (goOut3, divisorOut3, dividendOut3, quotient3, negDivisorOut3, negDividendOut3, DivisorNoCeroOut3,
             goOut4, divisorOut4, dividendOut4, quotient4, negDivisorOut4, negDividendOut4, DivisorNoCeroOut4, reset, clk);
			 
etapa5 Est5 (goOut4, divisorOut4, dividendOut4, quotient4, negDivisorOut4, negDividendOut4, DivisorNoCeroOut4,
             goOut, divisorOut, dividendOut, quotientOut, negDivisorOut, negDividendOut, DivisorNoCeroOut, reset, clk);
			 
endmodule
