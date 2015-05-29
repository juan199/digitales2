module test;
	reg Reset;
	reg Clk;
	reg [7:0] Data;
	reg k;
	reg TXCOMP;
	wire [9:0] EncData;
	wire [9:0] oROM;
	wire [9:0] wCompare;
	wire [3:0] wPolarity;
	wire [1:0] wBalanced;
	Encoder  Enc(
		.Reset(Reset),
		.INTERCLK(Clk),
		.iData(Data),
		.TXDATAK(k),
		.TXCOMP(TXCOMP),
		.oData(EncData)
	);
	
	ROM rom(
		.iClk(Clk),
		.iData(Data),
		.ik(k),
		.oS10Encoding(oROM),
		.oPolarity(wPolarity),
		.oBalanced(wBalanced)
	);
	
	Verifier ver(
	.iRom(oROM),
	.iEnc(EncData),
	.oCompare(wCompare)
	);
	initial
	begin
		Clk = 0;
		k = 1;
		Data = 0;
		TXCOMP = 0;
		Reset = 0;
		$dumpfile("senales.vcd");
		$dumpvars;
		#4 Reset = 1;
		#6 Reset = 0;
		#2000;
        $finish;
	end
	always 
	begin
		#2 Clk = ~Clk; //250 MHz 
	end
	always 
	begin
		#2 Data = Data+1; 
		#2; 
	end
