`timescale 1ns / 1ps

module index_fifo #(
    parameter WIDTH = 5,
    parameter DATA_WIDTH = 16,
    parameter MAX = 32
)(
    input clk,
    input rstn,
    input index_valid,
    input dout_en,
    input logic [WIDTH-1:0] in_index [0:DATA_WIDTH-1],
    output logic [WIDTH-1:0] out_index [0:DATA_WIDTH-1]
);

    logic full, empty;


    logic [9:0] count;
    logic [4:0] wr_prt;
    logic [4:0] rd_prt;

    assign full = (count==MAX);
    assign empty = (count==0);

    logic [WIDTH-1:0] mem [0:MAX-1][0:DATA_WIDTH-1];
    
    integer i;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            count <= 0;
            wr_prt <= 0;
            rd_prt <= 0;
        end else begin
            if (index_valid && !full && dout_en && !empty) begin
                // 동시에 read/write == count 변화 없음
                wr_prt <= (wr_prt+1)%MAX;
                for (i=0; i<DATA_WIDTH; i=i+1) begin
                    mem[wr_prt][i] <= in_index[i];
                    out_index[i]   <= mem[rd_prt][i];
                end
                rd_prt <= (rd_prt+1)%MAX;
            end else begin
                if (index_valid&&!full) begin
                    for (i=0; i<DATA_WIDTH; i=i+1) begin
                        mem[wr_prt][i] <= in_index[i];
                    end
                    wr_prt <= (wr_prt + 1)%MAX;
                    if (count<MAX) count <= count+1;
                end
                if (dout_en&&!empty) begin
                    for (i =0; i<DATA_WIDTH; i=i+1 ) begin
                        out_index[i] <= mem[rd_prt][i];
                    end
                    rd_prt <= (rd_prt + 1)%MAX;
                    if (count>0) count <= count - 1;
                end
            end
        end
    end
   
endmodule