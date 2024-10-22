import shared_pkg::*;
module fifo_sva(FIFO_if.DUT FIFOif);



 property full_p ; //1
 @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
   (count == FIFO_DEPTH) |-> (FIFOif.full);
 endproperty
 assert_full_p:  assert property (full_p) ;
 cover_full_p: cover property (full_p);

 property empty_p ; //2
  @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
    (count == 0) |-> (FIFOif.empty);
  endproperty
  assert_empty_p:  assert property (empty_p) ;
  cover_empty_p: cover property (empty_p);
 
  property almostfull_p ; //3
    @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
    (count == FIFO_DEPTH-1) |-> (FIFOif.almostfull);
    endproperty
    assert_almostfull_p:  assert property (almostfull_p) ;
    cover_almostfull_p: cover property (almostfull_p);
   
   property almostempty_p ; //4
     @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
      (count == 1) |-> (FIFOif.almostempty);
     endproperty
     assert_almostempty_p:  assert property (almostempty_p) ;
     cover_almostempty_p: cover property (almostempty_p);
 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     property count_1 ; //5
      @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
      (({FIFOif.wr_en, FIFOif.rd_en} == 2'b10)&& !FIFOif.full) |=> (count == ($past(count)) + 1);
      endproperty
      assert_count_1:  assert property (count_1) ;
      cover_count_1: cover property (count_1);
     
      property count_2 ; //6
        @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
        ( ({FIFOif.wr_en, FIFOif.rd_en} == 2'b01) && !FIFOif.empty) |=> (count == ($past(count)) - 1);
        endproperty
        assert_count_2:  assert property (count_2) ;
        cover_count_2: cover property (count_2);
     
       property count_3 ; //7
        @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
        ( ({FIFOif.wr_en, FIFOif.rd_en} == 2'b11) && FIFOif.empty) |=> (count == ($past(count)) + 1);
        endproperty
         assert_count_3:  assert property (count_3) ;
         cover_count_3: cover property (count_3);
     
          
       property count_4 ; //8
        @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)   
        ( ({FIFOif.wr_en, FIFOif.rd_en} == 2'b11) && FIFOif.full) |=> (count === ($past(count)) - 1);
        endproperty
        assert_count_4:  assert property (count_4) ;
        cover_count_4: cover property (count_4);
      ///////////////////////////////////////////////////////////////////////////////////
        property underflow_1 ; //9
          @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
          (FIFOif.empty && FIFOif.rd_en && count == 0) |=> FIFOif.underflow;
          endproperty
          assert_underflow_1:  assert property (underflow_1) ;
          cover_underflow_1: cover property (underflow_1);
         
          property overflow_1 ; //10
            @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
            (FIFOif.full && FIFOif.wr_en && !(count < FIFO_DEPTH)) |=> FIFOif.overflow;
            endproperty
            assert_overflow_1:  assert property (overflow_1) ;
            cover_overflow_1: cover property (overflow_1);

           property wr_ack_1 ; //11
            @(posedge FIFOif.clk ) disable iff (!FIFOif.rst_n)
            (FIFOif.wr_en && count < FIFO_DEPTH) |=> FIFOif.wr_ack;
            endproperty
             assert_wr_ack_1:  assert property (wr_ack_1) ;
             cover_wr_ack_1: cover property (wr_ack_1);
         
              
           
 
endmodule