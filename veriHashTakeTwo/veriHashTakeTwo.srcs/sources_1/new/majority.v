`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 04:21:39 PM
// Design Name: 
// Module Name: majority
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
module majority(
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    output [31:0] Majority_Out
    );
    
    assign Majority_Out = (A & B) ^ (A & C) ^ (B & C);
    
endmodule
