////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2006 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: I.32
//  \   \         Application: netgen
//  /   /         Filename: chip_root.v
// /___/   /\     Timestamp: Mon Jul 31 19:40:40 2006
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -ofmt verilog -log ngd2ver.log chip.ngd chip_root.v 
// Device	: 2s15vq100
// Input file	: chip.ngd
// Output file	: chip_root.v
// # of Modules	: 1
// Design Name	: contador_chip
// Xilinx        : c:\Xilinx
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Development System Reference Guide, Chapter 23
//     Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module contador_chip (
  reset, clk, q
);
  input reset;
  input clk;
  output [7 : 0] q;
  wire N0;
  wire N1;
  wire N2;
  wire N3;
  wire N4;
  wire N5;
  wire N6;
  wire N7;
  wire N8;
  wire N9;
  wire N10;
  wire N11;
  wire N12;
  wire N13;
  wire N14;
  wire N15;
  wire N16;
  wire N17;
  wire N18;
  wire N19;
  wire N20;
  wire N21;
  wire N22;
  wire N23;
  wire N24;
  wire N25;
  wire N26;
  wire N27;
  wire N28;
  wire N29;
  wire N30;
  wire N31;
  wire N32;
  wire N33;
  wire N35;
  wire N37;
  wire N39;
  wire N41;
  wire N43;
  wire N45;
  wire N47;
  wire N49;
  wire N51;
  wire \U51/O ;
  wire \U48/O ;
  wire \U45/O ;
  wire \U42/O ;
  wire \U39/O ;
  wire \U36/O ;
  wire \U32/O ;
  wire VCC;
  wire GND;
  X_ZERO U61 (
    .O(N0)
  );
  X_ZERO U60 (
    .O(N3)
  );
  X_ZERO U59 (
    .O(N6)
  );
  X_ZERO U58 (
    .O(N9)
  );
  X_ZERO U57 (
    .O(N12)
  );
  X_ZERO U56 (
    .O(N15)
  );
  X_ZERO U55 (
    .O(N18)
  );
  X_ONE U54 (
    .O(N21)
  );
  X_XOR2 U53 (
    .I0(N2),
    .I1(N1),
    .O(N24)
  );
  defparam U52.INIT = 4'h6;
  X_LUT2 U52 (
    .ADR0(N35),
    .ADR1(N0),
    .O(N1)
  );
  X_XOR2 U50 (
    .I0(N5),
    .I1(N4),
    .O(N25)
  );
  defparam U49.INIT = 4'h6;
  X_LUT2 U49 (
    .ADR0(N37),
    .ADR1(N3),
    .O(N4)
  );
  X_XOR2 U47 (
    .I0(N8),
    .I1(N7),
    .O(N26)
  );
  defparam U46.INIT = 4'h6;
  X_LUT2 U46 (
    .ADR0(N39),
    .ADR1(N6),
    .O(N7)
  );
  X_XOR2 U44 (
    .I0(N11),
    .I1(N10),
    .O(N27)
  );
  defparam U43.INIT = 4'h6;
  X_LUT2 U43 (
    .ADR0(N41),
    .ADR1(N9),
    .O(N10)
  );
  X_XOR2 U41 (
    .I0(N14),
    .I1(N13),
    .O(N28)
  );
  defparam U40.INIT = 4'h6;
  X_LUT2 U40 (
    .ADR0(N43),
    .ADR1(N12),
    .O(N13)
  );
  X_XOR2 U38 (
    .I0(N17),
    .I1(N16),
    .O(N29)
  );
  defparam U37.INIT = 4'h6;
  X_LUT2 U37 (
    .ADR0(N45),
    .ADR1(N15),
    .O(N16)
  );
  X_XOR2 U35 (
    .I0(N20),
    .I1(N19),
    .O(N30)
  );
  defparam U34.INIT = 4'h6;
  X_LUT2 U34 (
    .ADR0(N47),
    .ADR1(N18),
    .O(N19)
  );
  X_ZERO U33 (
    .O(N23)
  );
  X_XOR2 U31 (
    .I0(N23),
    .I1(N22),
    .O(N31)
  );
  defparam U30.INIT = 4'h6;
  X_LUT2 U30 (
    .ADR0(N49),
    .ADR1(N21),
    .O(N22)
  );
  defparam U29.INIT = 1'b0;
  X_FF U29 (
    .CE(VCC),
    .CLK(N32),
    .I(N24),
    .O(N35),
    .RST(N33),
    .SET(GND)
  );
  defparam U28.INIT = 1'b0;
  X_FF U28 (
    .CE(VCC),
    .CLK(N32),
    .I(N25),
    .O(N37),
    .RST(N33),
    .SET(GND)
  );
  defparam U27.INIT = 1'b0;
  X_FF U27 (
    .CE(VCC),
    .CLK(N32),
    .I(N26),
    .O(N39),
    .RST(N33),
    .SET(GND)
  );
  defparam U26.INIT = 1'b0;
  X_FF U26 (
    .CE(VCC),
    .CLK(N32),
    .I(N27),
    .O(N41),
    .RST(N33),
    .SET(GND)
  );
  defparam U25.INIT = 1'b0;
  X_FF U25 (
    .CE(VCC),
    .CLK(N32),
    .I(N28),
    .O(N43),
    .RST(N33),
    .SET(GND)
  );
  defparam U24.INIT = 1'b0;
  X_FF U24 (
    .CE(VCC),
    .CLK(N32),
    .I(N29),
    .O(N45),
    .RST(N33),
    .SET(GND)
  );
  defparam U23.INIT = 1'b0;
  X_FF U23 (
    .CE(VCC),
    .CLK(N32),
    .I(N30),
    .O(N47),
    .RST(N33),
    .SET(GND)
  );
  defparam U22.INIT = 1'b0;
  X_FF U22 (
    .CE(VCC),
    .CLK(N32),
    .I(N31),
    .O(N49),
    .RST(N33),
    .SET(GND)
  );
  X_CKBUF U21 (
    .I(N51),
    .O(N32)
  );
  X_BUF U20 (
    .I(reset),
    .O(N33)
  );
  X_IPAD U19 (
    .PAD(reset)
  );
  X_OPAD U17 (
    .PAD(q[7])
  );
  X_OPAD U15 (
    .PAD(q[6])
  );
  X_OPAD U13 (
    .PAD(q[5])
  );
  X_OPAD U11 (
    .PAD(q[4])
  );
  X_OPAD U9 (
    .PAD(q[3])
  );
  X_OPAD U7 (
    .PAD(q[2])
  );
  X_OPAD U5 (
    .PAD(q[1])
  );
  X_OPAD U3 (
    .PAD(q[0])
  );
  X_BUF U2 (
    .I(clk),
    .O(N51)
  );
  defparam U1.LOC = "P39";
  X_IPAD U1 (
    .PAD(clk)
  );
  X_BUF \U51/MUXCY_L_BUF  (
    .I(\U51/O ),
    .O(N2)
  );
  X_MUX2 U51 (
    .IA(N37),
    .IB(N5),
    .SEL(N4),
    .O(\U51/O )
  );
  X_BUF \U48/MUXCY_L_BUF  (
    .I(\U48/O ),
    .O(N5)
  );
  X_MUX2 U48 (
    .IA(N39),
    .IB(N8),
    .SEL(N7),
    .O(\U48/O )
  );
  X_BUF \U45/MUXCY_L_BUF  (
    .I(\U45/O ),
    .O(N8)
  );
  X_MUX2 U45 (
    .IA(N41),
    .IB(N11),
    .SEL(N10),
    .O(\U45/O )
  );
  X_BUF \U42/MUXCY_L_BUF  (
    .I(\U42/O ),
    .O(N11)
  );
  X_MUX2 U42 (
    .IA(N43),
    .IB(N14),
    .SEL(N13),
    .O(\U42/O )
  );
  X_BUF \U39/MUXCY_L_BUF  (
    .I(\U39/O ),
    .O(N14)
  );
  X_MUX2 U39 (
    .IA(N45),
    .IB(N17),
    .SEL(N16),
    .O(\U39/O )
  );
  X_BUF \U36/MUXCY_L_BUF  (
    .I(\U36/O ),
    .O(N17)
  );
  X_MUX2 U36 (
    .IA(N47),
    .IB(N20),
    .SEL(N19),
    .O(\U36/O )
  );
  X_BUF \U32/MUXCY_L_BUF  (
    .I(\U32/O ),
    .O(N20)
  );
  X_MUX2 U32 (
    .IA(N49),
    .IB(N23),
    .SEL(N22),
    .O(\U32/O )
  );
  X_OBUF U18 (
    .I(N35),
    .O(q[7])
  );
  X_OBUF U16 (
    .I(N37),
    .O(q[6])
  );
  X_OBUF U14 (
    .I(N39),
    .O(q[5])
  );
  X_OBUF U12 (
    .I(N41),
    .O(q[4])
  );
  X_OBUF U10 (
    .I(N43),
    .O(q[3])
  );
  X_OBUF U8 (
    .I(N45),
    .O(q[2])
  );
  X_OBUF U6 (
    .I(N47),
    .O(q[1])
  );
  X_OBUF U4 (
    .I(N49),
    .O(q[0])
  );
  X_ONE NlwBlock_contador_chip_VCC (
    .O(VCC)
  );
  X_ZERO NlwBlock_contador_chip_GND (
    .O(GND)
  );
endmodule


`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

    wire GSR;
    wire GTS;
    wire PRLD;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

