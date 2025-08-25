`timescale 1ns/1ps

module min_detect_1 #(
    parameter DATA_WIDTH = 16
)(
    input  logic unsigned [4:0] i_cnt_re [0:DATA_WIDTH-1],
    input  logic unsigned [4:0] i_cnt_im [0:DATA_WIDTH-1],   
    output logic unsigned [4:0] min_cnt_0,
    output logic unsigned [4:0] min_cnt_1
);

    parameter HALF = (DATA_WIDTH/2);

    integer i;
    logic unsigned [4:0] min_re_0;
    logic unsigned [4:0] min_im_0;

    logic unsigned [4:0] min_re_1;
    logic unsigned [4:0] min_im_1;


    always_comb begin
        min_re_0 = i_cnt_re[0];
        min_im_0 = i_cnt_im[0];

        for (i = 1; i < HALF; i = i + 1) begin
            if (i_cnt_re[i] < min_re_0)
                min_re_0 = i_cnt_re[i];
            if (i_cnt_im[i] < min_im_0)
                min_im_0 = i_cnt_im[i];
        end

        min_re_1 = i_cnt_re[HALF];
        min_im_1 = i_cnt_im[HALF];   

        for (i = (HALF+1); i < DATA_WIDTH; i = i + 1) begin
            if (i_cnt_re[i] < min_re_1)
                min_re_1 = i_cnt_re[i];
            if (i_cnt_im[i] < min_im_1)
                min_im_1 = i_cnt_im[i];
        end

        if (min_re_0 < min_im_0)
            min_cnt_0 = min_re_0;
        else
            min_cnt_0 = min_im_0;

        if (min_re_1 < min_im_1)
            min_cnt_1 = min_re_1;
        else
            min_cnt_1 = min_im_1;
    end

endmodule
