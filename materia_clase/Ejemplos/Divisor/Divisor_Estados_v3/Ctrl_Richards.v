module demux3a8 (Y, i, c, b, a);
  output [7:0] Y;
  input i, c, b, a;

  reg [7:0] Y;

  always @ (i or c or b or a)
    begin
      case ({c, b, a})
        3'b000: Y = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, i};
        3'b001: Y = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, i, 1'b0};
        3'b010: Y = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, i, 1'b0, 1'b0};
        3'b011: Y = {1'b0, 1'b0, 1'b0, 1'b0, i, 1'b0, 1'b0, 1'b0};
        3'b100: Y = {1'b0, 1'b0, 1'b0, i, 1'b0, 1'b0, 1'b0, 1'b0};
        3'b101: Y = {1'b0, 1'b0, i, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        3'b110: Y = {1'b0, i, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        3'b111: Y = {i, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        default: Y = 8'bx;
      endcase
    end
endmodule

module Cont8_carga (Q, I, carga, reset, clk);
  input [2:0] I;
  input carga, reset, clk;
  output [2:0] Q;

  reg [2:0] Q;

  always @ (negedge clk or negedge reset)
    begin
      if (~reset)
        Q = 3'b0;
      else
        begin
          if (carga)
             Q = I;
           else
             Q = Q + 1;
        end
    end
endmodule

module Ctrl_Richards (go, Cont16NoCero, divisorNoCero, reloj, reset, Est, EstPresente);
  input go, Cont16NoCero, divisorNoCero, reloj, reset;
  output [2:0]  EstPresente;
  wire [2:0]  EstPresente;

  output [7:0] Est;
  wire [7:0] Est;  //Salidas indicando el estado de la maquina

  not inv1 (goB, go);
  not inv2 (divisorNoCeroB, divisorNoCero);

  //Multiplexor con las condiciones
  mux8a1 mux1 (carga, {go, 1'b0, Cont16NoCero, 1'b0, 1'b0, 1'b0, divisorNoCeroB, goB}, EstPresente[2], EstPresente[1], EstPresente[0]);

  //Demultiplexor con las salidas del controlador
  demux3a8 dmux1 (Est, 1'b1, EstPresente[2], EstPresente[1], EstPresente[0]);

  //Logica combinacional para saltar cuando la condicion es verdadera
  wire [2:0] I;
  or g0 (I[0], Est[1], Est[5], Est[7]);
  or g1 (I[1], Est[1], Est[5], Est[7]);
  or g2 (I[2], Est[1], Est[7]);

  //Contador con el estado del controlador
  Cont8_carga cont1 (EstPresente, I, carga, reset, reloj);

endmodule
