// El proceso de codificación (encoder module) puede tomar más de un ciclo, pero no el de decodificación (decoder module)

`default_nettype none
`timescale 1ns/100ps

module encoder (
	input wire       Reset,
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
	wire S = L21 & D & ~E & PDFS6 | L12 & ~D & E & NDFS6;
	
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
	/*If the input required disparity is the same as the previous 
	required disparity, invert the input to guarantee a balanced 
	output.*/
	wire CMPLS6 = PDFS4 & PDRS6 | NDFS4 & NDRS6;
	wire CMPLS4 = (PDFS6 & PDRS4 | NDFS6 & NDRS4)& ~CMPLS6;
	
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

/*----------------------------------------------------------------------
					Sequential section
----------------------------------------------------------------------*/
	
	
	//Previous Required Disparity
	//for S4
	reg PDFS4; //positive (disparity in front of S4)
	reg NDFS4; //negative (disparity in front of S4)
	//for S6
	reg PDFS6; //positive (disparity in front of S6)
	reg NDFS6; //negative (disparity in front of S6)
//---------------------------------------------------------------------//
	always @(posedge INTERCLK)
	begin
		if(~Reset)
		begin
			//Update the final 10 bit encoded Data vector
			oData <= {oS6,oS4};
			
			//If the required disparity of the 4 bit coded input is neutral,... 
			if (PDRS4 == NDRS4)
			begin
				/*...the previous required disparity seen by the 6 bit vector 
				remains the same */
				PDFS6 <= PDFS6;
				NDFS6 <= NDFS6;
			end
			
			//---------------------------------//
			
			//else...
			else 
			begin
				/* The 4 bit vector required disparity is now the previous 
				disparity seen by the 6 bit vector */
				PDFS6 <= PDRS4;
				NDFS6 <= NDRS4;
			end
		end
		
		//------------------------------------------------------------//
		
		else
		begin
			//Output reset
			oData <= 10'b0;
			//Starting previous required disparity
			PDFS6 <= 0;
			PDFS4 <= 0;
			NDFS6 <= 1;
			NDFS4 <= 1;
		end
	end
//--------------------------------------------------------------------//	
	always @(negedge INTERCLK)
	begin
		if(~Reset)
		begin
			//If the required disparity of the 6 bit coded input is neutral,... 
			if (PDRS6 == NDRS6)
			begin
				//...the previous required disparity seen by the 4 bit vector 
				//remains the same
				PDFS4 <= PDFS4;
				NDFS4 <= NDFS4;
			end
			
			//---------------------------------//
			
			else 
			begin
				// The 6 bit vector required disparity is now the previous 
				// disparity seen by the 4 bit vector
				PDFS4 <= PDRS6;
				NDFS4 <= NDRS6;
			end
		end	
		
		//------------------------------------------------------------//
			
		else
		begin
			//Output reset
			oData <= 10'b0;
			//Starting previous required disparity
			PDFS6 <= 0;
			PDFS4 <= 0;
			NDFS6 <= 1;
			NDFS4 <= 1;
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
