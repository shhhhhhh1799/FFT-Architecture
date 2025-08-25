`timescale 1ns / 1ps

module delay #
(
    parameter WIDTH       = 9,
    parameter DATA_WIDTH  = 16
)(
    input clk,
    input rstn,
    input logic signed [WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input logic signed [WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [WIDTH-1:0] dout_im [0:DATA_WIDTH-1]
);

integer i ;

always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) begin
        for (i=0 ;i<16 ;i=i+1 ) begin
            dout_re[i] <=0;
            dout_im[i] <=0;
        end
    end
    else begin
            for (i=0 ;i<16 ;i=i+1) begin
                dout_re[i] <= din_re[i];
                dout_im[i] <= din_im[i];
            end           
    end
end
endmodule
