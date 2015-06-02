// Circuitos Digitales II
// Marco V. Chacon Taylor, Roberto Herrera, Robert Quiros
// Proyecto No 3. Multiplicador/Divisor

//--------------------------------------------------------------------------------------------------------------------
//modulo completo del multiplicador/divisor (cascaron)

module cascaron(result,done,input1,input2,go,selecc_op,clk,reset);
		
  input[15:0] input1; //entrada que se usa para divisor o multiplicador
  input[31:0] input2; //entrada que se usa para dividendo multiplicando
  input go,selecc_op,clk,reset;

  output [31:0] result;
  output done;

  // alambrado entre diferentes modulos/registros
		
  // señales de control
  wire	initDiv,
	initMult,
	done_1,
	assignZ_to_A,
	assignZ_to_B,
	assignZ_to_C,
	CHIassignZ,
	assign_Z_to_D,
	Shift_A,
	Shift_B,
	Shift_C_right,
	Shift_C_left;
		
  // alambrado para registros de signo
  wire	MSB_A,
	MSB_B,
	MSB_C,
	neg_reg_C_MSB;
	
  // alambrado para condiciones
  wire	AEScero,
	A0EScero,
	CNOcero,
	neg1IGUALneg2,
	contNOquince;
		
  // alambrado de 16 bits para registros A,B,C y ALU
  wire [15:0] sal_A,
	      sal_B,
	      sal_CHi,
	      input2_lo,
	      z_lo,
	      z_hi;
		
  // alambrado de microOperacion
  wire [17:0] uOp;
		
  // alambrado de 4 bits (contador y ALU)
  wire [3:0]  sal_D,
	      z_4_bits;
		
  // alambrado de 32 bits para registro C y ALU (ademas de salida de C y B para salida de cascara)
  wire [31:0]	z,
		sal_C,
		sal_B_extend;
		
  // alambrado de 3 bits (provenientes de microinstruccion)
  wire [2:0]  seleccion_operacion,
	      seleccion_operando;
		
  assign MSB_A = input1[15];
  assign MSB_B = input2[15];
  assign MSB_C = input2[31];
  assign input2_lo = input2[15:0];
  assign neg_reg_C_MSB = sal_C[31];
    
  //instanciacion de registros internos
  regA_con_ctrl Reg_A(clk,initDiv,initMult,assignZ_to_A,Shift_A,input1,z_lo,sal_A);
  
  regB_con_ctrl Reg_B(clk,initDiv,initMult,assignZ_to_B,Shift_B,input2_lo,z_lo,sal_B);
  
  regC_completo Reg_C(clk,initDiv,initMult,assignZ_to_C,CHIassignZ,Shift_C_right,Shift_C_left,input2,z,sal_C);
  
  regD_con_ctrl Reg_D(clk,initDiv,initMult,assignZ_to_D,z_4_bits,sal_D);
  
  regdone_con_ctrl Reg_done(clk, initDiv,initMult,done_1,done);
  
  regneg1_con_ctrl Reg_neg1(clk,initDiv,initMult,MSB_A,sal_neg1);
  
  regneg2_con_ctrl Reg_neg2(clk,initDiv,initMult,MSB_B,MSB_C,sal_neg2);
  
  reg_mult_div_con_ctrl reg_mult_div(clk, mult_div_reg,initDiv, initMult, selecc_op);

  // instaciacion de la ALU
  ALU ALU_conductual(z,sal_A,sal_B,sal_C,sal_C[31:16],sal_D,seleccion_operacion,seleccion_operando);
  
  // instanciacion del controlador microprogramado
  controlador control_uProg(uOp,go,mult_div_reg,sal_neg1,sal_neg2,AEScero,A0EScero,CNOcero,neg1IGUALneg2,contNOquince,clk,reset, neg_reg_C_MSB);
		
  // selector de salida (registro C en multiplicacion y B en division)
  selector #(31) selector_salida(result, sal_B_extend, sal_C,mult_div_reg);

  // asignacion de registros, asignacion de operaciones y operandos a partir de la uOperacion
  assign  seleccion_operacion = uOp[5:3],	// operacion
	  seleccion_operando = uOp[2:0],	// operandos
	  {initDiv,initMult,done_1,assignZ_to_A,Shift_A,Shift_B,assignZ_to_B,assignZ_to_C,Shift_C_right,Shift_C_left,CHIassignZ,assignZ_to_D} = uOp[17:6]; //asignacion registros
		
  //distribucion de salida de ALU hacia registros, segun tamaño
  assign  z_4_bits = z[3:0],
	  z_lo = z[15:0],
	  z_hi = z[31:16];
		
  // asignacion para condiciones generadas desde registros
  assign  AEScero = ~|(sal_A),
	  A0EScero = ~(sal_A[0]),
	  CNOcero = |(sal_C),
	  neg1IGUALneg2 = ~(sal_neg1^sal_neg2),
	  contNOquince = ~&(sal_D);
				
  // extension de signo de salida de registro B para asignarlo a salida de 32 bits
  assign sal_B_extend = {sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B[15],sal_B};

endmodule
