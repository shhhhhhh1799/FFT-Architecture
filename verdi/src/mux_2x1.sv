`timescale 1ns / 1ps

module mux_2x1 #(
    parameter WIDTH = 10,
    parameter DATA_WIDTH =16
)
(
    input sw,
    input logic signed [WIDTH-1:0] add_re [0:DATA_WIDTH-1],
    input logic signed [WIDTH-1:0] add_im [0:DATA_WIDTH-1],
    input logic signed [WIDTH-1:0] sub_re [0:DATA_WIDTH-1],
    input logic signed [WIDTH-1:0] sub_im [0:DATA_WIDTH-1],
    output logic signed [WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [WIDTH-1:0] dout_im [0:DATA_WIDTH-1]
);
    
    integer i;

    always @(*) begin
        for (i =0; i<DATA_WIDTH; i=i+1 ) begin
            if (sw==0) begin
                dout_re [i] = add_re[i];
                dout_im [i] = add_im[i];
            end else begin
                dout_re [i] = sub_re[i];
                dout_im [i] = sub_im[i];            
            end 
        end
    end
endmodule