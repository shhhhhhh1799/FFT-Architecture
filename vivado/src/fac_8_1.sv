`timescale 1ns / 1ps

module fac8_1 #(
    parameter I_WIDTH = 11,
    parameter FAC_WIDTH = 21,
    parameter O_WIDTH = 13,
    parameter DATA_WIDTH = 16,
    parameter SHIFT = 8
)(
    input clk,
    input rstn,
    input unsigned [2:0] sel,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1]
);

    // 로컬 변수 선언
    logic signed [FAC_WIDTH-1:0] next_dout_re [0:DATA_WIDTH-1];
    logic signed [FAC_WIDTH-1:0] next_dout_im [0:DATA_WIDTH-1];
   
    // 항상 블록: 출력 데이터는 순차적으로 관리
    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
                dout_re[i] <= 0;
                dout_im[i] <= 0;
            end
        end else begin
            for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
                dout_re[i] <= (next_dout_re[i] + 128) >>> SHIFT; // rounding 추가
                dout_im[i] <= (next_dout_im[i] + 128) >>> SHIFT;
            end
        end
    end

    // fac8_1 = [256, 256, 256, -j*256, 256, 181-j*181, 256, -181-j*181];
    // 조합 논리: case문 처리
    always_comb begin
            case (sel)
                3'b000, 3'b001, 3'b100, 3'b010, 3'b110: begin
                    for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
                        next_dout_re[i] = 256 * din_re[i];
                        next_dout_im[i] = 256 * din_im[i];
                    end
                end
                3'b011: begin
                    for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
                        next_dout_re[i] = 256 * din_im[i];
                        next_dout_im[i] = -256 * din_re[i];
                    end
                end
                3'b101: begin
                    for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
                        next_dout_re[i] = (181*din_re[i])+(181*din_im[i]);
                        next_dout_im[i] = (181*din_im[i])-(181*din_re[i]);
                    end
                end
                3'b111: begin
                    for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
                        next_dout_re[i] = (181*din_im[i])-(181*din_re[i]);
                        next_dout_im[i] = -((181*din_re[i])+(181*din_im[i]));
                    end
                end
            endcase
    end

endmodule