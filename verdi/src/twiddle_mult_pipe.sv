module twiddle_mult_pipe #(
    parameter I_WIDTH = 13,
    parameter O_WIDTH = 22,
    parameter DATA_WIDTH = 16
)(
    input  logic                      clk,
    input  logic                      rstn,

    input  logic signed [I_WIDTH-1:0] din_re [0:DATA_WIDTH-1],
    input  logic signed [I_WIDTH-1:0] din_im [0:DATA_WIDTH-1],
    input  logic [5:0]                count,
    input  logic                      valid_in,

    output logic signed [O_WIDTH-1:0] dout_re [0:DATA_WIDTH-1],
    output logic signed [O_WIDTH-1:0] dout_im [0:DATA_WIDTH-1],
    output logic                      valid_out
);

    // Twiddle address 계산 (count * 16 + i)
    logic [8:0] addr_tw [0:15];
    
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            addr_tw[i] = count * 16 + i;
        end
    end

    // Twiddle output
    logic signed [8:0] tw_re [0:15];
    logic signed [8:0] tw_im [0:15];

    // Twiddle ROM instance (16개 병렬)
    for (genvar i = 0; i < 16; i++) begin : GEN_TW_ROM
        twiddle_512 u_tw (
            .clk   (clk),
            .addr  (addr_tw[i]),
            .tw_re (tw_re[i]),
            .tw_im (tw_im[i])
        );
    end

    // 곱셈기
    for (genvar i = 0; i < 16; i++) begin : GEN_MUL
        mutl_tw #(.WIDTH(13)) u_mult (
	    .clk(clk),
	    .rstn(rstn),
            .a_re (din_re[i]),
            .a_im (din_im[i]),
            .b_re (tw_re[i]),
            .b_im (tw_im[i]),
            .m_re (dout_re[i]),
            .m_im (dout_im[i])
        );
    end

    // valid 1클럭 지연 (twiddle이 1clk 지연되므로)
    logic valid_d;
    always_ff @(posedge clk or negedge rstn) begin
        //if (!rstn)
        //    valid_d <= 1'b0;
        //else
        //    valid_d <= valid_in;
	
	//if(count < 33) 
	//	valid_d <= valid_in;
	//else 	
	//	valid_d <= 1'd0;
	///////////////////////////////////////////////
	if(!rstn) begin
		valid_d <= 1'b0;
	end else begin
		if(count < 33) begin
			valid_d <= valid_in;
		end else begin
			valid_d <= 1'd0;
		end
	end	
	///////////////////////////////////////////////////



    end
    assign valid_out = valid_d;

endmodule
