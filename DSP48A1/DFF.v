module DFF
    #(
         parameter WIDTH = 1,
         parameter RSTTYPE = "ASYNC"
     )
     (
         input wire clk,
         input wire rst,
         input wire en,
         input wire [WIDTH-1:0] d,
         output reg [WIDTH-1:0] q
     );

    generate
        if (RSTTYPE == "ASYNC") begin
            always @(posedge clk or posedge rst) begin
                if (rst) begin
                    q <= 0;
                end else if (en) begin
                    q <= d;
                end
            end
        end else begin
            always @(posedge clk) begin
                if (rst) begin
                    q <= 0;
                end else if (en) begin
                    q <= d;
                end
            end
        end
    endgenerate

endmodule
