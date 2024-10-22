////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;
module FIFO(fifo_if.DUT fifoif);
    
    localparam max_fifo_addr = $clog2(fifoif.FIFO_DEPTH);
    
    reg [fifoif.FIFO_WIDTH-1:0] mem [fifoif.FIFO_DEPTH-1:0];
    
    reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
    reg [max_fifo_addr:0] count;

    always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
        if (!fifoif.rst_n) begin
            wr_ptr <= 0;
        end
        else if (fifoif.wr_en && count < fifoif.FIFO_DEPTH) begin
            mem[wr_ptr] <= fifoif.data_in;
            fifoif.wr_ack <= 1;
            wr_ptr <= wr_ptr + 1;
        end
        else begin 
            fifoif.wr_ack <= 0; 
            if (fifoif.full && fifoif.wr_en)
            fifoif.overflow <= 1;
            else
            fifoif.overflow <= 0;
        end
    end
    
    always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
        if (!fifoif.rst_n) begin
            rd_ptr <= 0;
            fifoif.data_out <=0;
        end
        else if (fifoif.rd_en && count != 0) begin
            fifoif.data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
        else begin
            if(fifoif.empty && fifoif.rd_en)
            fifoif.underflow <=1;
            else
            fifoif.underflow <=0;
        end 
    end
    
    always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
        if (!fifoif.rst_n) begin
            count <= 0;
        end
        else begin
            if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) 
                count <= count + 1;
            else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty)
                count <= count - 1;
            else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.empty)
                count <= count + 1;
            else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.full)
                count <= count - 1;
        end
    end
    
    assign fifoif.full        = (count == fifoif.FIFO_DEPTH)? 1 : 0;
    assign fifoif.empty       = (count == 0)? 1 : 0;
    assign fifoif.almostfull  = (count == fifoif.FIFO_DEPTH-1)? 1 : 0; 
    assign fifoif.almostempty = (count == 1)? 1 : 0;
    property full_p ; //1
        @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
          (count == fifoif.FIFO_DEPTH) |-> (fifoif.full);
        endproperty
        assert_full_p:  assert property (full_p) ;
        cover_full_p: cover property (full_p);
       
        property empty_p ; //2
         @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
           (count == 0) |-> (fifoif.empty);
         endproperty
         assert_empty_p:  assert property (empty_p) ;
         cover_empty_p: cover property (empty_p);
        
         property almostfull_p ; //3
           @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
           (count == fifoif.FIFO_DEPTH-1) |-> (fifoif.almostfull);
           endproperty
           assert_almostfull_p:  assert property (almostfull_p) ;
           cover_almostfull_p: cover property (almostfull_p);
          
          property almostempty_p ; //4
            @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
             (count == 1) |-> (fifoif.almostempty);
            endproperty
            assert_almostempty_p:  assert property (almostempty_p) ;
            cover_almostempty_p: cover property (almostempty_p);
        
       /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            property count_1 ; //5
             @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
             (({fifoif.wr_en, fifoif.rd_en} == 2'b10)&& !fifoif.full) |=> (count == ($past(count)) + 1);
             endproperty
             assert_count_1:  assert property (count_1) ;
             cover_count_1: cover property (count_1);
            
             property count_2 ; //6
               @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
               ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty) |=> (count == ($past(count)) - 1);
               endproperty
               assert_count_2:  assert property (count_2) ;
               cover_count_2: cover property (count_2);
            
              property count_3 ; //7
               @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
               ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.empty) |=> (count == ($past(count)) + 1);
               endproperty
                assert_count_3:  assert property (count_3) ;
                cover_count_3: cover property (count_3);
            
                 
              property count_4 ; //8
               @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)   
               ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.full) |=> (count === ($past(count)) - 1);
               endproperty
               assert_count_4:  assert property (count_4) ;
               cover_count_4: cover property (count_4);
             ///////////////////////////////////////////////////////////////////////////////////
               property underflow_1 ; //9
                 @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
                 (fifoif.empty && fifoif.rd_en && count == 0) |=> fifoif.underflow;
                 endproperty
                 assert_underflow_1:  assert property (underflow_1) ;
                 cover_underflow_1: cover property (underflow_1);
                
                 property overflow_1 ; //10
                   @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
                   (fifoif.full &&fifoif.wr_en && !(count < fifoif.FIFO_DEPTH)) |=> fifoif.overflow;
                   endproperty
                   assert_overflow_1:  assert property (overflow_1) ;
                   cover_overflow_1: cover property (overflow_1);
       
                  property wr_ack_1 ; //11
                   @(posedge fifoif.clk ) disable iff (!fifoif.rst_n)
                   (fifoif.wr_en && count < fifoif.FIFO_DEPTH) |=> fifoif.wr_ack;
                   endproperty
                    assert_wr_ack_1:  assert property (wr_ack_1) ;
                    cover_wr_ack_1: cover property (wr_ack_1);
                
    endmodule
