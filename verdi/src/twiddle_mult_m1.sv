module twiddle_mult_m1 #(
    parameter I_WIDTH = 15,
    parameter O_WIDTH = 24,
    parameter DATA_WIDTH = 16
)(
    input  logic                      clk,
    input  logic                      rstn,

    input  logic signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input  logic signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    input  logic [1:0]                count,

    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1]
);

    logic signed [I_WIDTH-1:0] d_din_re [0:DATA_WIDTH-1];
    logic signed [I_WIDTH-1:0] d_din_im [0:DATA_WIDTH-1];


    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (int i = 0; i < DATA_WIDTH; i++) begin
                d_din_re[i] <= '0;
                d_din_im[i] <= '0;
            end
        end else begin
            for (int i = 0; i < DATA_WIDTH; i++) begin
                d_din_re[i] <= din_re[i];
                d_din_im[i] <= din_im[i];
            end
        end
    end

    
    // Twiddle address 계산 (count * 16 + i)
    logic [5:0] addr_tw [0:DATA_WIDTH-1];
    always_comb begin
        for (int i = 0; i < DATA_WIDTH; i++) begin
            addr_tw[i] = count * 16 + i;
        end
    end

    // Twiddle output
    logic signed [8:0] tw_re [0:DATA_WIDTH-1];
    logic signed [8:0] tw_im [0:DATA_WIDTH-1];

    // Twiddle ROM instance (16개 병렬)
    for (genvar i = 0; i < DATA_WIDTH; i++) begin : GEN_TW_ROM
        twiddle_64 U_TW_64 (
            .clk   (clk),
            .addr  (addr_tw[i]),
            .tw_re (tw_re[i]),
            .tw_im (tw_im[i])
        );
    end

    // 곱셈기
    for (genvar i = 0; i < DATA_WIDTH; i++) begin : GEN_MUL
        mutl_tw #(
            .WIDTH(I_WIDTH)
            ) U_MULT_1_2 (
	    .clk(clk),
	    .rstn(rstn),
            .a_re (d_din_re[i]),
            .a_im (d_din_im[i]),
            .b_re (tw_re[i]),
            .b_im (tw_im[i]),
            .m_re (dout_re[i]),
            .m_im (dout_im[i])
        );
    end

endmodule
