`timescale 1ns / 1ps

module add_sub_1_2 #(
    parameter WIDTH       = 13,
    parameter DATA_WIDTH  = 16
)(
   input                clk,
   input                rstn,
   input  logic signed [WIDTH-1:0] din_re     [0:DATA_WIDTH-1],         
   input  logic signed [WIDTH-1:0] din_im     [0:DATA_WIDTH-1],         
   output logic signed [(WIDTH+1)-1:0]  add_sub_re [0:DATA_WIDTH-1],
   output logic signed [(WIDTH+1)-1:0]  add_sub_im [0:DATA_WIDTH-1]
);
    integer i;

    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i = 0; i < DATA_WIDTH; i=i+1) begin
                add_sub_re[i] <= 0;
                add_sub_im[i] <= 0;             
            end
        end else begin
            for (i=0; i<(DATA_WIDTH/2); i=i+1) begin
                add_sub_re[i] <= din_re[i] + din_re[i+8];
                add_sub_im[i] <= din_im[i] + din_im[i+8];
            end

            for (i=(DATA_WIDTH/2); i<DATA_WIDTH; i=i+1) begin
                add_sub_re[i] <= din_re[i-8] - din_re[i];
                add_sub_im[i] <= din_im[i-8] - din_im[i];     
            end
        end
    end
endmodule
