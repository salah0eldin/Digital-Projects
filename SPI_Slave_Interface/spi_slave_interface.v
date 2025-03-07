/**
* * This module is best optimized for the project, it has the best performance no need 
* * for extra clock cycle when reading data as i didn't add a debug core for this project 
* * in vivado constraints, also changed the FSM as shown in the ./SPI_Slave_Interface/Files/FSM_screen.png
  */

module spi_slave_interface
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
    wire tx_valid;                       // Becomes HIGH when data is ready to be read
    wire [MEM_WORD_SIZE-1:0] tx_data;    // Data input from Memory
    wire rx_valid;                      // Becoms HIGH when sending data to Memory
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
    localparam IDLE             = 0;    // Idle state
    localparam TAKE_INPUT       = 1;    // Takes 11 bits first dump and 10 data
    localparam WRITE_MEM_OUT    = 2;    /* Writes input data to memory and
                                           if Read operation is requested, then sends data to MISO */

    // Registers
    (* fsm_encoding = "gray" *)
    reg [1:0] cs, ns;   // Current state and next state

    // Counter
    reg [3:0] counter;  // 4-bit counter to count bits received

    // # State Memory
    always @(posedge clk)
    begin
        if(~rst_n)
            cs <= IDLE;     // Reset to IDLE state
        else
            cs <= ns;       // Transition to next state
    end

    // # Next State Logic
    always @(*)
    begin
        if(~rst_n) begin
            ns = IDLE;  // Reset to IDLE state
        end
        else begin
            case(cs)
                IDLE: begin
                    if(~SS_n)
                        ns = TAKE_INPUT;    // Move to TAKE_INPUT state if Slave Select is active
                    else
                        ns = IDLE;          // Remain in IDLE state
                end
                TAKE_INPUT: begin
                    if(counter >= 10)
                        ns = WRITE_MEM_OUT; // Move to WRITE_MEM_OUT state if 10 bits are received
                    else
                        ns = TAKE_INPUT;    // Remain in TAKE_INPUT state
                end
                WRITE_MEM_OUT: begin
                    if(SS_n == 1)
                        ns = IDLE;          // Move to IDLE state if Slave Select is inactive
                    else
                        ns = WRITE_MEM_OUT; // Remain in WRITE_MEM_OUT state
                end
                default: ns = IDLE;         // Default to IDLE state
            endcase
        end
    end

    // # Output Logic
    always @(posedge clk) begin
        if(~rst_n)begin
            counter <= 4'b0;
            MISO <= 0;
        end
        else begin
            MISO <= 0;  // Default MISO to 0
            case(cs)
                IDLE: begin
                    counter <= 0;               // Reset counter in IDLE state
                end
                TAKE_INPUT: begin
                    rx_data <= {rx_data[MEM_INPUT_SIZE-2:0], MOSI};  // Shift in MOSI data
                    counter <= counter + 1;
                end
                WRITE_MEM_OUT: begin
                    if(rx_data[9:8] == 2'b11 && tx_valid) begin // Check if read operation and data is valid
                        if(counter < 8) begin
                            MISO <= tx_data[7-counter];         // Output data bit by bit on MISO
                            counter <= counter + 1;
                        end
                    end else begin
                        counter <= 0;  // Reset counter
                    end
                end
                default begin
                    counter <= 0;
                end
            endcase
        end
    end

    assign rx_valid = (cs == WRITE_MEM_OUT);  // rx_valid is high in WRITE_MEM_OUT state

endmodule
