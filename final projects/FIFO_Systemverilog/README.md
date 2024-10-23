# Synchronous FIFO in SystemVerilog

## Overview of the Testbench Flow

### Top Module:

- Generates the clock and passes it to the interface.
- The interface is shared between the DUT (Device Under Test), testbench (tb), and monitor.

### Testbench (tb):

- Resets the DUT.
- Randomizes the DUT inputs.
- At the end of the simulation, asserts the test_finished signal.

### Monitor Module:

- Instantiates FIFO_transaction, FIFO_scoreboard, and FIFO_coverage classes.
- Continuously samples the interface at each clock edge in a forever loop.
- Stores the sampled data in the FIFO_transaction object.
- Uses fork-join to simultaneously execute sample_data (for functional coverage) and check_data (for correctness verification).

### End of Simulation:

- After the fork-join, checks if test_finished is asserted.
- If test_finished is high, the simulation ends, and a summary of correct_count and error_count is displayed.

### Classes Used in Verification
- FIFO_transaction_pkg: Defines the FIFO_transaction class, which includes the inputs, outputs, and constraints on the enable signals.

- FIFO_coverage_pkg: Contains the FIFO_coverage class to collect functional coverage through cross-coverage of wr_en, rd_en, and control signals.

- FIFO_scoreboard_pkg: Implements the FIFO_scoreboard class to verify the DUT’s outputs against a reference model and update correct_count or error_count.
