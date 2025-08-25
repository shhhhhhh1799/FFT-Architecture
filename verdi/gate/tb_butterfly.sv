`timescale 1ns / 1ps

module tb_gate_fft;

    // 파라미터 및 flatten 처리
    parameter WIDTH = 9;          // 입력 단일 샘플 비트폭
    parameter OUT_WIDTH = 13;     // 출력 단일 샘플 비트폭
    parameter DATA_WIDTH = 16;    // FFT 포인트 수
    parameter TOTAL_BLOCKS = 32;  // 입력 데이터 블록 수 (필요시 조정)

    logic clk, rstn, valid;

    // flatten signal ( 역방향 배열로 선언한 경우 )
    //logic signed [WIDTH*DATA_WIDTH-1:0] din_re_flat;
    //logic signed [WIDTH*DATA_WIDTH-1:0] din_im_flat;
    //logic signed [OUT_WIDTH*DATA_WIDTH-1:0] dout_re_flat;
    //logic signed [OUT_WIDTH*DATA_WIDTH-1:0] dout_im_flat;
    
    // flatten signal ( 정방향 배열로 선언한 경우 )
    logic signed [0:WIDTH*DATA_WIDTH-1] din_re_flat;
    logic signed [0:WIDTH*DATA_WIDTH-1] din_im_flat;
    logic signed [0:OUT_WIDTH*DATA_WIDTH-1] dout_re_flat;
    logic signed [0:OUT_WIDTH*DATA_WIDTH-1] dout_im_flat;

    logic output_en;

    // TB 내 RTL 용 2차원 배열 (파일 로딩, 값 할당)
    logic signed [WIDTH-1:0] din_re [0:DATA_WIDTH-1];
    logic signed [WIDTH-1:0] din_im [0:DATA_WIDTH-1];
    //logic signed [WIDTH-1:0] din_re [DATA_WIDTH-1:0];
    //logic signed [WIDTH-1:0] din_im [DATA_WIDTH-1:0];


    // 파일 전체 입력 데이터(벡터화)
    logic signed [WIDTH-1:0] read_din_i [0:TOTAL_BLOCKS*DATA_WIDTH-1];
    logic signed [WIDTH-1:0] read_din_q [0:TOTAL_BLOCKS*DATA_WIDTH-1];
    //logic signed [WIDTH-1:0] read_din_i [TOTAL_BLOCKS*DATA_WIDTH-1:0];
    //logic signed [WIDTH-1:0] read_din_q [TOTAL_BLOCKS*DATA_WIDTH-1:0];


    // clock & reset
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rstn = 0;
        #(30);
        rstn = 1;
    end

    // read files
    integer i;
    integer file_i, file_q;
    initial begin
        // File open
        //file_i = $fopen("ran_i_dat_stu.txt", "r");
        //file_q = $fopen("ran_q_dat_stu.txt", "r");
	
	// cos file open
	file_i = $fopen("cos_i_dat.txt", "r");
	file_q = $fopen("cos_q_dat.txt", "r");

        if (file_i == 0 || file_q == 0) begin
            $display("ERROR: input file open failed.");
            $finish;
        end

        // 실제 데이터 read
        for (i = 0; i < TOTAL_BLOCKS*DATA_WIDTH; i++) begin
            void'($fscanf(file_i, "%d\n", read_din_i[i]));
            void'($fscanf(file_q, "%d\n", read_din_q[i]));
        end
        $fclose(file_i);
        $fclose(file_q);
    end

    // feed input (flatten)
    integer k;
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            k <= 0;
            valid <= 1'b0;
        end 
        else if (k < TOTAL_BLOCKS) begin
            valid <= 1'b1;
            for (int m = 0; m < DATA_WIDTH; m++) begin
	        din_re[m] <= read_din_i[k*DATA_WIDTH + m];
                din_im[m] <= read_din_q[k*DATA_WIDTH + m];
	        //din_re[m] <= read_din_i[TOTAL_BLOCKS*DATA_WIDTH - 1 - (k*DATA_WIDTH + m)];
                //din_im[m] <= read_din_q[TOTAL_BLOCKS*DATA_WIDTH - 1 - (k*DATA_WIDTH + m)];
            end
            k <= k + 1;
        end 
        else begin
            valid <= 1'b0;
        end
    end

    // 2차원 입력 -> flatten vector 변환
    always_comb begin
        for (int m = 0; m < DATA_WIDTH; m++) begin
            din_re_flat[m*WIDTH +: WIDTH] = din_re[m];
            din_im_flat[m*WIDTH +: WIDTH] = din_im[m];
	    //din_re_flat[(m+1)*WIDTH-1 -: WIDTH] = din_re[m];
            //din_im_flat[(m+1)*WIDTH-1 -: WIDTH] = din_im[m];
        end
    end
    //////////////////////////////////////////
     

//////////////////////////////////////////////
    // Output 2차원 배열로 보기(시뮬 뷰용, optional)
    logic signed [OUT_WIDTH-1:0] dout_re [0:DATA_WIDTH-1];
    logic signed [OUT_WIDTH-1:0] dout_im [0:DATA_WIDTH-1];
    //logic signed [OUT_WIDTH-1:0] dout_re [DATA_WIDTH-1:0];
    //logic signed [OUT_WIDTH-1:0] dout_im [DATA_WIDTH-1:0];



    always_comb begin
        for (int m = 0; m < DATA_WIDTH; m++) begin
	    dout_re[m] = dout_re_flat[m*OUT_WIDTH +: OUT_WIDTH];
	    dout_im[m] = dout_im_flat[m*OUT_WIDTH +: OUT_WIDTH];
            //dout_re[m] = dout_re_flat[(m+1)*OUT_WIDTH-1 -: OUT_WIDTH];
            //dout_im[m] = dout_im_flat[(m+1)*OUT_WIDTH-1 -: OUT_WIDTH];
        end
    end

    // DUT 인스턴스 (Gate-level Netlist가 fft_top이고, 포트는 flatten vector라고 가정)
    fft_top G_FFT_TOP (
        .clk(clk),
        .rstn(rstn),
        .valid(valid),
        .din_re(din_re_flat),
        .din_im(din_im_flat),
        .dout_re(dout_re_flat),
        .dout_im(dout_im_flat),
        .output_en(output_en)
    );

    // 결과 모니터링
    always_ff @(posedge clk) begin
        if (output_en) begin
            $display("=== FFT Gate Sim OUT VALID ===");
            for (int n = 0; n < DATA_WIDTH; n++) begin
                $display("[%0d] re = %d, im = %d", n, dout_re[n], dout_im[n]);
            end
        end
    end

endmodule

