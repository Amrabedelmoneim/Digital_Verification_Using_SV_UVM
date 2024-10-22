interface fifo_if (clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    input bit clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [FIFO_WIDTH-1:0] data_in;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack;
    logic overflow;
    logic full;
    logic empty;
    logic almostfull;
    logic almostempty;
    logic underflow;

    modport DUT (input data_in, wr_en, rd_en, clk, rst_n, output full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out );
    modport TEST (input clk,full, empty,almostfull, almostempty, wr_ack, overflow, underflow, data_out, output data_in, wr_en, rd_en, rst_n );
    modport MONITOR (input data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out );
endinterface

