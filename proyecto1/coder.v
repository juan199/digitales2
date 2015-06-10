`default_nettype none
`timescale 1ns/100ps

module encoder (
	input wire 		 Reset,
	input wire       INTERCLK,  // Internal clock
	input wire [7:0] iData,     // Data input
	input wire       TXDATAK,   // 1 = control byte. 0 = data byte
	input wire       TXCOMP,    // 1 = SET running disparity negative. 0 = nothing happens
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
	
	//Exception for disparity rules: if input = D7.x, and the 4 bit coded 
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
		if (TXCOMP)
			PBRD <= 1; //Set negative CBRD 	
		else
			PBRD <= CBRD; //Normal case
			
		if(~Reset)
		begin
			//Update the final 10 bit encoded Data vector
			oData <= S10;
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
	output reg       RXDATAK,          // 0 = data byte, 1 = control byte
	output reg [7:0] oData             // Data output
);
	//Coded vector R6 
	wire a = iData[9];
	wire b = iData[8];
	wire c = iData[7];
	wire d = iData[6];
	wire e = iData[5];
	wire i = iData[4];
	
	//Coded vector R4
	wire f = iData[3];
	wire g = iData[2];
	wire h = iData[1];
	wire j = iData[0];
	
	wire P40 = a & b & c & d;
	wire P04 = ~a & ~b & ~c & ~d;
	wire P3X = a & b & c | a & b & d | a & c & d | b & c & d;
	wire PX3 = ~a & ~b & ~c | ~a & ~b & ~d | ~a & ~c & ~d | ~b & ~c & ~d;
	wire P22 = ~P3X & ~PX3;
	
	wire P2X = a & b | a & c | b & c;
	wire PX2 = ~a & ~b | ~a & ~c | ~b & ~c;
	
	//Calculating A
	wire n8 = ~a | ~b;
	wire n0 = ~c & d & (e==i) & n8;
	wire n1 = PX3 & (d & i | ~e);
	wire n2 = a & b & e & i | ~c & ~d & ~e & ~i;
	wire CMPLa = n0 | n1 | P3X & i | n2;
	
	//Calculating B
	wire n3 = c & ~d & (e==i) & (a!=b);
	wire CMPLb = n3 | n1 | P3X & i | n2;
	
	//Calculating C
	wire n4 = ~a & b & (c!=d) & (e==i);
	wire n5 = ~e & ~i &(~a & ~b | ~c & ~d);
	wire CMPLc = n4 | n1 | P3X & i | n5;
	
	//Calculating D
	wire n6 = a & ~b & (c!=d) & (e==i);
	wire CMPLd = n6 | n1 | P3X & i | n2;
	
	//Calculating E
	wire n7 = PX3 & (~e | ~i);
	wire CMPLe = n0 | n7 | n5;
	
	//Calculating F
	wire m0 = (f!=g) & h & j;
	wire m7 = ~c & ~d & ~e & ~i & (h!=j);
	wire CMPLf = m0 | (f==g) & j | m7;
	
	//Calculating G
	wire CMPLg = (f!=g) & ~h & ~j | (f==g) & j | m7;
	
	//Calculating H
	wire m2 = f & ~g & (h==j);
	wire CMPLh = m2 | (f==g) & j | m7;
	
	//Complement each input letter if required	
	wire A = a^CMPLa;
	wire B = b^CMPLb;
	wire C = c^CMPLc;
	wire D = d^CMPLd;
	wire E = e^CMPLe;
	
	wire F = f^CMPLf;
	wire G = g^CMPLg;
	wire H = h^CMPLh;
	
	//Control bit K
	wire m10 =i & g & h & j | ~i & ~g & ~h & ~j;
	wire k28 = c & d & e & i | ~c & ~d & ~e & ~i;
	wire kx7 = (e!=i) & m10;
	wire K = k28 | kx7;
	 
	//Invalid Vectors
	wire m5 = k28 & (f & g & h | ~f & ~g & ~h);
	wire m6 = ~k28 & (g & h & j & ~i | ~g & ~h & ~j & i);
	wire m3 = f & g & h & j | ~f & ~g & ~h & ~j;
	wire m4 = e & i & f & g & h | ~e & ~i & ~f & ~g & ~h;
	
	wire VKX7 = m10 & (e^i) & P22; 
	wire INVR6 = P40 | P04 | P3X & e & i | PX3 & ~e & ~i;
	wire INVR4 = m3 | m4 | m5 | m6;
	
	wire DecError = VKX7 | INVR4 | INVR6;//////////////////------------------------------------------
	
	//Input Required Disparity
	wire PDRR4 = ~f & ~g | (f^g) & ~h & ~j;
	wire NDRR4 = f & g | m0;
	
	wire PDRR6 = PX3 & (~e | ~i) | ~a & ~b & ~c | ~e & ~i &(PX2 | ~d & ~(a & b & c));
	wire NDRR6 = P3X & (e | i) | a & b & c | e & i & (P2X | d & (a | b | c));
	
	//Assumed disparity
	wire PDUR4 = h & j | f & g &(h^j);
	wire NDUR4 = ~h & ~j | ~f & ~g &(h^j);
	
	wire PDUR6 = P3X & (e | i) | e & i & (d | P2X);
	wire NDUR6 = PX3 & (~e | ~i) | ~e & ~i & (~d | PX2);
	
	//Previous Block Running Disparity
	reg PDFBY;
	reg NDFBY;
	
	//Disparity Violation
	wire DVBY = NDFBY & (PDRR6 | PDRR4 & ~NDRR6) + PDFBY & (NDRR6 | NDRR4 & ~PDRR6);
	
	//If there is a decode error the output should be a K30.7
	wire [8:0] out;
	assign out = (DecError)? {1'b1,3'd7,5'd30}:{K,H,G,F,E,D,C,B,A};
	
	//Current Block Running Disparity
	//Remember!!!: This is running disparity, not required running disparity as in inputs
	wire [1:0] CBRD;
	assign CBRD [1] = NDRR6 | ~PDRR6 & ~NDRR6 & NDRR4; 
	assign CBRD [0] = PDRR6 | ~PDRR6 & ~NDRR6 & PDRR4 ;///////////!!!!!!!!!!! maybe Missing disparity rule exceptions
	
	//Sequential block
	always @(posedge INTERCLK)
	begin
		PDFBY <= CBRD [1];
		NDFBY <= CBRD [0];
		oData <= out[7:0];
		RXDATAK <= out[8];
		DECODE_ERROR <= DecError;
		DISPARITY_ERROR <= DVBY;
	end
	
endmodule
