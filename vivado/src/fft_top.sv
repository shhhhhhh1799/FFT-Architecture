`timescale 1ns / 1ps

module fft_top (
    input clk,
    input rstn,
    input valid,
    input signed [8:0] din_re[0:15],
    input signed [8:0] din_im[0:15],
    output logic signed [12:0] dout_re [0:15],
    output logic signed [12:0] dout_im [0:15],
    output logic output_en
);

    logic signed [10:0] w_bf_0_re [0:15];
    logic signed [10:0] w_bf_0_im [0:15];

    logic signed [11:0] w_bf_1_re [0:15];
    logic signed [11:0] w_bf_1_im [0:15];   




    logic w_bf_1_valid, w_bf_2_valid;
    logic [4:0] w_index1 [0:15];
    logic [4:0] w_index2 [0:15];


    butterfly_0 #(
        . WIDTH_0_0_IN (9),
        . WIDTH_0_0_OUT (10),
        . WIDTH_0_1_OUT(13),
        . WIDTH_0_2_OUT (22),
        . WIDTH_CBFP_0_OUT (11),
        . DATA_WIDTH (16)
    )U_BF_0(
        . clk(clk),
        . rstn(rstn),
        . valid_start_0(valid),
        . din_re(din_re) ,
        . din_im(din_im) ,
        . dout_re(w_bf_0_re) ,
        . dout_im(w_bf_0_im) ,
        . index_1_out (w_index1),
        . bf_0_o_en(w_bf_1_valid)
    );

    butterfly_1 #(
        . WIDTH_1_0_IN (11),
        . WIDTH_1_0_OUT (12),
        . WIDTH_1_1_OUT (14),
        . WIDTH_1_2_OUT (24),
        . WIDTH_CBFP_1_OUT (12),
        . DATA_WIDTH (16)
    )U_BF_1(
        . clk (clk),
        . rstn (rstn),
        . valid_start_1 (w_bf_1_valid),
        . din_re (w_bf_0_re) ,
        . din_im (w_bf_0_im) ,
        . dout_re (w_bf_1_re) ,
        . dout_im (w_bf_1_im) ,
        . index2_out (w_index2), 
        . bf_1_o_en (w_bf_2_valid)
    );

    butterfly_2 #(
        . WIDTH_2_0_IN  (12),
        . WIDTH_2_0_OUT (13),
        . WIDTH_2_1_OUT (15),
        . WIDTH_2_2_OUT (13),
        . DATA_WIDTH (16)
    ) U_BF_2(  
        . clk (clk),
        . rstn (rstn),
        . valid_start_2 (w_bf_2_valid),
        . index1_valid (w_bf_1_valid),
        . index2_valid (w_bf_2_valid),
        . index1 (w_index1),
        . index2 (w_index2),
        . din_re (w_bf_1_re) ,
        . din_im (w_bf_1_im) ,
        . dout_re (dout_re) ,
        . dout_im (dout_im) ,
        . bf_2_o_en (output_en)
    );

endmodule