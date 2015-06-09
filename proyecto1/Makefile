encoder:
	iverilog coder.v testbench/Encoder_Testbench.v -o encoder.vvp
	vvp encoder.vvp
	gtkwave testbench/encoder_wave.gtkw &
	
serdes:
	iverilog serdes.v power_manager.v testbench/serdes_testbench.v -o serdes.vvp
	vvp serdes.vvp
	gtkwave testbench/serdes_wave.gtkw &
	
electrical:
	iverilog components.v testbench/XI_O.v -o electrical.vvp
	vvp electrical.vvp
	gtkwave testbench/electrical_wave.gtkw &
	
K285:
	iverilog components.v power_manager.v K285.v testbench/K285_testbench.v -o K285.vvp
	vvp K285.vvp
transmitter:
	iverilog components.v coder.v serdes.v power_manager.v transmitter.v testbench/transmitter_testbench.v -o transmitter.vvp
	vvp transmitter.vvp
	gtkwave testbench/transmitter_wave.gtkw &
	
clock_recovery:
	iverilog clock_recovery.v power_manager.v testbench/clock_recovery_testbench.v -o clock_recovery.vvp
	
clean:
	rm *.vvp
	rm *.vco
