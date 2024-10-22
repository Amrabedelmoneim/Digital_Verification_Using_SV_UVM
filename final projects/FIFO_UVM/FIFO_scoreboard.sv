package fifo_scoreboard_pkg;
    import uvm_pkg::*;
    import fifo_seq_item_pkg::*;
    import fifo_agent_pkg::*;
    import fifo_coverage_pkg::*;
    import shared_pkg::*;

    `include "uvm_macros.svh";
    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)
        uvm_analysis_export #(fifo_seq_item)sb_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item)sb_fifo;
        fifo_seq_item seq_item_sb;

         logic [FIFO_WIDTH-1:0] data_out_ref;
         logic wr_ack_ref;
         logic overflow_ref;
         logic full_ref;
         logic empty_ref;
         logic almostfull_ref;
         logic almostempty_ref;
         logic underflow_ref;


         localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    
         reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
         
         reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
         reg [max_fifo_addr:0] count;

        int error_count =0;
        int correct_count =0;
        
        function new(string name ="fifo_scoreboard",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export= new("sb_export",this);
            sb_fifo= new("sb_fifo",this);

        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
             sb_fifo.get(seq_item_sb);
             ref_model(seq_item_sb);
             if(seq_item_sb.data_out != data_out_ref) begin
                `uvm_error("run_phase",$sformatf("Comparsion faild, Transaction received by the DUT:%s While the reference out:0b%0b",seq_item_sb.convert2string(),data_out_ref));
                error_count++;
             end
             else begin
                `uvm_info("run_phase",$sformatf("correct out: %s",seq_item_sb.convert2string()),UVM_HIGH);
                correct_count++;
             end
            end

        endtask

      

        task ref_model(fifo_seq_item seq_item_chk);
          fork begin
            if(!seq_item_chk.rst_n) begin
             wr_ptr = 0;
             data_out_ref =0;
             end
            else begin
           
             if(seq_item_chk.wr_en && count < FIFO_DEPTH) begin
               mem[wr_ptr] = seq_item_chk.data_in;
               wr_ack_ref = 1;
               wr_ptr = wr_ptr + 1;
             end
             else begin
               wr_ack_ref = 0;
               if(full_ref && seq_item_chk.wr_en)
               overflow_ref = 1;
               else
               overflow_ref = 0;
              end
           end
         end

           begin
            if(!seq_item_chk.rst_n) begin
               rd_ptr = 0;
               data_out_ref =0;
               wr_ptr = 0;
               end
             else begin
               if(seq_item_chk.rd_en && count!=0) begin
                data_out_ref = mem[rd_ptr];
                rd_ptr = rd_ptr + 1;
               end
               else begin 
               if(seq_item_chk.rd_en && empty_ref)
               underflow_ref =1;
               else
               underflow_ref =0;
               end
             end
           end
       join
       if (!seq_item_chk.rst_n) begin
         count = 0;
         data_out_ref =0;
       end
       else begin
         if	( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b10) && !full_ref) 
             count = count + 1;
         else if ( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b01) && !empty_ref)
             count = count - 1;
         else if ( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b11) && empty_ref)
             count = count + 1;
         else if ( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b11) && full_ref)
             count = count - 1;
        end
          full_ref        = (count == FIFO_DEPTH)? 1 : 0;
         empty_ref       = (count == 0)? 1 : 0;
         almostfull_ref  = (count == FIFO_DEPTH-1)? 1 : 0; 
         almostempty_ref = (count == 1)? 1 : 0;  
         
        endtask
        
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("Total successful transactions: %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("Total failed transactions: %0d",error_count),UVM_MEDIUM);
        endfunction
    endclass
endpackage
