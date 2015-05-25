serdes:
	iverilog serdes.v power_manager.v testbench/serdes_testbench.v -o serdes.vvp
	vvp serdes.vvp
	gtkwave testbench/serdes_wave.gtkw &
	
clean:
	rm *.vvp
	rm *.vco
