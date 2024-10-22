# Synchronous FIFO Overview
This FIFO (First-In, First-Out) design, implements a synchronous FIFO buffer using an interface for signal communication, with assertions and properties to verify key behaviors. Here's a brief breakdown of the design:

## Basic Operation:

Write Operation: Data is written to the FIFO when wr_en (write enable) is asserted, and the FIFO is not full. The wr_ptr points to the location where the data is stored. Acknowledgment (wr_ack) is given upon a successful write.

Read Operation: Data is read from the FIFO when rd_en (read enable) is asserted, and the FIFO is not empty. The rd_ptr points to the location from where the data is read.

Control Signals: The count keeps track of the number of elements in the FIFO, and status flags (full, empty, almostfull, almostempty, overflow, underflow) are used to monitor the FIFO's state.

This design is robust, focusing on correct functionality with extensive use of formal verification techniques through assertions.
## Parameters:

• FIFO_WIDTH: DATA in/out and memory word width (default: 16)

• FIFO_DEPTH: Memory depth (default: 8)

## Ports

| Port | Direction | Function |
| --- | --- | --- |
|  data_in  | input | Write Data: The input data bus used when writing the FIFO. |
|  wr_en  | input |Write Enable: If the FIFO is not full, asserting this signal causes data (on data_in) to be written into the FIFO |
|  rd_en  | input | Read Enable: If the FIFO is not empty, asserting this signal causes data (on data_out) to be read from the FIFO |
|  clk  | input | Clock signal |
|  rst_n  | input | Active low asynchronous reset |
|  data_out  | output | Read Data: The sequential output data bus used when reading from the FIFO. |
|  full  | output | Full Flag: When asserted, this combinational output signal indicates that the FIFO is full. Write requests are ignored when the FIFO is full, initiating a write when the FIFO is full is not destructive to the contents of the FIFO. |
|  almostfull  | output | Almost Full: When asserted, this combinational output signal indicates that only one more write can be performed before the FIFO is full. |
|  empty  | output | Empty Flag: When asserted, this combinational output signal indicates that the FIFO is empty. Read requests are ignored when the FIFO is empty, initiating a read while empty is not destructive to the FIFO. |
|  almostempty  | output | Almost Empty: When asserted, this output combinational signal indicates that only one more read can be performed before the FIFO goes to empty. |
|  overflow  | output | Overflow: This sequential output signal indicates that a write request (wr_en) was rejected because the FIFO is full. Overflowing the FIFO is not destructive to the contents of the FIFO. |
|  underflow  | output | Underflow: This sequential output signal Indicates that the read request (rd_en) was rejected because the FIFO is empty. Under flowing the FIFO is not destructive to the FIFO.|
|  wr_ack  | output | Write Acknowledge: This sequential output signal indicates that a write request (wr_en) has succeeded. |
