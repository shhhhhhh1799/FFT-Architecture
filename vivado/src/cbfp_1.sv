`timescale 1ns/1ps

module cbfp_1 #(
    parameter I_WIDTH = 24,
    parameter O_WIDTH = 12,
    parameter DATA_WIDTH = 16      
)(
    input clk,
    input rstn,
    input valid_cbfp_1,
    input  logic signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input  logic signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic [4:0] min_cnt_out_1 [0:DATA_WIDTH-1],
    output logic o_cbfp_1_en
);

    logic valid_cbfp_1_d1;
    logic valid_cbfp_1_d2;
    logic cnt_cbfp_flag;
    logic [5:0] cnt_cbfp, cnt_d1, cnt_d2; 


    always_ff @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            valid_cbfp_1_d1 <= 0;
            cnt_d1 <=0;
            cnt_cbfp_flag <= 0;
            cnt_cbfp <= 0;
            o_cbfp_1_en <=0;
        end else begin
            valid_cbfp_1_d1 <= valid_cbfp_1;
            valid_cbfp_1_d2 <= valid_cbfp_1_d1;

            if (valid_cbfp_1&&(cnt_cbfp_flag==0)) begin
                cnt_cbfp_flag <= 1;
                cnt_cbfp <= cnt_cbfp + 1;
            end else if (valid_cbfp_1||cnt_cbfp_flag) begin
                cnt_cbfp <= cnt_cbfp + 1;
            end


            if (cnt_cbfp==1) begin
                o_cbfp_1_en <= 1;
            end else if (cnt_cbfp==33) begin
                o_cbfp_1_en <= 0;
                cnt_cbfp_flag <= 0;
                cnt_cbfp <= 0;
            end
        end
    end

    logic signed [(I_WIDTH+1)-1:0] w_mag_dout_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH+1)-1:0] w_mag_dout_im [0:DATA_WIDTH-1];
    logic unsigned [4:0] w_mag_cnt_re [0:DATA_WIDTH-1];
    logic unsigned [4:0] w_mag_cnt_im [0:DATA_WIDTH-1];

    logic unsigned [4:0] group_min_cnt;
    logic unsigned [4:0] min_cnt;
    logic unsigned [4:0] com_min_cnt[0:7];

    logic [4:0] w_min_cnt_0;
    logic [4:0] w_min_cnt_1;

    mag_detect_1 #(
        . I_WIDTH(I_WIDTH), 
        . DATA_WIDTH(DATA_WIDTH)
        ) U_MAG_1_RE (
        . clk(clk), 
        . rstn(rstn), 
        . din(din_re), 
        . dout(w_mag_dout_re), 
        . o_cnt(w_mag_cnt_re)
    );

    mag_detect_1 #(
        . I_WIDTH(I_WIDTH), 
        . DATA_WIDTH(DATA_WIDTH)
        ) U_MAG_1_IM (
        . clk (clk), 
        . rstn (rstn), 
        . din (din_im), 
        . dout (w_mag_dout_im), 
        . o_cnt (w_mag_cnt_im)
    );

    min_detect_1 #(
        . DATA_WIDTH (DATA_WIDTH)
    ) U_MIN_DETECT_1 (
        . i_cnt_re (w_mag_cnt_re) ,
        . i_cnt_im (w_mag_cnt_im) ,   
        . min_cnt_0 (w_min_cnt_0),
        . min_cnt_1 (w_min_cnt_1)
    );






    bit_shift_1 #(
        . LENGTH (13),
        . I_WIDTH (I_WIDTH+1),
        . O_WIDTH (O_WIDTH),
        . DATA_WIDTH (DATA_WIDTH)
        ) U_BIT_SHIFT_CBFP_1(
        . clk (clk),
        . rstn (rstn),
        . din_re (w_mag_dout_re),
        . din_im (w_mag_dout_im),
        . min_cnt_0 (w_min_cnt_0),
        . min_cnt_1 (w_min_cnt_1),
        . dout_re (dout_re) ,
        . dout_im (dout_im) ,
        . min_cnt_cbfp_1_out(min_cnt_out_1)
    );

endmodule


