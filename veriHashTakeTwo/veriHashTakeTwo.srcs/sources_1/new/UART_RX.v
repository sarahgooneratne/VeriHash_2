`timescale 1ns / 1ps
module UART_RX(
    input clk, rst, enable, RX_In, 
    output framing_error, reset_detected, chunk_received,
    output [511:0] chunk_out
    );
    
    parameter DISABLED = 1'b0;
    parameter ENABLE_RX = 1'b1;
    
    reg S_current = DISABLED;
    reg S_next = DISABLED;
    
    reg baud_rate_gen_enable = 1'b0;
    reg rst_shift_reg = 1'b1;
    
    wire baud_rate;
    
    clk_to_baud converter(.input_clk(clk), .rst(rst_shift_reg), .enable(baud_rate_gen_enable), .clk_output(baud_rate));
    RX_Shift_Register sr(.Clk(baud_rate), .Reset(rst_shift_reg), .Rx(RX_In), .FramingError(framing_error), .Reset_Received(reset_detected), .ChunkReady(chunk_received), .ChunkOut(chunk_out));
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin 
            S_current <= DISABLED;
            rst_shift_reg <= 1'b0;
            baud_rate_gen_enable <= 1'b0;
        end else begin 
            S_current <= S_next;
            case (S_current) 
                DISABLED : begin 
                    rst_shift_reg <= 1'b1;
                    if (enable) begin 
                       baud_rate_gen_enable <= 1'b1;
                       S_next <= ENABLE_RX;
                    end else begin 
                       S_next <= DISABLED;
                    end 
                end 
                ENABLE_RX : begin
                    if (!enable) begin 
                        baud_rate_gen_enable <= 1'b0;
                        S_next <= DISABLED;
                    end else if (reset_detected) begin 
                        baud_rate_gen_enable <= 1'b0;
                        S_next <= DISABLED;
                    end else begin 
                        S_next <= ENABLE_RX;
                    end 
                end
            endcase
        end                    
    end
endmodule 