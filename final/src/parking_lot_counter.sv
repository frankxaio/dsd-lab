`timescale 1ns / 1ps

module parking_lot_counter (
    input clk,
    input rst_n,
    input a,
    input b,
    output logic enter,
    output logic exit,
    output logic [7:0] led
);
    logic [31:0] timer;
    logic led_mode;

    //FSM declarations
    typedef enum {
        START,
        ENTER1,
        ENTER2,
        ENTER3,
        ENTERED,
        EXIT1,
        EXIT2,
        EXIT3,
        EXITED
    } state_t;
    state_t state_reg, state_nxt;

    //FSM register operations
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) state_reg <= START;
        else state_reg <= state_nxt;
    end

    //FSM next-state and output logics
    always_comb begin
        state_nxt = state_reg;
        enter = 0;
        exit = 0;
        case (state_reg)
            /*00*/ START: begin
                led_mode = 0;
                if (a && !b) state_nxt = ENTER1;
                else if (!a && b) state_nxt = EXIT1;
            end
            /*10*/ ENTER1: begin
                led_mode = 0;
                if (!a && !b) state_nxt = START;
                else if (a && b) state_nxt = ENTER2;
            end
            /*11*/ ENTER2: begin
                led_mode = 0;
                if (a && !b) state_nxt = ENTER1;
                else if (!a && b) state_nxt = ENTER3;
            end
            /*01*/ ENTER3: begin
                led_mode = 0;
                if (a && b) state_nxt = ENTER2;
                else if (!a && !b) state_nxt = ENTERED;
            end
            /*00*/ ENTERED: begin
                led_mode = 0;
                enter = 1;
                state_nxt = START;
            end
            /*01*/ EXIT1: begin
                led_mode = 0;
                if (!a && !b) state_nxt = START;
                else if (a && b) state_nxt = EXIT2;
            end
            /*11*/ EXIT2: begin
                led_mode = 1;
                if (!a && b) state_nxt = EXIT1;
                else if (a && !b) state_nxt = EXIT3;
            end
            /*10*/ EXIT3: begin
                led_mode = 1;
                if (a && b) state_nxt = EXIT2;
                else if (!a && !b) state_nxt = EXITED;
            end
            /*00*/ EXITED: begin
                led_mode = 1;
                exit = 1;
                state_nxt = START;
            end
            default: state_nxt = START;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) timer <= 32'd0;  // when the reset signal valid,time counter clearing
        else if (timer == 32'd28_999_999)  // 4 seconds count(50M*4-1=199999999)
            timer <= 32'd0;  // count done,clearing the time counter
        else timer <= timer + 1'b1;  // timer counter = timer counter + 1
    end

    assign led = (led_mode && timer >= 32'd24_999_999) ? 8'b10000011 :  // LED7,8亮
        (led_mode && timer >= 32'd22_499_999) ? 8'b00000111 :  // LED6,7,8亮
        (led_mode && timer >= 32'd19_999_999) ? 8'b00001110 :  // LED5,6,7亮
        (led_mode && timer >= 32'd17_499_999) ? 8'b00011100 :  // LED4,5,6亮
        (led_mode && timer >= 32'd14_999_999) ? 8'b00111000 :  // LED3,4,5亮
        (led_mode && timer >= 32'd12_499_999) ? 8'b01110000 :  // LED2,3,4亮
        (led_mode && timer >= 32'd9_999_999) ? 8'b11100000 :  // LED1,2,3亮
        (led_mode && timer >= 32'd7_499_999) ? 8'b11000000 :  // LED1,2亮
        (led_mode && timer >= 32'd4_999_999) ? 8'b00000011 :  // LED7,8亮
        (led_mode && timer >= 32'd2_499_999) ? 8'b00000111 :  // LED6,7,8亮
        (led_mode && timer >= 32'd1_999_999) ? 8'b00001110 :  // LED5,6,7亮
        (led_mode && timer >= 32'd1_499_999) ? 8'b00011100 :  // LED4,5,6亮
        (led_mode && timer >= 32'd999_999) ? 8'b00111000 :  // LED3,4,5亮
        (led_mode && timer >= 32'd499_999) ? 8'b01110000 :  // LED2,3,4亮
        (led_mode && timer >= 32'd249_999) ? 8'b11000000 :  // LED1,2亮
        (led_mode) ? 8'b00000000 :  // 全滅
        8'b00000000;  // 全滅



endmodule
