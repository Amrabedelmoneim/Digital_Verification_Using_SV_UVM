module FIFO_tb(fifo_if.TEST fifoif);
    import scoreboard_pkg::*;
    import transaction_pkg::*;
    import coverage_pkg::*;
    import shared_pkg::*;


    FIFO_transaction transaction =new();
    
    initial begin
        test_finished=0;
        Assert_reset();
        @(negedge fifoif.clk);
        repeat(100000) begin
         transaction.randomize();
         fifoif.rst_n          =transaction.rst_n ;
         fifoif.data_in        =transaction.data_in ;
         fifoif.wr_en          =transaction.wr_en ;
         fifoif.rd_en          =transaction.rd_en ;
         @(negedge fifoif.clk);
       /* transaction.data_out =fifoif.data_out;
          transaction.wr_ack =fifoif.wr_ack;
          transaction.overflow =fifoif.overflow;
          transaction.full =fifoif.full;
          transaction.empty =fifoif.empty;
          transaction.almostfull =fifoif.almostfull;
          transaction.almostempty =fifoif.almostempty;
          transaction.underflow =fifoif.underflow;*/
        end
         test_finished=1;
     end
        

        task Assert_reset ();
          fifoif.rst_n          =1;
            @(negedge fifoif.clk);
           fifoif.rst_n          =0;
           @(negedge fifoif.clk);
           fifoif.rst_n          =1;
        endtask



        endmodule

