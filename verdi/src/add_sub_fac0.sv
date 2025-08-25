`timescale 1ns / 1ps

module add_sub_fac0 #(
    parameter WIDTH       = 9,
    parameter DATA_WIDTH  = 16
)(
   input  logic                fac8_0_cal,
   input  logic signed [WIDTH-1:0] din_re           [0:DATA_WIDTH-1],
   input  logic signed [WIDTH-1:0] din_shift_reg_re [0:DATA_WIDTH-1],
   input  logic signed [WIDTH-1:0] din_im           [0:DATA_WIDTH-1],
   input  logic signed [WIDTH-1:0] din_shift_reg_im [0:DATA_WIDTH-1],
   output logic signed [WIDTH:0]   add_re           [0:DATA_WIDTH-1],
   output logic signed [WIDTH:0]   sub_re           [0:DATA_WIDTH-1],
   output logic signed [WIDTH:0]   add_im           [0:DATA_WIDTH-1],
   output logic signed [WIDTH:0]   sub_im           [0:DATA_WIDTH-1]
);

    always_comb begin
        if (fac8_0_cal==0) begin
            for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
                add_re[i] = din_shift_reg_re[i] + din_re[i];
                add_im[i] = din_shift_reg_im[i] + din_im[i];
                sub_re[i] = din_shift_reg_re[i] - din_re[i];
                sub_im[i] = din_shift_reg_im[i] - din_im[i];
            end

        end else begin
            for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
                add_re[i] = din_shift_reg_re[i] + din_re[i];
                add_im[i] = din_shift_reg_im[i] + din_im[i];          
                sub_re[i] = din_shift_reg_im[i] - din_im[i];
                sub_im[i] = din_re[i] - din_shift_reg_re[i];
            end
        end
    end
    

endmodule
