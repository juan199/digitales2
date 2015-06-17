module test;

	wire SKP_ADDED;
	wire SKP_REMOVED;
	wire RXDET_O;
	wire DECODE_ERROR;
	wire BUFF_OVERFLOW;
	wire BUFF_UNDERFLOW;
	wire DISPARITY_ERROR;
	
	/*reg SKP_ADDED;
	reg SKP_REMOVED;
	reg RXDET_O;
	reg DECODE_ERROR;
	reg BUFF_OVERFLOW;
	reg BUFF_UNDERFLOW;
	reg DISPARITY_ERROR;*/
	wire [2:0] RXSTATUS;
	
	reg [6:0] Input;
	assign {SKP_ADDED,SKP_REMOVED,RXDET_O,DECODE_ERROR,BUFF_OVERFLOW,BUFF_UNDERFLOW,DISPARITY_ERROR} = Input;	
	
	status stat(	
		.SKP_ADDED(SKP_ADDED),
		.SKP_REMOVED(SKP_REMOVED),
		.RXDET_O(RXDET_O),
		.DECODE_ERROR(DECODE_ERROR),
		.BUFF_OVERFLOW(BUFF_OVERFLOW),
		.BUFF_UNDERFLOW(BUFF_UNDERFLOW),
		.DISPARITY_ERROR(DISPARITY_ERROR),
		.RXSTATUS(RXSTATUS)
	);

	initial
	begin
		Input = 7'b0;
		$dumpfile("status_dump.vco");
		$dumpvars;
		/*#2 Input = 1;
		#2 Input = 0;
		#2 Input = 2;
		#2 Input = 0;
		#2 Input = 3;
		#2 Input = 0;
		#2 Input = 4;
		#2 Input = 0;
		#2 Input = 5;
		#2 Input = 0;
		#2 Input = 6;
		#2 Input = 0;
		#2 Input = 7;
		#2 Input = 0;
		#2 */
		#3000
        $finish;
	end
	always
		#2 Input = Input +1;
endmodule
