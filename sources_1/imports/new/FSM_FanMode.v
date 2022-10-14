`timescale 1ns / 1ps

module FSM_FanMode(
    input i_clk,
    input i_reset,
    input [3:0] i_button,
    output [2:0] o_fanState
    ); 

    parameter   S_FAN_0 = 3'd0,
                S_FAN_1 = 3'd1,
                S_FAN_2 = 3'd2,
                S_FAN_3 = 3'd3;
    
    reg [2:0] r_curState = S_FAN_0;
    reg [2:0] r_nextState;
    reg [2:0] r_fanState;
    assign o_fanState = r_fanState;

    /* 상태 변경 */
    always @(posedge i_clk or posedge i_reset) begin
        if (i_reset)    r_curState <= S_FAN_0;
        else            r_curState <= r_nextState;
    end

    /* 이벤트 처리 */
    always @(i_button or r_curState) begin
        r_nextState <= S_FAN_0;
        case (r_curState)
            S_FAN_0 : begin
                if     (i_button[1])      r_nextState <= S_FAN_1;
                else if(i_button[2])      r_nextState <= S_FAN_2;
                else if(i_button[3])      r_nextState <= S_FAN_3;
                else                      r_nextState <= S_FAN_0;
            end
            S_FAN_1 : begin
                if     (i_button[0])      r_nextState <= S_FAN_0;
                else if(i_button[2])      r_nextState <= S_FAN_2;
                else if(i_button[3])      r_nextState <= S_FAN_3;
                else                      r_nextState <= S_FAN_1;
            end
            S_FAN_2 : begin
                if     (i_button[0])      r_nextState <= S_FAN_0;
                else if(i_button[1])      r_nextState <= S_FAN_1;
                else if(i_button[3])      r_nextState <= S_FAN_3;
                else                      r_nextState <= S_FAN_2;
            end
            S_FAN_3 : begin
                if     (i_button[0])      r_nextState <= S_FAN_0;
                else if(i_button[1])      r_nextState <= S_FAN_1;
                else if(i_button[2])      r_nextState <= S_FAN_2;
                else                      r_nextState <= S_FAN_3;
            end
        endcase
    end

    /* 상태에 따른 동작 */
    always @(r_curState) begin
        case (r_curState)
            S_FAN_0 : r_fanState <= 3'd0;
            S_FAN_1 : r_fanState <= 3'd1;
            S_FAN_2 : r_fanState <= 3'd2;
            S_FAN_3 : r_fanState <= 3'd3;
        endcase
    end

endmodule
