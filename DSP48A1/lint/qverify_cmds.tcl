configure output directory D:/Learning/DigitalKareem/Projects/DSP48A1/lint
clear settings -lib
configure output directory D:/Learning/DigitalKareem/Projects/DSP48A1/lint
clear directives
vlib work
vmap work work
vlog D:/Learning/DigitalKareem/Projects/DSP48A1/DFF.v D:/Learning/DigitalKareem/Projects/DSP48A1/DSP48A1.v D:/Learning/DigitalKareem/Projects/DSP48A1/DSP48A1_tb.v -work work
lint methodology soc -goal start
configure output directory D:/Learning/DigitalKareem/Projects/DSP48A1/lint
clear directives
lint methodology soc -goal start
lint run -d DSP48A1 -L work
clear directives