endmodule
module ROM(
	input wire iClk,
	input wire [7:0] iData,
	input wire ik,
	output reg [9:0] oS10Encoding,
	output reg [3:0] oPolarity,
	output reg [1:0] oBalanced
	);
	wire [4:0] S5;
	wire [2:0] S3;
	assign S3 = iData[7:5];
	assign S5 = iData[4:0];
	reg [9:0] S6Encoding;
	reg [7:0] S4EncodingD;
	reg [7:0] S4EncodingK;
	
	// Special case K28 and D28 have different encoding
	wire [9:0] DorK28;
	assign DorK28 = (ik==1'b0)? { 6'b001110,1'b0,`NEU,1'b0}:{ 6'b001111,1'b1,`NEG,1'b1};
		
	//special case Dx.A7 or Dx.P7
	reg [3:0] Dx7;
		
	// 5B/6B Data and Instruction LUT	
	always @ ( S5 )
	begin
	
		if(S5 == 5'd11 || S5 == 5'd13 || S5 == 5'd14 || S5 == 5'd17 || S5 == 5'd18 || S5 == 5'd20)
			Dx7 =4'b0111;
		else
			Dx7 = 4'b1110;
			
		case (S5)
		//Encoded vector, Invertible, Required disparity, Unbalanced vector(1=yes)					
		5'd0: S6Encoding = { 6'b011000,1'b1,`POS,1'b1};
		5'd1: S6Encoding = { 6'b100010,1'b1,`POS,1'b1};
		5'd2: S6Encoding = { 6'b010010,1'b1,`POS,1'b1};
		5'd3: S6Encoding = { 6'b110001,1'b0,`NEU,1'b0};
		5'd4: S6Encoding = { 6'b001010,1'b1,`POS,1'b1};
		5'd5: S6Encoding = { 6'b101001,1'b0,`NEU,1'b0};
		5'd6: S6Encoding = { 6'b011001,1'b0,`NEU,1'b0};	
		5'd7: S6Encoding = { 6'b111000,1'b1,`NEG,1'b0};	

		5'd8:  S6Encoding = { 6'b000110,1'b1,`POS,1'b1}; 
		5'd9:  S6Encoding = { 6'b100101,1'b0,`NEU,1'b0}; 
		5'd10: S6Encoding = { 6'b010101,1'b0,`NEU,1'b0};
		5'd11: S6Encoding = { 6'b110100,1'b0,`NEU,1'b0};	
		5'd12: S6Encoding = { 6'b001101,1'b0,`NEU,1'b0}; 
		5'd13: S6Encoding = { 6'b101100,1'b0,`NEU,1'b0};
		5'd14: S6Encoding = { 6'b011100,1'b0,`NEU,1'b0};
		5'd15: S6Encoding = { 6'b101000,1'b1,`POS,1'b1};
		
		5'd16: S6Encoding = { 6'b011011,1'b1,`NEG,1'b1};
		5'd17: S6Encoding = { 6'b100011,1'b0,`NEU,1'b0};
		5'd18: S6Encoding = { 6'b010011,1'b0,`NEU,1'b0};
		5'd19: S6Encoding = { 6'b110010,1'b0,`NEU,1'b0};
		5'd20: S6Encoding = { 6'b001011,1'b0,`NEU,1'b0};
		5'd21: S6Encoding = { 6'b101010,1'b0,`NEU,1'b0};
		5'd22: S6Encoding = { 6'b011010,1'b0,`NEU,1'b0};
		5'd23: S6Encoding = { 6'b111010,1'b1,`NEG,1'b1};
		
		5'd24: S6Encoding = { 6'b001100,1'b1,`POS,1'b1};
		5'd25: S6Encoding = { 6'b100110,1'b0,`NEU,1'b0}; 
		5'd26: S6Encoding = { 6'b010110,1'b0,`NEU,1'b0}; 
		5'd27: S6Encoding = { 6'b110110,1'b1,`NEG,1'b1}; 
		5'd28: S6Encoding = {DorK28}; // Special case K28 and D28 have different encoding
		5'd29: S6Encoding = { 6'b101110,1'b1,`NEG,1'b1};
		5'd30: S6Encoding = { 6'b011110,1'b1,`NEG,1'b1};
		5'd31: S6Encoding = { 6'b101011,1'b1,`NEG,1'b1};

		default:
			S6Encoding = {10'b0000000000};		
		endcase	
	end
	
	
	
	
	// 3B/4B Data LUT
	always @ ( S3 )
	begin
		case (S3)
		//Encoded vector, Invertible, Required disparity, Unbalanced vector(1=yes)
		3'd0: S4EncodingD = {4'b0100,1'b0,`POS, 1'b1}; 
		3'd1: S4EncodingD = {4'b1001,1'b0,`NEU, 1'b0};
		3'd2: S4EncodingD = {4'b0101,1'b0,`NEU, 1'b0};
		3'd3: S4EncodingD = {4'b1100,1'b1,`NEG, 1'b0};
		3'd4: S4EncodingD = {4'b0010,1'b1,`POS, 1'b1};
		3'd5: S4EncodingD = {4'b1010,1'b0,`NEU, 1'b0};
		3'd6: S4EncodingD = {4'b0110,1'b0,`NEU, 1'b0};
		3'd7: S4EncodingD = {Dx7,1'b1,`NEG, 1'b1}; //special case Dx.A7 or Dx.P7
		
		default:
			S4EncodingD = {8'b00000000};	
		endcase	
	end
	
	// 3B/4B Instruction LUT
	always @ ( S3 )
	begin
		case (S3)
		//Encoded vector, Invertible, Required disparity, Unbalanced vector(1=yes)
		3'd0: S4EncodingK = {4'b0100,1'b0,`POS, 1'b1}; 
		3'd1: S4EncodingK = {4'b1001,1'b1,`POS, 1'b0};
		3'd2: S4EncodingK = {4'b0101,1'b1,`POS, 1'b0};
		3'd3: S4EncodingK = {4'b1100,1'b1,`NEG, 1'b0};
		3'd4: S4EncodingK = {4'b0010,1'b1,`POS, 1'b1};
		3'd5: S4EncodingK = {4'b1010,1'b1,`POS, 1'b0};
		3'd6: S4EncodingK = {4'b0110,1'b1,`POS, 1'b0};
		3'd7: S4EncodingK = {4'b0111,1'b1,`NEG, 1'b1}; //special case Dx.A7 or Dx.P7
		
		default:
			S4EncodingK = {8'b00000000};	
		endcase	
	end
	
	//Read from different LUT depending if its data or instruction	
	wire [7:0] S4Encoding;
	assign S4Encoding = (ik == 1'b1)? S4EncodingK:S4EncodingD;
	
	wire [1:0] wPolarityS6; 
	assign wPolarityS6 = S6Encoding[2:1];
	wire [1:0] wPolarityS4; 
	assign wPolarityS4 = S4Encoding[2:1];
	
	wire wBalancedS6; 
	assign wBalancedS6 = S6Encoding[0];
	wire wBalancedS4; 
	assign wBalancedS4 = S4Encoding[0];
	
	always @(posedge iClk)
	begin
		oS10Encoding = {S6Encoding[9:4],S4Encoding[7:4]};
		oPolarity = {wPolarityS6,wPolarityS4};
		oBalanced = {wBalancedS6,wBalancedS4};
	end

	
endmodule
module Verifier(
	input wire [9:0] iRom,
	input wire [9:0] iEnc,
	output wire [9:0] oCompare
	);
	assign oCompare = iEnc -iRom;
	
endmodule
