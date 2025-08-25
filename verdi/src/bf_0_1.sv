`timescale 1ns / 1ps


module butterfly_0_1 #(
    parameter WIDTH = 10,
    parameter O_WIDTH = 13,
    parameter DATA_WIDTH = 16,
    parameter DATA_HEIGHT = 8
)(
    input clk,
    input rstn,
    input valid_0_1,
    input signed [WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic bf0_1_o_en
);

    logic signed [(WIDTH-1):0] w_reg_re [0:DATA_WIDTH-1];
    logic signed [(WIDTH-1):0] w_reg_im [0:DATA_WIDTH-1];
    logic signed [(WIDTH-1):0] w_cal_re [0:DATA_WIDTH-1];
    logic signed [(WIDTH-1):0] w_cal_im [0:DATA_WIDTH-1];
    
    logic signed [(WIDTH-1):0] w_reg_out_re [0:DATA_WIDTH-1];
    logic signed [(WIDTH-1):0] w_reg_out_im [0:DATA_WIDTH-1];

    logic signed [((WIDTH+1)-1):0] w_add_re [0:DATA_WIDTH-1];
    logic signed [((WIDTH+1)-1):0] w_add_im [0:DATA_WIDTH-1];
    logic signed [((WIDTH+1)-1):0] w_sub_re [0:DATA_WIDTH-1];
    logic signed [((WIDTH+1)-1):0] w_sub_im [0:DATA_WIDTH-1];


    logic signed [((WIDTH+1)-1):0] w_fac_din_re [0:DATA_WIDTH-1];
    logic signed [((WIDTH+1)-1):0] w_fac_din_im [0:DATA_WIDTH-1];

    logic signed [((WIDTH+1)-1):0] w_shift_sub_out_re [0:DATA_WIDTH-1];
    logic signed [((WIDTH+1)-1):0] w_shift_sub_out_im [0:DATA_WIDTH-1];   
   
    logic cnt_trig_0_1, cnt_0_0_part2_trig;

    logic input_switch_0_1, output_switch_0_1;
    logic [4:0] sel_cnt;
    logic [4:0] sel_cnt_2;
    logic [2:0] fac_sel;

    always @(posedge clk, negedge rstn) begin
        if (~rstn) begin
            input_switch_0_1 <= 0;
            sel_cnt <=0;
            fac_sel <=0;
            bf0_1_o_en <=0;
            cnt_trig_0_1 <=0;
	        output_switch_0_1 <=0;
            sel_cnt_2 <= 0;
            cnt_0_0_part2_trig <=0;
        end
        else begin
            // 수정 : count 모두 1씩 추가.
            if (valid_0_1) begin
                sel_cnt <= sel_cnt + 1;
                cnt_trig_0_1 <= 1;
            end else begin
                cnt_trig_0_1 <=0;
                sel_cnt <= 0;
            end
            
            
            if (cnt_trig_0_1) begin
                sel_cnt <= sel_cnt + 1;
            end 

            if (cnt_0_0_part2_trig) begin
                sel_cnt_2 <= sel_cnt_2 + 1;
            end

            if (sel_cnt ==7) begin
                input_switch_0_1 <= 1;
            end else if (sel_cnt==9) begin
                bf0_1_o_en <= 1;
            end else if (sel_cnt==15) begin
                input_switch_0_1 <= 0; 
            end  else if (sel_cnt==16) begin
                output_switch_0_1 <= 1; 
            end else if (sel_cnt==23) begin
                input_switch_0_1 <= 1;
            end else if (sel_cnt==24) begin
                output_switch_0_1 <= 0;
            end else if (sel_cnt==31) begin
                input_switch_0_1 <= 0;
                cnt_trig_0_1 <= 0;
                cnt_0_0_part2_trig <= 1;
                sel_cnt <= 0;
                sel_cnt_2 <= sel_cnt_2 + 1;
            end else if (sel_cnt_2==1) begin  // end else if (sel_cnt==32) 
                output_switch_0_1 <= 1; 
            end else if (sel_cnt_2==9) begin  // end else if (sel_cnt==40) begin
                output_switch_0_1 <= 0; 
            end else if (sel_cnt_2==10) begin //  end else if (sel_cnt==41)
                bf0_1_o_en <= 0;
		        cnt_0_0_part2_trig <= 0;
                fac_sel <= 0;
                sel_cnt_2 <= 0;

            end

            if (sel_cnt==12) begin
                fac_sel <= fac_sel + 1;
            end else if (sel_cnt==16) begin
                fac_sel <= fac_sel + 1;
            end else if (sel_cnt==20) begin
                fac_sel <= fac_sel + 1;
            end else if (sel_cnt==24) begin
                fac_sel <= fac_sel + 1;
            end else if (sel_cnt==28) begin
                fac_sel <= fac_sel + 1;
            end else if (sel_cnt_2==1) begin // end else if (sel_cnt==32)
                fac_sel <= fac_sel + 1;
            end else if (sel_cnt_2==5) begin // end else if (sel_cnt==36) begin
                fac_sel <= fac_sel + 1;
            end else if (sel_cnt_2==9) begin  // end else if (sel_cnt==40) begin 
                fac_sel <= fac_sel + 1;
            end
        end
    end

    demux_1to2 #(
        .WIDTH(WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) U_DEMUX_1to2_0_0 (
        .d_in_re(din_re),
        .d_in_im(din_im),
        .sel(input_switch_0_1),
        .d_out_re_reg(w_reg_re),  
        .d_out_re_cal(w_cal_re),  
        .d_out_im_reg(w_reg_im),  
        .d_out_im_cal(w_cal_im)   
    );

    shift_register_1sub #(
        .WIDTH(WIDTH),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(DATA_HEIGHT)
    )U_SHIFT_REG_RE_0_1(
        .clk(clk),
        .rstn(rstn),
        .din   (w_reg_re),
        .s_dout(w_reg_out_re)
    );

    shift_register_1sub #(
        .WIDTH(WIDTH),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(DATA_HEIGHT)
    )U_SHIFT_REG_IM_0_1(
        .clk(clk),
        .rstn(rstn),
        .din   (w_reg_im),
        .s_dout(w_reg_out_im)
    );

    add_sub #(
        . WIDTH       (WIDTH),
        . DATA_WIDTH  (DATA_WIDTH)
    ) U_ADD_SUB_0_1 (                                          
    . clk(clk),
    . rstn(rstn),
    . din_re(w_cal_re),
    . din_im(w_cal_im),
    . din_shift_reg_re(w_reg_out_re) , 
    . din_shift_reg_im(w_reg_out_im) ,
    . add_re(w_add_re),
    . add_im(w_add_im),
    . sub_re(w_sub_re),
    . sub_im(w_sub_im)
    );

    shift_register_1sub #(
        .WIDTH(WIDTH+1),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(8)
    )U_SHIFT_SAVE_RE_0_1(
        .clk(clk),
        .rstn(rstn),
        .din   (w_sub_re),
        .s_dout(w_shift_sub_out_re)
    );

    shift_register_1sub #(
        .WIDTH(WIDTH+1),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(8)
    )U_SHIFT_SAVE_IM_0_1(
        .clk(clk),
        .rstn(rstn),
        .din   (w_sub_im),
        .s_dout(w_shift_sub_out_im)
    );

    mux_2x1 #(
        . WIDTH (WIDTH+1),
        . DATA_WIDTH (DATA_WIDTH)
    ) U_MUX_2x1_0_0 (
        . sw(output_switch_0_1),
        . add_re(w_add_re) ,
        . add_im(w_add_im) ,
        . sub_re(w_shift_sub_out_re) ,
        . sub_im(w_shift_sub_out_im) ,
        . dout_re(w_fac_din_re) ,
        . dout_im(w_fac_din_im) 
    );

    fac8_1 #(
        . I_WIDTH (WIDTH+1),        
        . FAC_WIDTH (21),
        . O_WIDTH (13),
        . DATA_WIDTH (16),
        . SHIFT (8)
    ) U_FAC8_1_0_1 (                                     
        . clk (clk),
        . rstn (rstn),
        . sel(fac_sel),
        . din_re (w_fac_din_re),
        . din_im (w_fac_din_im),
        . dout_re (dout_re),
        . dout_im (dout_im)
    );

endmodule


