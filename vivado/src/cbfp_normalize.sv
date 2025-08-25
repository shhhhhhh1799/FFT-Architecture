`timescale 1ns / 1ps

module cbfp_normalize #(
    parameter I_WIDTH  = 16,
    parameter O_WIDTH  = 13
)(
    input  logic                         clk,
    input  logic                         rstn,

    input  logic signed [I_WIDTH-1:0]    in_re  [0:15],
    input  logic signed [I_WIDTH-1:0]    in_im  [0:15],
    input  logic [4:0]                   index1 [0:15],
    input  logic [4:0]                   index2 [0:15],

    output logic signed [O_WIDTH-1:0]    out_re [0:15],
    output logic signed [O_WIDTH-1:0]    out_im [0:15]
    
);
    
    // 내부 계산용 wire
    logic [5:0] shift_amt [0:15];
    logic signed [I_WIDTH-1:0] shifted_re [0:15];
    logic signed [I_WIDTH-1:0] shifted_im [0:15];
    logic [5:0]                 sum_index [0:15];

    // 계산 로직 (현재 클럭에서 수행)
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            sum_index[i] = index1[i] + index2[i];
            
            shift_amt[i] = (sum_index[i]>9)? (sum_index[i]-9):(9-sum_index[i]);

            if (sum_index[i] >= 23) begin
                shifted_re[i] = '0;
                shifted_im[i] = '0;
            end else begin
                if (sum_index[i]>9) begin
                    shifted_re[i] = in_re[i] >>> shift_amt[i];
                    shifted_im[i] = in_im[i] >>> shift_amt[i];
                end else if (sum_index[i]<=9) begin
                    shifted_re[i] = in_re[i] <<< shift_amt[i];
                    shifted_im[i] = in_im[i] <<< shift_amt[i];                    
                end
            end

        end
    end

    // 출력은 한 클럭 지연
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (int i = 0; i < 16; i++) begin
                out_re[i] <= '0;
                out_im[i] <= '0;
            end
        end else begin
            for (int i = 0; i < 16; i++) begin
                out_re[i] <= shifted_re[i][O_WIDTH-1:0]; // Output 에 맞게 비트 슬라이싱
                out_im[i] <= shifted_im[i][O_WIDTH-1:0];
            end
        end
    end

endmodule
