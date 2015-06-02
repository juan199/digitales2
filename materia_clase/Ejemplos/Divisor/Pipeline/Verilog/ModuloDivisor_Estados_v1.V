`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module divide (ddInput, dvInput, quotient, go, done, reloj, reset);
input		[`DdLen:0]	ddInput;
input		[`DvLen:0]	dvInput;
output	    [`QLen:0]	quotient;
input			go,
				reloj,
				reset;
output          done;

wire goOut;
wire [`DvLen:0]	divisorOut0, divisorOut1, divisorOut2, divisorOut5, divisorOut8,
                divisorOut11, divisorOut14, divisorOut17, divisorOut20, divisorOut23,
				divisorOut26, divisorOut29, divisorOut32, divisorOut35, divisorOut38,
				divisorOut41, divisorOut44, divisorOut47, divisorOut50, divisorOut51;
wire [`DdLen:0]	dividendOut0, dividendOut1, dividendOut2, dividendOut5, dividendOut8,
                dividendOut11, dividendOut14, dividendOut17, dividendOut20, dividendOut23,
				dividendOut26, dividendOut29, dividendOut32, dividendOut35, dividendOut38,
				dividendOut41, dividendOut44, dividendOut47, dividendOut50, dividendOut51;
wire [`QLen:0]	quotient2, quotient5, quotient8,
                quotient11, quotient14, quotient17, quotient20, quotient23,
				quotient26, quotient29, quotient32, quotient35, quotient38,
				quotient41, quotient44, quotient47, quotient50;

etapa0 Est0 (go, dvInput, ddInput,
             goOut0, divisorOut0, dividendOut0, reset, reloj);
			 
etapa1 Est1 (goOut0, divisorOut0, dividendOut0,
             goOut1, divisorOut1, dividendOut1, negDivisorOut1, negDividendOut1, DivisorNoCeroOut1, reset, reloj);
			 
etapa2 Est2 (goOut1, divisorOut1, dividendOut1, negDivisorOut1, negDividendOut1, DivisorNoCeroOut1,
             goOut2, divisorOut2, dividendOut2, quotient2, negDivisorOut2, negDividendOut2, DivisorNoCeroOut2, reset, reloj);
			 
//16 iteraciones de los estados 3, 4, y 5
etapas_3_4_5 Iter_01 (goOut2, divisorOut2, dividendOut2, quotient2, negDivisorOut2, negDividendOut2, DivisorNoCeroOut2,
                      goOut5, divisorOut5, dividendOut5, quotient5, negDivisorOut5, negDividendOut5, DivisorNoCeroOut5, reset, reloj);
			 
etapas_3_4_5 Iter_02 (goOut5, divisorOut5, dividendOut5, quotient5, negDivisorOut5, negDividendOut5, DivisorNoCeroOut5,
                      goOut8, divisorOut8, dividendOut8, quotient8, negDivisorOut8, negDividendOut8, DivisorNoCeroOut8, reset, reloj);
			 
etapas_3_4_5 Iter_03 (goOut8, divisorOut8, dividendOut8, quotient8, negDivisorOut8, negDividendOut8, DivisorNoCeroOut8,
                      goOut11, divisorOut11, dividendOut11, quotient11, negDivisorOut11, negDividendOut11, DivisorNoCeroOut11, reset, reloj);
			 
etapas_3_4_5 Iter_04 (goOut11, divisorOut11, dividendOut11, quotient11, negDivisorOut11, negDividendOut11, DivisorNoCeroOut11,
                      goOut14, divisorOut14, dividendOut14, quotient14, negDivisorOut14, negDividendOut14, DivisorNoCeroOut14, reset, reloj);
			 
etapas_3_4_5 Iter_05 (goOut14, divisorOut14, dividendOut14, quotient14, negDivisorOut14, negDividendOut14, DivisorNoCeroOut14,
                      goOut17, divisorOut17, dividendOut17, quotient17, negDivisorOut17, negDividendOut17, DivisorNoCeroOut17, reset, reloj);
			 
etapas_3_4_5 Iter_06 (goOut17, divisorOut17, dividendOut17, quotient17, negDivisorOut17, negDividendOut17, DivisorNoCeroOut17,
                      goOut20, divisorOut20, dividendOut20, quotient20, negDivisorOut20, negDividendOut20, DivisorNoCeroOut20, reset, reloj);
			 
etapas_3_4_5 Iter_07 (goOut20, divisorOut20, dividendOut20, quotient20, negDivisorOut20, negDividendOut20, DivisorNoCeroOut20,
                      goOut23, divisorOut23, dividendOut23, quotient23, negDivisorOut23, negDividendOut23, DivisorNoCeroOut23, reset, reloj);
			 
etapas_3_4_5 Iter_08 (goOut23, divisorOut23, dividendOut23, quotient23, negDivisorOut23, negDividendOut23, DivisorNoCeroOut23,
                      goOut26, divisorOut26, dividendOut26, quotient26, negDivisorOut26, negDividendOut26, DivisorNoCeroOut26, reset, reloj);
			 
etapas_3_4_5 Iter_09 (goOut26, divisorOut26, dividendOut26, quotient26, negDivisorOut26, negDividendOut26, DivisorNoCeroOut26,
                      goOut29, divisorOut29, dividendOut29, quotient29, negDivisorOut29, negDividendOut29, DivisorNoCeroOut29, reset, reloj);
			 
etapas_3_4_5 Iter_10 (goOut29, divisorOut29, dividendOut29, quotient29, negDivisorOut29, negDividendOut29, DivisorNoCeroOut29,
                      goOut32, divisorOut32, dividendOut32, quotient32, negDivisorOut32, negDividendOut32, DivisorNoCeroOut32, reset, reloj);
			 
etapas_3_4_5 Iter_11 (goOut32, divisorOut32, dividendOut32, quotient32, negDivisorOut32, negDividendOut32, DivisorNoCeroOut32,
                      goOut35, divisorOut35, dividendOut35, quotient35, negDivisorOut35, negDividendOut35, DivisorNoCeroOut35, reset, reloj);
			 
etapas_3_4_5 Iter_12 (goOut35, divisorOut35, dividendOut35, quotient35, negDivisorOut35, negDividendOut35, DivisorNoCeroOut35,
                      goOut38, divisorOut38, dividendOut38, quotient38, negDivisorOut38, negDividendOut38, DivisorNoCeroOut38, reset, reloj);
			 
etapas_3_4_5 Iter_13 (goOut38, divisorOut38, dividendOut38, quotient38, negDivisorOut38, negDividendOut38, DivisorNoCeroOut38,
                      goOut41, divisorOut41, dividendOut41, quotient41, negDivisorOut41, negDividendOut41, DivisorNoCeroOut41, reset, reloj);
			 
etapas_3_4_5 Iter_14 (goOut41, divisorOut41, dividendOut41, quotient41, negDivisorOut41, negDividendOut41, DivisorNoCeroOut41,
                      goOut44, divisorOut44, dividendOut44, quotient44, negDivisorOut44, negDividendOut44, DivisorNoCeroOut44, reset, reloj);
			 
etapas_3_4_5 Iter_15 (goOut44, divisorOut44, dividendOut44, quotient44, negDivisorOut44, negDividendOut44, DivisorNoCeroOut44,
                      goOut47, divisorOut47, dividendOut47, quotient47, negDivisorOut47, negDividendOut47, DivisorNoCeroOut47, reset, reloj);
			 
etapas_3_4_5 Iter_16 (goOut47, divisorOut47, dividendOut47, quotient47, negDivisorOut47, negDividendOut47, DivisorNoCeroOut47,
                      goOut50, divisorOut50, dividendOut50, quotient50, negDivisorOut50, negDividendOut50, DivisorNoCeroOut50, reset, reloj);
			 
etapa6 Est6 (goOut50, divisorOut50, dividendOut50, quotient50, negDivisorOut50, negDividendOut50, DivisorNoCeroOut50,
             goOut51, divisorOut51, dividendOut51, quotient,   negDivisorOut51, negDividendOut51, DivisorNoCeroOut51, reset, reloj);
			 
assign done = reloj;

endmodule
