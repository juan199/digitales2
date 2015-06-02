module select2 (sal, ent0, ent1, sel0, sel1);
  parameter tamData = 0;
  input [tamData:0] ent0, ent1;
  input sel0, sel1;
  output [tamData:0] sal;
  reg [tamData:0] sal;

  always @(ent0 or ent1 or sel0 or sel1)
    begin
      if (sel0)
        sal = ent0;
      else if (sel1)
        sal = ent1;
    end
endmodule

