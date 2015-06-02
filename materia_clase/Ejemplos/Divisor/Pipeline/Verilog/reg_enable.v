//Este es un registro de "a" bits con entradas de enable y reset
//Si el enable=0 el registro mantiene su valor anterior
//Si el enable=1 el registro almacena el valor en Din
//El reset domina, si este es cero entonces borra el registro en forma asincronica
//El parametro "a" se puede cambiar al invocar el registro, por ejemplo, para un registro
// de 8 bits llamado "Reg1":
//       reg_en #(8) Reg1 (Din, enable, clk, reset, Dout);

module reg_en (Din, enable, clk, reset, Dout);
  parameter a = 1; //Numero de bits del registro
  
  input [a-1:0] Din;
  input enable, clk, reset;
  output [a-1:0] Dout;
  reg [a-1:0] Dout;
  
  always @ (negedge clk or negedge reset)
    begin
	  if (~reset)
	    Dout <= 0;
      else if (enable)
	    Dout <= Din;
	  else
	    Dout <= Dout;
	end
	
endmodule
