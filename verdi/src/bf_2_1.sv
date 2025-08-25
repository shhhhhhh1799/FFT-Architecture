`timescale 1ns / 1ps

module butterfly_2_1 #(
    parameter I_WIDTH = 13,
    parameter O_WIDTH = 15,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rstn,
    input valid_2_1,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic bf2_1_o_en
);

    logic valid_2_1_d1, valid_2_1_d2;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            valid_2_1_d1 <= 0;
            valid_2_1_d2 <= 0;
            bf2_1_o_en <= 0;
        end else begin
            valid_2_1_d1 <= valid_2_1;
            valid_2_1_d2 <= valid_2_1_d1;

            if (valid_2_1_d1) begin
                bf2_1_o_en <= 1;
            end else begin
                bf2_1_o_en <= 0;
            end
        end

    end



    logic signed [(I_WIDTH+1)-1:0] w_fac_i_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH+1)-1:0] w_fac_i_im [0:DATA_WIDTH-1];

    add_sub_2_1 #(
        . I_WIDTH  (I_WIDTH),
        . O_WIDTH   (I_WIDTH+1),
        . DATA_WIDTH  (DATA_WIDTH)
    ) U_ADD_2_0 (
        . clk(clk),
        . rstn(rstn),
        . din_re(din_re) ,         
        . din_im(din_im) ,         
        . add_sub_re(w_fac_i_re),
        . add_sub_im(w_fac_i_im) 
    );



    fac8_1_2_1 #(
        . I_WIDTH (14),
        . FAC_WIDTH (23),
        . O_WIDTH (15),
        . DATA_WIDTH (16),
        . SHIFT (8)
    ) U_FAC8_1_2_1(
        . clk(clk),
        . rstn(rstn),
        . din_re(w_fac_i_re) ,
        . din_im(w_fac_i_im) ,
        . dout_re(dout_re) ,
        . dout_im(dout_im) 
    );


endmodule