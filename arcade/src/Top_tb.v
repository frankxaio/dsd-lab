`timescale 1ns / 1ps

module Top_tb;

    // Inputs
    reg clk;
    reg rstn;
    reg restart;
    reg [6:0] dip;
    reg start;
    reg stop;

    // Outputs
    wire [6:0] guess;
    wire [6:0] led;
    wire [6:0] one;
    wire [6:0] ten;
    wire [6:0] hundred;

    // Instantiate the Unit Under Test (UUT)
    Top uut (
        .clk(clk),
        .rstn(rstn),
        .restart(restart),
        .dip(dip),
        .start(start),
        .stop(stop),
        .guess(guess),
        .led(led),
        .one(one),
        .ten(ten),
        .hundred(hundred)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rstn = 0;
        restart = 0;
        dip = 0;
        start = 0;
        stop = 0;

        // Reset the module
        #10 rstn = 1;

        // Test case 1: Set number and start
        #20 dip = 7'b1010101;
        #10 start = 1;
        #10 start = 0;

        // Test case 2: Stop and check result
        #100 stop = 1;
        #10 stop = 0;
        #10;
        if (guess == dip)
            $display("Test case 2 passed!");
        else
            $display("Test case 2 failed!");

        // Test case 3: Restart and set a new number
        #20 restart = 1;
        #10 restart = 0;
        #20 dip = 7'b0101010;
        #10 start = 1;
        #10 start = 0;

        // Test case 4: Stop and check result
        #100 stop = 1;
        #10 stop = 0;
        #10;
        if (guess == dip)
            $display("Test case 4 passed!");
        else
            $display("Test case 4 failed!");

        // Test case 5: Set number and start, check sum
        #20 dip = 7'b1100110;
        #10 start = 1;
        #10 start = 0;
        #10;
        if (uut.sum == 4)
            $display("Test case 5 passed!");
        else
            $display("Test case 5 failed!");

        // Test case 6: Stop and check init_val
        #100 stop = 1;
        #10 stop = 0;
        #10;
        if (uut.init_val_cs == 9'd196)
            $display("Test case 6 passed!");
        else
            $display("Test case 6 failed!");

        // End the simulation
        #20 $finish;
    end

    // Monitor the outputs
    always @(posedge clk) begin
        $display("Time: %0t, State: %b, DIP: %b, Guess: %b, LED: %b, One: %b, Ten: %b, Hundred: %b",
                 $time, uut.cs, dip, guess, led, one, ten, hundred);
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, Top_tb);
    end

endmodule

