module comp_a_2 (sal, ent);
  parameter tamData = 0;
  input [tamData:0] ent;
  output [tamData:0] sal;

  assign sal = -ent;
endmodule

