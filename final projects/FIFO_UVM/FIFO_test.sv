package fifo_test_pkg;
    import uvm_pkg::*;
    import fifo_env_pkg::*;
    import fifo_config_obj_pkg::*;
    import fifo_main_sequence_pkg::*;
    import fifo_reset_sequence_pkg::*;
    import shared_pkg::*;
    import fifo_seq_item_pkg::*;

    `include "uvm_macros.svh"
    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test);
        fifo_env env;
        fifo_config_obj fifo_cfg;
        virtual FIFO_if fifo_vif;
        write_read_sequence wr_rd_seq;
        write_only_sequence wr_seq;
        read_only_sequence rd_seq;
        fifo_reset_sequence reset_seq;

        function new(string name ="fifo_test",uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = fifo_env::type_id::create("env",this);
            fifo_cfg = fifo_config_obj::type_id::create("fifo_cfg",this);
            wr_rd_seq=write_read_sequence::type_id::create("wr_rd_seq",this);
            wr_seq   =write_only_sequence::type_id::create("wr_seq",this);
            rd_seq   =read_only_sequence::type_id::create("rd_seq",this);
            reset_seq=fifo_reset_sequence::type_id::create("reset_seq",this);

            if (!uvm_config_db#(virtual FIFO_if)::get(this, "", "FIFO_if", fifo_cfg.fifo_vif)) begin
                `uvm_error("fifo_driver", "Failed to get virtual interface from config DB")
            end
            uvm_config_db#(fifo_config_obj)::set (this,"*","CFG",fifo_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase","Reset Asserted",UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)

            `uvm_info("run_phase","Stimulus generation started",UVM_LOW)
            wr_rd_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Stimulus generation Ended",UVM_LOW)

            `uvm_info("run_phase","Stimulus generation started",UVM_LOW)
            wr_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Stimulus generation Ended",UVM_LOW)

            `uvm_info("run_phase","Stimulus generation started",UVM_LOW)
            rd_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Stimulus generation Ended",UVM_LOW)

            phase.drop_objection(this);
        endtask:run_phase
        endclass:fifo_test
 endpackage