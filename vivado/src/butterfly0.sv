`timescale 1ns / 1ps

module butterfly_0 #(
    parameter WIDTH_0_0_IN = 9,
    parameter WIDTH_0_0_OUT = 10,
    parameter WIDTH_0_1_OUT = 13,
    parameter WIDTH_0_2_OUT = 22,
    parameter WIDTH_CBFP_0_OUT = 11,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rstn,
    input valid_start_0,
    input signed [WIDTH_0_0_IN-1:0] din_re [0:DATA_WIDTH-1],
    input signed [WIDTH_0_0_IN-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [WIDTH_CBFP_0_OUT-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [WIDTH_CBFP_0_OUT-1:0] dout_im [0:DATA_WIDTH-1],
    output logic [4:0] index_1_out [0:DATA_WIDTH-1],
    output bf_0_o_en
);
    
    logic signed [WIDTH_0_0_OUT-1:0] w_0_0_dout_re [0:DATA_WIDTH-1];
    logic signed [WIDTH_0_0_OUT-1:0] w_0_0_dout_im [0:DATA_WIDTH-1];

    logic signed [WIDTH_0_1_OUT-1:0] w_0_1_dout_re [0:DATA_WIDTH-1];
    logic signed [WIDTH_0_1_OUT-1:0] w_0_1_dout_im [0:DATA_WIDTH-1];    

    logic signed [WIDTH_0_2_OUT-1:0] w_0_2_dout_re [0:DATA_WIDTH-1];
    logic signed [WIDTH_0_2_OUT-1:0] w_0_2_dout_im [0:DATA_WIDTH-1];        


    logic w_valid_0_1,w_valid_0_2, w_valid_cbfp_0;

    butterfly_0_0 #(
        . WIDTH      (9),
        . DATA_WIDTH (16),
        . DATA_HEIGHT (16)
    ) U_BF_0_0(
        . clk(clk),
        . rstn(rstn),
        . valid_0_0(valid_start_0),
        . din_re (din_re),
        . din_im (din_im),
        . dout_re (w_0_0_dout_re),
        . dout_im (w_0_0_dout_im),
        . bf0_0_o_en (w_valid_0_1)
    );

    butterfly_0_1 #(
        . WIDTH (10),
        . O_WIDTH (WIDTH_0_1_OUT),
        . DATA_WIDTH (16),
        . DATA_HEIGHT (8)
    ) U_BF_0_1(
        . clk(clk),
        . rstn(rstn),
        . valid_0_1(w_valid_0_1),
        . din_re(w_0_0_dout_re) ,
        . din_im(w_0_0_dout_im) ,
        . dout_re(w_0_1_dout_re) ,
        . dout_im(w_0_1_dout_im) ,
        . bf0_1_o_en(w_valid_0_2) 
    );

    butterfly_0_2 #(
        . I_WIDTH (13),
        . O_WIDTH (WIDTH_0_2_OUT),				
        . DATA_WIDTH (16),
        . DATA_HEIGHT (4)
    ) U_BF_0_2(
        . clk(clk),
        . rstn(rstn),
        . valid_0_2(w_valid_0_2),
        . din_re(w_0_1_dout_re) ,			
        . din_im(w_0_1_dout_im) ,			
        . dout_re(w_0_2_dout_re) ,
        . dout_im(w_0_2_dout_im) ,
        . bf0_2_o_en(w_valid_cbfp_0)
    );

    cbfp #(
        .I_WIDTH (22),
        .O_WIDTH (11),
        .DATA_WIDTH (16), 
        .GROUP_WIDTH (64)         
    )U_CBFP_0(
        .clk(clk),
        .rstn(rstn),
        .valid_cbfp(w_valid_cbfp_0),
        .din_re(w_0_2_dout_re) ,
        .din_im (w_0_2_dout_im),
        .dout_re(dout_re) ,
        .dout_im (dout_im),
        .min_cnt_out (index_1_out), 
        .o_cbfp_en(bf_0_o_en)           
    );

endmodule

