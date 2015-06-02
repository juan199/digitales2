`define DvLen 15
`define DdLen 31
`define QLen 15
`define HiDdMin 16

module divide (ddInput, dvInput, quotient, go, done, reloj, reset, EstPresente);
input	[`DdLen:0]	ddInput;
input	[`DvLen:0]	dvInput;
output	[`QLen:0]	quotient;
input	go,
	reloj,
	reset;
output	done;

reg	[`DdLen:0]	dividend;
reg	[`QLen:0]	quotient;
reg	[`DvLen:0]	divisor;
reg	done,
	negDivisor, 
	negDividend;

//Inclusiones para maquina de estados
output  [2:0]	EstPresente;
reg	[2:0]	EstPresente,
		ProximoEst;

reg	[3:0]	Cont16;
reg     [7:0]	Est;  //Salidas indicando el estado de la maquina

parameter   ESTADO_0   = 3'b000,   //Estados de la maquina de estados
            ESTADO_1   = 3'b001,
            ESTADO_2   = 3'b010,
            ESTADO_3   = 3'b011,
            ESTADO_4   = 3'b100,
            ESTADO_5   = 3'b101,
            ESTADO_6   = 3'b110,
            ESTADO_7   = 3'b111;

//Declaracion de condiciones de salto
wire  Cont16NoCero,
      divisorNoCero;

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

//Senales con las condiciones que producen cambios de estado
assign Cont16NoCero = | Cont16;
assign divisorNoCero = | divisor;

always @(EstPresente or go or Cont16NoCero or divisorNoCero)
	begin
		case(EstPresente)
			ESTADO_0: begin
                            Est <= 8'b00000001;
				if (go)
					ProximoEst <= ESTADO_1;
				else
					ProximoEst <= ESTADO_0;
			end

			ESTADO_1: begin
                            Est <= 8'b00000010;
				if (divisorNoCero)
					ProximoEst <= ESTADO_2;
				else
					ProximoEst <= ESTADO_7;
			end

			ESTADO_2: begin
                            Est <= 8'b00000100;
				ProximoEst <= ESTADO_3;
			end

			ESTADO_3: begin
                            Est <= 8'b00001000;
				ProximoEst <= ESTADO_4;
			end

			ESTADO_4: begin
                            Est <= 8'b00010000;
				ProximoEst <= ESTADO_5;
			end

			ESTADO_5: begin
                            Est <= 8'b00100000;
				if (Cont16NoCero)
					ProximoEst <= ESTADO_3;
				else
					ProximoEst <= ESTADO_6;
			end

			ESTADO_6: begin
                            Est <= 8'b01000000;
				ProximoEst <= ESTADO_7;
			end

			ESTADO_7: begin
                            Est <= 8'b10000000;
				if (go)
					ProximoEst <= ESTADO_7;
				else
					ProximoEst <= ESTADO_0;
			end

			default: begin
                            Est <= 8'b00000001;
				ProximoEst <= ESTADO_0;
                    end
		endcase
	end

//Registro done ===================================================
wire ct1, ct2, ce_done;

//Condiciones de transferencia
assign ct1 = Est[0];
assign ct2 = Est[1];

//CE del registro
assign ce_done = ct1 | ct2;

//Seleccion de datos
reg datos_done;
always @ (ct1 or ct2)
  begin
    if (ct1)
      datos_done <= 1;
    else if (ct2)
      datos_done <= 0;
    else
      datos_done <= 0;
  end

//Registro
always @(negedge reloj)
  begin
    if (ce_done)
      done <= datos_done;
  end

//Registro divisor ================================================
wire ct3, ct4, ce_divisor;

//Condiciones de transferencia
assign ct3 = Est[0] && go;
assign ct4 = Est[2] && negDivisor;

//CE del registro
assign ce_divisor = ct3 | ct4;

//Seleccion de datos
reg [`DvLen:0] datos_divisor;
always @ (ct3 or ct4 or dvInput or divisor)
  begin
    if (ct3)
      datos_divisor <= dvInput;
    else if (ct4)
      datos_divisor <= - divisor;
    else
      datos_divisor <= 0;
  end

//Registro
always @(negedge reloj)
  begin
    if (ce_divisor)
      divisor <= datos_divisor;
  end

//Registro dividend ===============================================
wire ct5, ct6, ct7, ct8, ct9, ce_dividend;

//Condiciones de transferencia
assign ct5 = Est[0] & go;
assign ct6 = Est[2] & negDividend;
assign ct7 = Est[3];
assign ct8 = Est[4];
assign ct9 = Est[5] & dividend [`DdLen];

//CE del registro
assign ce_dividend = ct5 | ct6 | ct7 | ct8 | ct9;

//Seleccion de datos
reg [`DdLen:0] datos_dividend;
always @ (ct5 or ct6 or ct7 or ct8 or ct9 or ddInput or dividend)
  begin
    if (ct5)
      datos_dividend <= ddInput;
    else if (ct6)
      datos_dividend <= - dividend;
    else if (ct7)
      datos_dividend <= dividend << 1;
    else if (ct8)
      datos_dividend <= {dividend[`DdLen:`HiDdMin] - divisor, dividend[`HiDdMin - 1:0]};
    else if (ct9)
      datos_dividend <= {dividend[`DdLen:`HiDdMin] + divisor, dividend[`HiDdMin - 1:0]};
    else
      datos_dividend <= 0;
  end

//Registro
always @(negedge reloj)
  begin
    if (ce_dividend)
      dividend <= datos_dividend;
  end

//Registro quotient ===============================================
wire ct10, ct11, ct12, ct13, ce_quotient;

//Condiciones de transferencia
assign ct10 = Est[0] & go;
assign ct11 = Est[3];
assign ct12 = Est[5] & (! dividend [`DdLen]);
assign ct13 = Est[6] & (negDivisor != negDividend);

//CE del registro
assign ce_quotient = ct10 | ct11 | ct12 | ct13;

//Seleccion de datos
reg [`QLen:0] datos_quotient;
always @ (ct10 or ct11 or ct12 or ct13 or quotient)
  begin
    if (ct10)
      datos_quotient <= 0;
    else if (ct11)
      datos_quotient <= quotient << 1;
    else if (ct12)
      datos_quotient <= quotient + 1;
    else if (ct13)
      datos_quotient <= - quotient;
    else
      datos_quotient <= 0;
  end

//Registro
always @(negedge reloj)
  begin
    if (ce_quotient)
      quotient <= datos_quotient;
  end

//Registro negDivisor =============================================
always @(negedge ((Est[1] & divisorNoCero) & reloj))
  begin
    if (Est[1])
      negDivisor <= divisor[`DvLen];
  end

//Registro negDividend ============================================
always @(negedge ((Est[1] & divisorNoCero) & reloj))
  begin
    if (Est[1])
      negDividend <= dividend[`DdLen];
  end

//Registro Cont16 =================================================
always @(negedge ((Est[2] | Est[3]) & reloj))
  begin
    if (Est[2])
      Cont16 <= 0;
    if (Est[3])
      Cont16 <= Cont16 + 1;
  end

endmodule
