module mux2a1 (sal, ent0, ent1, sel);
  parameter tamData = 0;
  input [tamData:0] ent0, ent1;
  input sel;
  output [tamData:0] sal;
  reg [tamData:0] sal;

  always @(ent0 or ent1 or sel)
    begin
      if (~sel)
        sal = ent0;
      else
        sal = ent1;
    end
endmodule

