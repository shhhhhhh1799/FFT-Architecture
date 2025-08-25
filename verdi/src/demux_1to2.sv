`timescale 1ns / 1ps

module demux_1to2 #(
    parameter WIDTH = 9,
    parameter DATA_WIDTH = 16
) (
    input logic signed [WIDTH-1:0]  d_in_re [0:DATA_WIDTH-1],
    input logic signed [WIDTH-1:0]  d_in_im [0:DATA_WIDTH-1],
    input logic               sel,
    output logic signed [WIDTH-1:0] d_out_re_reg [0:DATA_WIDTH-1],
    output logic signed [WIDTH-1:0] d_out_re_cal [0:DATA_WIDTH-1] ,
    output logic signed [WIDTH-1:0] d_out_im_reg [0:DATA_WIDTH-1],
    output logic signed [WIDTH-1:0] d_out_im_cal [0:DATA_WIDTH-1]
);

integer i;

always @(*) begin
    for (i = 0; i < DATA_WIDTH; i = i + 1) begin
        d_out_re_reg[i] = 0;
        d_out_re_cal[i] = 0;
        d_out_im_reg[i] = 0;
        d_out_im_cal[i] = 0;
        if (sel == 0) begin
            d_out_re_reg[i] = d_in_re[i];
            d_out_im_reg[i] = d_in_im[i];
        end else begin
            d_out_re_cal[i] = d_in_re[i];
            d_out_im_cal[i] = d_in_im[i];
        end
    end
end
endmodule

