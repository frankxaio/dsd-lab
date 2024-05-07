module Top (
        input clk,
        input rstn,
        input restart,
        input [6:0] dip,
        input start,
        input stop,
        output reg [6:0] guess,
        output reg [6:0] led,
        output [6:0] one,
        output [6:0] ten,
        output [6:0] hundred
    );

    parameter SET_NUM = 2'b00, GEN_NUM = 2'b01, SHOW_NUM = 2'b10;

    reg [7:0] init_val_ns, init_val_cs;
    wire [7:0] init_val_cs_wire;
    reg [1:0] cs, ns;
    wire [6:0] randnum, randnum_in;
    wire start_detect, stop_detect, restart_detect;
    reg [6:0] guess_init;
    wire [6:0] sum;
    reg [6:0] randnum_reg;

    Pseudo_Random u1 (
                      .clk(clk),
                      .rstn(rstn),
                      .random_num(randnum)
                  );

    assign init_val_cs_wire = init_val_cs;

    scan u2 (
             .dipsw7(init_val_cs_wire),
             .one(one),
             .ten(ten),
             .hundred(hundred)
         );

    scan u3 (
             .dipsw7(randnum),
             .one(randnum_in),
             .ten(),
             .hundred()
         );

    edge_detect u4 (
                    .clk(clk),
                    .anrst(rstn),
                    .in(start),
                    .falling(start_detect)
                );

    edge_detect u5 (
                    .clk(clk),
                    .anrst(rstn),
                    .in(stop),
                    .falling(stop_detect)
                );

    edge_detect u6 (
                    .clk(clk),
                    .anrst(rstn),
                    .in(restart),
                    .falling(restart_detect)
                );



    assign sum = dip[0] + dip[1] + dip[2] + dip[3] + dip[4] + dip[5] + dip[6];

    // LED control
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            led <= 7'b0000_0000;
        end
        else begin
            case (cs)
                SET_NUM:
                    led <= dip;
                default:
                    led <= led;
            endcase
        end
    end

    // guess_init
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            guess_init <= 0;
        else if(cs == SET_NUM) begin
            guess_init <= ~dip;
        end
        else
            guess_init <= guess_init;
    end

    // rando_num_reg
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            randnum_reg <= 0;
        else if (ns == SHOW_NUM)
            randnum_reg <= randnum_in;
        else if (cs == SET_NUM)
            randnum_reg <= 0;
        else
            randnum_reg <= randnum_reg;
    end


    // guess
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            guess <= ~dip;
        else begin
            case(cs)
                SET_NUM:
                    guess <= ~dip;
                GEN_NUM: begin
                    guess <= randnum_in;
                end
                SHOW_NUM:
                    guess <= guess;
                default:
                    guess <= guess;
            endcase
        end
    end


    reg sum_flag;
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            sum_flag <=0;
        else if (cs == SET_NUM && ns == GEN_NUM)
            sum_flag <=1;
        else if (cs == GEN_NUM)
            sum_flag <= 0;
        else
            sum_flag <=sum_flag;
    end

    reg correct_flag;
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            correct_flag <= 0;
        else if (cs == GEN_NUM && ns == SHOW_NUM && (guess_init == randnum_in))
            correct_flag <= 1;
        else
            correct_flag <= 0;
    end


    // init_val
    always @(*) begin
        case (cs)
            SET_NUM:
                init_val_ns = init_val_cs;
            GEN_NUM:
                if (sum_flag)
                    init_val_ns = init_val_cs - sum;
                else
                    init_val_ns = init_val_cs;
            SHOW_NUM:
                if (correct_flag)
                    init_val_ns = init_val_cs + 2*dip[0] + 2*dip[1] + 2*dip[2] + 2*dip[3] + 2*dip[4] + 2*dip[5] + 2*dip[6];
                else
                    init_val_ns = init_val_cs;
            default:
                init_val_ns = init_val_cs;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            init_val_cs <=9'd200;
        else
            init_val_cs <= init_val_ns;
    end

    // State machine
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cs <= SET_NUM;
        end
        else begin
            cs <= ns;
        end
    end

    always @(*) begin
        case (cs)
            SET_NUM:
                ns = start_detect ? GEN_NUM : SET_NUM;
            GEN_NUM:
                ns = stop_detect ? SHOW_NUM : GEN_NUM;
            SHOW_NUM:
                ns = restart_detect ? SET_NUM : SHOW_NUM;
            default:
                ns = SET_NUM;
        endcase
    end

endmodule
