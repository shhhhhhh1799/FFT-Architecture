//`timescale 1ns / 1ps

module mutl_tw #(
    parameter WIDTH = 13
)(
    input clk,
    input rstn,
    input logic signed [WIDTH-1:0] a_re,
    input logic signed [WIDTH-1:0] a_im,
    input logic signed [8:0] b_re,
    input logic signed [8:0] b_im,
    output logic signed [WIDTH+8:0] m_re,
    output logic signed [WIDTH+8:0] m_im

);

//logic signed [WIDTH+9-1:0]   arbr, arbi, aibr, aibi;
//logic signed [WIDTH+9:0] w_m_re, w_m_im;

//  
//assign  arbr = a_re * b_re;
//assign  arbi = a_re * b_im;
//assign  aibr = a_im * b_re;
//assign  aibi = a_im * b_im;

// 
//assign  w_m_re = arbr - aibi;
//assign  w_m_im = arbi + aibr;



always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        m_re <= '0;
        m_im <= '0;
    end
    else begin
        m_re <= (a_re * b_re) - (a_im * b_im);
        m_im <= (a_re * b_im) + (a_im * b_re);
    end
end

endmodule
