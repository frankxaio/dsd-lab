module Pseudo_Random(
        input clk,
        input rstn,
        output reg [7:0] random_num
    );

    reg [31:0] counter;
    reg [6:0] lfsr;
    wire [3:0] div = 4'd9;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            counter <= 32'd0;
            lfsr <= 7'b1000000; // Initialize LFSR with a non-zero value
        end
        else begin
            // counter == 32'd900000000
            if (counter == 32'd40000000) begin // assuming 100MHz clock, this is 1 second
                counter <= 32'd0;
                lfsr <= {lfsr[5:0], lfsr[6] ^ lfsr[5]}; // LFSR update
                random_num <= {4'b0, lfsr[3:0] % div + 1'b1}; // generate a new random number between 1 and 9
            end
            else begin
                counter <= counter + 1;
            end
        end
    end


endmodule
