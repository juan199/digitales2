

module testbench;

  reg [9:0] INP_PAR;
  wire OUT_SER;
  
  
  output reg INP_SER;
  wire [9:0] OUT_PAR;
  
  wire clksp;
  wire clkps;
  
  reg NEG; 
 
	clock CLK1(clksp);
	clock CLK2(clkps);
	
	par2ser parser(clkps, INP_PAR, OUT_SER);
	ser2par serpar(clksp, INP_SER, NEG, OUT_PAR);

   integer i;
   
initial
begin

	$dumpfile("serdes_dump.vco");
	$dumpvars;

	#1	NEG =1;
	#1	INP_PAR = 35;
	#1	INP_SER = 1;
	
	
	#1500 NEG =1;


		//#30;
		//INP_PAR = 0;
		//#100;
		for(i = 0; i < 100; i = i+1)
		begin 
		#7 INP_SER = INP_SER +1;
		//#5 INP_PAR = INP_PAR+1;
		end
		

    
   #1000 $finish;
end

	
	
endmodule 
