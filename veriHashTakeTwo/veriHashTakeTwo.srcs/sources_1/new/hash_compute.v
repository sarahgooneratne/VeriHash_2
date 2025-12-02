`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 02:43:30 PM
// Design Name: 
// Module Name: hash_compute
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


module hash_compute(
    input clk, 
    input [31:0] W_In, K_In, a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in,
    output reg [31:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out
    );
    
   wire [31:0] ch_out;
   wire [31:0] big_sigma1_out; 
   wire [31:0] maj_out;
   wire [31:0] big_sigma0_out;
   
   // From FIPS 180-4
   wire [31:0] T1; 
   wire [31:0] T2;

   reg [31:0] T1_reg, T2_reg;
   reg [31:0] a_reg, b_reg, c_reg, d_reg, e_reg, f_reg, g_reg, h_reg;
   
   assign T1 = h_in + big_sigma1_out + ch_out + (K_In + W_In);
   assign T2 = big_sigma0_out + maj_out;
   
   Big_Sigma1 E1(e_in, big_sigma1_out);
   ch choose (e_in, f_in, g_in, ch_out);
   
   Big_Sigma0 E0(a_in, big_sigma0_out);
   majority maj(a_in, b_in, c_in, maj_out);
   
   always @(posedge clk) begin 
       // Using a two-stage process to meet timing constraints of 100 MHz clock
       T1_reg <= T1;
       T2_reg <= T2;
       a_reg <= a_in;
       b_reg <= b_in;
       c_reg <= c_in;
       d_reg <= d_in;
       e_reg <= e_in;
       f_reg <= f_in;
       g_reg <= g_in;
       h_reg <= h_in;
   
       
       h_out <= g_reg;
       g_out <= f_reg;
       f_out <= e_reg;
       e_out <= d_reg + T1_reg;
       d_out <= c_reg;
       c_out <= b_reg;
       b_out <= a_reg;
       a_out <= T1_reg + T2_reg;
   end   
endmodule
