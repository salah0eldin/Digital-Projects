vlib work
vlog ../*.v
vsim -voptargs=+acc work.single_port_async_ram_tb
add wave *
run -all