`timescale 1ns / 1ps

module butterfly_1_1 #(
    parameter I_WIDTH = 12,
    parameter O_WIDTH = 14,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rstn,
    input valid_1_1,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic bf1_1_o_en
);

    logic signed [(I_WIDTH-1):0] w_reg_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_reg_im [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_cal_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_cal_im [0:DATA_WIDTH-1];

    logic signed [(I_WIDTH-1):0] w_reg_out_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_reg_out_im [0:DATA_WIDTH-1];

    logic signed [((I_WIDTH+1)-1):0] w_add_re [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-1):0] w_add_im [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-1):0] w_sub_re [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-1):0] w_sub_im [0:DATA_WIDTH-1];

    logic signed [((I_WIDTH+1)-1):0] w_d_sub_re [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-1):0] w_d_sub_im [0:DATA_WIDTH-1];


    logic signed [(I_WIDTH+1)-1:0] w_fac_i_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH+1)-1:0] w_fac_i_im [0:DATA_WIDTH-1];

    logic cnt_1_1_flag;
    logic [6:0] cnt_1_1;
    logic input_switch_1_1, output_switch_1_1;
    logic [1:0] sw_fac_8_1;


    always @(posedge clk, negedge rstn) begin
        if (~rstn) begin
            cnt_1_1_flag <= 0;
            input_switch_1_1 <= 0;
            output_switch_1_1 <= 0;
            bf1_1_o_en <= 0;
            cnt_1_1 <= 0;
            sw_fac_8_1 <= 0;
        end else begin
            if (valid_1_1) begin
                cnt_1_1_flag <= 1;
                cnt_1_1 <= cnt_1_1 + 1;
                input_switch_1_1 <= ~input_switch_1_1;
            end else if (cnt_1_1_flag) begin
                cnt_1_1 <= cnt_1_1 + 1;
            end

            if (cnt_1_1==2) begin
                bf1_1_o_en <= 1;
            end else if (cnt_1_1==34) begin
                bf1_1_o_en <= 0;
                cnt_1_1_flag <= 0;
                cnt_1_1 <= 0;
                input_switch_1_1 <= 0;
                output_switch_1_1 <= 0;
                sw_fac_8_1 <= 0;
            end

            if (cnt_1_1==2) begin
                output_switch_1_1 <= 1;
                sw_fac_8_1 <= sw_fac_8_1 + 1;
            end else if ((cnt_1_1<34)&&(cnt_1_1>2)) begin
                output_switch_1_1 <= ~output_switch_1_1;
                sw_fac_8_1 <= sw_fac_8_1 + 1;
            end
        end
    end

    demux_1to2 #(
        .WIDTH(I_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) U_DEMUX_1to2_1_1 (
        .d_in_re (din_re),
        .d_in_im (din_im),
        .sel (input_switch_1_1),
        .d_out_re_reg (w_reg_re),  
        .d_out_re_cal (w_cal_re),  
        .d_out_im_reg (w_reg_im),  
        .d_out_im_cal (w_cal_im)   
    );


    delay #(
        .WIDTH(I_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )U_Delay_1_1(
        .clk(clk),
        .rstn(rstn),
        .din_re(w_reg_re) ,
        .din_im(w_reg_im) ,
        .dout_re(w_reg_out_re) ,
        .dout_im(w_reg_out_im)
    );

    add_sub #(
        .WIDTH(I_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )U_ADD_SUB_1_1(                                           
        .clk (clk),
        .rstn (rstn),
        .din_re (w_cal_re),
        .din_im (w_cal_im),
        .din_shift_reg_re (w_reg_out_re) , 
        .din_shift_reg_im (w_reg_out_im) ,
        .add_re (w_add_re),
        .add_im (w_add_im),
        .sub_re (w_sub_re),
        .sub_im (w_sub_im)
    );


    delay #(
        .WIDTH    (I_WIDTH+1),
        .DATA_WIDTH (DATA_WIDTH)
    )U_Delay_1_1_2(
        .clk(clk),
        .rstn(rstn),
        .din_re(w_sub_re) ,
        .din_im(w_sub_im) ,
        .dout_re(w_d_sub_re) ,
        .dout_im(w_d_sub_im)
    );


    mux_2x1 #(
        .WIDTH (I_WIDTH+1),
        .DATA_WIDTH (DATA_WIDTH)
    ) U_MUX_2x1_1_1(
        .sw(output_switch_1_1),
        .add_re(w_add_re),
        .add_im(w_add_im),
        .sub_re(w_d_sub_re),
        .sub_im(w_d_sub_im),
        .dout_re(w_fac_i_re),
        .dout_im(w_fac_i_im) 
    );

    fac8_1_1_1 #(
        . I_WIDTH (I_WIDTH+1),        
        . FAC_WIDTH (22),
        . O_WIDTH (14),
        . DATA_WIDTH (DATA_WIDTH),
        . SHIFT (8)
    )U_FAC8_1_1_1(                                 
        . clk (clk),
        . rstn (rstn),
        . sel (sw_fac_8_1),
        . din_re (w_fac_i_re),
        . din_im (w_fac_i_im),
        . dout_re (dout_re),
        . dout_im (dout_im)
    );

endmodule