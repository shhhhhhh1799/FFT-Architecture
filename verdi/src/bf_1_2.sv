`timescale 1ns / 1ps

module butterfly_1_2 #(
    parameter I_WIDTH = 14,
    parameter O_WIDTH = 24,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rstn,
    input valid_1_2,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic bf1_2_o_en  
);

    logic [6:0] cnt_1_2;
    logic [6:0] sw_cnt_1_2;
    logic unsigned [1:0] count_twp;
    
    logic valid_1_2_d1, valid_1_2_d2, cnt_1_2_trig;

    logic signed [(I_WIDTH+1)-1:0] w_add_sub_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH+1)-1:0] w_add_sub_im [0:DATA_WIDTH-1];

    always @(posedge clk, negedge rstn) begin
        if (~rstn) begin
            cnt_1_2 <= 0;
            bf1_2_o_en <= 0;
            cnt_1_2_trig <= 0;
            valid_1_2_d1 <= 0;
            valid_1_2_d2 <= 0;
            count_twp <= 0;
        end
        else begin
            valid_1_2_d1 <= valid_1_2;
            valid_1_2_d2 <= valid_1_2_d1;
            if (valid_1_2) begin
                cnt_1_2_trig <= 1;
                cnt_1_2 <= cnt_1_2 + 1;
            end else if (valid_1_2||cnt_1_2_trig) begin
                cnt_1_2 <= cnt_1_2 + 1;
            end

            if (valid_1_2_d1) begin
                count_twp <= count_twp + 1;
            end

            if (cnt_1_2==2) begin
                bf1_2_o_en <= 1;
            end else if (cnt_1_2==34) begin
                bf1_2_o_en <= 0;
                cnt_1_2_trig <= 0;
                count_twp <= 0;
                cnt_1_2 <= 0;
                
            end
        end
    end


    add_sub_1_2 #(
        .WIDTH       (I_WIDTH),
        .DATA_WIDTH  (DATA_WIDTH)
    )U_ADD_SUB_1_2(                                            
    .clk(clk),
    .rstn(rstn),
    .din_re(din_re),
    .din_im(din_im),
    .add_sub_re(w_add_sub_re),
    .add_sub_im(w_add_sub_im)
    );


    twiddle_mult_m1 #(
        .I_WIDTH (I_WIDTH+1),
        .O_WIDTH (O_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    )U_TWM_1_2(
        .clk(clk),
        .rstn(rstn),
        .din_re(w_add_sub_re) ,
        .din_im(w_add_sub_im) ,
        .count(count_twp),
        .dout_re(dout_re),
        .dout_im(dout_im) 
    );


endmodule
