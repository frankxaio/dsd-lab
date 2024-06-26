module scan(
        input  [7:0] dipsw7,
        output reg [6:0] one, ten, hundred
    );

    wire [3:0] one_int, ten_int;
    wire [3:0] hundred_int;

    binary_to_BCD u1 (.binary(dipsw7),.Ones(one_int),.Tens(ten_int),.Hundreds(hundred_int));

    always @(*) begin
        case(one_int)
            4'b0000:
                one=7'b1000000;
            4'b0001:
                one=7'b1111001;
            4'b0010:
                one=7'b0100100;
            4'b0011:
                one=7'b0110000;
            4'b0100:
                one=7'b0011001;
            4'b0101:
                one=7'b0010010;
            4'b0110:
                one=7'b0000010;
            4'b0111:
                one=7'b1111000;
            4'b1000:
                one=7'b0000000;
            4'b1001:
                one=7'b0011000;
            4'b1010:
                one=7'b0001000;
            4'b1011:
                one=7'b0000011;
            4'b1100:
                one=7'b1000110;
            4'b1101:
                one=7'b0100001;
            4'b1110:
                one=7'b0000110;
            4'b1111:
                one=7'b0001110;
            default:
                one=7'b1111111;
        endcase
        case(ten_int)
            4'b0000:
                ten=7'b1000000;
            4'b0001:
                ten=7'b1111001;
            4'b0010:
                ten=7'b0100100;
            4'b0011:
                ten=7'b0110000;
            4'b0100:
                ten=7'b0011001;
            4'b0101:
                ten=7'b0010010;
            4'b0110:
                ten=7'b0000010;
            4'b0111:
                ten=7'b1111000;
            4'b1000:
                ten=7'b0000000;
            4'b1001:
                ten=7'b0011000;
            4'b1010:
                ten=7'b0001000;
            4'b1011:
                ten=7'b0000011;
            4'b1100:
                ten=7'b1000110;
            4'b1101:
                ten=7'b0100001;
            4'b1110:
                ten=7'b0000110;
            4'b1111:
                ten=7'b0001110;
            default:
                ten=7'b1111111;
        endcase
        case(hundred_int)
            4'b0000:
                hundred=7'b1000000;
            4'b0001:
                hundred=7'b1111001;
            4'b0010:
                hundred=7'b0100100;
            4'b0011:
                hundred=7'b0110000;
            4'b0100:
                hundred=7'b0011001;
            4'b0101:
                hundred=7'b0010010;
            4'b0110:
                hundred=7'b0000010;
            4'b0111:
                hundred=7'b1111000;
            4'b1000:
                hundred=7'b0000000;
            4'b1001:
                hundred=7'b0011000;
            4'b1010:
                hundred=7'b0001000;
            4'b1011:
                hundred=7'b0000011;
            4'b1100:
                hundred=7'b1000110;
            4'b1101:
                hundred=7'b0100001;
            4'b1110:
                hundred=7'b0000110;
            4'b1111:
                hundred=7'b0001110;
            default:
                hundred=7'b1111111;
        endcase
    end
endmodule

