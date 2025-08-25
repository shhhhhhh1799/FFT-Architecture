`timescale 1ns/1ps

module cbfp #(
    parameter I_WIDTH = 22,
    parameter O_WIDTH = 11,
    parameter DATA_WIDTH = 16, // 한 번에 입력/출력 데이터 폭
    parameter GROUP_WIDTH = 64         
)(
    input clk,
    input rstn,
    input valid_cbfp,
    input  logic signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input  logic signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic [4:0] min_cnt_out [0:DATA_WIDTH-1],
    output logic o_cbfp_en
);

    logic valid_cbfp_d1;
    logic valid_cbfp_d2;

    always_ff @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            valid_cbfp_d1 <= 0;
            valid_cbfp_d2 <= 0;
        end else if (rstn) begin
            valid_cbfp_d1 <= valid_cbfp;
            valid_cbfp_d2 <= valid_cbfp_d1;
        end
    end

    logic signed [(I_WIDTH+1)-1:0] w_mag_dout_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH+1)-1:0] w_mag_dout_im [0:DATA_WIDTH-1];
    logic [4:0] w_mag_cnt_re [0:DATA_WIDTH-1];
    logic [4:0] w_mag_cnt_im [0:DATA_WIDTH-1];

    logic [4:0] group_min_cnt;
    logic [4:0] min_cnt;
    logic [4:0] com_min_cnt[0:7];

    mag_detect #(
        . I_WIDTH(I_WIDTH), 
        . DATA_WIDTH(DATA_WIDTH)
        ) U_MAG_RE (
        . clk(clk), 
        . rstn(rstn), 
        . din(din_re), 
        . dout(w_mag_dout_re), 
        . o_cnt(w_mag_cnt_re)
    );

    mag_detect #(
        . I_WIDTH(I_WIDTH), 
        . DATA_WIDTH(DATA_WIDTH)
        ) U_MAG_IM (
        . clk(clk), 
        . rstn(rstn), 
        . din(din_im), 
        . dout(w_mag_dout_im), 
        . o_cnt(w_mag_cnt_im)
    );

    min_detect #(
        . DATA_WIDTH (DATA_WIDTH)
    ) U_MIN_DETECT (
        . i_cnt_re (w_mag_cnt_re) ,
        . i_cnt_im (w_mag_cnt_im) ,   
        . min_cnt (min_cnt)
    );

    logic min_update_trig;
    logic cnt_cbfp_trig;
    logic unsigned [5:0] min_update_cnt;
    logic unsigned [2:0] arr_index;

    integer i;

    always_ff @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            min_update_cnt <= 0;
            group_min_cnt <= 0;
            arr_index <= 0;
            min_update_trig <=0;
            cnt_cbfp_trig <= 0;
            o_cbfp_en <= 0;
            for (i=0 ; i<8 ;i=i+1 ) begin
                com_min_cnt[i] <= 31;
            end
            end else begin
            if (valid_cbfp_d1&&(cnt_cbfp_trig==0)) begin
                min_update_cnt <= min_update_cnt + 1;
                cnt_cbfp_trig <= 1;
            end else if (cnt_cbfp_trig||valid_cbfp_d1) begin
                min_update_cnt <= min_update_cnt + 1;
            end


            if ((min_update_cnt==2)||(min_update_cnt==6)||(min_update_cnt==10)||(min_update_cnt==14)||(min_update_cnt==18)||(min_update_cnt==22)||(min_update_cnt==26)||(min_update_cnt==30)) begin
                min_update_trig <=1;
            end else if (min_update_cnt==4) begin
                group_min_cnt <= com_min_cnt[0];
            end else if (min_update_cnt==5) begin  // 기존 5
                o_cbfp_en <= 1;
            end else if (min_update_cnt==8) begin
                group_min_cnt <= com_min_cnt[1];
            end else if (min_update_cnt==12) begin
                group_min_cnt <= com_min_cnt[2];
            end else if (min_update_cnt==16) begin
                group_min_cnt <= com_min_cnt[3];
            end else if (min_update_cnt==20) begin
                group_min_cnt <= com_min_cnt[4];
            end else if (min_update_cnt==24) begin
                group_min_cnt <= com_min_cnt[5];
            end else if (min_update_cnt==28) begin
                group_min_cnt <= com_min_cnt[6];
            end else if (min_update_cnt==32) begin
                group_min_cnt <= com_min_cnt[7];
            end else if (min_update_cnt==37) begin // 기존 37
                o_cbfp_en <= 0;
                cnt_cbfp_trig <=0;
                min_update_cnt <= 0;
                arr_index <= 0;
            end else begin
                min_update_trig <=0;
            end

            
            if (min_update_trig) begin
                if (min_update_cnt>2) begin
                    arr_index <= arr_index + 1;
                end
            end 

              if (valid_cbfp_d1) begin
                if ((com_min_cnt[arr_index] > min_cnt)) begin
                    com_min_cnt[arr_index] <= min_cnt;
                end
            end
        end
    end

    logic signed [(I_WIDTH+1)-1:0] w_shift_dout_re [0:DATA_WIDTH-1];
    logic signed [(I_WIDTH+1)-1:0] w_shift_dout_im [0:DATA_WIDTH-1];    


    shift_register #(
        .WIDTH (I_WIDTH+1),          
        .DATA_WIDTH (DATA_WIDTH),  
        .DATA_HEIGHT (4)
    ) U_SHIFT_CBFP_RE (
        .clk(clk),
        .rstn(rstn),
        .din   (w_mag_dout_re),
        .s_dout(w_shift_dout_re)
    );


    shift_register #(
        .WIDTH(I_WIDTH+1),          
        .DATA_WIDTH(DATA_WIDTH),  
        .DATA_HEIGHT(4)
    ) U_SHIFT_CBFP_IM (
        .clk (clk),
        .rstn (rstn),
        .din   (w_mag_dout_im),
        .s_dout(w_shift_dout_im)
    );




    bit_shift_0 #(
        . LENGTH (12),
        . I_WIDTH (I_WIDTH+1),
        . O_WIDTH (11),
        . DATA_WIDTH (16)
        ) U_BIT_SHIFT_CBFP(
        . clk (clk),
        . rstn (rstn),
        . din_re (w_shift_dout_re),
        . din_im (w_shift_dout_im),
        . min_cnt (group_min_cnt),
        . dout_re (dout_re) ,
        . dout_im (dout_im) ,
        . min_cnt_out(min_cnt_out)
    );

endmodule