`timescale 1ns / 1ps

module butterfly_2_2 #(
    parameter I_WIDTH = 15,
    parameter O_WIDTH = 13,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rstn,
    input valid_2_2,
    input index1_valid,
    input index2_valid,
    input unsigned [4:0] index_1 [0:DATA_WIDTH-1],
    input unsigned [4:0] index_2 [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic bf_2_2_en  
);

    logic valid_2_2_d1, valid_2_2_d2,valid_2_2_d3,valid_2_2_d4 , reorder_en, output_en;
    logic cnt_2_2, cnt_2_2_d1, cnt_2_2_d2, out_cnt_flag, fall_edge;

    logic [6:0] out_cnt ;

    logic [4:0] w_index1 [0:DATA_WIDTH-1];
    logic [4:0] w_index2 [0:DATA_WIDTH-1];

    logic signed [(I_WIDTH+1)-1:0] w_cal_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH+1)-1:0] w_cal_im [0:DATA_WIDTH-1];

    logic signed [O_WIDTH-1:0] w_pre_reoder_re [0:DATA_WIDTH-1];
    logic signed [O_WIDTH-1:0] w_pre_reoder_im [0:DATA_WIDTH-1];

    assign fall_edge = (valid_2_2_d3==0)&&(valid_2_2_d4==1);

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            bf_2_2_en <= 0;
            valid_2_2_d1 <= 0;
            valid_2_2_d2 <= 0;
            valid_2_2_d3 <= 0;
            valid_2_2_d4 <= 0;
            cnt_2_2 <= 0;
            cnt_2_2_d1 <= 0;
            cnt_2_2_d2 <= 0;
            out_cnt_flag <= 0;
            out_cnt <= 0;
            reorder_en <= 0;
            output_en <= 0;
        end else begin
            valid_2_2_d1 <= valid_2_2 ;
            valid_2_2_d2 <= valid_2_2_d1;
            valid_2_2_d3 <= valid_2_2_d2;
            valid_2_2_d4 <= valid_2_2_d3;
            if (valid_2_2_d1) begin
                reorder_en <= 1;
            end else begin
                reorder_en <= 0;
            end

            if (fall_edge) begin
                output_en <= 1;
                out_cnt_flag <= 1;
                out_cnt <= out_cnt + 1;
            end else if (out_cnt_flag) begin
                out_cnt <= out_cnt + 1;
            end

            if (out_cnt==1) begin
                bf_2_2_en <= 1;
            end else if (out_cnt==32) begin
                output_en <= 0;
            end else if (out_cnt==33) begin
                bf_2_2_en <= 0;
                out_cnt_flag <= 0;
                out_cnt <= 0;
            end
        end
    end


    add_sub_2_2 #(
        . I_WIDTH  (I_WIDTH),
        . O_WIDTH  (16),
        . DATA_WIDTH (DATA_WIDTH)
    ) U_ADD_2_2(
        . clk (clk),
        . rstn (rstn),
        . din_re(din_re),         
        . din_im(din_im),         
        . add_sub_re(w_cal_re),
        . add_sub_im(w_cal_im) 
    );

    index_fifo #(   
        . WIDTH (5),
        . DATA_WIDTH (16),
        . MAX (32)
    )U_INDEX1_FIFO(
        . clk(clk),
        . rstn(rstn),
        . index_valid(index1_valid),
        . dout_en(valid_2_2),
        . in_index(index_1) ,
        . out_index(w_index1) 
    );

    index_fifo #(   
        . WIDTH (5),
        . DATA_WIDTH (16),
        . MAX (32)
    )U_INDEX2_FIFO(
        . clk(clk),
        . rstn(rstn),
        . index_valid(index2_valid),
        . dout_en(valid_2_2),
        . in_index(index_2) ,
        . out_index(w_index2) 
    );

    cbfp_normalize #(
        . I_WIDTH  (16),
        . O_WIDTH  (13)
    )U_INDEX_ORGANIZE(
        . clk(clk),
        . rstn(rstn),
        . in_re(w_cal_re)  ,
        . in_im(w_cal_im)  ,
        . index1(w_index1) ,
        . index2(w_index2) ,
        . out_re(w_pre_reoder_re) ,
        . out_im(w_pre_reoder_im) 
        
    );

    reorder #(
        . WIDTH (13)
    )U_REORDER_RE(
        . clk(clk),
        . rstn(rstn),
        . din(w_pre_reoder_re),
        . reorder_en (reorder_en),
        . output_en (output_en),
        . final_dout (dout_re)
    );

    reorder #(
        . WIDTH (13)
    )U_REORDER_IM(
        . clk(clk),
        . rstn(rstn),
        . din(w_pre_reoder_im),
        . reorder_en (reorder_en),
        . output_en (output_en),
        . final_dout (dout_im)
    );



endmodule