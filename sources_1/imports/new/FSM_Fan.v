`timescale 1ns / 1ps

module FSM_Fan(
    input i_clk,
    input i_reset,
    input [3:0] i_button,
    output o_motor,
    output [3:0] o_light,
    output [3:0] o_FND_Digit,
    output [7:0] o_FND_Font
    );


    // Motor & Led Part
    wire w_1M_clk;
    ClockDivider_1MHz clkdiv_1M(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .o_clk(w_1M_clk)
    );

    wire [9:0] w_counter;
    Counter_Fan count_fan(
        .i_clk(w_1M_clk),
        .i_reset(i_reset),
        .o_counter(w_counter)
    );

    wire [3:0] w_fan;
    Comparator comp(
        .i_counter(w_counter),
        .o_fan_0(w_fan[0]), 
        .o_fan_1(w_fan[1]), 
        .o_fan_2(w_fan[2]), 
        .o_fan_3(w_fan[3])
    );

    wire [3:0] w_button; // 0 : Off, 1 : 1stage, 2 : 2stage 3 : 3stage
    ButtonController OffBTN(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button[0]),
        .o_button(w_button[0])
    );

    ButtonController Stage1_BTN(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button[1]),
        .o_button(w_button[1])
    );

    ButtonController Stage2_BTN(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button[2]),
        .o_button(w_button[2])
    );

    ButtonController Stage3_BTN(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button[3]),
        .o_button(w_button[3])
    );

    wire [2:0] w_fanState;
    FSM_FanMode modeSel(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(w_button),
        .o_fanState(w_fanState)
    ); 

    MUX_4x1 MoterStageSel(
        .i_x(w_fan),
        .sel(w_fanState),
        .o_y(o_motor)
    );

    LightControl light(
        .i_fanState(w_fanState),
        .o_light(o_light)
    );

    // FND Part
    wire w_1K_clk;
    ClockDivider_1KHz clkDiv_1K(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .o_clk(w_1K_clk)
    );

    wire [1:0] w_digitPosition;
    Counter_FND count_FND(
        .i_clk(w_1K_clk),
        .i_reset(i_reset),
        .o_counter(w_digitPosition)
    );

    Decoder_2x4 SelDigit(
        .i_digitPosition(w_digitPosition),
        .o_Digit(o_FND_Digit)
    );

    wire [3:0] w_1000_value, w_100_value, w_10_value, w_1_value;
    FNDValue FNDVal(
        .i_fanState(w_fanState),
        .o_1000_value(w_1000_value), 
        .o_100_value(w_100_value), 
        .o_10_value(w_10_value), 
        .o_1_value(w_1_value)
    );


    wire [3:0] w_value;
    MUX_FNDValueSel FNDValSel(
        .i_1000_value(w_1000_value), 
        .i_100_value(w_100_value), 
        .i_10_value(w_10_value), 
        .i_1_value(w_1_value),
        .i_digitPosition(w_digitPosition),
        .o_value(w_value)
    );

    BCDToFND_Decoder Font(
        .i_value(w_value),
        .o_font(o_FND_Font)
    );



endmodule
