module divide (ddInput, dvInput, quotient, go, done);
input		[`DdLen:0]		 	ddInput;
input		[`DvLen:0]			dvInput;
output		[`QLen:0]			quotient;
input					go;
output					done;

reg	[`DdLen:0]		 	dividend;
reg	[`QLen:0]			quotient;
reg	[`DvLen:0]			divisor;
reg				done,
				negDivisor, 
				negDividend;
initial
  //La maquina comienza indicando que esta disponible para hacer una division
  #1 done = 1;

always
	begin
        //Aqui espera a que el cliente externo le de la informacion para comenzar
		wait (go);
        #1 done = 0;
		divisor = dvInput;
		dividend = ddInput;
      	#2 quotient = 0;
		if (divisor)
			begin
				negDivisor = divisor[`DvLen];
				if (negDivisor)
					divisor = - divisor;
				negDividend = dividend[`DdLen];
				if (negDividend)
					dividend = - dividend;
				repeat (`DvLen + 1)
					begin
						#2 quotient = quotient << 1;
						dividend = dividend << 1;
						dividend[`DdLen:`HiDdMin] = 
							dividend[`DdLen:`HiDdMin] - divisor;
						if (! dividend [`DdLen])
							#2 quotient = quotient + 1;
						else	
							dividend[`DdLen:`HiDdMin] = 
								dividend[`DdLen:`HiDdMin] + divisor;
					end
				if (negDivisor != negDividend)
					#2 quotient = - quotient;
			end
        //El cociente esta listo, indique que termino
	    #1 done = 1;
		//Espere que el cliente externo retire la solicitud que se acaba de procesar antes de continuar
		wait (~go);
	end
endmodule
//example 2.1
