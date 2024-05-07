`timescale 1ns / 1ps

module top_tb;

    parameter WIDTH = 4;

    logic clk;
    logic rst;
    logic start;
    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic [6:0] val_one;
    logic [6:0] val_ten;
    logic [6:0] rem_one;
    logic [6:0] rem_ten;

    top #(
        .WIDTH(WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .val_one(val_one),
        .val_ten(val_ten),
        .rem_one(rem_one),
        .rem_ten(rem_ten)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        start = 0;
        a = 0;
        b = 0;

        #10 rst = 1;

        // Test case 1: 15 / 3 = 5 remainder 0
        #10 a = 15;
        b = 3;
        start = 1;
        #10 start = 0;
        #100;
        assert(val_one === 7'b1111001 && val_ten === 7'b1000000 && rem_one === 7'b1000000 && rem_ten === 7'b1000000)
            $display("Test case 1 passed");
        else
            $display("Test case 1 failed");

        // Test case 2: 10 / 4 = 2 remainder 2
        #10 a = 10;
        b = 4;
        #10 start = 1;
        #10 start = 0;
        #100;
        assert(val_one === 7'b0100100 && val_ten === 7'b1000000 && rem_one === 7'b0100100 && rem_ten === 7'b1000000)
            $display("Test case 2 passed");
        else
            $display("Test case 2 failed");

        // Test case 3: 7 / 0 (divide by zero)
        #10 a = 7;
        b = 0;
        #10 start = 1;
        #10 start = 0;
        #100;
        assert(val_one === 7'b0011000 && val_ten === 7'b0011000 && rem_one === 7'b0011000 && rem_ten === 7'b0011000)
            $display("Test case 3 passed");
        else
            $display("Test case 3 failed");

        // Test case 4: 0 / 5 = 0 remainder 0
        #10 a = 0;
        b = 5;
        #10 start = 1;
        #10 start = 0;
        #100;
        assert(val_one === 7'b1000000 && val_ten === 7'b1000000 && rem_one === 7'b1000000 && rem_ten === 7'b1000000)
            $display("Test case 4 passed");
        else
            $display("Test case 4 failed");

        #10 $finish;
    end

endmodule

