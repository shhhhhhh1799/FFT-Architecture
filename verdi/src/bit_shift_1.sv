`timescale 1ns/1ps

module bit_shift_1 #(
    parameter LENGTH = 13,
    parameter I_WIDTH = 24,
    parameter O_WIDTH = 12,
    parameter DATA_WIDTH = 16
    )(
    input clk,
    input rstn,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    input unsigned [4:0] min_cnt_0,
    input unsigned [4:0] min_cnt_1,
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic [4:0] min_cnt_cbfp_1_out [0:DATA_WIDTH-1]
);

    integer i;

    parameter HALF = DATA_WIDTH/2;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i=0; i<DATA_WIDTH; i=i+1) begin
                dout_re[i] <= 0;
                dout_im[i] <= 0;
            end
        end else begin
            for (i=0; i<HALF; i=i+1) begin
                logic signed [I_WIDTH-1:0] tmp_0_re;
                logic signed [I_WIDTH-1:0] tmp_0_im;

                if (min_cnt_0 > LENGTH) begin
                    tmp_0_re = (din_re[i] <<< min_cnt_0) >>> LENGTH;
                    tmp_0_im = (din_im[i] <<< min_cnt_0) >>> LENGTH;
                end else begin
                    tmp_0_re = din_re[i] >>> (LENGTH-min_cnt_0);
                    tmp_0_im = din_im[i] >>> (LENGTH-min_cnt_0);
                end
                dout_re[i] <= tmp_0_re[O_WIDTH-1:0];
                dout_im[i] <= tmp_0_im[O_WIDTH-1:0];
            end

            for (i=HALF; i<DATA_WIDTH; i=i+1) begin
                logic signed [I_WIDTH-1:0] tmp_1_re;
                logic signed [I_WIDTH-1:0] tmp_1_im;

                if (min_cnt_1 > LENGTH) begin
                    tmp_1_re = (din_re[i] <<< min_cnt_1) >>> LENGTH;
                    tmp_1_im = (din_im[i] <<< min_cnt_1) >>> LENGTH;
                end else begin
                    tmp_1_re = din_re[i] >>> (LENGTH-min_cnt_1);
                    tmp_1_im = din_im[i] >>> (LENGTH-min_cnt_1);
                end
                dout_re[i] <= tmp_1_re[O_WIDTH-1:0];
                dout_im[i] <= tmp_1_im[O_WIDTH-1:0];
            end

            for (i=0; i<HALF; i=i+1) begin
                min_cnt_cbfp_1_out[i] <= min_cnt_0;
            end

            for (i=HALF; i<DATA_WIDTH; i=i+1) begin
                min_cnt_cbfp_1_out[i] <= min_cnt_1;
            end
        end
    end
endmodule
