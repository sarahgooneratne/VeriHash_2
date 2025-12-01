`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 04:16:07 AM
// Design Name: 
// Module Name: constant_words
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


module constant_words(
    input [5:0] index, 
    output [31:0] K
    );
    
    // index is the subscript number of each of the 64 constant 32-bit words, as defined in the FIPS 180-2, Secure Hash Standard 
    // K is the 32-bit value of each 32-bit word 
    
    reg [31:0] current_word;
    assign K = current_word;
    
    always@(*) begin
        case(index) 
            00: current_word = 32'h428a2f98;  // K0
            01: current_word = 32'h71374491;  // K1
            02: current_word = 32'hb5c0fbcf;  // K2
            03: current_word = 32'he9b5dba5;  // K3
            04: current_word = 32'h3956c25b;  // K4
            05: current_word = 32'h59f111f1;  // K5
            06: current_word = 32'h923f82a4;  // K6
            07: current_word = 32'hab1c5ed5;  // K7
            08: current_word = 32'hd807aa98;  // K8
            09: current_word = 32'h12835b01;  // K9
            10: current_word = 32'h243185be;  // K10
            11: current_word = 32'h550c7dc3;  // K11
            12: current_word = 32'h72be5d74;  // K12
            13: current_word = 32'h80deb1fe;  // K13
            14: current_word = 32'h9bdc06a7;  // K14
            15: current_word = 32'hc19bf174;  // K15
            16: current_word = 32'he49b69c1;  // K16
            17: current_word = 32'hefbe4786;  // K17
            18: current_word = 32'h0fc19dc6;  // K18
            19: current_word = 32'h240ca1cc;  // K19
            20: current_word = 32'h2de92c6f;  // K20
            21: current_word = 32'h4a7484aa;  // K21
            22: current_word = 32'h5cb0a9dc;  // K22
            23: current_word = 32'h76f988da;  // K23
            24: current_word = 32'h983e5152;  // K24
            25: current_word = 32'ha831c66d;  // K25
            26: current_word = 32'hb00327c8;  // K26
            27: current_word = 32'hbf597fc7;  // K27
            28: current_word = 32'hc6e00bf3;  // K28
            29: current_word = 32'hd5a79147;  // K29
            30: current_word = 32'h06ca6351;  // K30
            31: current_word = 32'h14292967;  // K31
            32: current_word = 32'h27b70a85;  // K32
            33: current_word = 32'h2e1b2138;  // K33
            34: current_word = 32'h4d2c6dfc;  // K34
            35: current_word = 32'h53380d13;  // K35
            36: current_word = 32'h650a7354;  // K36
            37: current_word = 32'h766a0abb;  // K37
            38: current_word = 32'h81c2c92e;  // K38
            39: current_word = 32'h92722c85;  // K39
            40: current_word = 32'ha2bfe8a1;  // K40
            41: current_word = 32'ha81a664b;  // K41
            42: current_word = 32'hc24b8b70;  // K42
            43: current_word = 32'hc76c51a3;  // K43
            44: current_word = 32'hd192e819;  // K44
            45: current_word = 32'hd6990624;  // K45
            46: current_word = 32'hf40e3585;  // K46
            47: current_word = 32'h106aa070;  // K47
            48: current_word = 32'h19a4c116;  // K48
            49: current_word = 32'h1e376c08;  // K49
            50: current_word = 32'h2748774c;  // K50
            51: current_word = 32'h34b0bcb5;  // K51
            52: current_word = 32'h391c0cb3;  // K52
            53: current_word = 32'h4ed8aa4a;  // K53
            54: current_word = 32'h5b9cca4f;  // K54
            55: current_word = 32'h682e6ff3;  // K55
            56: current_word = 32'h748f82ee;  // K56
            57: current_word = 32'h78a5636f;  // K57
            58: current_word = 32'h84c87814;  // K58
            59: current_word = 32'h8cc70208;  // K59
            60: current_word = 32'h90befffa;  // K60
            61: current_word = 32'ha4506ceb;  // K61
            62: current_word = 32'hbef9a3f7;  // K62
            63: current_word = 32'hc67178f2;  // K63            
            default : current_word = 32'h00000000; 
        endcase 
    end
endmodule
