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

    // Ram Signals
    wire tx_valid;                       // Becomes HIGH when data is ready to be read
    wire [MEM_WORD_SIZE-1:0] tx_data;    // Data input from Memory
    wire rx_valid;                      // Becoms HIGH when sending data to Memory
    reg [MEM_INPUT_SIZE-1:0] rx_data;   // Data output to Memory

    // RAM
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

    // SPI Slave Interface
    // States
    localparam IDLE         = 0;    // Idle state
    localparam TAKE_INPUT   = 1;    // Takes 11 bits first dump and 10 data
    localparam WRITE_MEM    = 2;    // Writes input data to memory
    localparam WRITE_OUT    = 3;    // Writes memory output to MISO

    // Registers
    (* fsm_encoding = "gray" *)
    reg [1:0] cs, ns;

    // Counter
    reg [3:0] counter;

    // State Memory
    always @(posedge clk)
    begin
        if(~rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    // Next State Logic
    always @(*)
    begin
        if(~rst_n) begin
            ns = IDLE;
        end
        else begin
            case(cs)
                IDLE: begin
                    if(~SS_n)
                        ns = TAKE_INPUT;
                    else
                        ns = IDLE;
                end
                TAKE_INPUT: begin
                    if(counter >= 10)
                        ns = WRITE_MEM;
                    else
                        ns = TAKE_INPUT;
                end
                WRITE_MEM: begin
                    if(rx_data[9:8] == 2'b11 && tx_valid)
                        ns = WRITE_OUT;
                    else if(SS_n == 1)
                        ns = IDLE;
                    else
                        ns = WRITE_MEM;
                end
                WRITE_OUT: begin
                    if(SS_n == 1)
                        ns = IDLE;
                    else
                        ns = WRITE_OUT;
                end
                default: ns = IDLE;
            endcase
        end
    end

    // Output Logic
    always @(posedge clk) begin
        if(~rst_n)begin
            counter <= 4'b0;
            MISO <= 0;
        end
        else begin
            MISO <= 0;
            case(cs)
                IDLE: begin
                    counter <= 0;
                end
                TAKE_INPUT: begin
                    rx_data <= {rx_data[MEM_INPUT_SIZE-2:0], MOSI};
                    counter <= counter + 1;
                end
                WRITE_MEM: begin
                    counter <= 0;
                end
                WRITE_OUT: begin
                    if(counter < 8) begin
                        MISO <= tx_data[7-counter];
                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end

    assign rx_valid = (cs == WRITE_MEM);


endmodule
