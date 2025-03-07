vlib work
vlog -work work +acc -cover bcesfx "../../*.v"
vsim -c -voptargs=+acc -coverage -do simulate.do -l simulation_log.txt work.spi_slave_interface_2_tb
vcd file simulation.vcd
vcd add -r /*
run -all
coverage save -onexit coverage.ucdb
quit -sim
vcover report -details -all -output coverage_report.txt coverage.ucdb
