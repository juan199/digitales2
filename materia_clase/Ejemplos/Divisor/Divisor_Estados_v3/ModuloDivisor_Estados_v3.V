`include "ParGlobal.v"

module divide (ddInput, dvInput, quotient, go, done, reloj, reset, EstPresente);
  input	[`DdLen:0]	ddInput;
  input	[`DvLen:0]	dvInput;
  output	[`QLen:0]	quotient;
  input			go,
				reloj,
				reset;
  output                    done;
  output [2:0]  EstPresente;

  reg		[`DdLen:0]	dividend;
  reg		[`QLen:0]	quotient;
  reg		[`DvLen:0]	divisor;
  reg				done,
				negDivisor, 
				negDividend;

  //Contador para llevar cuenta de iteraciones
  reg		[3:0]		Cont16;

  //Declaracion de condiciones de salto para el controlador
  wire  Cont16NoCero,
        divisorNoCero;
  assign Cont16NoCero = | Cont16;
  assign divisorNoCero = | divisor;

  //Controlador
  wire [2:0] EstPresente;
  wire [7:0] Est;
  //Seleccione el controlador con variables de ambiente
  `ifdef ME
  MaquinaEstados Control_1 (go, Cont16NoCero, divisorNoCero, reloj, reset, Est, EstPresente);
  `endif
  `ifdef Uff
  UnFFporEstado Control_2 (go, Cont16NoCero, divisorNoCero, reloj, reset, Est, EstPresente);
  `endif
  `ifdef CR
  Ctrl_Richards Control_3 (go, Cont16NoCero, divisorNoCero, reloj, reset, Est, EstPresente);
  `endif
  `ifdef CuP
  Ctrl_uProg Control_4 (go, Cont16NoCero, divisorNoCero, reloj, reset, Est, EstPresente);
  `endif

//Registro done
  wire h1, r1, d1;
  //Logica de control
  or  #`Tp g1(h1, Est[0], Est[1]);
  and #`Tp g2(r1, h1, reloj);
  //Seleccion de datos
  select5 #(0) sel1(d1, 1'b1, 1'b0,,,, Est[0], Est[1], 1'b0, 1'b0, 1'b0);
  //Registro
  always @(negedge r1 or negedge reset)
    begin
      if (~reset)
        done <= #`Tp 1;
      else
        done <= #`Tp d1;
    end

//Registro divisor
  wire h2, r2;
  wire [`DvLen:0] d2, divisor_comp2;
  //Logica de control
  and #`Tp g3(x1, Est[0], go);
  and #`Tp g4(x2, Est[2], negDivisor);
  or  #`Tp g5(h2, x1, x2);
  and #`Tp g6(r2, h2, reloj);
  //Modulo para sacar el complemento de divisor
  comp_a_2 #(`DvLen) comp1(divisor_comp2, divisor);
  //Seleccion de datos
  select5 #(`DvLen) sel2(d2, dvInput, divisor_comp2,,,, Est[0], Est[2], 1'b0, 1'b0, 1'b0);
  //Registro
  always @(negedge r2)
    divisor <= #`Tp d2;

//Registro dividend
  wire h3, r3;
  wire [`DdLen:0] d3, dividend_comp2, dd_dizq1;
  wire [`DvLen:0] dd_men_dv, dd_mas_dv;
  //Logica de control
  and #`Tp g7(x3, Est[0], go);
  and #`Tp g8(x4, Est[2], negDividend);
  and #`Tp g9(x7, Est[5], dividend[`DdLen]);
  or  #`Tp g10(h3, x3, x4, Est[3], Est[4], x7);
  and #`Tp g11(r3, h3, reloj);
  //Modulo para sacar el complemento de dividend
  comp_a_2 #(`DdLen) comp2(dividend_comp2, dividend);
  //Modulo para desplazar dividend a la izquierda
  assign dd_dizq1 = dividend << 1;
  //Modulo para restar divisor de dividend
  assign dd_men_dv = dividend[`DdLen:`HiDdMin] - divisor;
  //Modulo para sumar divisor y dividend
  assign dd_mas_dv = dividend[`DdLen:`HiDdMin] + divisor;
  //Seleccion de datos
  select5 #(`DdLen) sel3(d3, ddInput, dividend_comp2, dd_dizq1, {dd_men_dv, dividend[`DvLen:0]}, {dd_mas_dv, dividend[`DvLen:0]}, Est[0], Est[2], Est[3], Est[4], Est[5]);
  //Registro
  always @(negedge r3)
    dividend <= #`Tp d3;

//Registro quotient
always @(negedge (((Est[0] & go) | Est[3] | (Est[5] & (! dividend [`DdLen])) | (Est[6] & (negDivisor != negDividend))) & reloj) or negedge reset)
  begin
    if (Est[0])
      quotient <= 0;
    if (Est[3])
      quotient <= quotient << 1;
    if (Est[5])
      quotient <= quotient + 1;
    if (Est[6])
      quotient <= - quotient;
    if (~reset)
      quotient <= 0;
  end

//Registro negDivisor
always @(negedge ((Est[1] & divisorNoCero) & reloj))
  begin
    if (Est[1])
      negDivisor <= divisor[`DvLen];
  end

//Registro negDividend
always @(negedge ((Est[1] & divisorNoCero) & reloj))
  begin
    if (Est[1])
      negDividend <= dividend[`DdLen];
  end

//Registro Cont16
always @(negedge ((Est[2] | Est[3]) & reloj))
  begin
    if (Est[2])
      Cont16 <= 0;
    if (Est[3])
      Cont16 <= Cont16 + 1;
  end

endmodule
