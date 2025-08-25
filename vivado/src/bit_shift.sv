`timescale 1ns/1ps

module bit_shift_0 #(
    parameter LENGTH = 12,
    parameter I_WIDTH = 23,
    parameter O_WIDTH = 11,
    parameter DATA_WIDTH = 16
    )(
    input clk,
    input rstn,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    input unsigned [4:0] min_cnt,
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic [4:0] min_cnt_out [0:DATA_WIDTH-1]
);

    integer i;


    

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i=0; i<DATA_WIDTH; i=i+1) begin
                dout_re[i] <= 0;
                dout_im[i] <= 0;
            end
        end else begin
            for (i=0; i<DATA_WIDTH; i=i+1) begin
                logic signed [I_WIDTH-1:0] tmp_re;
                logic signed [I_WIDTH-1:0] tmp_im;

                if (min_cnt > LENGTH) begin
                    tmp_re = (din_re[i] <<< min_cnt) >>> LENGTH;
                    tmp_im = (din_im[i] <<< min_cnt) >>> LENGTH;
                end else begin
                    tmp_re = din_re[i] >>> (LENGTH-min_cnt);
                    tmp_im = din_im[i] >>> (LENGTH-min_cnt);
                end
                dout_re[i] <= tmp_re[O_WIDTH-1:0];
                dout_im[i] <= tmp_im[O_WIDTH-1:0];
            end

            for (i=0; i<DATA_WIDTH; i=i+1) begin
                min_cnt_out[i] <= min_cnt;
            end
        end
    end
endmodule