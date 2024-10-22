package shared_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    reg [max_fifo_addr:0] count;
endpackage


