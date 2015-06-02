module mux8a1 (y, I, c, b, a);
  input [7:0] I;
  input c, b, a;
  output y;

  reg y;

  always @ (I or c or b or a)
    case ({c, b, a})
      3'b000: y = I[0];
      3'b001: y = I[1];
      3'b010: y = I[2];
      3'b011: y = I[3];
      3'b100: y = I[4];
      3'b101: y = I[5];
      3'b110: y = I[6];
      3'b111: y = I[7];
    endcase
endmodule


