module mult_div_ideal(sal_32, done, ent_32, ent_16, go, div_mult);

  output  [31:0]  sal_32; 
  output          done;

  reg     [31:0]  sal_32; 
  reg             done;

  input   [31:0]  ent_32;
  input   [15:0]  ent_16;
  input           go, div_mult;

  reg     [15:0]  divisor, quotient, myMpy;
  reg     [31:0]  dividend, myMend, prod;
  reg     [3:0]   cont;

  reg             negdivisor, negdividend, negMpy, negMend;

  wire    [31:0]  ddInput;
  wire    [15:0]  dvInput, mpy, mend;

  assign ddInput=ent_32;
  assign dvInput=ent_16;
  assign mpy=ent_16;
  assign mend=ent_32;

  always
    begin
      done=0;
      wait(go);
      
      if(!div_mult)
        begin
          divisor=dvInput;
          dividend=ddInput;
          done=0;
          quotient=0;
          cont = 0;
          if(divisor)
            begin
              negdivisor=divisor[15];
              negdividend=dividend[31];
              if(negdivisor)
                divisor=-divisor;

              if(negdividend)
                dividend=-dividend;

              repeat(15+1)
                begin
                  quotient=quotient<<1;
                  dividend=dividend<<1;

                  dividend[31:16]=dividend[31:16]-divisor;
                  if(!dividend[31])
                    quotient=quotient+1;
                  else
                    dividend[31:16]=dividend[31:16]+divisor;
                end
            end
          if(negdivisor!=negdividend)
            quotient=-quotient;

          if(quotient[15])
            sal_32[31:16]=16'hFFFF;
          else
            sal_32[31:16]=16'h0000;

          sal_32[15:0]=quotient;
        end
      else
        begin
          myMpy=mpy[15:0];
          myMend=mend;
          prod=0;
          negMpy=mpy[15];
          negMend=mend[15];
          if(negMpy)

            myMpy=-myMpy;

          if(negMend)

            myMend=-myMend;
          
          repeat(16)
          begin
            if(myMpy[0])

              prod=prod+{myMend,16'h0000};

            prod=prod>>1;
            myMpy=myMpy>>1;
          end

          if(negMpy!=negMend)

            prod=-prod;

          sal_32=prod;
        end

        done=1;
        wait(~go);
    end
endmodule


