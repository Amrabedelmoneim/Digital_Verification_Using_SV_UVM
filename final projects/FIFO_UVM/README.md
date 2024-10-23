# Synchronous FIFO UVM

## Overview to the UVM flow

Universal Verification Methodology (UVM) is a standardized methodology used for functional verification of hardware designs. It provides a modular, reusable, and scalable framework for building complex testbenches. Here's an overview of the UVM flow:
![image](https://github.com/user-attachments/assets/0390a10f-8deb-4791-9d6d-800e3ab83aa6)

## UVM Components:

1. Top Module instantiates the DUT and connects the interface.
2. UVM Test generates sequences (stimulus) and passes them to the UVM Environment.
3. The UVM Sequencer controls the flow of sequence items to the UVM Driver.
4. The UVM Driver converts sequence items into pin-level signals to drive the DUT through the interface.
5. The UVM Monitor captures the signal activities and converts them into transactions.
6. UVM Scoreboard compares actual outputs against expected results to check for correctness.
7. UVM Coverage collects metrics to ensure all scenarios are tested.
Each component works together in the testbench to verify the functionality of the DUT, flagging any errors and providing comprehensive coverage metrics for verification completeness.
