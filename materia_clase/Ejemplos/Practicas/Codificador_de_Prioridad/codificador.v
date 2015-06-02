module codificador(S1,S2,S3,S4,E1,E2,E3,E4);
	input E1,E2,E3,E4;
	output S1,S2,S3,S4;
	reg S1,S2,S3,S4;
	
	always @(E1,E2,E3,E4)
		begin
		{S1,S2,S3,S4} = 4'b0000;
		if(E1) S1 = 1;
		if(E2 & ~E1) S2 = 1;
		if(E3 & ~E1 & ~E2) S3 = 1;
		if(E4 & ~E1 & ~E2 & ~E3) S4 = 1;
	end
endmodule