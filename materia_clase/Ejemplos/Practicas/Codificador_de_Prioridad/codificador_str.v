module cod_str
(f1, f2, f3, f4, a, b, c, d);
input a, b, c, d;
output f1, f2, f3,f4;
wire f1, f2, f3,f4;



and #1
g1(f1, ~a, b),
g2(f2, ~b, c, ~a),
g3(f3, d, ~c, ~b, ~a);

buf
g4(f4,a);

endmodule