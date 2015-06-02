module testbench;

reg [9:0] INP;
wire SCLK;
wire RX;
wire CLK;
reg reset;

trans_clock CLK1(CLK);
K285 test(CLK, INP, reset, SCLK, RX);

integer i;
   
initial
begin

	$dumpfile("K285_dump.vco");
	$dumpvars;

    #1 reset =1;
     #15 reset =0; 
	#1	INP = 10'd35;
	
	#15 INP = 10'b0011110101; //K28.5
	#100;
	
	

		for(i = 0; i < 100; i = i+1)
		begin 
		#7 INP = INP +1;
		end
		
	#1 reset =1;
    #15 reset =0; 
	#1 INP = 10'd35;  //BASURA
	
	   for(i = 0; i < 200; i = i+1)
		begin 
		#7 INP = INP +1;
		end
	
	#15 INP = 10'b1100001010;  //K28.5
	#100;
	
		for(i = 0; i < 100; i = i+1)
		begin 
		#7 INP = INP +1;
		end
    
   #10 $finish;
end

endmodule
