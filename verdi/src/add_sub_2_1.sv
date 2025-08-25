`timescale 1ns / 1ps

module add_sub_2_1 #(
    parameter I_WIDTH       = 13,
    parameter O_WIDTH       = 14,
    parameter DATA_WIDTH  = 16
)(
   input                clk,
   input                rstn,
   input  logic signed [I_WIDTH-1:0] din_re     [0:DATA_WIDTH-1],         
   input  logic signed [I_WIDTH-1:0] din_im     [0:DATA_WIDTH-1],         
   output logic signed [O_WIDTH-1:0] add_sub_re [0:DATA_WIDTH-1],
   output logic signed [O_WIDTH-1:0] add_sub_im [0:DATA_WIDTH-1]
);
    integer i;


    parameter ONE = DATA_WIDTH/8 , TWO = DATA_WIDTH*2/8 , THREE = DATA_WIDTH*3/8, FOUR = DATA_WIDTH*4/8, FIVE = DATA_WIDTH*5/8;
    parameter SIX = DATA_WIDTH*6/8, SEVEN = DATA_WIDTH*7/8;

    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i = 0; i < DATA_WIDTH; i=i+1) begin
                add_sub_re[i] <= 0;
                add_sub_im[i] <= 0;             
            end
        end else begin
            for (i=0; i<ONE; i=i+1) begin
                add_sub_re[i] <= din_re[i] + din_re[i+2];
                add_sub_im[i] <= din_im[i] + din_im[i+2];
            end

            for (i=ONE; i<TWO; i=i+1) begin
                add_sub_re[i] <= din_re[i-2] - din_re[i];
                add_sub_im[i] <= din_im[i-2] - din_im[i];     
            end

            for (i=TWO; i<THREE; i=i+1) begin
                add_sub_re[i] <= din_re[i] + din_re[i+2];
                add_sub_im[i] <= din_im[i] + din_im[i+2];
            end

            for (i=THREE; i<FOUR; i=i+1) begin
                add_sub_re[i] <= din_re[i-2] - din_re[i];
                add_sub_im[i] <= din_im[i-2] - din_im[i];      
            end

            for (i=FOUR; i<FIVE; i=i+1) begin
                add_sub_re[i] <= din_re[i] + din_re[i+2];
                add_sub_im[i] <= din_im[i] + din_im[i+2];
            end

            for (i=FIVE; i<SIX; i=i+1) begin
                add_sub_re[i] <= din_re[i-2] - din_re[i];
                add_sub_im[i] <= din_im[i-2] - din_im[i];          
            end

            for (i=SIX; i<SEVEN; i=i+1) begin
                add_sub_re[i] <= din_re[i] + din_re[i+2];
                add_sub_im[i] <= din_im[i] + din_im[i+2];    
            end

            for (i=SEVEN; i<DATA_WIDTH; i=i+1) begin
                add_sub_re[i] <= din_re[i-2] - din_re[i];
                add_sub_im[i] <= din_im[i-2] - din_im[i];    
            end            

        end
    end
endmodule
