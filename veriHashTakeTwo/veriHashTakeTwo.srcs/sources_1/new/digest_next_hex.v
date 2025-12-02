`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 09:23:06 PM
// Design Name: 
// Module Name: digest_next_hex
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


module digest_next_hex(
    input clk, rst, enable,
    input [255:0] digest_register, 
    output reg available, digest_end,
    output reg [3:0] hex_output
    );
    
    reg [5:0] index = 6'd63; // take complete digest
    
    always @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            digest_end <= 1'b0;
            available <= 1'b0;
            index <= 6'd63;
        end else begin 
            available <= 1'b0;
            digest_end <= 1'b0;
            
            if (!enable) begin 
                available <= 1'b0;
            end else if (!available && (index == 0)) begin // end of digest has been reached
                hex_output <= digest_register[4*index +: 4];
                available <= 1'b1;
                digest_end <= 1'b1;
                index <=6'd63;
            end else begin 
                hex_output <= digest_register[4*index +: 4];
                available <= 1'b1;
                index <= index - 1'b1;
            end 
        end 
    end
endmodule
