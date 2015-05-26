`default_nettype none
`timescale 1ns/100ps

module testbench;
	reg clock, data_in, t_order_idle, detect_r;
	wire detect_answer, p_line, n_line, detected_t_idle, data_out;
	
	TX_I_O trans( .TRANSCLK(clock),
	              .data(data_in),
	              .TXIDLE(t_order_idle),
	              .RXDET(detect_r),
	              .RXDET_O(detect_answer),
	              .TX_P(p_line),
	              .TX_N(n_line)
    );
    
    RX_I_O rec( .RX_P(p_line),
	            .RX_N(n_line),
	            .RXIDLE(detected_t_idle),
	            .data_out(data_out)
    );
	
	// clock bussines
	initial clock <= 1'b0;	
	always
		#5 clock = ~clock;
		
	// Testbench
	always @ (negedge clock)
		data_in = $random;
	
	initial
		begin
		$dumpfile("XI_O_dump.vco");
		$dumpvars;
		
		t_order_idle <= 1'b0;
		detect_r <= 1'b0;
		
		#100 t_order_idle <= 1'b1;
		#50  t_order_idle <= 1'b0;
		#50  detect_r <= 1'b1;
		#20  detect_r <= 1'b0;
		
		#400 $finish;
		end

endmodule
