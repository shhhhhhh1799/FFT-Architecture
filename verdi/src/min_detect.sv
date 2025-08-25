`timescale 1ns/1ps

module min_detect #(
    parameter DATA_WIDTH = 16
)(
    input  logic unsigned [4:0] i_cnt_re [0:DATA_WIDTH-1],
    input  logic unsigned [4:0] i_cnt_im [0:DATA_WIDTH-1],   
    output logic unsigned [4:0] min_cnt
);

    integer i;
    logic unsigned [4:0] min_re;
    logic unsigned [4:0] min_im;

    always_comb begin
        min_re = i_cnt_re[0];
        min_im = i_cnt_im[0];
        for (i = 1; i < DATA_WIDTH; i = i + 1) begin
            if (i_cnt_re[i] < min_re)
                min_re = i_cnt_re[i];
            if (i_cnt_im[i] < min_im)
                min_im = i_cnt_im[i];
        end
        if (min_re < min_im)
            min_cnt = min_re;
        else
            min_cnt = min_im;
    end
    
endmodule