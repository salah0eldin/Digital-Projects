module single_port_async_ram_tb;

    // Parameters
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    parameter INPUT_SIZE = 10;
    parameter WORD_SIZE = 8;

    // Signals
    reg [INPUT_SIZE-1:0] din;
    reg clk;
    reg rst_n;
    reg rx_valid;
    wire [WORD_SIZE-1:0] dout;
    wire tx_valid;

    // Instantiate the DUT (Device Under Test)
    single_port_async_ram #(
                              .MEM_DEPTH(MEM_DEPTH),
                              .ADDR_SIZE(ADDR_SIZE),
                              .INPUT_SIZE(INPUT_SIZE),
                              .WORD_SIZE(WORD_SIZE)
                          ) dut (
                              .din(din),
                              .clk(clk),
                              .rst_n(rst_n),
                              .rx_valid(rx_valid),
                              .dout(dout),
                              .tx_valid(tx_valid)
                          );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        din = 0;
        rx_valid = 0;

        // Reset the DUT
        #10;
        rst_n = 1;

        // Write address 0x01
        #10;
        din = 10'b0000000001; // Write address 0x01
        rx_valid = 1;
        #10;
        rx_valid = 0;

        // Write data 0xAA to address 0x01
        #10;
        din = 10'b0100001010; // Write data 0x0A
        rx_valid = 1;
        #10;
        rx_valid = 0;

        // Read address 0x01
        #10;
        din = 10'b1000000001; // Read address 0x01
        rx_valid = 1;
        #10;
        rx_valid = 0;

        // Read data from address 0x01
        #10;
        din = 10'b1100000000; // Read data
        rx_valid = 1;
        #10;
        rx_valid = 0;

        // Wait for tx_valid to go high and check the output
        #10;
        if (tx_valid && dout == 8'h0A) begin
            $display("Test Passed: Data read correctly from address 0x01");
        end else begin
            $display("Test Failed: Incorrect data read from address 0x01");
        end

        // Finish the simulation
        #10;
        $stop;
    end

endmodule
