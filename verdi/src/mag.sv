`timescale 1ns/1ps

module mag_detect #(
    parameter I_WIDTH = 22,
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
                o_cnt[i] <= 0;
                dout[i]  <= 0;
            end
        end else begin
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                logic [I_WIDTH:0] d_din;  // 지역 변수
                d_din = {din[i][I_WIDTH-1], din[i]};
                dout[i] <= d_din;
                o_cnt[i] <= 
                    ((d_din[21:0]=='0)&~d_din[22]) ? 22 :
                    ((d_din[21:1]=='0)&~d_din[22])? 21 :
                    ((d_din[21:2]=='0)&~d_din[22])? 20 :
                    ((d_din[21:3]=='0)&~d_din[22])? 19 :
                    ((d_din[21:4]=='0)&~d_din[22])? 18 :
                    ((d_din[21:5]=='0)&~d_din[22])? 17 :
                    ((d_din[21:6]=='0)&~d_din[22])? 16 :
                    ((d_din[21:7]=='0)&~d_din[22])? 15 :
                    ((d_din[21:8]=='0)&~d_din[22])? 14 :
                    ((d_din[21:9]=='0)&~d_din[22])? 13 :
                    ((d_din[21:10]=='0)&~d_din[22])? 12 :
                    ((d_din[21:11]=='0)&~d_din[22])? 11 :
                    ((d_din[21:12]=='0)&~d_din[22])? 10 :
                    ((d_din[21:13]=='0)&~d_din[22])? 9 :
                    ((d_din[21:14]=='0)&~d_din[22])? 8 :
                    ((d_din[21:15]=='0)&~d_din[22])? 7 :
                    ((d_din[21:16]=='0)&~d_din[22])? 6 :
                    ((d_din[21:17]=='0)&~d_din[22])? 5 :
                    ((d_din[21:18]=='0)&~d_din[22])? 4 :
                    ((d_din[21:19]=='0)&~d_din[22])? 3 :
                    ((d_din[21:20]=='0)&~d_din[22])? 2 :
                    ((d_din[21]=='0)&~d_din[22])? 1 :
                    ((d_din[21:0]== {22{1'b1}})&d_din[22])? 22 :
                    ((d_din[21:1]== {21{1'b1}})&d_din[22])? 21 :
                    ((d_din[21:2]== {20{1'b1}})&d_din[22])? 20 :
                    ((d_din[21:3]== {19{1'b1}})&d_din[22])? 19 :
                    ((d_din[21:4]== {18{1'b1}})&d_din[22])? 18 :
                    ((d_din[21:5]== {17{1'b1}})&d_din[22])? 17 :
                    ((d_din[21:6]== {16{1'b1}})&d_din[22])? 16 :
                    ((d_din[21:7]== {15{1'b1}})&d_din[22])? 15 :
                    ((d_din[21:8]== {14{1'b1}})&d_din[22])? 14 :
                    ((d_din[21:9]== {13{1'b1}})&d_din[22])? 13 :
                    ((d_din[21:10]== {12{1'b1}})&d_din[22])? 12 :
                    ((d_din[21:11]== {11{1'b1}})&d_din[22])? 11 :
                    ((d_din[21:12]== {10{1'b1}})&d_din[22])? 10 :
                    ((d_din[21:13]== {9{1'b1}})&d_din[22])? 9 :
                    ((d_din[21:14]== {8{1'b1}})&d_din[22])? 8 :
                    ((d_din[21:15]== {7{1'b1}})&d_din[22])? 7 :
                    ((d_din[21:16]== {6{1'b1}})&d_din[22])? 6 :
                    ((d_din[21:17]== {5{1'b1}})&d_din[22])? 5 :
                    ((d_din[21:18]== {4{1'b1}})&d_din[22])? 4 :
                    ((d_din[21:19]== {3{1'b1}})&d_din[22])? 3 :
                    ((d_din[21:20]== {2{1'b1}})&d_din[22])? 2 :
                    ((d_din[21]== {1'b1})&d_din[22])? 1 : 0;
            end
        end
    end

endmodule
