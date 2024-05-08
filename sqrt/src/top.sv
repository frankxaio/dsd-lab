module top #(
    parameter WIDTH = 10
) (
    input clk,
    input rst,
    input start,  //! 開始計算
    input [WIDTH-1:0] rad,  //! radicand
    output logic [6:0] val_one,  //! root 個位數
    output logic [6:0] val_ten,  //! root 十位數
    output logic [6:0] rem_one,  //! 餘數的個位數
    output logic [6:0] rem_ten  //! 餘數的十位數
);
    logic [WIDTH-1:0] root, rem;

    sqrt_int #(
        .WIDTH(WIDTH)
    ) sqrt_int_inst (
        .clk  (clk),
        .start(~start),
        .busy (),
        .valid(valid),
        .rad  (rad),
        .root (root),
        .rem  (rem)
    );

    scan u2 (
        .dipsw7({4'b0000, root}),
        .one(val_one),
        .ten(val_ten),
        .hundred()
    );

    scan u3 (
        .dipsw7({4'b0000, rem}),
        .one(rem_one),
        .ten(rem_ten),
        .hundred()
    );

endmodule
