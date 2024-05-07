module top #(
    parameter WIDTH = 4
) (
    input clk,
    input rst,
    input start,  //! 開始計算
    input [WIDTH-1:0] a,  //! 除數
    input [WIDTH-1:0] b,  //! 被除數 
    output logic [6:0] val_one,  //! 商的個位數
    output logic [6:0] val_ten,  //! 商的十位數
    output logic [6:0] rem_one,  //! 餘數的個位數
    output logic [6:0] rem_ten  //! 餘數的十位數
);

    parameter IDLE = 2'b00, VALID = 2'b01, DBZ = 2'b10;
    logic [WIDTH-1:0] val, rem, val_i, rem_i;  // result value: quotient, result: remainder
    logic [6:0] val_one_i, val_ten_i, rem_one_i, rem_ten_i;
    logic [6:0] val_one_ov, val_ten_ov, rem_one_ov, rem_ten_ov;
    logic dbz, valid;  // divide by zero
    logic [1:0] cs, ns;
    logic [6:0] val_one_ns, val_ten_ns, rem_one_ns, rem_ten_ns;


    divu_int #(
        .WIDTH(WIDTH)
    ) u0 (
        .clk(clk),
        .rstn(rst),
        .start(start),
        .busy(),
        .done(),
        .valid(valid),
        .dbz(dbz),
        .a(a),
        .b(b),
        .val(val_i),
        .rem(rem_i)
    );

    scan u2 (
        .dipsw7({4'b0000, val_i}),
        .one(val_one_i),
        .ten(val_ten_i),
        .hundred()
    );

    scan u3 (
        .dipsw7({4'b0000, rem_i}),
        .one(rem_one_i),
        .ten(rem_ten_i),
        .hundred()
    );

    scan u4 (
        .dipsw7(8'd99),
        .one(val_one_ov),
        .ten(val_ten_ov),
        .hundred()
    );

    scan u5 (
        .dipsw7(8'd99),
        .one(rem_one_ov),
        .ten(rem_ten_ov),
        .hundred()
    );

    always_comb begin
        if (cs == VALID) begin
            val_one_ns = val_one_i;
            val_ten_ns = val_ten_i;
            rem_one_ns = rem_one_i;
            rem_ten_ns = rem_ten_i;
        end else if (cs == IDLE) begin
            if (dbz) begin
                val_one_ns = val_one_ov;
                val_ten_ns = val_ten_ov;
                rem_one_ns = rem_one_ov;
                rem_ten_ns = rem_ten_ov;
            end else begin
                val_one_ns = val_one;
                val_ten_ns = val_ten;
                rem_one_ns = rem_one;
                rem_ten_ns = rem_ten;
            end
        end else begin
            val_one_ns = val_one;
            val_ten_ns = val_ten;
            rem_one_ns = rem_one;
            rem_ten_ns = rem_ten;
        end
    end

    always_ff @(posedge clk, negedge rst) begin
        if (!rst) begin
            val_one <= 7'b1000000;
            val_ten <= 7'b1000000;
            rem_one <= 7'b1000000;
            rem_ten <= 7'b1000000;
        end else begin
            val_one <= val_one_ns;
            val_ten <= val_ten_ns;
            rem_one <= rem_one_ns;
            rem_ten <= rem_ten_ns;
        end
    end


    always_ff @(posedge clk, negedge rst) begin
        if (!rst) begin
            cs <= IDLE;
        end else begin
            cs <= ns;
        end
    end

    always_comb begin
        case (cs)
            IDLE: ns = valid ? VALID : IDLE;
            VALID: ns = start ? IDLE : VALID;
            default: ns = IDLE;
        endcase
    end

endmodule
