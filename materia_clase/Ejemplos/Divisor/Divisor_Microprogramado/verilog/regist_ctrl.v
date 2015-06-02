// Circuitos Digitales II
// Marco V. Chacon Taylor, Roberto Herrera, Robert Quiros
// Proyecto No 3. Multiplicador/Divisor

// --->>> Registros y logica de seleccion y control <<<---

//registro A con su respectivo control
module regA_con_ctrl(clk,initDiv,initMult,assignZ,Shift_A,input1,z_lo,sal_A);
		
		input clk,initDiv,initMult,assignZ,Shift_A; //entradas de control
		input [15:0] input1,z_lo; //entradas de datos
		output [15:0] sal_A;
		
		reg [15:0] A;
		
		wire selecc_cont; //control del registro
		wire [15:0] A_shift_r;
		
		//control del registro
		assign selecc_cont = (clk &(initDiv | assignZ | Shift_A | initMult));
		
		//alambrado para el desplazamiento
		assign A_shift_r [14:0] = A[15:1];
              assign	A_shift_r [15] = 1'b0;
		
		//alambrado de salida
		assign sal_A = A;
		
		//logica de seleccion
		always @ (negedge selecc_cont) //en cada flanco negativo asigna un valor de entrada
										//al registro, segun señal de control
				begin					
						if (initDiv | initMult)
								A = input1;
						else if (assignZ)
								A = z_lo;
						else if (Shift_A)
								A = A_shift_r;
				end
endmodule

//--------------------------------------------------------------------------------------------------------------------

//registro B con su respectivo control
module regB_con_ctrl(clk,initDiv,initMult,assignZ,Shift_B,input2_lo,z_lo,sal_B);
		
		input clk,initDiv,initMult,assignZ,Shift_B; //entradas de control
		input [15:0] input2_lo,z_lo; //entradas de datos
		output [15:0] sal_B;
		
		reg [15:0] B;
		
		wire selecc_cont; //control de registro
		wire [15:0] B_shift_l;
		
		//control del registro
		assign selecc_cont = (clk &(initDiv | assignZ | Shift_B | initMult));
		
		//alambrado para el desplazamiento
		assign B_shift_l [15:1] = B[14:0];
              assign	B_shift_l [0] = 1'b0;
		
		//alambrado de salida
		assign sal_B = B;
		
		//logica de seleccion
		always @ (negedge selecc_cont)//en cada flanco negativo asigna un valor de entrada
										//al registro, segun señal de control
				begin
						if (initMult)
								B = input2_lo;
						else if (initDiv)
								B = 16'h0000;
						else if (assignZ)
								B = z_lo;
						else if (Shift_B)
								B = B_shift_l;
				end
endmodule

//--------------------------------------------------------------------------------------------------------------------

//parte alta del registro C su respectivo control
module regCHi_con_ctrl(clk,initDiv,initMult,assignZ,CHIassignZ,Shift_right,Shift_left,input2_hi,z_hi,z_lo,MSB_CLo,
						sal_CHi,sal_LSB_CHi);
		
		input clk,initDiv,initMult,assignZ,CHIassignZ,Shift_right,Shift_left; // entradas de control
		input MSB_CLo; // entrada para desplazamiento desde parte baja
		input [15:0] input2_hi,z_hi,z_lo; //entradas de datos
		output [15:0] sal_CHi;
		output sal_LSB_CHi; // salida de desplazamiento hacia parte alta
		
		reg [15:0] CHi;
		
		wire selecc_cont;
		wire [15:0] CHi_shift_r,CHi_shift_l; //conexiones para desplazamiento
		
		//control del registro
		assign selecc_cont = (clk &(initDiv | assignZ | CHIassignZ | Shift_right | Shift_left | initMult));
		
		//alambrado para el desplazamiento a la derecha
		assign CHi_shift_r [14:0] = CHi[15:1];
              assign	CHi_shift_r [15] = 1'b0;

              
		//alambrado para el desplazamiento a la izquierda
		assign CHi_shift_l [15:1] = CHi[14:0];
              assign	CHi_shift_l [0] = MSB_CLo;
		
		//alambrado de salida
		assign sal_CHi = CHi;
              assign	sal_LSB_CHi = CHi[0];


		//logica de seleccion
		always @ (negedge selecc_cont)//en cada flanco negativo asigna un valor de entrada
										//al registro, segun señal de control
				begin
						if (initDiv)
								CHi = input2_hi;
						else if (initMult)
								CHi = 16'h0000;
						else if (assignZ)
								CHi = z_hi;
						else if (CHIassignZ)
								CHi = z_lo;
						else if (Shift_right)
								CHi = CHi_shift_r;
						else if (Shift_left)
								CHi = CHi_shift_l;
				end
