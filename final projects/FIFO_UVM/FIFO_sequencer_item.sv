package fifo_seq_item_pkg ;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"
    class fifo_seq_item extends uvm_sequence_item;
        `uvm_object_utils(fifo_seq_item)
       bit clk;
       rand logic rst_n;
       rand logic wr_en;
       rand logic rd_en;
       rand logic [FIFO_WIDTH-1:0] data_in;
       logic [FIFO_WIDTH-1:0] data_out;
       logic wr_ack;
       logic overflow;
       logic full;
       logic empty;
       logic almostfull;
       logic almostempty;
       logic underflow;
 
      
      constraint rst_c {rst_n dist {1:/95 , 0:/5  } ; }
      constraint wr_en_c {wr_en dist {1:/(70) , 0:/(30)  } ; } 
      constraint rd_en_c {rd_en dist {1:/(30) , 0:/(70)  } ; } 
      
      constraint wr_en_on {wr_en dist {1:/(100) , 0:/(0)  } ;
                           rd_en dist {1:/(0) , 0:/(100)  }  ;  } 

      constraint rd_en_on {rd_en dist {1:/(100) , 0:/(0)  } ;
                           wr_en dist {1:/(0) , 0:/(100)  }; } 
                           
      constraint rd_wr_en {rd_en dist {1:/(50) , 0:/(50)  } ; } 

  
       
        function new(string name ="fifo_seq_item");
            super.new(name);
        endfunction
        function string convert2string();
            return $sformatf("%s rst_n =0b%0b, wr_en =0b%0b ,rd_en =0b%0b , data_in =0b%0b ,data_out =0b%0b, wr_ack =0b%0b ,overflow =0b%0b ,full =0b%0b, empty =0b%0b ,almostfull =0b%0b ,almostempty =0b%0b, underflow =0b%0b ", super.convert2string(), rst_n , wr_en ,rd_en ,data_in , data_out , wr_ack ,overflow ,full , empty , almostfull , almostempty , underflow);
            
        endfunction
        function string convert2string_stimulus();
          return $sformatf("%s rst_n =0b%0b, wr_en =0b%0b ,rd_en =0b%0b , data_in =0b%0b ", super.convert2string(), rst_n , wr_en ,rd_en ,data_in , data_out );
            
        endfunction
    endclass
endpackage
        
        
        
