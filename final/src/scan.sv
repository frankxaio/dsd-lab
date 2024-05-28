module scan (
    input [3:0] seg_disp,
    input is_full,
    output logic [6:0] seg_out0,
    output logic [6:0] seg_out1,
    output logic [6:0] seg_out2,
    output logic [6:0] seg_out3,
    output logic [6:0] seg_out4,
    output logic [6:0] seg_out5
);


    typedef enum logic [6:0] {
        ZERO  = 7'b1000000,
        ONE   = 7'b1111001,
        TWO   = 7'b0100100,
        THREE = 7'b0110000,
        FOUR  = 7'b0011001,
        FIVE  = 7'b0010010,
        SIX   = 7'b0000010,
        SEVEN = 7'b1111000,
        EIGHT = 7'b0000000,
        NINE  = 7'b0011000,
        A     = 7'b0001000,
        B     = 7'b0000011,
        C     = 7'b1000110,
        D     = 7'b0100001,
        E     = 7'b0000110,
        F     = 7'b0001110,
        OFF   = 7'b1111111,
        L     = 7'b1000111,
        U     = 7'b1000001
    } seg_t;

    logic [3:0] in0, in1;

    //Logic for converting hexadecimal to 2-digit BCD 
    always_comb begin
        if (seg_disp > 9) begin
            in0 = seg_disp - 4'd10;
            in1 = 4'd1;
        end else begin
            in0 = seg_disp;
            in1 = 4'd0;
        end
    end

    function automatic seg_t get_segment(input logic [3:0] value);
        case (value)
            4'h0: return ZERO;
            4'h1: return ONE;
            4'h2: return TWO;
            4'h3: return THREE;
            4'h4: return FOUR;
            4'h5: return FIVE;
            4'h6: return SIX;
            4'h7: return SEVEN;
            4'h8: return EIGHT;
            4'h9: return NINE;
            4'ha: return A;
            4'hb: return B;
            4'hc: return C;
            4'hd: return D;
            4'he: return E;
            4'hf: return F;
            default: return OFF;
        endcase
    endfunction

    always_comb begin
        seg_out0 = get_segment(in0);
        seg_out1 = get_segment(in1);
    end

    always_comb begin
        if (is_full) begin
            seg_out2 = L;
            seg_out3 = L;
            seg_out4 = U;
            seg_out5 = F;
        end else begin
            seg_out2 = OFF;
            seg_out3 = OFF;
            seg_out4 = OFF;
            seg_out5 = OFF;
        end
    end

endmodule
