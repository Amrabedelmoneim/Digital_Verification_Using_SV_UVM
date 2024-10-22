
    import scoreboard_pkg::*;
    import transaction_pkg::*;
    import coverage_pkg::*;
    import shared_pkg::*;
module FIFO_monitor (fifo_if.MONITOR fifoif );

    FIFO_scoreboard scoreboard =new();
    FIFO_transaction transaction=new();
    FIFO_coverage coverage=new();

    initial begin
    forever begin
      @(negedge fifoif.clk);

        transaction.rst_n =fifoif.rst_n;
        transaction.data_in =fifoif.data_in;
        transaction.wr_en =fifoif.wr_en;
        transaction.rd_en =fifoif.rd_en;
        transaction.data_out =fifoif.data_out;
        transaction.wr_ack =fifoif.wr_ack;
        transaction.overflow =fifoif.overflow;
        transaction.full =fifoif.full;
        transaction.empty =fifoif.empty;
        transaction.almostfull =fifoif.almostfull;
        transaction.almostempty =fifoif.almostempty;
        transaction.underflow =fifoif.underflow;

        fork
            begin
              coverage.sample_data(transaction);
            end
            begin
              @(posedge fifoif.clk)
              #10
              scoreboard.check_data(transaction);
            end
        join
      if(test_finished==1)
      begin
        $display("Test Finished.");
        $display("Correct Count: %0d", correct_count);
        $display("Error Count: %0d", error_count);
        $finish;
      end
    end
    end
    
    endmodule
