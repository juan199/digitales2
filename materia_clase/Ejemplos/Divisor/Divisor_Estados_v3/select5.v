module select5 (sal, ent0, ent1, ent2, ent3, ent4, sel0, sel1, sel2, sel3, sel4);
  parameter tamData = 0;
  input [tamData:0] ent0, ent1, ent2, ent3, ent4;
  input sel0, sel1, sel2, sel3, sel4;
  output [tamData:0] sal;
  reg [tamData:0] sal;

  always @(ent0 or ent1 or ent2 or ent3 or ent4 or sel0 or sel1 or sel2 or sel3 or sel4)
    begin
      if (sel0)
        sal = ent0;
      else if (sel1)
        sal = ent1;
      else if (sel2)
        sal = ent2;
      else if (sel3)
        sal = ent3;
      else if (sel4)
        sal = ent4;
      else
        sal = 0;
    end
endmodule

