`timescale 1ns / 1ps

module butterfly_0_0 #(
    parameter WIDTH       = 9,
    parameter O_WIDTH = 10,
    parameter DATA_WIDTH  = 16,
    parameter DATA_HEIGHT = 16
) (
    input logic clk,
    input logic rstn,
    input logic valid_0_0,
    input signed [WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],

    output logic bf0_0_o_en
);
    logic signed [(WIDTH-1):0] w_reg_re [0:DATA_WIDTH-1];
    logic signed [(WIDTH-1):0] w_reg_im [0:DATA_WIDTH-1];
    logic signed [(WIDTH-1):0] w_cal_re [0:DATA_WIDTH-1];
    logic signed [(WIDTH-1):0] w_cal_im [0:DATA_WIDTH-1];

    logic signed [(WIDTH-1):0] w_reg_out_re [0:DATA_WIDTH-1];
    logic signed [(WIDTH-1):0] w_reg_out_im [0:DATA_WIDTH-1];

    logic signed [(O_WIDTH-1):0] w_add_out_re [0:DATA_WIDTH-1];
    logic signed [(O_WIDTH-1):0] w_add_out_im [0:DATA_WIDTH-1];
    logic signed [(O_WIDTH-1):0] w_sub_out_re [0:DATA_WIDTH-1];
    logic signed [(O_WIDTH-1):0] w_sub_out_im [0:DATA_WIDTH-1];

    logic signed [(O_WIDTH-1):0] w_shift_sub_out_re [0:DATA_WIDTH-1];
    logic signed [(O_WIDTH-1):0] w_shift_sub_out_im [0:DATA_WIDTH-1];   

    logic unsigned [5:0] cnt_0_0;
    logic unsigned [5:0] cnt_0_0_v2;


    logic w_fac8_0_cal, input_switch_0_0, output_switch_0_0;

    logic cnt_trig_0_0, cnt_trig_0_0_v2;

    always @(posedge clk, negedge rstn) begin
        if (~rstn) begin
            cnt_0_0 <= 0;
            w_fac8_0_cal <=0;
            input_switch_0_0 <=0;
            bf0_0_o_en <= 0;
            output_switch_0_0 <= 0;
            cnt_trig_0_0_v2 <=0;
            cnt_trig_0_0 <= 0;
            cnt_0_0_v2 <=0;
        end
        else begin
            if ((valid_0_0)) begin
                cnt_trig_0_0 <= 1;
                cnt_0_0 <= cnt_0_0+1;
            end else begin
                cnt_trig_0_0 <= 0;
                cnt_0_0 <= 0;
            end
            
            if (cnt_trig_0_0) begin
                cnt_0_0 <= cnt_0_0 + 1;
            end

            if (cnt_trig_0_0_v2) begin
                cnt_0_0_v2 <= cnt_0_0_v2 + 1;
            end



            if (cnt_0_0==15) begin
                input_switch_0_0 <= 1;
                bf0_0_o_en <= 1; 
            end else if (cnt_0_0==23) begin
                w_fac8_0_cal <= 1;
            end else if (cnt_0_0==31) begin
                output_switch_0_0 <= 1;
                input_switch_0_0 <= 0;
                cnt_trig_0_0_v2 <=1;
                w_fac8_0_cal <= 0;
                cnt_0_0_v2 <= cnt_0_0_v2 + 1;


            end else if (cnt_0_0_v2==16) begin  //  end else if (cnt_0_0==47) begin
                bf0_0_o_en <= 0;
		        cnt_trig_0_0_v2 <= 0;
                output_switch_0_0 <=0;
                cnt_0_0_v2 <= 0;
            end
        end
    end

    demux_1to2 #(
        .WIDTH(WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) U_DEMUX_1to2_0_0 (
        .d_in_re(din_re),
        .d_in_im(din_im),
        .sel(input_switch_0_0),
        .d_out_re_reg(w_reg_re),   //0~255
        .d_out_im_reg(w_reg_im),   //0~255
        .d_out_re_cal(w_cal_re),   //256~511
        .d_out_im_cal(w_cal_im)   //256~511
    );

    shift_register_1sub #(
        .WIDTH(WIDTH),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(16)
    )U_SHIFT_REG_RE_0_0(
        .clk(clk),
        .rstn(rstn),
        .din   (w_reg_re),
        .s_dout(w_reg_out_re)
    );

    shift_register_1sub #(
        .WIDTH(WIDTH),          
        .DATA_WIDTH(DATA_WIDTH),    
        .DATA_HEIGHT(16)
    )U_SHIFT_REG_IM_0_0(
        .clk(clk),
        .rstn(rstn),
        .din   (w_reg_im),
        .s_dout(w_reg_out_im)
    );


    add_sub_fac0 #(
        . WIDTH       (WIDTH),
        . DATA_WIDTH  (DATA_WIDTH)
    ) U_ADD_SUB_8_0_0_0(
    . fac8_0_cal(w_fac8_0_cal),
    . din_re(w_cal_re)    ,            // 256 ~ 511
    . din_shift_reg_re(w_reg_out_re) ,      // 0 ~ 255
    . din_im (w_cal_im)    ,            // 256 ~ 511
    . din_shift_reg_im(w_reg_out_im) ,      // 0 ~ 255
    . add_re(w_add_out_re) ,
    . add_im(w_add_out_im) ,
    . sub_re(w_sub_out_re) ,
    . sub_im(w_sub_out_im)
    );

    shift_register_1sub #(
        .WIDTH(WIDTH+1),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(16)
    )U_SHIFT_SAVE_RE_0_0(
        .clk(clk),
        .rstn(rstn),
        .din   (w_sub_out_re),
        .s_dout(w_shift_sub_out_re)
    );

    shift_register_1sub #(
        .WIDTH(WIDTH+1),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(16)
    )U_SHIFT_SAVE_IM_0_0(
        .clk(clk),
        .rstn(rstn),
        .din   (w_sub_out_im),
        .s_dout(w_shift_sub_out_im)
    );

    mux_2x1 #(
        . WIDTH (O_WIDTH),
        . DATA_WIDTH (DATA_WIDTH)
    ) U_MUX_2x1_0_0 (
        . sw(output_switch_0_0),
        . add_re(w_add_out_re) ,
        . add_im(w_add_out_im) ,
        . sub_re(w_shift_sub_out_re) ,
        . sub_im(w_shift_sub_out_im) ,
        . dout_re(dout_re) ,
        . dout_im(dout_im) 
    );
endmodule
