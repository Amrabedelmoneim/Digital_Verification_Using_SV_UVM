module Top();
    bit clk =0;
    always #10 clk =~clk;
    fifo_if fifoif(clk);
    FIFO DUT(fifoif);
    FIFO_tb TEST(fifoif);
    FIFO_monitor MONITOR(fifoif);
endmodule


