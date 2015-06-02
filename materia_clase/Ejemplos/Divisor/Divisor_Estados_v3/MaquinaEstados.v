module MaquinaEstados (go, Cont16NoCero, divisorNoCero, reloj, reset, Est, EstPresente);
  input go, Cont16NoCero, divisorNoCero, reloj, reset;
  output [2:0]  EstPresente;
  reg    [2:0]  EstPresente,
		  ProximoEst;

  output [7:0] Est;
  reg    [7:0] Est;  //Salidas indicando el estado de la maquina

  parameter ESTADO_0   = 3'b000,   //Estados de la maquina de estados
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
    if (~reset)
      EstPresente <= ESTADO_0;
    else
      EstPresente <= ProximoEst;
  end

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

endmodule
