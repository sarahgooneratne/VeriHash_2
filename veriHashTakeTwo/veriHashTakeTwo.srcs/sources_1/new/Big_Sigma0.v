`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 06:11:26 PM
// Design Name: 
// Module Name: Big_Sigma0
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


module Big_Sigma0(
    input [31:0] Big_Sigma0,
    output [31:0] Big_Sigma0_Out
    );
    

	wire [31:0] RR_2;
	wire [31:0] RR_13;
	wire [31:0] RR_22;
	
	// Create three rotated versions of input Big_Sigma0
	assign RR_2 = {Big_Sigma0[1:0], Big_Sigma0[31:2]}; // RR Big_Sigma0 2 bits
	assign RR_13 = {Big_Sigma0[12:0], Big_Sigma0[31:13]}; // RR Big_Sigma0 13 bits
	assign RR_22 = {Big_Sigma0[21:0], Big_Sigma0[31:22]}; // RR Big_Sigma0 22 bits
	
	// Bitwise XOR the rotated versions together
	assign Big_Sigma0_Out = (RR_2 ^ RR_13 ^ RR_22);

    
endmodule
