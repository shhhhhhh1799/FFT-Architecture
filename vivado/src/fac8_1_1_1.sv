`timescale 1ns / 1ps

module fac8_1_1_1 #(
    parameter I_WIDTH = 13,
    parameter FAC_WIDTH = 22,
    parameter O_WIDTH =14,
    parameter DATA_WIDTH = 16,
    parameter SHIFT = 8
)(
    input clk,
    input rstn,
    input [1:0] sel,
    input signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1]
);
    logic signed [FAC_WIDTH-1:0] next_dout_re [0:DATA_WIDTH-1];
    logic signed [FAC_WIDTH-1:0] next_dout_im [0:DATA_WIDTH-1];


    always_ff @(posedge clk, negedge rstn) begin
        if (~rstn) begin
            for (int i =0; i<DATA_WIDTH; i=i+1 ) begin                  // 변경
                dout_re[i] <= 0;
                dout_im[i] <= 0;           
            end
        end else begin
            for (int i =0 ;i<DATA_WIDTH ;i=i+1 ) begin                  // 변경
                dout_re[i] <= ((next_dout_re[i]+128)>>>SHIFT);
                dout_im[i] <= ((next_dout_im[i]+128)>>>SHIFT);
      	    end
   	end
end

    always_comb begin
    // fac8_1 = [256, 256, 256, -j*256, 256, 181-j*181, 256, -181-j*181]; % fixed <2.8>    
        case (sel)
            2'b00 : begin
                for (int i =0; i<(DATA_WIDTH/2); i=i+1) begin
                    next_dout_re[i] = 256*din_re[i];
                    next_dout_im[i] = 256*din_im[i];  
                end

                for (int i =(DATA_WIDTH/2); i<DATA_WIDTH; i=i+1) begin
                    next_dout_re[i] = 256*din_re[i];
                    next_dout_im[i] = 256*din_im[i];
                end
            end

            2'b01 : begin
                for (int i =0; i<(DATA_WIDTH/2); i=i+1) begin
                    next_dout_re[i] = 256*din_re[i];
                    next_dout_im[i] = 256*din_im[i];  
                end

                for (int i =(DATA_WIDTH/2); i<DATA_WIDTH; i=i+1) begin
                    next_dout_re[i] = 256 * din_im[i];
                    next_dout_im[i] = -256 * din_re[i];
                end                
            end

            2'b10 : begin
                for (int i =0; i<(DATA_WIDTH/2); i=i+1) begin
                    next_dout_re[i] = 256*din_re[i];
                    next_dout_im[i] = 256*din_im[i];  
                end

                for (int i =(DATA_WIDTH/2); i<DATA_WIDTH; i=i+1) begin
                    next_dout_re[i] = (181*din_re[i])+(181*din_im[i]);
                    next_dout_im[i] = (181*din_im[i])-(181*din_re[i]);
                end                
            end

            2'b11 : begin
                for (int i =0; i<(DATA_WIDTH/2); i=i+1) begin
                    next_dout_re[i] = 256*din_re[i];
                    next_dout_im[i] = 256*din_im[i];  
                end

                for (int i =(DATA_WIDTH/2); i<DATA_WIDTH; i=i+1) begin
                    next_dout_re[i] = (181*din_im[i])-(181*din_re[i]);
                    next_dout_im[i] = -((181*din_re[i])+(181*din_im[i]));
                end                
            end
        endcase
    end
endmodule

