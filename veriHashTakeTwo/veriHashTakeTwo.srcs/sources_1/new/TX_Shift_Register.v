`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2025 09:49:42 AM
// Design Name: 
// Module Name: TX_Shift_Register
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

module TX_Shift_Register(
    input clk, rst, asynch_load, 
    input [7:0] data_in, 
    output reg serial_out, empty 
    );
    
    reg [9:0] temp;
    reg [3:0] count;
    
    always @(posedge clk or negedge rst) begin 
        if (!rst) begin 
            temp <= 10'b1111111111;
            serial_out <= 1'b1;
            count <= 4'd0;
            empty <= 1'b1;
        end else begin 
            if (asynch_load && empty) begin 
                temp <= {1'b1, data_in[7:0], 1'b0};
                count <= 4'd10;
                empty <= 1'b0;
            end else if (count != 0) begin
                serial_out <= temp[0];
                temp <= {1'b1, temp[9:1]};
                
                if (count == 1) begin 
                    empty <= 1'b1;
                end
                
                count <= count - 4'd1;
            end
       end
    end 
endmodule

