package scoreboard_pkg;
    import transaction_pkg::*;
    import shared_pkg::*;

    class FIFO_scoreboard;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;


         bit [FIFO_WIDTH-1:0] data_out_ref;
         bit wr_ack_ref;
         bit overflow_ref;
         bit full_ref;
         bit empty_ref;
         bit almostfull_ref;
         bit almostempty_ref;
         bit underflow_ref;

                           
          
           logic [FIFO_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
           logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr, rd_ptr;
           logic [$clog2(FIFO_DEPTH):0] count; 
         function void reference_model(FIFO_transaction transaction);
          fork begin
             if(!transaction.rst_n) begin
              wr_ptr = 0;
              data_out_ref =0;
              end
             else begin
            
              if(transaction.wr_en && count < FIFO_DEPTH) begin
                mem[wr_ptr] = transaction.data_in;
		            wr_ack_ref = 1;
		            wr_ptr = wr_ptr + 1;
              end
              else begin
                wr_ack_ref = 0;
                if(full_ref && transaction.wr_en)
                overflow_ref = 1;
                else
                overflow_ref = 0;
               end
            end
          end

            begin
             if(!transaction.rst_n) begin
                rd_ptr = 0;
                data_out_ref =0;
                wr_ptr = 0;
                end
              else begin
                if(transaction.rd_en && count!=0) begin
                 data_out_ref = mem[rd_ptr];
		             rd_ptr = rd_ptr + 1;
                end
                else begin 
                if(transaction.rd_en && empty_ref)
                underflow_ref =1;
                else
                underflow_ref =0;
                end
              end
            end
        join
        if (!transaction.rst_n) begin
          count = 0;
          data_out_ref =0;
        end
        else begin
          if	( ({transaction.wr_en, transaction.rd_en} == 2'b10) && !full_ref) 
              count = count + 1;
          else if ( ({transaction.wr_en, transaction.rd_en} == 2'b01) && !empty_ref)
              count = count - 1;
          else if ( ({transaction.wr_en, transaction.rd_en} == 2'b11) && empty_ref)
              count = count + 1;
          else if ( ({transaction.wr_en, transaction.rd_en} == 2'b11) && full_ref)
              count = count - 1;
         end
      full_ref        = (count == FIFO_DEPTH)? 1 : 0;
      empty_ref       = (count == 0)? 1 : 0;
      almostfull_ref  = (count == FIFO_DEPTH-1)? 1 : 0; 
      almostempty_ref = (count == 1)? 1 : 0;
            

          endfunction
         
         function void check_data(FIFO_transaction obj);
            reference_model(obj);
          if(obj.data_out!=data_out_ref) begin
            error_count++;
            $display("Error in FIFo outputs at time %0t",$time);
            $display("Expected:data_out=%h, wr_ack=%b, overflow=%b, full=%b, empty=%b, almostfull=%b, almostempty=%b, underflow=%b",
            data_out_ref, wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref);
            $display("Actual  : data_out=%h, wr_ack=%b, overflow=%b, full=%b, empty=%b, almostfull=%b, almostempty=%b, underflow=%b",
            obj.data_out, obj.wr_ack, obj.overflow, obj.full, obj.empty, obj.almostfull, obj.almostempty, obj.underflow);
           end
           else
            begin
            correct_count++;
          //  $display("INFO: Correct FIFO output at time %0t", $time);
           //  $display("Expected: data_out=%h, wr_ack=%b, overflow=%b, full=%b, empty=%b, almostfull=%b, almostempty=%b, underflow=%b",
            //data_out_ref, wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref);
            //$display("Actual  : data_out=%h, wr_ack=%b, overflow=%b, full=%b, empty=%b, almostfull=%b, almostempty=%b, underflow=%b",
            //obj.data_out, obj.wr_ack, obj.overflow, obj.full, obj.empty, obj.almostfull, obj.almostempty, obj.underflow);
            end
           endfunction
           
    
    
        endclass
    

    endpackage
