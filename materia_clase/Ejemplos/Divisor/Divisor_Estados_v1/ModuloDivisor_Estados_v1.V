`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module divide (ddInput, dvInput, quotient, go, done, reloj, reset, EstPresente);
input		[`DdLen:0]	ddInput;
input		[`DvLen:0]	dvInput;
output	[`QLen:0]	quotient;
input				go,
				reloj,
				reset;
output                     done;

reg		[`DdLen:0]	dividend;
reg		[`QLen:0]	quotient;
reg		[`DvLen:0]	divisor;
reg				done,
				negDivisor, 
				negDividend;

//Inclusiones para maquina de estados
output  [2:0]  EstPresente;
reg		[2:0] 	EstPresente,
				ProximoEst;

reg		[3:0]		Cont16;

parameter   ESTADO_0   = 3'b000,   //Estados de la maquina de estados
            ESTADO_1   = 3'b001,
            ESTADO_2   = 3'b010,
            ESTADO_3   = 3'b011,
            ESTADO_4   = 3'b100,
            ESTADO_5   = 3'b101,
            ESTADO_6   = 3'b110,
            ESTADO_7   = 3'b111;

//Actualizar el registro de estado con el reloj o senal de reset
always @(negedge reloj or negedge reset)
  begin
    if (~reset) begin
      EstPresente <= ESTADO_0;
      done <= 1;
      quotient <= 0;
      end
    else
      EstPresente <= ProximoEst;
  end


always @(EstPresente or go)
	begin
		case(EstPresente)
			ESTADO_0: begin
        			done <= 1;
				if (go) begin
                                  divisor <= dvInput;
					dividend <= ddInput;
					quotient <= 0;
					ProximoEst <= ESTADO_1;
				end
				else
					ProximoEst <= ESTADO_0;
			end

			ESTADO_1: begin
                           done <= 0;
				if (divisor) begin
					negDivisor <= divisor[`DvLen];
					negDividend <= dividend[`DdLen];
					ProximoEst <= ESTADO_2;
				end
				else
					ProximoEst <= ESTADO_7;
			end

			ESTADO_2: begin
				if (negDivisor)
					divisor <= - divisor;
				if (negDividend)
					dividend <= - dividend;
				Cont16 <= 0;	//Lleva la cuenta del repeat
				ProximoEst <= ESTADO_3;
			end

			ESTADO_3: begin
				quotient <= quotient << 1;
				dividend <= dividend << 1;
				Cont16 <= Cont16 - 1;
				ProximoEst <= ESTADO_4;
			end

			ESTADO_4: begin
				dividend[`DdLen:`HiDdMin] <= 
					dividend[`DdLen:`HiDdMin] - divisor;
				ProximoEst <= ESTADO_5;
			end

			ESTADO_5: begin
				if (! dividend [`DdLen])
					quotient <= quotient + 1;
				else	
					dividend[`DdLen:`HiDdMin] <= 
						dividend[`DdLen:`HiDdMin] + divisor;
				if (Cont16)
					ProximoEst <= ESTADO_3;
				else
					ProximoEst <= ESTADO_6;
			end

			ESTADO_6: begin
				if (negDivisor != negDividend)
					quotient <= - quotient;
				ProximoEst <= ESTADO_7;
			end

			ESTADO_7: begin
				if (go)
					ProximoEst <= ESTADO_7;
				else
					ProximoEst <= ESTADO_0;
			end

			default:
				ProximoEst <= ESTADO_0;
		endcase
	end
endmodule
