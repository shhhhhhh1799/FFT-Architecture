`timescale 1ns/1ps

module mag_detect_1 #(
    parameter I_WIDTH = 24,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rstn,
    input signed [I_WIDTH-1:0] din [0:DATA_WIDTH-1],
    output logic signed [(I_WIDTH+1)-1:0] dout [0:DATA_WIDTH-1],
    output logic unsigned [4:0] o_cnt [0:DATA_WIDTH-1]
);

    integer i;

    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                dout[i]  <= '0;
                o_cnt[i] <= '0;
            end
        end else begin
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                logic [I_WIDTH:0] d_din;
                d_din = {din[i][I_WIDTH-1], din[i]};
                dout[i] <= d_din;
                // function 대신 직접 조건부 할당
                o_cnt[i] <=
                    ((d_din[23:0]=='0)&~d_din[24]) ? 24 :
                    ((d_din[23:1]=='0)&~d_din[24])? 23 :
                    ((d_din[23:2]=='0)&~d_din[24])? 22 :
                    ((d_din[23:3]=='0)&~d_din[24])? 21 :
                    ((d_din[23:4]=='0)&~d_din[24])? 20 :
                    ((d_din[23:5]=='0)&~d_din[24])? 19 :
                    ((d_din[23:6]=='0)&~d_din[24])? 18 :
                    ((d_din[23:7]=='0)&~d_din[24])? 17 :
                    ((d_din[23:8]=='0)&~d_din[24])? 16 :
                    ((d_din[23:9]=='0)&~d_din[24])? 15 :
                    ((d_din[23:10]=='0)&~d_din[24])? 14 :
                    ((d_din[23:11]=='0)&~d_din[24])? 13 :
                    ((d_din[23:12]=='0)&~d_din[24])? 12 :
                    ((d_din[23:13]=='0)&~d_din[24])? 11 :
                    ((d_din[23:14]=='0)&~d_din[24])? 10 :
                    ((d_din[23:15]=='0)&~d_din[24])? 9 :
                    ((d_din[23:16]=='0)&~d_din[24])? 8 :
                    ((d_din[23:17]=='0)&~d_din[24])? 7 :
                    ((d_din[23:18]=='0)&~d_din[24])? 6 :
                    ((d_din[23:19]=='0)&~d_din[24])? 5 :
                    ((d_din[23:20]=='0)&~d_din[24])? 4 :
                    ((d_din[23:21]=='0)&~d_din[24])? 3 :
                    ((d_din[23:22]=='0)&~d_din[24])? 2 :
                    ((d_din[23]=='0)&~d_din[24])? 1 :
                    ((d_din[23:0]== {24{1'b1}})&d_din[24])? 24 :
                    ((d_din[23:1]== {23{1'b1}})&d_din[24])? 23 :
                    ((d_din[23:2]== {22{1'b1}})&d_din[24])? 22 :
                    ((d_din[23:3]== {21{1'b1}})&d_din[24])? 21 :
                    ((d_din[23:4]== {20{1'b1}})&d_din[24])? 20 :
                    ((d_din[23:5]== {19{1'b1}})&d_din[24])? 19 :
                    ((d_din[23:6]== {18{1'b1}})&d_din[24])? 18 :
                    ((d_din[23:7]== {17{1'b1}})&d_din[24])? 17 :
                    ((d_din[23:8]== {16{1'b1}})&d_din[24])? 16 :
                    ((d_din[23:9]== {15{1'b1}})&d_din[24])? 15 :
                    ((d_din[23:10]== {14{1'b1}})&d_din[24])? 14 :
                    ((d_din[23:11]== {13{1'b1}})&d_din[24])? 13 :
                    ((d_din[23:12]== {12{1'b1}})&d_din[24])? 12 :
                    ((d_din[23:13]== {11{1'b1}})&d_din[24])? 11 :
                    ((d_din[23:14]== {10{1'b1}})&d_din[24])? 10 :
                    ((d_din[23:15]== {9{1'b1}})&d_din[24])? 9 :
                    ((d_din[23:16]== {8{1'b1}})&d_din[24])? 8 :
                    ((d_din[23:17]== {7{1'b1}})&d_din[24])? 7 :
                    ((d_din[23:18]== {6{1'b1}})&d_din[24])? 6 :
                    ((d_din[23:19]== {5{1'b1}})&d_din[24])? 5 :
                    ((d_din[23:20]== {4{1'b1}})&d_din[24])? 4 :
                    ((d_din[23:21]== {3{1'b1}})&d_din[24])? 3 :
                    ((d_din[23:22]== {2{1'b1}})&d_din[24])? 2 :
                    ((d_din[23]== {1'b1})&d_din[24])? 1 : 0;
            end
        end
    end

endmodule
