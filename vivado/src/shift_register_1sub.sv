`timescale 1ns / 1ps

module shift_register_1sub #(
    parameter WIDTH = 9,                                
    parameter DATA_WIDTH = 16,                          
    parameter DATA_HEIGHT = 16
)(
   input  clk,
   input  rstn,
   input  logic signed [WIDTH-1:0] din    [0:DATA_WIDTH-1],
   output logic signed [WIDTH-1:0] s_dout [0:DATA_WIDTH-1]
);

logic signed [WIDTH-1:0] shift_din [0:(DATA_HEIGHT * DATA_WIDTH)-1];

integer idx;

always @(posedge clk, negedge rstn) begin
    if (~rstn) begin
        for (idx = 0; idx < DATA_HEIGHT * DATA_WIDTH; idx = idx + 1) begin
            shift_din[idx] <= 0;
        end
        for (idx = 0; idx < DATA_WIDTH; idx = idx + 1) begin
            s_dout[idx] <= 0;
        end
    end else begin
        // Shift 데이터 이동
        for (idx = DATA_HEIGHT * DATA_WIDTH - 1; idx >= DATA_WIDTH; idx = idx - 1) begin
            shift_din[idx] <= shift_din[idx - DATA_WIDTH];
        end
        // 입력 데이터 맨 앞 저장
        for (idx = 0; idx < DATA_WIDTH; idx = idx + 1) begin
            shift_din[idx] <= din[idx];
        end
        // 출력 데이터 설정
        for (idx = 0; idx < DATA_WIDTH; idx = idx + 1) begin
            s_dout[idx] <= shift_din[(DATA_HEIGHT - 2) * DATA_WIDTH + idx];
        end
    end
end

endmodule
