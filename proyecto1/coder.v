// El proceso de codificación (encoder module) puede tomar más de un ciclo, pero no el de decodificación (decoder module)

module encoder(
	input wire       INTERCLK,  // Internal clock
	input wire [7:0] iData,     // Data input
	input wire       TXDATAK,   // 1 = data byte. 0 = control byte, do not scramble!
	input wire       TXCOMP,    // 1 = running disparity negative. 0 = running disparity positive
	output reg [9:0] oData      // Data output
);


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
