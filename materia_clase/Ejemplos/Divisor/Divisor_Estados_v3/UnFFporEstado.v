module UnFFporEstado (go, Cont16NoCero, divisorNoCero, reloj, reset, Est, EstPresente);
  input go, Cont16NoCero, divisorNoCero, reloj, reset;
  output [2:0]  EstPresente;
  wire [2:0]  EstPresente;

  output [7:0] Est;
  wire [7:0] Est;  //Salidas indicando el estado de la maquina

  //Necesario para ver el estado codificado pero no contribuye al control
  or g0(EstPresente[0], Est[1], Est[3], Est[5], Est[7]);
  or g1(EstPresente[1], Est[2], Est[3], Est[6], Est[7]);
  or g2(EstPresente[2], Est[4], Est[5], Est[6], Est[7]);

  //Estado 0
  or g03(d0, s0_0, s7_0);
  ffD Est0(d0, Est[0], reset, 1'b1, reloj);
  not g00(goB, go);
  and g01(s0_1, Est[0], go);
  and g02(s0_0, Est[0], goB);


  //Estado 1
  ffD Est1(s0_1, Est[1], 1'b1, reset, reloj);
  not g10(divisorNoCeroB, divisorNoCero);
  and g11(s1_2, Est[1], divisorNoCero);
  and g12(s1_7, Est[1], divisorNoCeroB);

  //Estado 2
  ffD Est2(s1_2, Est[2], 1'b1, reset, reloj);
  wire s2_3;
  assign s2_3 = Est[2];

  //Estado 3
  or g33(d3, s2_3, s5_3);
  ffD Est3(d3, Est[3], 1'b1, reset, reloj);
  wire s3_4;
  assign s3_4 = Est[3];

  //Estado 4
  ffD Est4(s3_4, Est[4], 1'b1, reset, reloj);
  wire s4_5;
  assign s4_5 = Est[4];

  //Estado 5
  ffD Est5(s4_5, Est[5], 1'b1, reset, reloj);
  not g50(Cont16NoCeroB, Cont16NoCero);
  and g51(s5_3, Est[5], Cont16NoCero);
  and g52(s5_6, Est[5], Cont16NoCeroB);

  //Estado 6
  ffD Est6(s5_6, Est[6], 1'b1, reset, reloj);
  wire s6_7;
  assign s6_7 = Est[6];

  //Estado 7
  or g73(d7, s7_7, s6_7);
  ffD Est7(d7, Est[7], 1'b1, reset, reloj);
  and g71(s7_7, Est[7], go);
  and g72(s7_0, Est[7], goB);

endmodule
