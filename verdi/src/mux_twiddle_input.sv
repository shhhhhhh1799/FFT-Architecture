module mux_twiddle_input (
    input  logic                 clk,
    input  logic                 rstn,
    input  logic                 do_en,          // 곱셈기 동작 enable

    input  logic signed [12:0]   add_re [0:15],
    input  logic signed [12:0]   add_im [0:15],
    input  logic signed [12:0]   sub_re [0:15],
    input  logic signed [12:0]   sub_im [0:15],

    output logic signed [12:0]   mux_out_re [0:15],
    output logic signed [12:0]   mux_out_im [0:15],
    output logic        [5:0]    count,
    output logic                 mux_valid
);

    // 내부 카운터
    logic       count_en;

    // 딜레이된 sub 신호들
    logic signed [12:0] sub_re_dly [0:15];
    logic signed [12:0] sub_im_dly [0:15];

    // Flatten vector for shift_register input/output
    logic signed [12:0] sub_re_vec [0:15];
    logic signed [12:0] sub_im_vec [0:15];
    logic signed [12:0] sub_re_dly_vec [0:15];
    logic signed [12:0] sub_im_dly_vec [0:15];

    // 벡터 준비
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            sub_re_vec[i] = sub_re[i];
            sub_im_vec[i] = sub_im[i];
        end
    end

    // 딜레이 모듈
    shift_register #(
        .WIDTH(13),
        .DATA_WIDTH(16),
        .DATA_HEIGHT(3)		// fix : 4 -> 3
    ) U_SHIFT_RE (
        .clk    (clk),
        .rstn   (rstn),
        .din    (sub_re_vec),
        .s_dout (sub_re_dly_vec)
    );

    shift_register #(
        .WIDTH(13),
        .DATA_WIDTH(16),
        .DATA_HEIGHT(3)		// fix : 4 -> 3
    ) U_SHIFT_IM (
        .clk    (clk),
        .rstn   (rstn),
        .din    (sub_im_vec),
        .s_dout (sub_im_dly_vec)
    );

    // 출력용 연결
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            sub_re_dly[i] = sub_re_dly_vec[i];
            sub_im_dly[i] = sub_im_dly_vec[i];
        end
    end

    // count logic
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            count <= 6'd0;
            count_en <= 1'b0;
        end else begin
            if (do_en)
                count_en <= 1'b1;
            else if (count > 6'd31)
                count_en <= 1'b0;

            if (count_en)
                count <= count + 6'd1;
            else
                count <= 6'd0;
        end
    end

    logic is_sub_phase;
    //assign is_sub_phase = count[2];

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
	    is_sub_phase <= 0;	
            for (int i = 0; i < 16; i++) begin
                mux_out_re[i] <= 13'sd0;
                mux_out_im[i] <= 13'sd0;
            end
        end else if (count_en) begin
            for (int i = 0; i < 16; i++) begin
                if (count[2]) begin
                    mux_out_re[i] <= sub_re_dly[i];
                    mux_out_im[i] <= sub_im_dly[i];
                end else begin
                    mux_out_re[i] <= add_re[i];
                    mux_out_im[i] <= add_im[i];
                end
            end
        end
    end

    // valid signal
    logic count_en_dly;
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) count_en_dly <= 1'b0;
        else       count_en_dly <= count_en;
    end
    assign mux_valid = count_en_dly;

endmodule
