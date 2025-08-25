`timescale 1ns / 1ps

module add_sub_2_0 #(
    parameter I_WIDTH       = 12,
    parameter O_WIDTH       = 13
)(
   input                clk,
   input                rstn,
   input  logic signed [I_WIDTH-1:0] din_re     [0:15],         
   input  logic signed [I_WIDTH-1:0] din_im     [0:15],         
   output logic signed [O_WIDTH-1:0] add_sub_re [0:15],
   output logic signed [O_WIDTH-1:0] add_sub_im [0:15]
);
    integer i;


    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i = 0; i < 16; i=i+1) begin
                add_sub_re[i] <= 0;
                add_sub_im[i] <= 0;             
            end
        end else begin
            for (i=0; i<4; i=i+1) begin
                add_sub_re[i] <= din_re[i] + din_re[i+4];
                add_sub_im[i] <= din_im[i] + din_im[i+4];
            end

            for (i=4; i<6; i=i+1) begin
                add_sub_re[i] <= din_re[i-4] - din_re[i];
                add_sub_im[i] <= din_im[i-4] - din_im[i];     
            end

            for (i=6; i<8; i=i+1) begin
                add_sub_re[i] <= din_im[i-4] - din_im[i];
                add_sub_im[i] <= din_re[i] - din_re[i-4];     
            end            

            for (i=8; i<12; i=i+1) begin
                add_sub_re[i] <= din_re[i] + din_re[i+4];
                add_sub_im[i] <= din_im[i] + din_im[i+4]; 
            end

            for (i=12; i<14; i=i+1) begin
                add_sub_re[i] <= din_re[i-4] - din_re[i];
                add_sub_im[i] <= din_im[i-4] - din_im[i];     
            end

            for (i=14; i<16; i=i+1) begin
                add_sub_re[i] <= din_im[i-4] - din_im[i];
                add_sub_im[i] <= din_re[i] - din_re[i-4];     
            end

        end
    end
endmodule
