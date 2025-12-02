`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 09:53:05 PM
// Design Name: 
// Module Name: Hex_ASCII_Convert
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


module Hex_ASCII_Convert(
    input clk, rst, enable, send_carriage_return, send_line_feed,
    input [3:0] hex_input, 
    output reg ASCII_available, carriage_return_sent, line_feed_sent,
    output reg [7:0] ASCII_output
    );
    
    always @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            ASCII_output <= 8'b0; 
            ASCII_available <= 1'b0;
            carriage_return_sent <= 1'b0;
            line_feed_sent <= 1'b0;
        end else begin 
            
            ASCII_available <= 1'b0;
            carriage_return_sent <= 1'b0;
            line_feed_sent <= 1'b0;
            
            if (!enable) begin 
                ASCII_available <= 1'b0;
            end else if (send_line_feed) begin 
                ASCII_output <= 8'd10; // character for line feed
                ASCII_available <= 1'b1;
                line_feed_sent <= 1'b1;
            end else if (send_carriage_return) begin 
                ASCII_output <= 8'd13; // character for carriage return
                ASCII_available <= 1'b1;
                carriage_return_sent <= 1'b1;
            end else if (hex_input >9) begin 
                ASCII_output <= (hex_input + 8'd87); 
                ASCII_available <= 1'b1; 
            end else begin 
                ASCII_output <= (hex_input + 8'd48);
                ASCII_available <= 1'b1;
            end 
        end
    end 
endmodule
