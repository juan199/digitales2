
module test;
	reg Reset;
	reg Clk;
	reg [2:0] S3;
	reg [4:0] S5;
	reg k;
	reg TXCOMP;
	wire [7:0] Data;
	wire [9:0] EncData;
	
	assign Data = {S3,S5};
	//Instantiate unit under test
	encoder  Enc(
		.Reset(Reset),
		.INTERCLK(Clk),
		.iData(Data),
		.TXDATAK(k),
		.TXCOMP(TXCOMP),
		.oData(EncData)
	);
	
	initial
	begin
		Clk = 0;
		k = 1;
		S3 = 0;
		S5 = 0;
		TXCOMP = 0;
		Reset = 0;
		$dumpfile("encoder_dump.vco");
		$dumpvars;
		#4 Reset = 1;
		#6 Reset = 0;
		
		//Special Character Symbol Code Test
		//K28.0
		S3 = 0;
		S5 = 28;
		//K28.x
		#8 S3 = 1;
		#8 S3 = 2;
		#8 S3 = 3;
		#8 S3 = 4;
		TXCOMP = 1;
		#4 TXCOMP = 0;
		#4 S3 = 5;
		#8 S3 = 6;
		#8 S3 = 7;
		//K23.7
		#8 S5 = 23;
		//K27.7
		#8 S5 = 27;
		//K29.7
		#8 S5 = 29;
		//K30.7
		#8 S5 = 30;
		
		//Data Tests
		#8 k = 0; 
		
		//Test Dx.7
		//characters calculated with "S"
		S5 = 11;
		#8 S5 = 13;
		#8 S5 = 14;
		#8 S5 = 17;
		#8 S5 = 18;
		#8 S5 = 20;
		
		//some data
		#8 S5 = 21;
		#8 S5 = 22;
		#8 S5 = 23;
		#8 S5 = 24;
		#8 S5 = 25;
		#8 S5 = 26;
		#8 S5 = 27;
		#8 S5 = 28;
		#8 S5 = 29;
		#8 S5 = 30;
		#8 S5 = 31;
		
		//Test disparity exceptions D7.0, D7.3, D7.4, D7.7
		#8 S5 = 7;
		S3 = 0;
		#8 S3 = 3;
		#8 S3 = 4;
		#8 S3 = 7;
		#8;
		
        $finish;
	end
	always 
	begin
		#2 Clk = ~Clk; //250 MHz 
	end
endmodule

