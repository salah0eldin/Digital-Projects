set_property SRC_FILE_INFO {cfile:D:/Learning/DigitalKareem/Projects/DSP48A1/viva/DSP48A1.xdc rfile:../../../../../DSP48A1.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:5 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK]
