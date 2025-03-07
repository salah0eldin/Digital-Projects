module single_port_async_ram
    #(
         parameter MEM_DEPTH = 256,
         parameter ADDR_SIZE = 8,
         parameter INPUT_SIZE = 10,
         parameter WORD_SIZE = 8
     )
     (
         input wire [INPUT_SIZE-1:0] din,    // Data input most 2 significant bits defines the operation
         /**
          * # din[9:8] Operation (most 2 significant bits)
          * ? Write operation:
          * * 00: Hold din as write address
          * * 01: Write din as data in write address
          * ? Read operation:
          * * 10: Hold din as read address
          * * 11: Read data from read address and tx_valid should be HIGH

          * ? Note that the most significant bit determines the operation if read or write.
         */

         input wire clk,                    // Clock
         input wire rst_n,                  // Active low synchronous reset
         input wire rx_valid,               // If HIGH: accept din to save address or write memory
         output reg [WORD_SIZE-1:0] dout,   // Data output
         output reg tx_valid                // Becomes HIGH when data is ready to be read
     );

    // Memory
    reg [WORD_SIZE-1:0] mem [0:MEM_DEPTH-1];

    // Address registers
    reg [ADDR_SIZE-1:0] addr_wr_reg;
    reg [ADDR_SIZE-1:0] addr_rd_reg;

    always @(posedge clk) begin
        if (~rst_n) begin
            addr_wr_reg <= 0;
            addr_rd_reg <= 0;
            dout <= 0;
            tx_valid <= 0;
        end else begin
            if(rx_valid)  // If rx_valid is HIGH, then do the operation
            begin
                case (din[INPUT_SIZE-1:INPUT_SIZE-2])
                    2'b00: begin
                        addr_wr_reg <= din[WORD_SIZE-1:0];
                        tx_valid <= 0;
                    end
                    2'b01: begin
                        mem[addr_wr_reg] <= din[WORD_SIZE-1:0];
                        tx_valid <= 0;
                    end
                    2'b10: begin
                        addr_rd_reg <= din[WORD_SIZE-1:0];
                        tx_valid <= 0;
                    end
                    2'b11: begin
                        dout <= mem[addr_rd_reg];
                        tx_valid <= 1;
                    end
                endcase
            end
        end
    end

endmodule
