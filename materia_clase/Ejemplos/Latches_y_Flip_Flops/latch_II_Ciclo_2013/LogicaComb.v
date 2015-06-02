`include "Globales.v"

module LogicaComb (
	input iSignal,
	output oNSignal
);

  not #`Tlc (oNSignal, iSignal);

endmodule
