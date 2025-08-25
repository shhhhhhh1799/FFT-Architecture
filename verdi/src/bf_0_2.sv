`timescale 1ns / 1ps

module butterfly_0_2 #(
    parameter I_WIDTH = 13,
    parameter O_WIDTH = 22,
    parameter DATA_WIDTH = 16,
    parameter DATA_HEIGHT = 4
)(
    input clk,
    input rstn,
    input valid_0_2,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic bf0_2_o_en
    
);

    logic signed [(I_WIDTH-1):0] w_reg_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_reg_im [0:DATA_WIDTH-1];

    logic signed [(I_WIDTH-1):0] w_reg_out_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_reg_out_im [0:DATA_WIDTH-1];

    logic signed [(I_WIDTH-1):0] w_cal_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH-1):0] w_cal_im [0:DATA_WIDTH-1];

    logic signed [((I_WIDTH+1)-1):0] w_o_cal_add_re [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-1):0] w_o_cal_add_im [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-1):0] w_o_cal_sub_re [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-1):0] w_o_cal_sub_im [0:DATA_WIDTH-1];

    logic signed [((I_WIDTH+1)-2):0] s_w_o_cal_add_re [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-2):0] s_w_o_cal_add_im [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-2):0] s_w_o_cal_sub_re [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-2):0] s_w_o_cal_sub_im [0:DATA_WIDTH-1];

    logic [5:0] count;         // 0~31까지만 쓰므로 6비트 충분
    logic       mux_valid;     // mux에서 valid out용

    logic signed [((I_WIDTH+1)-2):0] mux_out_re [0:DATA_WIDTH-1];
    logic signed [((I_WIDTH+1)-2):0] mux_out_im [0:DATA_WIDTH-1];



    logic [6:0] cnt_0_2;
    logic [6:0] sw_cnt_0_2;
    
    logic cnt_0_2_trig, mux_0_2_en;
    logic bf0_2_mult_en;
    logic sw_reg_cal;

    logic input_switch_0_2, output_switch_0_2;


    always @(posedge clk, negedge rstn) begin
        if (~rstn) begin
            cnt_0_2 <= 0;
            input_switch_0_2 <= 0;
            output_switch_0_2 <= 0;
            //bf0_2_o_en <= 0;
            sw_cnt_0_2 <= 0;
            mux_0_2_en <= 0;
	        cnt_0_2_trig <= 0;
        end
        else begin
            if (valid_0_2&&cnt_0_2_trig==0) begin
                cnt_0_2_trig <= 1;
                cnt_0_2 <= cnt_0_2 + 1;
                sw_cnt_0_2 <= sw_cnt_0_2 + 1;
            end else if (valid_0_2||cnt_0_2_trig) begin
                cnt_0_2 <= cnt_0_2 + 1;
                sw_cnt_0_2 <= sw_cnt_0_2 + 1;
            end

            if (sw_cnt_0_2==3) begin
                input_switch_0_2 <= 1;
            end else if (sw_cnt_0_2==7) begin
                input_switch_0_2 <= 0;      
            end else if (sw_cnt_0_2==11) begin
                input_switch_0_2 <= 1;
            end else if (sw_cnt_0_2==15) begin
                input_switch_0_2 <= 0;      
            end else if (sw_cnt_0_2==19) begin
                input_switch_0_2 <= 1;
            end else if (sw_cnt_0_2==23) begin
                input_switch_0_2 <= 0;      
            end else if (sw_cnt_0_2==27) begin
                input_switch_0_2 <= 1;
            end else if (sw_cnt_0_2==31) begin
                input_switch_0_2 <= 0;      
            end 
            
            if (cnt_0_2==3) begin
                mux_0_2_en <= 1;      
            end else if (cnt_0_2==35) begin
                mux_0_2_en <= 0;
	    	    cnt_0_2_trig <= 0;
                cnt_0_2 <= 0;
                sw_cnt_0_2 <= 0;
                input_switch_0_2 <=0;
            end 
        end
    end

     demux_1to2 #(
        .WIDTH(I_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) U_DEMUX_1to2_0_0 (
        .d_in_re(din_re),
        .d_in_im(din_im),
        .sel(input_switch_0_2),
        .d_out_re_reg(w_reg_re),  
        .d_out_re_cal(w_cal_re),  
        .d_out_im_reg(w_reg_im),  
        .d_out_im_cal(w_cal_im)   
    );

    shift_register_1sub #(
        .WIDTH(I_WIDTH),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(DATA_HEIGHT)
    )U_SHIFT_REG_RE_0_2(  
        .clk(clk),
        .rstn(rstn),
        .din   (w_reg_re),
        .s_dout(w_reg_out_re)
    );

    shift_register_1sub #(
        .WIDTH(I_WIDTH),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(DATA_HEIGHT)
    )U_SHIFT_REG_IM_0_2( 
        .clk(clk),
        .rstn(rstn),
        .din   (w_reg_im),
        .s_dout(w_reg_out_im)
    );


    add_sub #(
        . WIDTH       (I_WIDTH),
        . DATA_WIDTH  (DATA_WIDTH)
    ) U_ADD_SUB_0_2 (                                           
    . clk(clk),
    . rstn(rstn),
    . din_re(w_cal_re),
    . din_im(w_cal_im),
    . din_shift_reg_re(w_reg_out_re) , 
    . din_shift_reg_im(w_reg_out_im) ,
    . add_re(w_o_cal_add_re),
    . add_im(w_o_cal_add_im),
    . sub_re(w_o_cal_sub_re),
    . sub_im(w_o_cal_sub_im)
    );


    sat #(
        .WIDTH(14),
        .SAT_WIDTH(13) 
    ) U_SAT_1(
    .din(w_o_cal_add_re),
    .dout(s_w_o_cal_add_re)
    );

    sat #(
        .WIDTH(14),
        .SAT_WIDTH(13) 
    )U_SAT_2(
    .din(w_o_cal_add_im),
    .dout(s_w_o_cal_add_im)
    );

    sat #(
        .WIDTH(14),
        .SAT_WIDTH(13) 
    )U_SAT_3(
    .din(w_o_cal_sub_re),
    .dout(s_w_o_cal_sub_re)
    );

    sat #(
        .WIDTH(14),
        .SAT_WIDTH(13) 
    )U_SAT_4(
    .din(w_o_cal_sub_im),
    .dout(s_w_o_cal_sub_im)
    );

    // shift_register_1sub #(
    //     .WIDTH(I_WIDTH+1),          
    //     .DATA_WIDTH(DATA_WIDTH),  
    //     .DATA_HEIGHT(DATA_HEIGHT)
    // )U_SHIFT_SAVE_RE_0_2(
    //     .clk(clk),
    //     .rstn(rstn),
    //     .din   (w_o_cal_sub_re),
    //     .s_dout(w_shift_4clk_sub_re)
    // );

    // shift_register_1sub #(
    //     .WIDTH(I_WIDTH+1),          
    //     .DATA_WIDTH(DATA_WIDTH),  
    //     .DATA_HEIGHT(DATA_HEIGHT)
    // )U_SHIFT_SAVE_IM_0_2(
    //     .clk(clk),
    //     .rstn(rstn),
    //     .din   (w_o_cal_sub_im),
    //     .s_dout(w_shift_4clk_sub_im)
    // );

    
    mux_twiddle_input u_mux (
        .clk(clk), .rstn(rstn),
        .do_en(mux_0_2_en),
        .add_re(s_w_o_cal_add_re), .add_im(s_w_o_cal_add_im),
        .sub_re(s_w_o_cal_sub_re), .sub_im(s_w_o_cal_sub_im),
        .mux_out_re(mux_out_re),
        .mux_out_im(mux_out_im),
        .count(count),
        .mux_valid(mux_valid)
    );

    twiddle_mult_pipe #(
        .I_WIDTH(13),
        .O_WIDTH(O_WIDTH),
        .DATA_WIDTH(16)
        ) u_mult_pipe (
        .clk(clk), .rstn(rstn),
        .din_re(mux_out_re),
        .din_im(mux_out_im),
        .count(count),
        .valid_in(mux_valid),
        .dout_re(dout_re),
        .dout_im(dout_im),
        .valid_out(bf0_2_o_en)
    );



endmodule
