// `timescale 1ns / 1ps

// 512-point Twiddle Factor ROM 모듈 (<2.7> 형식, signed 9bit 출력)
// addr에 해당하는 twiddle factor를 복소수 형태로 출력함
// 출력은 항상 1클럭 레지스터를 통해 클럭 동기화됨

module twiddle_64 (
    input   clk,
    input [5:0] addr,                 // twiddle 주소 (0~63)
    output signed [8:0] tw_re,       // twiddle의 실수부 (<2.7>)
    output signed [8:0] tw_im        // twiddle의 허수부 (<2.7>)
);

    // 내부 Twiddle Table 정의 (ROM처럼 사용)
    wire [8:0] twf_rom_re[0:511];  // 실수부 테이블
    wire [8:0] twf_rom_im[0:511];  // 허수부 테이블

    // 선택된 twiddle factor
    wire [8:0] mx_re = twf_rom_re[addr];  // MUX로 선택된 실수부
    wire [8:0] mx_im = twf_rom_im[addr];  // MUX로 선택된 허수부

    // 클럭 동기화용 FF
    reg  [8:0] ff_re;         // FF에 저장된 실수부
    reg  [8:0] ff_im;         // FF에 저장된 허수부

    // 클럭 동기화
    always @(posedge clk) begin
        ff_re <= mx_re;
        ff_im <= mx_im;
    end

    // 최종 출력 (무조건 FF 경유)
        assign tw_re = ff_re;
        assign tw_im = ff_im;

    assign  twf_rom_re[  0] = 9'd128;  assign  twf_rom_im[  0] = 9'd0;
    assign  twf_rom_re[  1] = 9'd128;  assign  twf_rom_im[  1] = 9'd0;
    assign  twf_rom_re[  2] = 9'd128;  assign  twf_rom_im[  2] = 9'd0;
    assign  twf_rom_re[  3] = 9'd128;  assign  twf_rom_im[  3] = 9'd0;
    assign  twf_rom_re[  4] = 9'd128;  assign  twf_rom_im[  4] = 9'd0;
    assign  twf_rom_re[  5] = 9'd128;  assign  twf_rom_im[  5] = 9'd0;
    assign  twf_rom_re[  6] = 9'd128;  assign  twf_rom_im[  6] = 9'd0;
    assign  twf_rom_re[  7] = 9'd128;  assign  twf_rom_im[  7] = 9'd0;
    assign  twf_rom_re[  8] = 9'd128;  assign  twf_rom_im[  8] = 9'd0;
    assign  twf_rom_re[  9] = 9'd118;  assign  twf_rom_im[  9] = -9'd49;
    assign  twf_rom_re[ 10] = 9'd91;   assign  twf_rom_im[ 10] = -9'd91;
    assign  twf_rom_re[ 11] = 9'd49;   assign  twf_rom_im[ 11] = -9'd118;
    assign  twf_rom_re[ 12] = 9'd0;    assign  twf_rom_im[ 12] = -9'd128;
    assign  twf_rom_re[ 13] = -9'd49;  assign  twf_rom_im[ 13] = -9'd118;
    assign  twf_rom_re[ 14] = -9'd91;  assign  twf_rom_im[ 14] = -9'd91;
    assign  twf_rom_re[ 15] = -9'd118; assign  twf_rom_im[ 15] = -9'd49;
    assign  twf_rom_re[ 16] = 9'd128;  assign  twf_rom_im[ 16] = 9'd0;
    assign  twf_rom_re[ 17] = 9'd126;  assign  twf_rom_im[ 17] = -9'd25;
    assign  twf_rom_re[ 18] = 9'd118;  assign  twf_rom_im[ 18] = -9'd49;
    assign  twf_rom_re[ 19] = 9'd106;  assign  twf_rom_im[ 19] = -9'd71;
    assign  twf_rom_re[ 20] = 9'd91;   assign  twf_rom_im[ 20] = -9'd91;
    assign  twf_rom_re[ 21] = 9'd71;   assign  twf_rom_im[ 21] = -9'd106;
    assign  twf_rom_re[ 22] = 9'd49;   assign  twf_rom_im[ 22] = -9'd118;
    assign  twf_rom_re[ 23] = 9'd25;   assign  twf_rom_im[ 23] = -9'd126;
    assign  twf_rom_re[ 24] = 9'd128;  assign  twf_rom_im[ 24] = 9'd0;
    assign  twf_rom_re[ 25] = 9'd106;  assign  twf_rom_im[ 25] = -9'd71;
    assign  twf_rom_re[ 26] = 9'd49;   assign  twf_rom_im[ 26] = -9'd118;
    assign  twf_rom_re[ 27] = -9'd25;  assign  twf_rom_im[ 27] = -9'd126;
    assign  twf_rom_re[ 28] = -9'd91;  assign  twf_rom_im[ 28] = -9'd91;
    assign  twf_rom_re[ 29] = -9'd126; assign  twf_rom_im[ 29] = -9'd25;
    assign  twf_rom_re[ 30] = -9'd118; assign  twf_rom_im[ 30] = 9'd49;
    assign  twf_rom_re[ 31] = -9'd71;  assign  twf_rom_im[ 31] = 9'd106;
    assign  twf_rom_re[ 32] = 9'd128;  assign  twf_rom_im[ 32] = 9'd0;
    assign  twf_rom_re[ 33] = 9'd127;  assign  twf_rom_im[ 33] = -9'd13;
    assign  twf_rom_re[ 34] = 9'd126;  assign  twf_rom_im[ 34] = -9'd25;
    assign  twf_rom_re[ 35] = 9'd122;  assign  twf_rom_im[ 35] = -9'd37;
    assign  twf_rom_re[ 36] = 9'd118;  assign  twf_rom_im[ 36] = -9'd49;
    assign  twf_rom_re[ 37] = 9'd113;  assign  twf_rom_im[ 37] = -9'd60;
    assign  twf_rom_re[ 38] = 9'd106;  assign  twf_rom_im[ 38] = -9'd71;
    assign  twf_rom_re[ 39] = 9'd99;   assign  twf_rom_im[ 39] = -9'd81;
    assign  twf_rom_re[ 40] = 9'd128;  assign  twf_rom_im[ 40] = 9'd0;
    assign  twf_rom_re[ 41] = 9'd113;  assign  twf_rom_im[ 41] = -9'd60;
    assign  twf_rom_re[ 42] = 9'd71;   assign  twf_rom_im[ 42] = -9'd106;
    assign  twf_rom_re[ 43] = 9'd13;   assign  twf_rom_im[ 43] = -9'd127;
    assign  twf_rom_re[ 44] = -9'd49;  assign  twf_rom_im[ 44] = -9'd118;
    assign  twf_rom_re[ 45] = -9'd99;  assign  twf_rom_im[ 45] = -9'd81;
    assign  twf_rom_re[ 46] = -9'd126; assign  twf_rom_im[ 46] = -9'd25;
    assign  twf_rom_re[ 47] = -9'd122; assign  twf_rom_im[ 47] = 9'd37;
    assign  twf_rom_re[ 48] = 9'd128;  assign  twf_rom_im[ 48] = 9'd0;
    assign  twf_rom_re[ 49] = 9'd122;  assign  twf_rom_im[ 49] = -9'd37;
    assign  twf_rom_re[ 50] = 9'd106;  assign  twf_rom_im[ 50] = -9'd71;
    assign  twf_rom_re[ 51] = 9'd81;   assign  twf_rom_im[ 51] = -9'd99;
    assign  twf_rom_re[ 52] = 9'd49;   assign  twf_rom_im[ 52] = -9'd118;
    assign  twf_rom_re[ 53] = 9'd13;   assign  twf_rom_im[ 53] = -9'd127;
    assign  twf_rom_re[ 54] = -9'd25;  assign  twf_rom_im[ 54] = -9'd126;
    assign  twf_rom_re[ 55] = -9'd60;  assign  twf_rom_im[ 55] = -9'd113;
    assign  twf_rom_re[ 56] = 9'd128;  assign  twf_rom_im[ 56] = 0;
    assign  twf_rom_re[ 57] = 9'd99;   assign  twf_rom_im[ 57] = -9'd81;
    assign  twf_rom_re[ 58] = 9'd25;   assign  twf_rom_im[ 58] = -9'd126;
    assign  twf_rom_re[ 59] = -9'd60;  assign  twf_rom_im[ 59] = -9'd113;
    assign  twf_rom_re[ 60] = -9'd118; assign  twf_rom_im[ 60] = -9'd49;
    assign  twf_rom_re[ 61] = -9'd122; assign  twf_rom_im[ 61] = 9'd37;
    assign  twf_rom_re[ 62] = -9'd71;  assign  twf_rom_im[ 62] = 9'd106;
    assign  twf_rom_re[ 63] = 9'd13;   assign  twf_rom_im[ 63] = 9'd127;


endmodule
