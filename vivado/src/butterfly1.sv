`timescale 1ns / 1ps

module butterfly_1 #(
    parameter WIDTH_1_0_IN = 11,
    parameter WIDTH_1_0_OUT = 12,
    parameter WIDTH_1_1_OUT = 14,
    parameter WIDTH_1_2_OUT = 24,
    parameter WIDTH_CBFP_1_OUT = 12,
    parameter DATA_WIDTH = 16
)(  
    input clk,
    input rstn,
    input valid_start_1,
    input logic signed [WIDTH_1_0_IN-1:0] din_re [0:DATA_WIDTH-1],
    input logic signed [WIDTH_1_0_IN-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [WIDTH_CBFP_1_OUT-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [WIDTH_CBFP_1_OUT-1:0] dout_im [0:DATA_WIDTH-1],
    output logic [4:0] index2_out [0:DATA_WIDTH-1],
    output bf_1_o_en
);

    logic w_valid_1_1, w_valid_1_2, w_valid_cbfp_1;

    logic signed [WIDTH_1_0_OUT-1:0] w_1_0_dout_re[0:DATA_WIDTH-1];
    logic signed [WIDTH_1_0_OUT-1:0] w_1_0_dout_im[0:DATA_WIDTH-1];

    logic signed [WIDTH_1_1_OUT-1:0] w_1_1_dout_re[0:DATA_WIDTH-1];
    logic signed [WIDTH_1_1_OUT-1:0] w_1_1_dout_im[0:DATA_WIDTH-1];    

    logic signed [WIDTH_1_2_OUT-1:0] w_1_2_dout_re [0:DATA_WIDTH-1];
    logic signed [WIDTH_1_2_OUT-1:0] w_1_2_dout_im [0:DATA_WIDTH-1];   

    butterfly_1_0 #(
        .I_WIDTH(11),
        .O_WIDTH(12),
        .DATA_WIDTH(16),
        .DATA_HEIGHT(2)
    )U_BF_1_0(
        .clk(clk),
        .rstn(rstn),
        .valid_1_0(valid_start_1),
        .din_re(din_re),
        .din_im(din_im),
        .dout_re(w_1_0_dout_re),
        .dout_im(w_1_0_dout_im),
        .bf1_0_o_en(w_valid_1_1)
    );

    butterfly_1_1 #(
        .I_WIDTH(12),
        .O_WIDTH(14),
        .DATA_WIDTH(16)
    )U_BF_1_1(
        .clk(clk),
        .rstn(rstn),
        .valid_1_1(w_valid_1_1),
        .din_re(w_1_0_dout_re),
        .din_im(w_1_0_dout_im),
        .dout_re(w_1_1_dout_re),
        .dout_im(w_1_1_dout_im),
        .bf1_1_o_en(w_valid_1_2) 
    );

    butterfly_1_2 #(
        .I_WIDTH (14),
        .O_WIDTH (24),
        .DATA_WIDTH (16)
    )U_BF_1_2(
        .clk(clk),
        .rstn(rstn),
        .valid_1_2(w_valid_1_2),
        .din_re(w_1_1_dout_re),
        .din_im(w_1_1_dout_im),
        .dout_re(w_1_2_dout_re),
        .dout_im(w_1_2_dout_im),
        .bf1_2_o_en(w_valid_cbfp_1)  
    );

    cbfp_1 #(
        .I_WIDTH (24),
        .O_WIDTH (12),
        .DATA_WIDTH (16)      
    ) U_CBFP_1 (
        .clk (clk),
        .rstn (rstn),
        .valid_cbfp_1 (w_valid_cbfp_1),
        .din_re (w_1_2_dout_re) ,
        .din_im (w_1_2_dout_im) ,
        .dout_re (dout_re) ,
        .dout_im (dout_im) ,
        .min_cnt_out_1 (index2_out) ,
        .o_cbfp_1_en (bf_1_o_en)
    );



endmodule