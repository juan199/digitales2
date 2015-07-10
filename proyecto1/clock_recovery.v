`default_nettype none
`timescale 1ns/1ps

module clock_recovery # ( parameter T = 10) (
	input wire data,
	output reg CRC_CLK
);

	wire up, down; 
	real V_ctrl, error, error_before, integral;
	real up_time, down_time;
	
	initial
		begin
		CRC_CLK = 0;	
		V_ctrl = 0;
		error = 0;
		error_before = 0;
		integral = 0;
		end
	
	phase_detector ph_d(
		.ref_clk(data),
		.vco_clk(CRC_CLK),
		.up(up),
		.down(down)
	);
	
	
	/* Controlador */
	
	// Calculo del error
	always @ (up)
		begin
		if(up)
			up_time = $realtime;
		else
			begin
			up_time = $realtime - up_time;
			if(up_time > 0)
				error = up_time/T;
			end
		end
	
	always @ (down)
		begin
		if(down)
			down_time = $realtime;
		else
			begin
			down_time = $realtime - down_time;
			if(down_time > 0)
				error = -down_time/T;
			end
		end
	
	// Controlador PI
	always
		begin
		#(T/10);
		integral = 0.5*(T/10)*(error + error_before);
		//~ integral = 0.5*(T/10)*(error); // Para ser solo P
		V_ctrl = T*(error + integral);
		error_before = error;
		end
	
	// Voltage controlled oscilator
	always
		begin
		#( (T + V_ctrl)/2 ) CRC_CLK <= ~CRC_CLK;
		end
		
endmodule

module phase_detector(
	input wire  ref_clk,
	input wire  vco_clk,
	output wire up,
	output wire down
);
	wire rst;
	assign rst = up & down;
		
	ffd_rst internal_ff(
		.D(1'b1),
		.clk(vco_clk),
		.rst(rst),
		.Q(up)
	);

	ffd_rst external_ff(
		.D(1'b1),
		.clk(ref_clk),
		.rst(rst),
		.Q(down)
	);
endmodule

module ffd_rst(
	input wire D,
	input wire clk,
	input wire rst,
	output reg Q
);
	initial 
		Q <= 1'b0;
		
	always @ (posedge clk or posedge rst)
		begin
			if(rst)
				Q <= 1'b0;
			else
				Q <= D;
		end	
endmodule
