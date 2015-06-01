`default_nettype none
`timescale 1ns/100ps

module Encoder (
	input wire 		 Reset,
	input wire       INTERCLK,  // Internal clock
	input wire [7:0] iData,     // Data input
	input wire       TXDATAK,   // 1 = control byte. 0 = data byte
	input wire       TXCOMP,    // 1 = running disparity negative. 0 = running disparity positive
	output reg [9:0] oData      // Data output
	);
		 
	//Input Separation
	wire A = iData[0]; //LSB
	wire B = iData[1];
	wire C = iData[2];
	wire D = iData[3];
	wire E = iData[4];
	wire F = iData[5];
	wire G = iData[6];
	wire H = iData[7]; //MSB
	
	wire K = TXDATAK; //Control character

	/*-----------------------------------------------------------------
							Combinational Section
						based on IBMs proposed solution 
	------------------------------------------------------------------*/	
	//Groupping input data for simulation control purposes
	wire [4:0] iS5; //5 bit data vector
	wire [2:0] iS3; //3 bit data vector
	assign iS5 = {E,D,C,B,A};
	assign iS3 = {H,G,F};
	
	//Lij, i is the number of 1s and j is the number of 0s present in ABC bits
	wire L03 = ~A & ~B & ~C;
	wire L30 = A & B & C;
	wire L12 = A & ~B & ~C | ~A & B & ~C | ~A & ~B & C;
	wire L21 = ~A & B & C | A & ~B & C | A & B & ~C;
	
	//Special case
	wire S = L21 & D & ~E & ~PBRD | L12 & ~D & E & PBRD;
	
	//-----------------------------------------------------------------
	
	//Generation of primary vectors from S6: abcdei
	wire a = A;
	wire b = B & ~(L30 & D) | L03 & ~D;
	wire c = C | L03 & (~D | E);
	wire d = D & ~(L30 & D);
	wire e = E & ~(L03 & D) | L12 & ~D & ~E | L03 & D & ~E ;
	//extra bit result from encoding
	wire i = L21 & ~D & ~E | L12 & ((D ^ E) | K)| L03 & ~D & E | L30 & D & E; 
	
	//Generation of primary vectors from S4: fghj
	wire f = F & ~(F & G & H & (S | K));
	wire g = G | ~F & ~H;
	wire h = H;
	//extra bit result from encoding
	wire j = (F ^ G) & ~H | F & G & H & (S | K);

	//-----------------------------------------------------------------
	
	//Required disparity
	//for 6 bit vector
	//RD6+, if asserted means data input requires positive disparity
	wire PDRS6 = L03 & (D | ~E) | L30 & D & ~E | L12 & ~D & ~E;
	//RD6-, if asserted means data input requires negative disparity
	wire NDRS6 = L30 & (~D | E) | L03 & ~D & E | L21 & D & E | K;
	/*If both are deasserted means there is no required disparity
	usually for balanced coded data*/	
	
	//Required disparity
	//for 4 bit vector
	//RD4+, if asserted means data input requires positive disparity
	wire PDRS4 = ~F & ~G |(F ^ G)& K;
	//RD4-, if asserted means data input requires negative disparity
	wire NDRS4 = F & G;
	/*If both are deasserted means there is no required disparity
	usually for balanced coded data */	
	
	//-----------------------------------------------------------------
	
	//Complement signals
	/*If the 6 bit coded input required disparity is the same as the previous 
	block required disparity, invert the input to guarantee a balanced 
	output.*/
	wire CMPLS6 = PBRD & PDRS6 | ~PBRD & NDRS6;
	
	//Exception for disparity rules: if input = D7.x and the 4 bit coded 
	//input has a non neutral required disparity
	wire DispException = L30 & ~D & ~E & (PDRS4 | NDRS4);
	
	/*Normal way of complementing S4: 0 for neutral, - for negative, + 
	for positive
	 _____________________
	 | PBRD | DRS6 | DRS4 |
	 |------|------|------|
	 |  -   |   0  |  -   |
	 |------|------|------|
	 |  -   |   -  |  +   |
	 |------|------|------|
	 |  -   |   +  |  +   |
	 |------|------|------|
	 |  +   |   0  |  +   |
	 |------|------|------|
	 |  +   |   -  |  -   |
	 |------|------|------|
	 |  +   |   +  |  -   |
	 ~~~~~~~~~~~~~~~~~~~~~~
	*/
	wire cmpls4 = ~PBRD &((~NDRS6 & ~PDRS6 & NDRS4) | ((NDRS6 | PDRS6) & PDRS4))| PBRD &((~NDRS6 & ~PDRS6 & PDRS4) | ((NDRS6 | PDRS6) & NDRS4));
	
	//Complement S4  if the disparity exception is different from the 
	//normal way  
	wire CMPLS4 = DispException ^ cmpls4;
	
	//If the S6 complement signal is asserted, invert the letter
	wire oa = CMPLS6 ^ a;
	wire ob = CMPLS6 ^ b;
	wire oc = CMPLS6 ^ c;
	wire od = CMPLS6 ^ d;
	wire oe = CMPLS6 ^ e;
	wire oi = CMPLS6 ^ i;
	
	//The 5 bit vector is encoded in a 6 bit vector
	wire [5:0] oS6;
	assign oS6  = {oa,ob,oc,od,oe,oi} ;
	
	//If the S4 complement signal is asserted, invert the letter
	wire of = CMPLS4 ^ f;
	wire og = CMPLS4 ^ g;
	wire oh = CMPLS4 ^ h;
	wire oj = CMPLS4 ^ j;
	
	//The 3 bit vector is encoded in a 4 bit vector
	wire [3:0] oS4;
	assign oS4 = {of,og,oh,oj};
	
	//Output 10 bit coded vector
	wire [9:0] S10; 
	assign S10 = {oS6,oS4};
	
	//Force complementation
	wire [9:0] oS10; 
	assign oS10 = (TXCOMP)? ~S10:S10;

