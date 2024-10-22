package fifo_main_sequence_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import fifo_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class write_only_sequence extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(write_only_sequence)
        fifo_seq_item seq_item;
        function new(string name ="write_only_sequence");
            super.new(name);
        endfunction
        task body;
            repeat (100) begin
            seq_item =fifo_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.constraint_mode(0);
            seq_item.rst_c.constraint_mode(1);
            seq_item.wr_en_on.constraint_mode(1);
            assert(seq_item.randomize());
            finish_item(seq_item);
            end
        endtask
     endclass

     class read_only_sequence extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(read_only_sequence)
        fifo_seq_item seq_item;
        function new(string name ="read_only_sequence");
            super.new(name);
        endfunction
        task body;
            repeat (100) begin
            seq_item =fifo_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.constraint_mode(0);
            seq_item.rst_c.constraint_mode(1);
            seq_item.rd_en_on.constraint_mode(1);
            assert(seq_item.randomize());
            finish_item(seq_item);
            end
        endtask
     endclass

     class write_read_sequence extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(write_read_sequence)
        fifo_seq_item seq_item;
        function new(string name ="write_read_sequence");
            super.new(name);
        endfunction
        task body;
            repeat (1000) begin
            seq_item =fifo_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.constraint_mode(0);
            seq_item.rst_c.constraint_mode(1);
            seq_item.rd_wr_en.constraint_mode(1);
            assert(seq_item.randomize());
            finish_item(seq_item);
            end
        endtask
     endclass


    endpackage



