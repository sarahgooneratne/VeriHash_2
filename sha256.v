module sha256 (Clk, Reset, Start, Chunk, Digest, DigestReady, WOut, CurrentHash);
	 // Initial round constants (defined by SHA256 standard)
    parameter    SHA256_A0 = 32'h6a09e667;
    parameter    SHA256_B0 = 32'hbb67ae85;
    parameter    SHA256_C0 = 32'h3c6ef372;
    parameter    SHA256_D0 = 32'ha54ff53a;
    parameter    SHA256_E0 = 32'h510e527f;
    parameter    SHA256_F0 = 32'h9b05688c;
    parameter    SHA256_G0 = 32'h1f83d9ab;
    parameter    SHA256_H0 = 32'h5be0cd19;

    // States
    parameter    DISABLED      = 2'b00,
                 HASHING       = 2'b01,
                 DIGEST_READY  = 2'b10;

    // I/O
    input Clk, Reset, Start;
    input [511:0] Chunk;
    output reg DigestReady = 1'b0;
    output reg [255:0] Digest = 256'b0;

    // Debug outputs (now registered)
    output [31:0]  WOut;
    output [255:0] CurrentHash;

    reg  [31:0]  WOut_reg        = 32'd0;
    reg  [255:0] CurrentHash_reg = 256'd0;

    assign WOut       = WOut_reg;
    assign CurrentHash = CurrentHash_reg;

    // State registers
    reg [1:0] Q_present = DISABLED, Q_next = DISABLED;

    reg [31:0]	    a_in = SHA256_A0, // Input to hashing round
                    b_in = SHA256_B0, 
                    c_in = SHA256_C0, 
                    d_in = SHA256_D0, 
                    e_in = SHA256_E0, 
                    f_in = SHA256_F0, 
                    g_in = SHA256_G0, 
                    h_in = SHA256_H0;

    wire [31:0]	    a_out, // Output from hashing round
                    b_out,
                    c_out,
                    d_out,
                    e_out,
                    f_out,
                    g_out,
                    h_out;

    reg [5:0] round = 6'd0; // Counter for tracking how many rounds have been performed

    reg [31:0] w_array [0:15];
    integer i;
    wire [511:0] flat_w_arr;

    assign flat_w_arr = { w_array[15], w_array[14], w_array[13], w_array[12],
                          w_array[11], w_array[10], w_array[9],  w_array[8],
                          w_array[7],  w_array[6],  w_array[5],  w_array[4],
                          w_array[3],  w_array[2],  w_array[1],  w_array[0] };

    wire [31:0] k, w; // interconnects for K constant and W input for hashing algorithm

    // Instantiate K constant RAM module, W calculation module, and SHA256 hashing algorithm module
    k_constants   a(round, k);
    calc_w        b(Clk, round, flat_w_arr, w);
    hash_algorithm c(Clk, w, k,
                     a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in,
                     a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out);

    // Update round input from round output
    always @ (posedge Clk or negedge Reset) begin
        // Reset round words to initial constants
        if (!Reset) begin
            a_in <= SHA256_A0;
            b_in <= SHA256_B0; 
            c_in <= SHA256_C0; 
            d_in <= SHA256_D0; 
            e_in <= SHA256_E0; 
            f_in <= SHA256_F0; 
            g_in <= SHA256_G0; 
            h_in <= SHA256_H0;
        end
        else if (Q_present == HASHING) begin
            // Feed back previous round's output into next round's input
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

    // Main FSM + round counter + W schedule update
    always @ (posedge Clk or negedge Reset) begin
        if (!Reset) begin
            round       <= 6'd0;
            Digest      <= 256'd0;
            DigestReady <= 1'b0;
            Q_present   <= DISABLED;
            Q_next      <= DISABLED;

            for (i = 0; i < 16; i = i + 1)
                w_array[i] <= 32'd0;
        end
        else begin
            case (Q_present)
                DISABLED : begin
                    // Load preprocessed chunk data into the message schedule array
                    if (Start) begin
                        w_array[0]  <= Chunk[511:480];
                        w_array[1]  <= Chunk[479:448];
                        w_array[2]  <= Chunk[447:416];
                        w_array[3]  <= Chunk[415:384];
                        w_array[4]  <= Chunk[383:352];
                        w_array[5]  <= Chunk[351:320];
                        w_array[6]  <= Chunk[319:288];
                        w_array[7]  <= Chunk[287:256];
                        w_array[8]  <= Chunk[255:224];
                        w_array[9]  <= Chunk[223:192];
                        w_array[10] <= Chunk[191:160];
                        w_array[11] <= Chunk[159:128];
                        w_array[12] <= Chunk[127:96];
                        w_array[13] <= Chunk[95:64];
                        w_array[14] <= Chunk[63:32];
                        w_array[15] <= Chunk[31:0];
                        round       <= 6'd0;
                        Q_next      <= HASHING;
                    end
                    else begin
                        Q_next <= DISABLED;
                    end
                end

                HASHING : begin
                    if (round == 6'd63) begin
                        Q_next <= DIGEST_READY;
                    end
                    else begin
                        round <= round + 6'd1; // increment round counter
                        if (round > 15) begin
                            // begin calculating new w values
                            for (i = 0; i < 15; i = i + 1)
                                w_array[i] <= w_array[i+1];
                            w_array[15] <= w; // Shift in the latest calculated w value
                        end
                        Q_next <= HASHING;
                    end
                end

                DIGEST_READY : begin
                    // Hashing complete. Calculate intermediate hash by summing
                    Digest <= { (a_out + SHA256_A0), (b_out + SHA256_B0),
                                (c_out + SHA256_C0), (d_out + SHA256_D0),
                                (e_out + SHA256_E0), (f_out + SHA256_F0),
                                (g_out + SHA256_G0), (h_out + SHA256_H0) };
                    DigestReady <= 1'b1; // Assert Digest Ready flag
                    Q_next      <= DIGEST_READY; // Stay in this state until reset
                end
            endcase

            Q_present <= Q_next; // Transition to next state
        end
    end

    // NEW: tidy debug registers so you see one value per round
    always @ (posedge Clk or negedge Reset) begin
        if (!Reset) begin
            WOut_reg        <= 32'd0;
            CurrentHash_reg <= 256'd0;
        end
        else if (Q_present == HASHING) begin
            // Snapshot W[t] and the round output state once per round
            WOut_reg        <= w;
            CurrentHash_reg <= {a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out};
        end
    end
endmodule