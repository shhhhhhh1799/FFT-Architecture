`timescale 1ns / 1ps

module add_sub_1_0_fac_8_0 #(
    parameter WIDTH       = 9,
    parameter DATA_WIDTH  = 16
)(
   input                fac8_0_cal,
   input  logic signed [WIDTH-1:0]      din_re               [0:DATA_WIDTH-1],            // 256 ~ 511
   input  logic signed [WIDTH-1:0]      din_shift_reg_re    [0:DATA_WIDTH-1],      // 0 ~ 255
   input  logic signed [WIDTH-1:0]      din_im              [0:DATA_WIDTH-1],            // 256 ~ 511
   input  logic signed [WIDTH-1:0]      din_shift_reg_im [0:DATA_WIDTH-1],      // 0 ~ 255
   output logic signed [(WIDTH+1)-1:0]  add_re              [0:DATA_WIDTH-1],
   output logic signed [(WIDTH+1)-1:0]  sub_re              [0:DATA_WIDTH-1],
   output logic signed [(WIDTH+1)-1:0]  add_im              [0:DATA_WIDTH-1],
   output logic signed [(WIDTH+1)-1:0]  sub_im              [0:DATA_WIDTH-1]
);


    integer i;

    always_comb begin 
        if (!(fac8_0_cal)) begin
            for (i = 0; i < DATA_WIDTH; i=i+1) begin
            add_re[i] = din_shift_reg_re[i] + din_re[i];
            add_im[i] = din_shift_reg_im[i] + din_im[i];
            sub_re[i] = din_shift_reg_re[i] - din_re[i];
            sub_im[i] = din_shift_reg_im[i] - din_im[i];
            end 
        end else if (fac8_0_cal) begin
            for (i = 0; i < DATA_WIDTH; i=i+1) begin
            add_re[i] = din_shift_reg_re[i] + din_re[i];
            add_im[i] = din_shift_reg_im[i] + din_im[i];        
            sub_re[i] = din_shift_reg_im[i] - din_im[i];
            sub_im[i] = din_re[i] - din_shift_reg_re[i];
            end
        end
    end

endmodule