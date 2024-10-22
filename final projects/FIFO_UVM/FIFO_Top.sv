import fifo_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module FIFO_Top();
    bit clk;
    initial begin 
        forever
        #1 clk=~clk;
    end

    FIFO_if FIFOif (clk);
    FIFO DUT (FIFOif);
    bind FIFO fifo_sva SVA_INST (FIFOif);
    initial begin
        uvm_config_db#(virtual FIFO_if)::set(null,"uvm_test_top","FIFO_if",FIFOif);
        run_test("fifo_test");
    end
endmodule
