`timescale 1ns / 1ps

module butterfly_2 #(
    parameter WIDTH_2_0_IN = 12,
    parameter WIDTH_2_0_OUT = 13,
    parameter WIDTH_2_1_OUT = 15,
    parameter WIDTH_2_2_OUT = 13,
    parameter DATA_WIDTH = 16
)(  
    input clk,
    input rstn,
    input valid_start_2,
    input index1_valid,
    input index2_valid,
    input logic [4:0] index1 [0:DATA_WIDTH-1],
    input logic [4:0] index2 [0:DATA_WIDTH-1],
    input logic signed [WIDTH_2_0_IN-1:0] din_re [0:DATA_WIDTH-1],
    input logic signed [WIDTH_2_0_IN-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [WIDTH_2_2_OUT-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [WIDTH_2_2_OUT-1:0] dout_im [0:DATA_WIDTH-1],
    output bf_2_o_en
);

    logic w_vaild_2_1, w_vaild_2_2;


    
    logic signed [WIDTH_2_0_OUT-1:0] w_2_0_dout_re[0:DATA_WIDTH-1];
    logic signed [WIDTH_2_0_OUT-1:0] w_2_0_dout_im[0:DATA_WIDTH-1];

    logic signed [WIDTH_2_1_OUT-1:0] w_2_1_dout_re[0:DATA_WIDTH-1];
    logic signed [WIDTH_2_1_OUT-1:0] w_2_1_dout_im[0:DATA_WIDTH-1];    




    butterfly_2_0 #(
        . I_WIDTH (12),
        . O_WIDTH (13),
        . DATA_WIDTH (16)
    ) U_BF_2_0 (
        . clk(clk),
        . rstn(rstn),
        . valid_2_0(valid_start_2),
        . din_re(din_re) ,
        . din_im(din_im) ,
        . dout_re(w_2_0_dout_re) ,
        . dout_im (w_2_0_dout_im),
        . bf2_0_o_en(w_vaild_2_1)
    );

    butterfly_2_1 #(
        . I_WIDTH (13),
        . O_WIDTH (15),
        . DATA_WIDTH (16)
    ) U_BF_2_1 (
        . clk(clk),
        . rstn(rstn),
        . valid_2_1(w_vaild_2_1),
        . din_re(w_2_0_dout_re) ,
        . din_im(w_2_0_dout_im) ,
        . dout_re(w_2_1_dout_re) ,
        . dout_im (w_2_1_dout_im),
        . bf2_1_o_en(w_vaild_2_2)
    );


    butterfly_2_2 #(
        . I_WIDTH (15),
        . O_WIDTH (13),
        . DATA_WIDTH (16)
    )U_BF_2_2(
        . clk(clk),
        . rstn(rstn),
        . valid_2_2(w_vaild_2_2),
        . index1_valid(index1_valid),
        . index2_valid(index2_valid),
        . index_1(index1) ,
        . index_2(index2) ,
        . din_re(w_2_1_dout_re) ,
        . din_im(w_2_1_dout_im) ,
        . dout_re(dout_re) ,
        . dout_im(dout_im) ,
        . bf_2_2_en(bf_2_o_en)  
    );






endmodule