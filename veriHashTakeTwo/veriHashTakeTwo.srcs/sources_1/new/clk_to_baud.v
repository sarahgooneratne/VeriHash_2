`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2025 09:01:58 PM
// Design Name: 
// Module Name: clk_to_baud
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


module clk_to_baud(
    input input_clk, rst, enable,
    output reg clk_output
    );
    
    parameter MAX = 10'd867;
    
    reg [9:0] counter = 10'd0; 
    
    always @(posedge input_clk or negedge rst) begin 
        if (!rst) begin 
            counter <= 10'd0;
            clk_output <= 1'b0;
        end else begin 
            if (!enable) begin 
                counter <= 10'd0;
                clk_output <= 1'b0;
            end else if (counter == MAX) begin 
                counter <= 10'd0;
                clk_output <= 1'b1;
            end else begin 
                counter <= counter + 10'd1;
                clk_output <= 1'b0;
            end
        end
    end
endmodule