endmodule

//--------------------------------------------------------------------------------------------------------------------
//parte Baja del registro C su respectivo control
module regCLo_con_ctrl(clk,initDiv,initMult,assignZ,Shift_right,Shift_left,input2_lo,z_lo,LSB_CHi,sal_CLo,sal_MSB_CLo);
		
		input clk,initDiv,initMult,assignZ,Shift_right,Shift_left; //entradas de control
		input LSB_CHi; //entrada para desplazamiento desde parte alta
		input [15:0] input2_lo,z_lo; //entrada de datos
		output [15:0] sal_CLo;
		output sal_MSB_CLo; //salida para desplazamiento hacia parte baja
		
		reg [15:0] CLo;
		
		wire selecc_cont; //control de registro
		wire [15:0] CLo_shift_r,CLo_shift_l; //conexiones para desplazamiento
		
		//control del registro
		assign selecc_cont = (clk &(initDiv | assignZ | Shift_right | Shift_left | initMult));

		//alambrado para el desplazamiento a la derecha
		assign CLo_shift_r [14:0] = CLo[15:1];
              assign	CLo_shift_r [15] = LSB_CHi;
		
		//alambrado para el desplazamiento a la izquierda
		assign CLo_shift_l [15:1] = CLo[14:0];
              assign	CLo_shift_l [0] = 1'b0;
		
		//alambrado de salida
		assign sal_CLo = CLo;
              assign	sal_MSB_CLo = CLo[15];

		//logica de seleccion
		always @ (negedge selecc_cont)//en cada flanco negativo asigna un valor de entrada
										//al registro, segun señal de control
				begin
						if (initDiv)
								CLo = input2_lo;
						else if (initMult)
								CLo = 16'h0000;
						else if (assignZ)
								CLo = z_lo;
						else if (Shift_right)
								CLo = CLo_shift_r;
						else if (Shift_left)
								CLo = CLo_shift_l;
				end
endmodule

//--------------------------------------------------------------------------------------------------------------------
//registro C completo
module regC_completo(clk,initDiv,initMult,assignZ,CHIassignZ,Shift_right,Shift_left,input2,z,sal_C);
		
		input clk,initDiv,initMult,assignZ,CHIassignZ,Shift_right,Shift_left;

		input [31:0] input2,z; //recibe todo input2 y lo reparte, tambien z
		output [31:0] sal_C;
		
		reg [15:0] C;
		
		wire selecc_cont, MSB_CLo, LSB_CHi; //las 2 ultimas son para desplazamiento
		
		//reparticion de señales en parte baja y alta
		wire [15:0] input2_hi,input2_lo,z_hi,z_lo, sal_CLo, sal_CHi;
		assign input2_hi = input2[31:16];
              assign	input2_lo = input2[15:0];
              assign	z_hi = z[31:16];
              assign	z_lo = z[15:0];
		
		//alambrado de salida
		assign sal_C = {sal_CHi,sal_CLo};

		
		//instancia parte alta y parte baja
		regCHi_con_ctrl parte_alta_C(clk,initDiv,initMult,assignZ,CHIassignZ,Shift_right,Shift_left,input2_hi,z_hi,z_lo,
									 MSB_CLo,sal_CHi,LSB_CHi);
		regCLo_con_ctrl parte_baja_C(clk,initDiv,initMult,assignZ,Shift_right,Shift_left,input2_lo,z_lo,LSB_CHi,sal_CLo,MSB_CLo);
		
