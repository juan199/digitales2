
module test;
	reg Reset;
	reg Clk;
	reg [2:0] S3;
	reg [4:0] S5;
	reg k;
	reg TXCOMP;
	wire [7:0] Data;
	wire [9:0] EncData;
	wire [7:0] DecData;
	wire DecK;
	wire DispErr;
	wire DecErr;
	
	wire [7:0] verifier;
	
	assign verifier = Data - DecData -1;
	
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
	decoder Dec(
		.INTERCLK(Clk),        
		.iData(EncData),            
		.DECODE_ERROR(DecErr),     
		.DISPARITY_ERROR(DispErr), 
		.RXDATAK(DecK), 
		.oData(DecData)  
	);
	
	initial
	begin
		Clk = 0;
		k = 0;
		S3 = 7;
		S5 = 31;
		TXCOMP = 0;
		Reset = 1;
		$dumpfile("decoder_dump.vco");
		$dumpvars;
		#4 Reset = 0;
		#22
		TXCOMP = 1;
		#4 TXCOMP = 0;
		#2046 k=1;
		
		#2100;
		
        $finish;
	end
	always 
	begin
		#2 Clk = ~Clk; //250 MHz 
	end
	always 
	begin
		#2 S3 = S3+1;
		#254; 
	end
	always 
	begin
		#2 S5 = S5+1;
		#6; 
	end
endmodule
