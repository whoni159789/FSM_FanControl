`timescale 1ns / 1ps

module LightControl(
    input [2:0] i_fanState,
    output [3:0] o_light
    );

    reg [3:0] r_light;
    assign o_light = r_light;

    always @(*) begin
        case (i_fanState)
            3'd0 : r_light = 4'b0000;
            3'd1 : r_light = 4'b0001;
            3'd2 : r_light = 4'b0011;
            3'd3 : r_light = 4'b0111;
        endcase
    end
    
endmodule
