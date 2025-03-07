configure output directory D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/lint/spi_slave_interface
clear settings -lib
configure output directory D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/lint/spi_slave_interface
clear directives
vlib work
vmap work work
vlog D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/single_port_async_ram.v D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/single_port_async_ram_tb.v D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/spi_slave_interface.v -work work
lint methodology soc -goal start
configure output directory D:/Learning/DigitalKareem/Projects/SPI_Slave_Interface/lint/spi_slave_interface
clear directives
lint methodology soc -goal start
lint run -d spi_slave_interface -L work
clear directives
