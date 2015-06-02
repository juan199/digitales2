module testBench;
  wire w1, w2, w3, w4, w5;

  binaryToESeg d (w1, w2, w3, w4, w5);
  test_bToESeg t (w1, w2, w3, w4, w5);

endmodule

