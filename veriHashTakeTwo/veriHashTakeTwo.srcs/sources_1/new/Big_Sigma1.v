`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 06:07:47 PM
// Design Name: 
// Module Name: Big_Sigma1
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


module Big_Sigma1(
    input [31:0] Big_Sigma1,
    output [31:0] Big_Sigma1_Out
    );
    
    // Interconnects
	wire [31:0] RR_6;
	wire [31:0] RR_11;
	wire [31:0] RR_25;
	
	// Create three rotated versions of input E
	assign RR_6 = {Big_Sigma1[5:0], Big_Sigma1[31:6]}; // RR E 6 bits
	assign RR_11 = {Big_Sigma1[10:0], Big_Sigma1[31:11]}; // RR E 11 bits
	assign RR_25 = {Big_Sigma1[24:0], Big_Sigma1[31:25]}; // RR E 25 bits
	
	// Bitwise XOR the rotated versions together
	assign Big_Sigma1_Out = (RR_6 ^ RR_11 ^ RR_25);

endmodule
