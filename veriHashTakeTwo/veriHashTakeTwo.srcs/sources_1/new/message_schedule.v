`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 10:43:05 AM
// Design Name: 
// Module Name: message_schedule
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


module message_schedule(
    input clk,
    input [5:0] block,
    input [511:0] Flat_W_Arr,
    output reg [31:0] W_Out
    );
    
    
    wire [15:0] W_Arr [0:31];
    
    reg [31:0] E = 32'd0, F = 32'd0, G = 32'd0, H = 32'd0, I = 32'd0, J = 32'd0, sigma0 = 32'd0, sigma1 = 32'd0;
    
    assign {W_Arr[31], W_Arr[30], W_Arr[29], W_Arr[28], W_Arr[27], W_Arr[26], W_Arr[25], W_Arr[24], W_Arr[23], W_Arr[22], W_Arr[21], W_Arr[20], W_Arr[19], W_Arr[18], W_Arr[17], W_Arr[16], W_Arr[15], W_Arr[14], W_Arr[13], W_Arr[12], W_Arr[11], W_Arr[10], W_Arr[9], W_Arr[8], W_Arr[7], W_Arr[6], W_Arr[5], W_Arr[4], W_Arr[3], W_Arr[2], W_Arr[1], W_Arr[0]} = Flat_W_Arr;
 
    always @ (negedge clk) begin
        if (block < 16) begin 
            W_Out <= W_Arr[block];
        end else begin
            E = {W_Arr[1][6:0], W_Arr[1][31:7]}; // RR7
		    F = {W_Arr[1][17:0], W_Arr[1][31:18]}; // RR18
			G = W_Arr[1] >> 3; // Shift Right 3
			H = {W_Arr[14][16:0], W_Arr[14][31:17]}; // RR17
		    I = {W_Arr[14][18:0], W_Arr[14][31:19]}; // Rotate Right 19
			J = W_Arr[14] >> 10; // Shift Right 10
			sigma0 = (E ^ F ^ G);
			sigma1 = (H ^ I ^ J);
			
			W_Out = (W_Arr[0] + sigma0 + W_Arr[9] + sigma1);
			
	   end
    end
    
        
    
endmodule
