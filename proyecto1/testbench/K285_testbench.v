module testbench;

reg [9:0] INP;
wire SCLK;
wire RX;
wire CLK;
reg reset;

clock CLK1(CLK);
K285 test(CLK, INP, reset, SCLK, RX);

integer i;
   
initial
begin

	$dumpfile("K285_dump.vco");
	$dumpvars;

    #1 reset =1;
     #15 reset =0; 
	#1	INP = 10'd35;
	#100 INP = 10'd245;
	

		for(i = 0; i < 1000; i = i+1)
		begin 
		#7 INP = INP +1;
		end
		
    
   #1000 $finish;
end

endmodule
