`timescale 1ns / 1ps

module top (
    input clk,
    input rst_n,
    input a,  // a 是最右邊的按鈕
    input b,
    output [7:0] led,
    output logic [6:0] seg_out0,
    output logic [6:0] seg_out1,
    output logic [6:0] seg_out2,
    output logic [6:0] seg_out3,
    output logic [6:0] seg_out4,
    output logic [6:0] seg_out5
    // output [7:0] seg_out,
    // output [5:0] sel_out,
);
    logic [3:0] mod_16_reg = 0;
    logic [3:0] mod_16_nxt;
    logic a_db, b_db, enter, exit;
    logic [3:0] in0, in1, seg_disp;
    logic is_full;

    //debounce the button "a" and "b" first
    debouncing_button db_m0 (
        .clk(clk),
        .rst_n(rst_n),
        .sw_low(a),  //active low
        .db(a_db)  //active high
    );
    debouncing_button db_m1 (
        .clk(clk),
        .rst_n(rst_n),
        .sw_low(b),  //active low
        .db(b_db)  //active high
    );

    // instantiation of lot-counter circuit
    parking_lot_counter lot_m0 (
        .clk(clk),
        .rst_n(rst_n),
        .a(a_db),
        .b(b_db),
        .enter(enter),
        .exit(exit),
        .led(led)
    );

    //Mod-16 counter that increments/decrements based on the tick of enter/exit
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) mod_16_reg <= 0;
        else mod_16_reg <= mod_16_nxt;
    end
    assign mod_16_nxt = enter ? mod_16_reg - 1 : (exit ? mod_16_reg + 1 : mod_16_reg);

    assign seg_disp = mod_16_reg;
    assign is_full = (seg_disp == 4'd0) ? 1 : 0;

    scan scan_m0 (.*);

    //Instantiation of LED-mux module
    // LED_mux led_mux (
    //     .clk(clk),
    //     .rst(rst_n),
    //     .in0(in0),
    //     .in1(in1),
    //     .in2(0),
    //     .in3(0),
    //     .in4(0),
    //     .in5(0),
    //     .seg_out(seg_out),
    //     .sel_out(sel_out)
    // );

endmodule
