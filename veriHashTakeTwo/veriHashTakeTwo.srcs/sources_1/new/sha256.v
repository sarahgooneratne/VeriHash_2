`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 08:32:24 PM
// Design Name: 
// Module Name: sha256
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sha256(
    input clk, rst, start,
    input [511:0] block, 
    output reg digest_ready,
    output reg [255:0] digest,
    output [31:0] W_out, 
    output [255:0] current_hash
    );
    
    
    // Initial hash values, defined in FIPS 180-4 standard 
    parameter H0 = 32'h6a09e667;
    parameter H1 = 32'hbb67ae85;
    parameter H2 = 32'h3c6ef372;
    parameter H3 = 32'ha54ff53a;
    parameter H4 = 32'h510e527f;
    parameter H5 = 32'h9b05688c;
    parameter H6 = 32'h1f83d9ab;
    parameter H7 = 32'h5be0cd19;
    
    
    // States 
    parameter DISABLED = 2'b00;
    parameter HASHING = 2'b01;
    parameter DIGEST_READY = 2'b10;
    
    reg [1:0] S_current = DISABLED;
    reg [1:0] S_next = DISABLED;
    
    reg [31:0] a_in = H0;
    reg [31:0] b_in = H1;
    reg [31:0] c_in = H2;
    reg [31:0] d_in = H3;
    reg [31:0] e_in = H4;
    reg [31:0] f_in = H5;
    reg [31:0] g_in = H6;
    reg [31:0] h_in = H7;
    
    wire [31:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out;
    wire [31:0] K, W;
    
    // Track number of rounds
    reg [5:0] round = 6'd0;
    
    reg [511:0] Zero_Value = 512'b0;
    
    reg [511:0] Flat_W_Arr = 512'b0;
    
    wire [31:0] W_Arr [0:15];
    integer i;
    
    assign W_Arr[0]  = Flat_W_Arr[511:480];
    assign W_Arr[1]  = Flat_W_Arr[479:448];
    assign W_Arr[2]  = Flat_W_Arr[447:416];
    assign W_Arr[3]  = Flat_W_Arr[415:384];
    assign W_Arr[4]  = Flat_W_Arr[383:352];
    assign W_Arr[5]  = Flat_W_Arr[351:320];
    assign W_Arr[6]  = Flat_W_Arr[319:288];
    assign W_Arr[7]  = Flat_W_Arr[287:256];
    assign W_Arr[8]  = Flat_W_Arr[255:224];
    assign W_Arr[9]  = Flat_W_Arr[223:192];
    assign W_Arr[10] = Flat_W_Arr[191:160];
    assign W_Arr[11] = Flat_W_Arr[159:128];
    assign W_Arr[12] = Flat_W_Arr[127:96];
    assign W_Arr[13] = Flat_W_Arr[95:64];
    assign W_Arr[14] = Flat_W_Arr[63:32];
    assign W_Arr[15] = Flat_W_Arr[31:0];

    assign W_out = W;
    assign current_hash = {a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out};
    
    constant_words indices(.index(round), .K(K));
    message_schedule scheduler(.clk(clk), .block(round), .Flat_W_Arr(Flat_W_Arr), .W_Out(W)); 
    hash_compute hasher(.clk(clk), .W_In(W), .K_In(K), .a_in(a_in), .b_in(b_in), .c_in(c_in), .d_in(d_in), .e_in(e_in),
    .f_in(f_in), .g_in(g_in), .h_in(h_in), .a_out(a_out), .b_out(b_out), .c_out(c_out), .d_out(d_out), .e_out(e_out), .f_out(f_out), .g_out(g_out), .h_out(h_out));
   
   
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            S_current <= DISABLED;
        end else begin
            S_current <= S_next;
        end
    end
   
   always @ (posedge clk, negedge rst) begin 
       if(!rst) begin 
           a_in <= H0;
           b_in <= H1;
           c_in <= H2;
           d_in <= H3;
           e_in <= H4;
           f_in <= H5;
           g_in <= H6;
           h_in <= H7;
       end else if ((S_current == HASHING) && (round != 0)) begin
           a_in <= a_out;
           b_in <= b_out;
           c_in <= c_out;
           d_in <= d_out;
           e_in <= e_out;
           f_in <= f_out;
           g_in <= g_out;
           h_in <= h_out;
       end 
   end 
   
   always @(*) begin
        case (S_current)
            DISABLED:     S_next = start ? HASHING : DISABLED;
            HASHING:      S_next = (round == 6'd63) ? DIGEST_READY : HASHING;
            DIGEST_READY: S_next = DIGEST_READY; // stay here until external reset/start clears
            default:      S_next = DISABLED;
        endcase
    end
   always @(posedge clk, negedge rst) begin 
       if(!rst) begin 
           round <= 6'd0;
           Flat_W_Arr <= 512'd0;
           digest <= 256'd0;
           digest_ready <= 1'b0;
       end else begin
        
           case (S_current) 
               DISABLED : begin
                   if (start) begin 
                    round <= 0;
                    digest_ready <= 0;
                    Flat_W_Arr[511:480] <= block[511:480];
                    Flat_W_Arr[479:448] <= block[479:448];
                    Flat_W_Arr[447:416] <= block[447:416];
                    Flat_W_Arr[415:384] <= block[415:384];
                    Flat_W_Arr[383:352] <= block[383:352];
                    Flat_W_Arr[351:320] <= block[351:320];
                    Flat_W_Arr[319:288] <= block[319:288];
                    Flat_W_Arr[287:256] <= block[287:256];
                    Flat_W_Arr[255:224] <= block[255:224];
                    Flat_W_Arr[223:192] <= block[223:192];
                    Flat_W_Arr[191:160] <= block[191:160];
                    Flat_W_Arr[159:128] <= block[159:128];
                    Flat_W_Arr[127:96]  <= block[127:96];
                    Flat_W_Arr[95:64]   <= block[95:64];
                    Flat_W_Arr[63:32]   <= block[63:32];
                    Flat_W_Arr[31:0]    <= block[31:0];
                    
                    
                    
                    a_in <= H0;
                    b_in <= H1;
                    c_in <= H2;
                    d_in <= H3;
                    e_in <= H4;
                    f_in <= H5;
                    g_in <= H6;
                    h_in <= H7;
                   end 
              end 
            HASHING : begin
                 if (round >= 6'd16) begin
                        // shift left by one word and insert new W into least-significant 32 bits
                        Flat_W_Arr <= {Flat_W_Arr[479:0], W};
                 end

                    // advance round (stop incrementing after 63)
                    if (round < 6'd63)
                        round <= round + 6'd1;
             end
             DIGEST_READY: begin
                    // latch digest only once (first cycle in DIGEST_READY)
                    // detect entry by seeing previous state = HASHING and now DIGEST_READY
                    // but we don't have previous state here; simpler: if digest_ready not set yet, set it
                    if (!digest_ready) begin
                        digest <= {(a_out + H0), (b_out + H1), (c_out + H2), (d_out + H3),
                                   (e_out + H4), (f_out + H5), (g_out + H6), (h_out + H7)};
                        digest_ready <= 1'b1;
                    end
                end

                default: begin
                
                end
            endcase
        end
    end

endmodule
