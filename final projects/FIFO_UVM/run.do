vlib work
vlog *v +cover
vsim -voptargs=+acc work.FIFO_Top -classdebug -uvmcontrol=all -cover
add wave /FIFO_Top/FIFOif/*
coverage save FIFO_Top.ucdb -onexit
run -all
quit -sim
vcover report FIFO_Top.ucdb -details -annotate -all -output coverage.txt