package fifo_coverage_pkg;
    import uvm_pkg::*;
    import fifo_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class fifo_coverage extends uvm_component;
        `uvm_component_utils(fifo_coverage)
        uvm_analysis_export #(fifo_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
        fifo_seq_item seq_item_cov;
       
        covergroup g1 ;

            wr_en_cp :coverpoint seq_item_cov.wr_en;
            rd_en_cp : coverpoint seq_item_cov.rd_en; 
            wr_ack_cp: coverpoint seq_item_cov.wr_ack;
            overflow_cp : coverpoint seq_item_cov.overflow;
            full_cp: coverpoint seq_item_cov.full;
            empty_cp: coverpoint seq_item_cov.empty;
            almostfull_cp: coverpoint seq_item_cov.almostfull;
            almostempty_cp: coverpoint seq_item_cov.almostempty;
            underflow_cp: coverpoint seq_item_cov.underflow;

            wr_full_cp: cross wr_en_cp, full_cp;
            wr_wr_ack_cp: cross wr_en_cp, wr_ack_cp
            {
                ignore_bins wr_en0_wr_ack1 = !binsof(wr_en_cp) intersect {1} && binsof(wr_ack_cp) intersect {1};

            }
            wr_overflow_cp : cross wr_en_cp, overflow_cp
            {
                ignore_bins wr_en0_overflow1 = !binsof(wr_en_cp) intersect {1} && binsof(overflow_cp) intersect {1};

            }
            
            wr_empty_cp: cross wr_en_cp, empty_cp;
            wr_almostfull_cp: cross wr_en_cp , almostfull_cp;
            wr_almostempty_cp: cross wr_en_cp, almostempty_cp; 
            wr_underflow_cp: cross wr_en_cp, underflow_cp;

            rd_full_cp: cross rd_en_cp, full_cp
            
            {
                ignore_bins rd_full_1 =binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect {1};

            }
            
            
            rd_wr_ack_cp: cross rd_en_cp, wr_ack_cp;
            rd_overflow_cp: cross rd_en_cp, overflow_cp;
            rd_empty_cp: cross rd_en_cp ,empty_cp;
            rd_almostfull_cp: cross rd_en_cp, almostfull_cp;
            rd_almostempty_cp: cross rd_en_cp, almostempty_cp;
            rd_underflow_cp: cross rd_en_cp, underflow_cp;

        endgroup : g1

       
        function new(string name ="fifo_coverage",uvm_component parent = null);
            super.new(name,parent);
            g1 = new();

        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export =new("cov_export",this);
            cov_fifo =new("cov_fifo",this);
            
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                g1.sample();
            end
        endtask
    endclass

endpackage