endmodule

//--------------------------------------------------------------------------------------------------------------------
//registro D (contador) con su respectivo control
module regD_con_ctrl(clk,initDiv,initMult,assignZ,z_4_bits,sal_D);
		
		input clk,initDiv,initMult,assignZ; //entradas de control
		input [3:0] z_4_bits; //solo toma 4 bits menos significativos de D
		output [3:0] sal_D;
		
		reg [3:0] D;
		
		wire selecc_cont; //control de registro
		
		//control del registro
		assign selecc_cont = (clk &(initDiv | assignZ | initMult));
		
		//alambrado de salida
		assign sal_D = D;
		
		//logica de seleccion
		always @ (negedge selecc_cont)//en cada flanco negativo asigna un valor de entrada
										//al registro, segun señal de control
				begin/*
						if (initMult)
                                                      D = 4'hF;
                                         else if(initDiv)
								D = 4'hF;*/
						if (initMult | initDiv)
                                                      D = 4'hF;
   						else if (assignZ)
								D = z_4_bits;
				end
endmodule

//--------------------------------------------------------------------------------------------------------------------
//registro done con su respectivo control
module regdone_con_ctrl(clk,initDiv,initMult,done_1,sal_done);
		
		input clk,initDiv,initMult,done_1; //entradas de control y datos
		output sal_done;
		
		reg done;
		
		wire selecc_cont;  //control de registro
		assign selecc_cont = (clk &(initDiv | done_1 | initMult));
		
		//alambrado de salida
		assign sal_done = done;
		
		//logica de seleccion
		always @ (negedge selecc_cont)//en cada flanco negativo asigna un valor de entrada
										//al registro, segun señal de control
				begin
						if (initMult | initDiv)
								done = 1'b0;
						else if (done_1)
								done = 1'b1;
				end
endmodule

//--------------------------------------------------------------------------------------------------------------------
//registro neg1 con su respectivo control
module regneg1_con_ctrl(clk,initDiv,initMult,MSB_A,sal_neg1);
		
		input clk,initDiv,initMult,MSB_A; //entradas de control y datos
		output sal_neg1;
		
		reg neg1;
		
		wire selecc_cont;		//control del registro
		assign selecc_cont = (clk &(initDiv | initMult));
		
		//alambrado de salida
		assign sal_neg1 = neg1;
		
		//logica de seleccion
		always @ (negedge selecc_cont)//en cada flanco negativo asigna un valor de entrada
										//al registro, segun señal de control
				begin
						if (initMult | initDiv)
								neg1 = MSB_A;
				end
endmodule

//--------------------------------------------------------------------------------------------------------------------
//registro neg2 con su respectivo control
module regneg2_con_ctrl(clk,initDiv,initMult,MSB_B,MSB_C,sal_neg2);
		
		input clk,initDiv,initMult,MSB_B,MSB_C; //entrada de control y datos
		output sal_neg2;
		
		reg neg2;
		
		wire selecc_cont;		//control del registro
		assign selecc_cont = (clk &(initDiv | initMult));
		
		//alambrado de salida
		assign sal_neg2 = neg2;
		
		//logica de seleccion
		always @ (negedge selecc_cont)//en cada flanco negativo asigna un valor de entrada
										//al registro, segun señal de control
				begin
						if (initDiv)
								neg2 = MSB_C;
						else if (initMult)
								neg2 = MSB_B;
				end
endmodule

//registro A con su respectivo control
module reg_mult_div_con_ctrl(clk, mult_div_reg,initDiv, initMult, mult_div);
		
  input   initDiv, initMult, clk; //entradas de control
  input   mult_div; //entradas de datos
  output  mult_div_reg;
		
  reg     mult_div_reg;

  wire    selecc_cont;
  assign  selecc_cont = (clk &(initDiv | initMult));
		
  //logica de seleccion
  always @ (negedge selecc_cont) 								
    mult_div_reg= mult_div;
endmodule

