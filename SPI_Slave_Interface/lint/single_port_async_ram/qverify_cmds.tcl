configure output directory D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/lint/single_port_async_ram
clear settings -lib
configure output directory D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/lint/single_port_async_ram
clear directives
vlib work
vmap work work
vlog D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/single_port_async_ram.v D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/single_port_async_ram_tb.v D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/spi_slave_interface.v D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/spi_slave_interface_2.v D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/spi_slave_interface_tb.v -work work
lint methodology soc -goal start
configure output directory D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/lint/single_port_async_ram
clear directives
lint methodology soc -goal start
lint run -d single_port_async_ram -L work
clear directives
