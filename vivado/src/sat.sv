`timescale 1ns/1ps

module sat #(
    parameter WIDTH = 13, SAT_WIDTH = 12 
    )(
    input signed [WIDTH-1:0] din[0:15],
    output logic signed [SAT_WIDTH-1:0] dout[0:15]
);

    integer i;

    always @(*) begin
        for (i=0;i<64 ; i=i+1) begin
            if (din[i]>=(2**(SAT_WIDTH-1)-1)) begin
                dout[i]=2**(SAT_WIDTH-1)-1;
            end
            else if (din[i]<=(-(2**(SAT_WIDTH-1)))) begin
                dout[i]=-(2**(SAT_WIDTH-1));
            end
            else begin
                dout[i] = din[i];
            end
        end
    end

endmodule
