/**
* * This module is for submission of the project, it needs debug core as required
* * but this added an extra not needed clock cycle when reading data because of 
* * vivado negative hold stack which is not even logical but couldn't resolve it
* * so sacrificing the extra clock when debugging only
  */

module spi_slave_interface_2
    #(
         parameter MEM_DEPTH = 256,
         parameter MEM_ADDR_SIZE = 8,
         parameter MEM_INPUT_SIZE = 10,
         parameter MEM_WORD_SIZE = 8
     )
     (
         input wire MOSI,   // Master Out Slave In
         output reg MISO,   // Master In Slave Out
         input wire clk,    // Serial Clock
         input wire SS_n,   // Slave Select
         input wire rst_n   // Active low synchronous reset
     );

    //// ! Ram Signals
    wire tx_valid;                      // Becomes HIGH when data is ready to be read
    wire [MEM_WORD_SIZE-1:0] tx_data;   // Data input from Memory
    reg rx_valid;                       // Becoms HIGH when sending data to Memory
    reg [MEM_INPUT_SIZE-1:0] rx_data;   // Data output to Memory

    //// ! RAM
    single_port_async_ram #(
                              .MEM_DEPTH(MEM_DEPTH),
                              .ADDR_SIZE(MEM_ADDR_SIZE),
                              .INPUT_SIZE(MEM_INPUT_SIZE),
                              .WORD_SIZE(MEM_WORD_SIZE)
                          ) ram (
                              .din(rx_data),
                              .clk(clk),
                              .rst_n(rst_n),
                              .rx_valid(rx_valid),
                              .dout(tx_data),
                              .tx_valid(tx_valid)
                          );

    //// ! SPI Slave Interface

    // States
    localparam IDLE         = 0;    // Idle state
    localparam CHK_CMD      = 1;    // Takes one MOSI input
    localparam WRITE        = 2;    // Writes address/data is being sent to RAM
    localparam READ_ADD     = 3;    // Read address is being sent to RAM
    localparam READ_DATA    = 4;    // Read data is being saved then sent to MISO

    // Registers for current state (cs) and next state (ns)
    (* fsm_encoding = "one_hot" *)
    reg [2:0] cs, ns;

    // Counter to keep track of bits received or transmitted
    reg [4:0] counter;

    // Flag to indicate a read operation
    reg READ_OP;

    // # State Memory: Sequential logic to update the current state
    always @(posedge clk)
    begin
        if(~rst_n)
            cs <= IDLE;  // Reset to IDLE state
        else
            cs <= ns;    // Update to next state
    end

    // # Next State Logic: Combinational logic to determine the next state
    always @(*)
    begin
        if(~rst_n) begin
            ns = IDLE;                      // Reset to IDLE state
        end
        else begin
            case(cs)
                IDLE: begin
                    if(~SS_n)
                        ns = CHK_CMD;       // Move to CHK_CMD state if Slave Select is active
                    else
                        ns = IDLE;          // Remain in IDLE state
                end
                CHK_CMD: begin
                    if(MOSI == 0)
                        ns = WRITE;         // Move to WRITE state if MOSI is 0 (Write operation)
                    else begin
                        if(READ_OP)
                            ns = READ_DATA; // Move to READ_DATA state if READ_OP is set (Address received before)
                        else
                            ns = READ_ADD;  // Move to READ_ADD state otherwise (Address receiveing)
                    end
                end
                WRITE: begin
                    if(SS_n)
                        ns = IDLE;          // Move to IDLE state if Slave Select is inactive
                    else
                        ns = WRITE;         // Remain in WRITE state
                end
                READ_ADD: begin
                    if(SS_n)
                        ns = IDLE;          // Move to IDLE state if Slave Select is inactive
                    else
                        ns = READ_ADD;      // Remain in READ_ADD state
                end
                READ_DATA: begin
                    if(SS_n)
                        ns = IDLE;          // Move to IDLE state if Slave Select is inactive
                    else
                        ns = READ_DATA;     // Remain in READ_DATA state
                end
                default: ns = IDLE;         // Default to IDLE state
            endcase
        end
    end

    // # Output Logic: Sequential logic to generate outputs based on the current state
    always @(posedge clk) begin
        if(~rst_n)begin
            counter <= 4'b0;
            MISO <= 0;
            READ_OP <= 0;
        end
        else begin
            MISO <= 0;                  // Default MISO to 0
            rx_valid <= 0;              // Default rx_valid to 0
            case(cs)
                IDLE: begin
                    // No operation in IDLE state
                end
                CHK_CMD: begin
                    counter <= 0;       // Reset counter in CHK_CMD state
                end
                WRITE: begin
                    if(counter >= 10)
                        rx_valid <= 1;  // Set rx_valid when 10 bits are received
                    else begin
                        rx_data <= {rx_data[MEM_INPUT_SIZE-2:0], MOSI};  // Shift in MOSI data
                        rx_valid <= 0;
                        counter <= counter + 1;
                    end
                end
                READ_ADD: begin
                    READ_OP <= 1;       // Set READ_OP flag as Address is received
                    if(counter >= 10) begin // ! this could be only 9 but for vivado negative hold stack became 10
                        rx_valid <= 1;  // Set rx_valid when 10 bits are received
                    end
                    else begin
                        rx_data <= {rx_data[MEM_INPUT_SIZE-2:0], MOSI};  // Shift in MOSI data
                        rx_valid <= 0;
                        counter <= counter + 1;
                    end
                end
                READ_DATA: begin
                    READ_OP <= 0;       // Clear READ_OP flag as Data is received
                    if(counter >= 18) begin
                        // No operation when counter exceeds 18
                    end
                    else if(counter >= 10) begin
                        rx_valid <= 1;      // Set rx_valid when 10 bits are received
                        if(tx_valid) begin  // If tx_valid is HIGH (Data received from RAM), then send data to MISO
                            counter <= counter + 1;
                            MISO <= tx_data[17-counter];  // Send data on MISO
                        end
                    end
                    else begin
                        rx_data <= {rx_data[MEM_INPUT_SIZE-2:0], MOSI};  // Shift in MOSI data
                        counter <= counter + 1;
                        if(counter >= 10)
                            rx_valid <= 1;  // Set rx_valid when 10 bits are received to pass to RAM
                    end
                end
                default: begin
                    rx_valid <= 0;
                    MISO <= 0;
                    counter <= 0;
                end
            endcase
        end
    end

endmodule
