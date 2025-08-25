`timescale 1ns / 1ps

module butterfly_1_0 #(
    parameter I_WIDTH = 11,
    parameter O_WIDTH = 12,
    parameter DATA_WIDTH  = 16,
    parameter DATA_HEIGHT = 2
) (
    input logic clk,
    input logic rstn,
    input logic valid_1_0,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic bf1_0_o_en
);

    logic valid_1_0_d1, valid_1_0_d2 ;
    logic cnt_1_0_flag;
    logic [6:0] cnt_1_0;
    logic [6:0] cnt_1_0_d;
    logic input_switch_1_0, output_switch_1_0 , fac_8_0_1_0;

    logic signed [(I_WIDTH-1):0] w_reg_out_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_reg_out_im [0:DATA_WIDTH-1];

    logic signed [(I_WIDTH-1):0] w_reg_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_reg_im [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_cal_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_cal_im [0:DATA_WIDTH-1];

    logic signed [(O_WIDTH-1):0] w_add_out_re [0:DATA_WIDTH-1];
    logic signed [(O_WIDTH-1):0] w_add_out_im [0:DATA_WIDTH-1];
    logic signed [(O_WIDTH-1):0] w_sub_out_re [0:DATA_WIDTH-1];
    logic signed [(O_WIDTH-1):0] w_sub_out_im [0:DATA_WIDTH-1];

    logic signed [(O_WIDTH-1):0] w_shift_sub_out_re [0:DATA_WIDTH-1];
    logic signed [(O_WIDTH-1):0] w_shift_sub_out_im [0:DATA_WIDTH-1];   

    always @(posedge clk, negedge rstn) begin
        if (~rstn) begin
            valid_1_0_d1 <= 0;
            valid_1_0_d2 <= 0;
            cnt_1_0_flag <= 0;
            input_switch_1_0 <= 0;
            output_switch_1_0 <= 0;
            bf1_0_o_en <= 0;
            cnt_1_0 <= 0;
            fac_8_0_1_0 <= 0;
            cnt_1_0_d <= 0;
        end else begin 

            valid_1_0_d1 <= valid_1_0;
            valid_1_0_d2 <= valid_1_0_d1;

            if (valid_1_0&&(cnt_1_0_flag==0)) begin
                cnt_1_0_flag <= 1;
                cnt_1_0 <= cnt_1_0 + 1;
            end else if (valid_1_0||cnt_1_0_flag) begin
                cnt_1_0 <= cnt_1_0 + 1;
            end

            if (valid_1_0_d1||valid_1_0_d2) begin
                cnt_1_0_d <= cnt_1_0_d +1;
            end

            if (cnt_1_0%2) begin
                input_switch_1_0 <= ~input_switch_1_0;
            end 



            if ((cnt_1_0>2)&&(cnt_1_0%2)) begin
                output_switch_1_0 <= ~output_switch_1_0;
            end

            if (cnt_1_0 == 1) begin
                bf1_0_o_en <= 1;
            end  else if (cnt_1_0==33) begin
                bf1_0_o_en <= 0;
                cnt_1_0_flag <= 0;
                input_switch_1_0 <= 0;
                output_switch_1_0 <= 0;
                cnt_1_0 <= 0;
                cnt_1_0_d <= 0;

            end

            if ((cnt_1_0_d%4)==1) begin
                fac_8_0_1_0 <= 1;
            end else begin
                fac_8_0_1_0 <= 0;
            end
        end
    end

    demux_1to2 #(
        .WIDTH(I_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) U_DEMUX_1to2_1_0 (
        .d_in_re        (din_re),
        .d_in_im        (din_im),
        .sel            (input_switch_1_0),
        .d_out_re_reg   (w_reg_re),  
        .d_out_im_reg   (w_reg_im), 
        .d_out_re_cal   (w_cal_re),  
        .d_out_im_cal   (w_cal_im)  
    );

    shift_register_1sub #(
        .WIDTH(I_WIDTH),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(DATA_HEIGHT)
    ) U_SHIFT_REG_RE_1_0 (
        .clk    (clk),
        .rstn   (rstn),
        .din    (w_reg_re),
        .s_dout (w_reg_out_re)
    );

    shift_register_1sub #(
        .WIDTH(I_WIDTH),          
        .DATA_WIDTH(DATA_WIDTH),    
        .DATA_HEIGHT(DATA_HEIGHT)
    ) U_SHIFT_REG_IM_1_0 (
        .clk    (clk),
        .rstn   (rstn),
        .din    (w_reg_im),
        .s_dout (w_reg_out_im)
    );



    add_sub_1_0_fac_8_0 #(
        . WIDTH       (I_WIDTH),
        . DATA_WIDTH  (DATA_WIDTH)
    ) U_ADD_SUB_8_0_1_0(
    . fac8_0_cal(fac_8_0_1_0),
    . din_re(w_cal_re)    ,            
    . din_shift_reg_re(w_reg_out_re) ,     
    . din_im (w_cal_im)    ,          
    . din_shift_reg_im(w_reg_out_im) ,     
    . add_re(w_add_out_re) ,
    . add_im(w_add_out_im) ,
    . sub_re(w_sub_out_re) ,
    . sub_im(w_sub_out_im)
    );



    shift_register_1sub #(
        .WIDTH(I_WIDTH+1),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(DATA_HEIGHT)
    )U_SHIFT_SAVE_RE_1_0(
        .clk(clk),
        .rstn(rstn),
        .din   (w_sub_out_re),
        .s_dout(w_shift_sub_out_re)
    );

    shift_register_1sub #(
        .WIDTH(I_WIDTH+1),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(DATA_HEIGHT)
    )U_SHIFT_SAVE_IM_1_0(
        .clk(clk),
        .rstn(rstn),
        .din   (w_sub_out_im),
        .s_dout(w_shift_sub_out_im)
    );

    mux_2x1 #(
        . WIDTH (O_WIDTH),
        . DATA_WIDTH (DATA_WIDTH)
    ) U_MUX_2x1_1_0 (
        . sw(output_switch_1_0),
        . add_re(w_add_out_re) ,
        . add_im(w_add_out_im) ,
        . sub_re(w_shift_sub_out_re) ,
        . sub_im(w_shift_sub_out_im) ,
        . dout_re(dout_re) ,
        . dout_im(dout_im) 
    );




endmodule
