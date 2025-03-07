module spi_slave_interface_2_tb;

    // Parameters
    parameter MEM_DEPTH = 256;
    parameter MEM_ADDR_SIZE = 8;
    parameter MEM_INPUT_SIZE = 10;
    parameter MEM_WORD_SIZE = 8;

    // Signals
    reg MOSI;
    wire MISO;
    reg clk;
    reg SS_n;
    reg rst_n;
    reg [7:0] out;
    reg [7:0] expected;

    // Instantiate the DUT (Device Under Test)
    spi_slave_interface_2 #(
        .MEM_DEPTH(MEM_DEPTH),
        .MEM_ADDR_SIZE(MEM_ADDR_SIZE),
        .MEM_INPUT_SIZE(MEM_INPUT_SIZE),
        .MEM_WORD_SIZE(MEM_WORD_SIZE)
    ) dut (
        .MOSI(MOSI),
        .MISO(MISO),
        .clk(clk),
        .SS_n(SS_n),
        .rst_n(rst_n)
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
        MOSI = 0;
        SS_n = 1;
        expected = 0;
        out = 0;

        // Reset the DUT
        @(negedge clk);
        rst_n = 1;

        // Write address 0x01
        SS_n = 0;
        send_data(10'b0000000001); // Write address 0x01
        @(negedge clk);
        SS_n = 1;

        // Write data 0x0A to address 0x01
        @(negedge clk);
        @(negedge clk);
        SS_n = 0;
        send_data(10'b0100001010); // Write data 0x0A
        expected = 8'b00001010;
        @(negedge clk);
        SS_n = 1;

        // Read address 0x01
        @(negedge clk);
        @(negedge clk);
        SS_n = 0;
        send_data(10'b1000000001); // Read address 0x01
        @(negedge clk);
        SS_n = 1;

        // Read data from address 0x01
        @(negedge clk);
        @(negedge clk);
        SS_n = 0;
        send_data(10'b1100000000); // Read data
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        get_data();
        @(negedge clk);
        SS_n = 1;

        // Wait for tx_valid to go high and check the output
        @(posedge clk);
        if (out == 8'h0A) begin
            $display("Test Passed: Data read correctly from address 0x01 expected %d, got %d", expected, out);
        end else begin
            $display("Test Failed: Incorrect data read from address 0x01 expected %d, got %d", expected, out);
        end

        // Finish the simulation
        @(negedge clk);
        $finish;
    end

    // Task to send data to the DUT
    task send_data(input [9:0] data);
        integer i;
        begin
            @(negedge clk);
            MOSI = data[9];
            @(negedge clk);
            for (i = 9; i >= 0; i = i - 1) begin
                MOSI = data[i];
                @(negedge clk);
            end
        end
    endtask

    task get_data();
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                out[i] = MISO;
                @(negedge clk);
            end
        end
    endtask

endmodule
