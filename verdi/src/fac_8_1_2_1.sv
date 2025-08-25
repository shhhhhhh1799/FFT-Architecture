`timescale 1ns / 1ps

module fac8_1_2_1 #(
    parameter I_WIDTH = 14,
    parameter FAC_WIDTH = 23,
    parameter O_WIDTH =15,
    parameter DATA_WIDTH = 16,
    parameter SHIFT = 8
)(
    input clk,
    input rstn,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1]
);


    logic signed [O_WIDTH-1:0] reg_dout_re [0:DATA_WIDTH-1];
    logic signed [O_WIDTH-1:0] reg_dout_im [0:DATA_WIDTH-1];

    logic signed [FAC_WIDTH-1:0] next_dout_re [0:DATA_WIDTH-1];
    logic signed [FAC_WIDTH-1:0] next_dout_im [0:DATA_WIDTH-1];

    assign dout_re = reg_dout_re;
    assign dout_im = reg_dout_im;


    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (int i =0 ;i<DATA_WIDTH ;i=i+1 ) begin               
                reg_dout_re[i] <= 0;
                reg_dout_im[i] <= 0;  
            end
        end else begin
            for (int i =0 ;i<DATA_WIDTH ;i=i+1 ) begin                
                reg_dout_re[i] <= ((next_dout_re[i]+128)>>>SHIFT);
                reg_dout_im[i] <= ((next_dout_im[i]+128)>>>SHIFT);
      	    end
   	end
end

    always_comb begin
    // fac8_1 = [256, 256, 256, -j*256, 256, 181-j*181, 256, -181-j*181]; % fixed <2.8>    
        for (int i =0; i<2; i=i+1) begin
            next_dout_re[i*8] = 256*din_re[i*8];
            next_dout_im[i*8] = 256*din_im[i*8];

            next_dout_re[i*8+1] = 256*din_re[i*8+1];
            next_dout_im[i*8+1] = 256*din_im[i*8+1];

            next_dout_re[i*8+2] = 256*din_re[i*8+2];
            next_dout_im[i*8+2] = 256*din_im[i*8+2];

            next_dout_re[i*8+3] = 256*din_im[i*8+3];
            next_dout_im[i*8+3] = -256*din_re[i*8+3];

            next_dout_re[i*8+4] = 256*din_re[i*8+4];
            next_dout_im[i*8+4] = 256*din_im[i*8+4];

            next_dout_re[i*8+5] = (181*din_re[i*8+5])+(181*din_im[i*8+5]);
            next_dout_im[i*8+5] = (181*din_im[i*8+5])-(181*din_re[i*8+5]);

            next_dout_re[i*8+6] = 256*din_re[i*8+6];
            next_dout_im[i*8+6] = 256*din_im[i*8+6];
            
            next_dout_re[i*8+7] = (181*din_im[i*8+7])-(181*din_re[i*8+7]) ;
            next_dout_im[i*8+7] = -((181*din_re[i*8+7])+(181*din_im[i*8+7]));
        end

    end
endmodule

