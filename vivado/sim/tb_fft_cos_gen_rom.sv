`timescale 1ns / 1ps

module tb_fft_cos_gen_rom;

    // === 파라미터 및 신호 정의 ===
    parameter WIDTH = 9;
    parameter DEPTH = 512;
    parameter DATA_WIDTH = 16;

    logic clk;
    logic rstn;
    logic cos_dout_en;
    logic signed [WIDTH-1:0] cos_dout_re [0:15];
    logic signed [WIDTH-1:0] cos_dout_im [0:15];

    // fft_top 출력
    logic signed [12:0] fft_dout_re [0:15];
    logic signed [12:0] fft_dout_im [0:15];
    logic fft_output_en;

    // === 클럭, 리셋 ===
    initial clk = 0;
    always #5 clk = ~clk;  // 100MHz

    initial begin
        rstn = 0;
        #20;
        rstn = 1;
    end

    // === cos_gen_rom 인스턴스 ===
    cos_gen_rom #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) U_COS_ROM (
        .clk(clk),
        .rstn(rstn),
        .dout_re(cos_dout_re),
        .dout_im(cos_dout_im),
        .dout_en(cos_dout_en)
    );

    // === fft_top 인스턴스 ===
    fft_top U_FFT_TOP (
        .clk(clk),
        .rstn(rstn),
        .valid(cos_dout_en),
        .din_re(cos_dout_re),
        .din_im(cos_dout_im),
        .dout_re(fft_dout_re),
        .dout_im(fft_dout_im),
        .output_en(fft_output_en)
    );

    // === 출력 관찰 ===
    // (시뮬 wave로 확인하거나 아래처럼 텍스트로 출력)
    always_ff @(posedge clk) begin
        if (fft_output_en) begin
            $display("[%t ns] FFT OUT:", $time);
            for (int i = 0; i < 16; i++) begin
                $write("%d ", fft_dout_re[i]);
            end
            $write(" | ");
            for (int i = 0; i < 16; i++) begin
                $write("%d ", fft_dout_im[i]);
            end
            $display("");
        end
    end

    // (시뮬 자동 종료, 충분히 돌린 후)
    initial begin
        #100000;
        $finish;
    end

endmodule
