package transaction_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    class FIFO_transaction;
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

     integer RD_EN_ON_DIST;
     integer WR_EN_ON_DIST;

     constraint rst_c {rst_n dist {1:/95 , 0:/5  } ; }
     constraint wr_en_c {wr_en dist {1:/(WR_EN_ON_DIST) , 0:/(100-WR_EN_ON_DIST)  } ; } 
     constraint rd_en_c {rd_en dist {1:/(RD_EN_ON_DIST) , 0:/(100-RD_EN_ON_DIST)  } ; } 

     function new(integer RD_dist =30,integer WR_dist=70);
        this.RD_EN_ON_DIST = RD_dist;
        this.WR_EN_ON_DIST = WR_dist;
      endfunction
    endclass
endpackage
