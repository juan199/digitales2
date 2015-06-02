// Circuitos Digitales II
// Marco V. Chacon Taylor, Roberto Herrera, Robert Quiros
// Proyecto No 3. Multiplicador/Divisor

//--------------------------------------------------------------------------------------------------------------------
//ALU con control de entradas y de operaciones
module ALU(z,A,B,C,CHi,D,seleccion_operacion,seleccion_operando);
		
//		parameter retardoALU;
		output [31:0] z;
		input [15:0] A,B,CHi;
		input [31:0] C;
		input [3:0] D;
		input [2:0] seleccion_operacion, seleccion_operando;		
		reg [31:0] x,y,z;
		
		//seleccion de operandos
		always @(seleccion_operando or A or B or C or CHi or D) 
				begin
				case(seleccion_operando)
						3'b000: begin
								x = 32'h00000000;
								y = 32'h00000000;
								end
						3'b001: begin //debe extender el signo
								x = {A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],
								A[15],A[15],A[15],A};
								y = 32'h00000000;
								end
						3'b010: begin//debe extender el signo
								x = {B[15],B[15],B[15],B[15],B[15],B[15],B[15],B[15],B[15],B[15],B[15],B[15],B[15],
								B[15],B[15],B[15],B};
								y = 32'h00000000;
								end
						3'b011: begin
								x = C;
								y = 32'h00000000;
								end
						3'b100: begin//debe extender el signo
								x = {CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],
								CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi};
								y = A;
								end
						3'b101: begin//debe extender el signo
								x = {CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],
								CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi[15],CHi};
								y = B;
								end
						3'b110: begin//debe extender el signo
								/*x = {D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],
								D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D[3],D};*/
                                                       x=D;     
								y = 32'h00000000;
								end
					       default: begin 
								x = 32'h00000000;
								y = 32'h00000000;
								end
				endcase
		end
		
		//seleccion de operaciones
		
		always @(seleccion_operacion or x or y)
				begin
				case(seleccion_operacion)
						3'b000: begin 
                                                       
								z <= 32'h00000000;
								end
						3'b001: begin			
								z <= x+y;
								end
						3'b010: begin
								z <= x-y;
								end
						3'b011: begin
								z <= x+1;
								end
						3'b100: begin
								z <= -x;
								end

						default: begin 
								z <= 32'h00000000;
								end
				endcase
		end
endmodule

