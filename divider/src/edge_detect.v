module edge_detect
    (
        input clk,
        input anrst,
        input  in,
        output reg rising,
        output reg falling,
        output reg both
    );

    // data delay line
    reg in_d = 1'b0;
    always @(posedge clk or negedge anrst) begin
        if ( ~anrst ) begin
            in_d <= 1'b0;
        end
        else begin
            in_d <= in;
        end
    end

    always @(*) begin
        rising = (in & ~in_d);
        falling = (~in & in_d);
        both = rising | falling;
    end

endmodule