/*----------------------------------------------------------------------
					Sequential section
----------------------------------------------------------------------*/
	
	
	//Previous Block Required Disparity
	reg PBRD;
	//Current Block Required Disparity
	reg CBRD;

//---------------------------------------------------------------------//
	always @(posedge INTERCLK)
	begin
		//Update previous block required disparity
		PBRD <= CBRD;
		
		if(~Reset)
		begin
			//Update the final 10 bit encoded Data vector
			oData <= oS10;
		end
		
		//------------------------------------------------------------//
		
		else
		begin
			//Output reset
			oData <= 10'b0;
			//Starting previous required disparity
			CBRD <= 0; //negative

		end
	end
//--------------------------------------------------------------------//	

	always @(negedge INTERCLK)
	begin
		if(~Reset)
		begin
			//If the required disparity of both 4 and 6 bit coded inputs 
			//are neutral,... 
			if (PDRS4 == NDRS4 && PDRS6 == NDRS6)
			begin
				//...the current block required disparity remains the 
				//same 
				CBRD <= CBRD;
			end
			
			//---------------------------------//
			
			//else...
			else 
			begin
				//...the current block required disparity must be the opposite 
				//of the previous one 
				CBRD <= ~PBRD;
			end
		end
		
		//------------------------------------------------------------//
		
		else
		begin
			//Output reset
			oData <= 10'b0;
			//Starting previous required disparity
			CBRD <= 0; //negative

		end
	end
	 
endmodule


module decoder(
	input wire       INTERCLK,         // Internal clock
	input wire [9:0] iData,            // Data input
	output reg       DECODE_ERROR,     // Report a decode error
	output reg       DISPARITY_ERROR,  // Report a disparity error
	output reg       RXDATAK,          // 0 = data byte, 1 = control byte. Check this out please!!
	output reg [7:0] oData             // Data output
);

endmodule
