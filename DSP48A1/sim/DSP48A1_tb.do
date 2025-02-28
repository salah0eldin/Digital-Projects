vlib work
vlog ../*.v ../*.sv
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all