`timescale 1ns / 1ps

module butterfly_2_0 #(
    parameter I_WIDTH = 12,
    parameter O_WIDTH = 13,
    parameter DATA_WIDTH  = 16
) (
    input logic clk,
    input logic rstn,
    input logic valid_2_0,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic bf2_0_o_en
);

    logic valid_2_0_d1;

    always @(posedge clk, negedge rstn) begin
        if (~rstn) begin
            bf2_0_o_en <= 0;
        end else begin
            if (valid_2_0) begin
                bf2_0_o_en <= 1;
            end else begin
                bf2_0_o_en <= 0;
            end
        end
    end



    add_sub_2_0 #(
        . I_WIDTH  (I_WIDTH),
        . O_WIDTH   (O_WIDTH)
    ) U_ADD_2_0 (
        . clk(clk),
        . rstn(rstn),
        . din_re(din_re)     ,         
        . din_im(din_im)     ,         
        . add_sub_re(dout_re) ,
        . add_sub_im(dout_im) 
    );
endmodule
