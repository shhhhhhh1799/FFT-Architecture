`timescale 1ns / 1ps

module tb_butterfly_0;

    parameter WIDTH = 9;
    parameter DATA_WIDTH = 16;
    parameter TOTAL_BLOCKS = 32;

    logic clk, rstn, valid_start_0;
    logic signed [WIDTH-1:0] din_re [0:DATA_WIDTH-1];
    logic signed [WIDTH-1:0] din_im [0:DATA_WIDTH-1];
    logic signed [12:0] dout_re [0:DATA_WIDTH-1];
    logic signed [12:0] dout_im [0:DATA_WIDTH-1];
    //logic signed [13-1:0] dout_add_im [0:DATA_WIDTH-1];
    //logic signed [13-1:0] dout_sub_im [0:DATA_WIDTH-1];

    logic output_en;

    // clock & reset
    initial clk = 0;
    always #5 clk = ~clk;

    logic negedge_rstn_1clk;
    initial begin
    clk = 0;
    rstn = 0;
    negedge_rstn_1clk = 0;
    @(negedge clk);
    rstn = 1;
    @(negedge clk);
    negedge_rstn_1clk = 1; // 이 신호를 always_ff로 넘김
    end

    // input buffers
    logic signed [WIDTH-1:0] read_din_i [0:511];
    logic signed [WIDTH-1:0] read_din_q [0:511];


    // read files
    integer i, j;
    integer file_i, file_q;

    initial begin
	// using cosine data    
        //file_i = $fopen("cos_i_dat.txt", "r");
        //file_q = $fopen("cos_q_dat.txt", "r");

	// using random data
	file_i = $fopen("ran_i_dat_stu.txt", "r");
        file_q = $fopen("ran_q_dat_stu.txt", "r");


        if (file_i == 0 || file_q == 0) begin
            $display("ERROR: input file open failed.");
            $finish;
        end

        for (i = 0; i < 512; i++) begin
            void'($fscanf(file_i, "%d\n", read_din_i[i]));
            void'($fscanf(file_q, "%d\n", read_din_q[i]));
        end

        $fclose(file_i);
        $fclose(file_q);
    end

    // feed input
    integer k;
    always_ff @(negedge clk or negedge rstn) begin
        if (!rstn) begin
            k <= 0;
            valid_start_0 <= 1'b0;
        end else if (negedge_rstn_1clk && k < TOTAL_BLOCKS) begin
            valid_start_0 <= 1'b1;
            for (int m = 0; m < DATA_WIDTH; m++) begin
                din_re[m] <= read_din_i[k * DATA_WIDTH + m];
                din_im[m] <= read_din_q[k * DATA_WIDTH + m];
            end
            k <= k + 1;
        end else begin
            valid_start_0 <= 1'b0;
        end
    end

fft_top #(
    . DATA_WIDTH (16)
) DUT(
    . clk(clk),
    . rstn(rstn),
    . valid(valid_start_0),
    . din_re(din_re),
    . din_im(din_im),
    . dout_re(dout_re) ,
    . dout_im(dout_im) ,
    . output_en (output_en)
);

    //// output to file
    //integer f_result;
    //initial f_result = $fopen("RTL_fft_output.txt", "w");

    //initial begin
    //    wait(rstn == 1);
    //    wait(k == TOTAL_BLOCKS);
    //    #(1000);

    //    $display("==== Output Sample ====");
    //    for (int t = 0; t < DATA_WIDTH; t++) begin
    //        $fwrite(f_result, "%0d %0d %0d %0d\n",
    //            dout_add_re[t], dout_add_im[t], dout_sub_re[t], dout_sub_im[t]);
    //        $display("add_re[%0d]=%0d, add_im[%0d]=%0d, sub_re[%0d]=%0d, sub_im[%0d]=%0d",
    //            t, dout_add_re[t], t, dout_add_im[t], t, dout_sub_re[t], t, dout_sub_im[t]);
    //    end

    //    $fclose(f_result);
    //    $display("---- Testbench End ----");
    //    $stop;
    //end

endmodule
