`timescale 1ns / 1ps

module MUX_4x1(
    input [3:0] i_x,
    input [2:0] sel,
    output o_y
    );

    reg r_y;
    assign o_y = r_y;

    always @(*) begin
        r_y = 1'b0;
        case (sel)
            3'b000 : r_y = i_x[0];
            3'b001 : r_y = i_x[1];
            3'b010 : r_y = i_x[2];
            3'b011 : r_y = i_x[3];
        endcase
    end
endmodule
