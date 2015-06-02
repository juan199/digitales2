`define READ 0
`define WRITE 1

//==============================================================================
module busDriver(busLine, valueToGo, driveEnable);
  parameter Bsize = 15;

  inout [Bsize:0] busLine;
  input [Bsize:0] valueToGo;
  input driveEnable;

  assign busLine = (driveEnable) ? valueToGo: 'bz;
endmodule


//==============================================================================
module slave (rw, addressLines, dataLines, clock);
  parameter
    Asize = 4,
    Dsize = 15,
    Msize = 31;

  input rw, clock;
  input [Asize:0] addressLines;
  inout [Dsize:0] dataLines;
  reg [Dsize:0] m[0:Msize];
  reg [Dsize:0] internalData;
  reg enable;

  busDriver #(Dsize) bSlave (dataLines, internalData, enable);

  initial
    begin
      $readmemh ("memory.data", m);
      enable = 0;
    end

  always // bus slave end
    begin
      @(negedge clock);
      if (~rw) begin //read
        internalData <= m[addressLines];
        enable <= 1;
        @(negedge clock);
        enable <= 0;
      end
      else //write
        m[addressLines] <= dataLines;
    end
endmodule


//==============================================================================
module master (rw, addressLines, dataLines, clock);
  parameter
    Asize = 4,
    Dsize = 15;

  input clock;
  output rw;
  output [Asize:0] addressLines;
  inout [Dsize:0] dataLines;
  reg rw, enable;
  reg [Dsize:0] internalData;
  reg [Asize:0] addressLines;

  busDriver #(Dsize) bMaster (dataLines, internalData, enable);

  initial enable = 0;

  always // bus master end
    begin
      #1
      wiggleBusLines (`READ, 2, 0);
      wiggleBusLines (`READ, 3, 0);
      wiggleBusLines (`WRITE, 2, 5);
      wiggleBusLines (`WRITE, 3, 7);
      wiggleBusLines (`READ, 2, 0);
      wiggleBusLines (`READ, 3, 0);
      $finish;
    end

  task wiggleBusLines;
    input readWrite;
    input [Asize:0] addr;
    input [Dsize:0] data;

    begin
      rw <= readWrite;
      if (readWrite) begin// write value
        addressLines <= addr;
        internalData <= data;
        enable <= 1;
      end
      else begin //read value
        addressLines <= addr;
        @ (negedge clock);
      end
      @(negedge clock);
      enable <= 0;
    end
  endtask
endmodule


//==============================================================================
module sbus;
  parameter
    Tclock = 20,
    Asize = 4,
    Dsize = 15,
    Msize = 31;

  reg clock;
  wire rw;
  wire [Asize:0] addr;
  wire [Dsize:0] data;

  master #(Asize, Dsize) m1 (rw, addr, data, clock);
  slave #(Asize, Dsize, Msize)s1 (rw, addr, data, clock);

  initial
    begin
      clock = 0;
      $monitor ("rw=%d, data=%d, addr=%d at time %d", rw, data, addr, $time);
    end

  always
    #Tclock clock = !clock;
endmodule



