`timescale 1ns / 1ps

module add_sub_2_2 #(
    parameter I_WIDTH       = 15,
    parameter O_WIDTH       = 16,
    parameter DATA_WIDTH  = 16
)(
    input clk,
    input rstn,
    input  logic signed [I_WIDTH-1:0] din_re     [0:DATA_WIDTH-1],         
    input  logic signed [I_WIDTH-1:0] din_im     [0:DATA_WIDTH-1],         
    output logic signed [O_WIDTH-1:0] add_sub_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] add_sub_im [0:DATA_WIDTH-1]
);

    integer i;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i=0; i<DATA_WIDTH; i=i+1 ) begin
                add_sub_re[i] <= '0;
                add_sub_im[i] <= '0;
            end
        end else begin
            add_sub_re[0]  <= din_re[0]  + din_re[1];
            add_sub_im[0]  <= din_im[0]  + din_im[1];

            add_sub_re[1]  <= din_re[0]  - din_re[1];
            add_sub_im[1]  <= din_im[0]  - din_im[1];

            add_sub_re[2]  <= din_re[2]  + din_re[3];
            add_sub_im[2]  <= din_im[2]  + din_im[3];

            add_sub_re[3]  <= din_re[2]  - din_re[3];
            add_sub_im[3]  <= din_im[2]  - din_im[3];

            add_sub_re[4]  <= din_re[4]  + din_re[5];
            add_sub_im[4]  <= din_im[4]  + din_im[5];

            add_sub_re[5]  <= din_re[4]  - din_re[5];
            add_sub_im[5]  <= din_im[4]  - din_im[5];

            add_sub_re[6]  <= din_re[6]  + din_re[7];
            add_sub_im[6]  <= din_im[6]  + din_im[7];

            add_sub_re[7]  <= din_re[6]  - din_re[7];
            add_sub_im[7]  <= din_im[6]  - din_im[7];

            add_sub_re[8]  <= din_re[8]  + din_re[9];
            add_sub_im[8]  <= din_im[8]  + din_im[9];

            add_sub_re[9]  <= din_re[8]  - din_re[9];
            add_sub_im[9]  <= din_im[8]  - din_im[9];

            add_sub_re[10] <= din_re[10] + din_re[11];
            add_sub_im[10] <= din_im[10] + din_im[11];

            add_sub_re[11] <= din_re[10] - din_re[11];
            add_sub_im[11] <= din_im[10] - din_im[11];

            add_sub_re[12] <= din_re[12] + din_re[13];
            add_sub_im[12] <= din_im[12] + din_im[13];

            add_sub_re[13] <= din_re[12] - din_re[13];
            add_sub_im[13] <= din_im[12] - din_im[13];

            add_sub_re[14] <= din_re[14] + din_re[15];
            add_sub_im[14] <= din_im[14] + din_im[15];

            add_sub_re[15] <= din_re[14] - din_re[15];
            add_sub_im[15] <= din_im[14] - din_im[15];
        end
    end

endmodule
