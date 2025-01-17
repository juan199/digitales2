module test_bToESeg (eSeg, A, B, C, D);
  input eSeg;
  output A, B, C, D;
  reg A, B, C, D;

  initial // two slashes introduce a single line comment
    begin
      $monitor ($time,,
            "A = %b B = %b C = %b D = %b, eSeg = %b",
             A, B, C, D, eSeg);
      $dumpfile("eSeg.vcd"); //Define el nombre del archivo vcd
      $dumpvars;             //Salva los estados de todas las variables

      //waveform for simulating the nand lip lop
      #10 A = 0; B = 0; C = 0; D = 0;
      #10 D = 1;
      #10 C = 1; D = 0;
      #10 $finish;
    end

endmodule

