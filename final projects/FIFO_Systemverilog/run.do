vlib work
vlog FIFO_if.sv Top.sv FIFO.sv FIFO_tb.sv FIFO_monitor.sv FIFO_transaction.sv FIFO_coverage.sv FIFO_scoreboard.sv shared_pkg.sv +cover -covercells
vsim -voptargs=+acc work.Top -cover +ntb_random_seed=12345
vsim -voptargs=+acc work.Top -cover
add wave *
coverage save TOP.ucdb -onexit
