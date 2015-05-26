serdes:
	iverilog serdes.v power_manager.v testbench/serdes_testbench.v -o serdes.vvp
	vvp serdes.vvp
	gtkwave testbench/serdes_wave.gtkw &
	
electrical:
	iverilog components.v testbench/XI_O.v -o electrical.vvp
	vvp electrical.vvp
	gtkwave testbench/electrical_wave.gtkw &
	
clean:
	rm *.vvp
	rm *.vco
