module MaqEstados (teclas, val, clk, R1);
  input [4:0] teclas;
  input val, clk;
  output reg [31:0] R1;
  reg [4:0] CodTec;
  reg [1:0] EstadoPresente, ProximoEstado;
  
  parameter //Codificacion de los estados
    Estado0 = 2'b00,
    Estado1 = 2'b01,
    Estado2 = 2'b10;
  
  initial ProximoEstado = Estado0; //Al hacer un reset tenemos que comenzar en el estado 0
  
  always @(posedge clk) //Este deberia ser el registro de estado
    #3 EstadoPresente = ProximoEstado;
	
  //always @(*) //Este always produce un resultado incorrecto pues hace que R1 y CodTec sean parte de las entradas de la maquina de estados
  always @(val or EstadoPresente) //Esto es logica combinacional para generar el proximo estado y las salidas de la maquina de estados
    case (EstadoPresente)
      Estado0: begin
	  	if (val==1) begin
		  CodTec <= teclas; //Esto se transfiere tan pronto como val se haga 1, es decir, no esta controlado por el reloj clk
		  ProximoEstado = Estado1;
		end
		else
		  ProximoEstado = Estado0;
	  end
	  
      Estado1: begin
	  	if (val==0) begin
	      R1 <= {R1[27:0], CodTec[3:0]}; //Desplazamiento de 4 bits. Se hace la transferencia tan pronto como val se hace cero
		  ProximoEstado = Estado0;
		end
		else
		  ProximoEstado = Estado1;
	  end
	  
      Estado2: begin //Este estado no es necesario!!!!!!!
	  	if (val==0)
		  ProximoEstado = Estado0;
		else
		  ProximoEstado = Estado2;
	  end
	  
      default:
        ProximoEstado = Estado0; //Esta es una maquina de estados magica que siempre se inicializa si se pierde.. je je
    endcase
endmodule
