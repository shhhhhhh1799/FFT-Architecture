`timescale 1ns / 1ps

module TOP_test_fft(
    input clk_p,
    input clk_n,
    input rstn
    );
    
    logic signed [8:0] din_re [0:15];
    logic signed [8:0] din_im [0:15];
    logic signed [12:0] dout_re [0:15];
    logic signed [12:0] dout_im [0:15];    

    logic w_fft_valid;
    logic w_vio_valid;
    logic clk_real;

    clk_wiz_0 U_CLK_WIZ
    (
        .  resetn(rstn),
        .  clk_in1_p(clk_p),
        .  clk_in1_n(clk_n),
        .  clk_out1(clk_real)
    );

   cos_gen_rom #(
        .WIDTH(9),
        .DEPTH(512)
    ) U_COS_GEN (
        .clk(clk_real),
        .rstn(rstn),
        .dout_re(din_re),
        .dout_im(din_im),
        .dout_en (w_fft_valid)
    );

    fft_top U_FFT_TOP (
        .clk(clk_real),
        .rstn(rstn),
        .valid(w_fft_valid),
        .din_re(din_re),
        .din_im(din_im),
        .dout_re(dout_re),
        .dout_im(dout_im),
        .output_en(w_vio_valid)
    );

    vio_0 U_VIO(
    .clk(clk_real),
    .probe_in0(w_vio_valid),
    .probe_in1(dout_re[0]),
    .probe_in2(dout_re[1]),
    .probe_in3(dout_re[2]),
    .probe_in4(dout_re[3]),
    .probe_in5(dout_re[4]),
    .probe_in6(dout_re[5]),
    .probe_in7(dout_re[6]),
    .probe_in8(dout_re[7]),
    .probe_in9(dout_re[8]),
    .probe_in10(dout_re[9]),
    .probe_in11(dout_re[10]),
    .probe_in12(dout_re[11]),
    .probe_in13(dout_re[12]),
    .probe_in14(dout_re[13]),
    .probe_in15(dout_re[14]),
    .probe_in16(dout_re[15]),
    .probe_in17(dout_im[0]),
    .probe_in18(dout_im[1]),
    .probe_in19(dout_im[2]),
    .probe_in20(dout_im[3]),
    .probe_in21(dout_im[4]),
    .probe_in22(dout_im[5]),
    .probe_in23(dout_im[6]),
    .probe_in24(dout_im[7]),
    .probe_in25(dout_im[8]),
    .probe_in26(dout_im[9]),
    .probe_in27(dout_im[10]),
    .probe_in28(dout_im[11]),
    .probe_in29(dout_im[12]),
    .probe_in30(dout_im[13]),
    .probe_in31(dout_im[14]),
    .probe_in32(dout_im[14]),
    .probe_out0()
    );

endmodule
