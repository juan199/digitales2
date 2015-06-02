module probador (S1,S2,S3,S4,S1e,S2e,S3e,S4e,E1,E2,E3,E4);
	output E1,E2,E3,E4;
	input S1,S2,S3,S4,S1e,S2e,S3e,S4e;
	reg E1,E2,E3,E4;
	initial
	  begin
	    $monitor($time ,,,"E1 =%b E2 =%b E3 =%b E4 =%b S1= %b, S2 = %b, S3 = %b, S4 = %b S1e= %b, S2e = %b, S3e = %b, S4e = %b",
		E1,E2,E3,E4,S1,S2,S3,S4,S1e,S2e,S3e,S4e);
		$dumpfile("resultado.vcd");
		$dumpvars;
		{E1,E2,E3,E4} = 4'b0000;
	#10 {E1,E2,E3,E4} = 4'b0001;
	#10 {E1,E2,E3,E4} = 4'b0010;
	#10 {E1,E2,E3,E4} = 4'b0011;
	#10 {E1,E2,E3,E4} = 4'b0100;
	#10 {E1,E2,E3,E4} = 4'b0101;
	#10 {E1,E2,E3,E4} = 4'b0110;
	#10 {E1,E2,E3,E4} = 4'b0111;
	#10 {E1,E2,E3,E4} = 4'b1000;
	#10 {E1,E2,E3,E4} = 4'b1001;
	#10 {E1,E2,E3,E4} = 4'b1010;
	#10 {E1,E2,E3,E4} = 4'b1011;
	#10 {E1,E2,E3,E4} = 4'b1100;
	#10 {E1,E2,E3,E4} = 4'b1101;
	#10 {E1,E2,E3,E4} = 4'b1110;
	#10 {E1,E2,E3,E4} = 4'b1111;
	  end
endmodule