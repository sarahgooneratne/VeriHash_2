module get_digest_hex(
    input Clk, 
    input Reset, 
    input En, 
    input [255:0] DigestReg, 
    output reg [3:0] HexOut, 
    output reg HexAvailable, 
    output reg EndOfDigest
);
    reg [5:0] idx;

    always @(posedge Clk or negedge Reset) begin
        if (!Reset) begin
            HexOut <= 4'd0;
            HexAvailable <= 1'b0;
            EndOfDigest <= 1'b0;
            idx <= 6'd63;
        end else begin
            // Default values
            HexAvailable <= 1'b0;
            EndOfDigest <= 1'b0;

            if (En) begin
                HexOut <= DigestReg[4*idx +: 4];
                HexAvailable <= 1'b1;

                if (idx == 0) begin
                    EndOfDigest <= 1'b1;
                end else begin
                    idx <= idx - 1'b1;
                end
            end
        end
    end
endmodule
