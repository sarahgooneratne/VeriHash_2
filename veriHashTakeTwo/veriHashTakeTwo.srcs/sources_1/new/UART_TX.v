`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2025 10:18:35 AM
// Design Name: 
// Module Name: UART_TX
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


module UART_TX(
    input Clk, Reset, DigestReady, 
    input [255:0] Digest,
    output TxOut, 
    output reg TxDone
    );
   
	parameter	WAIT_FOR_DIGEST	=	4'b0000,	// Wait for digest to be calculated
					GET_NEXT_DIGEST	=	4'b0001,	// Access next hex value in the digest register
					GET_ASCII			=	4'b0010,	// Convert Hex to ASCII value
					LOAD_TX_SR			=	4'b0011,	// Load the ASCII value into the shift register
					TX_SHIFT_OUT		=	4'b0100,	// Shift out everything in register
					TX_SR_EMPTY			=	4'b0101,	// Shift register is empty
					TX_CR					=	4'b0110,	// Send Carriage Return
					TX_LF					=	4'b0111,	// Send Line Feed
					TX_COMPLETE			=	4'b1000;	// Transmission is complete
	
	
	
	// Reset control for baud rate
	reg reset_brg = 1'b0;
	
	// State registers
	reg [3:0] Q_present, Q_next;
	
	// Control signals
	reg next_hex, next_ascii, send_cr, send_lf, load_sr, brg_en;
	
	// Flag signals
	wire hex_available, ascii_available, cr_sent, lf_sent, sr_empty, last_hex;
	
	// Baud rate clock
	wire baud_rate;
	
	// Data interconnects
	wire [3:0] hex_data;
	wire [7:0] ascii_data;
	
	// Instantiate modules with appropriate interconnects
	clk_to_baud brg (.input_clk(Clk), .rst(reset_brg), .enable(brg_en), .clk_output(baud_rate));
	
	digest_next_hex gdh (.clk(Clk), .rst(Reset), .enable(next_hex), .digest_register(Digest), .hex_output(hex_data), .hex_available(hex_available), .digest_end(last_hex));
	
	
	
	Hex_ASCII_Convert hta (.clk(Clk), .rst(Reset), .enable(next_ascii), .send_carriage_return(send_cr), .send_line_feed(send_lf), .hex_input(hex_data), .ASCII_output(ascii_data), .ASCII_available(ascii_available), .carriage_return_sent(cr_sent), .line_feed_sent(lf_sent));
	
	
	
	
	TX_Shift_Register sr (.clk(baud_rate), .rst(Reset), .asynch_load(load_sr), .data_in(ascii_data), .serial_out(TxOut), .empty(sr_empty));
	
	always @ (posedge Clk, negedge Reset)
		begin
			if (!Reset)
				begin 
					Q_present <= WAIT_FOR_DIGEST;
					next_hex <= 0;
					next_ascii <= 0;
					send_cr <= 0;
					send_lf <= 0;
					load_sr <= 0;
					brg_en <= 0;
					TxDone <= 0;
				end
			else
				begin
					case (Q_present)
						WAIT_FOR_DIGEST: begin
							TxDone <= 0;
							reset_brg <= 1'b0;
						end
						GET_NEXT_DIGEST: begin
							next_hex <= 1;
						end
						GET_ASCII: begin
							next_hex <= 0;
							next_ascii <= 1;
						end
						LOAD_TX_SR: begin
							next_ascii <= 0;
							load_sr <= 1;
							reset_brg <= 1'b1;
						end
						TX_SHIFT_OUT: begin
							load_sr <= 0;
							brg_en <= 1;
						end
						TX_SR_EMPTY: begin
							brg_en <= 0;
						end
						TX_CR: begin
							send_cr <= 1;
						end
						TX_LF: begin
							send_lf <= 1;
						end
						TX_COMPLETE: begin
							send_cr <= 0;
							send_lf <= 0;
							TxDone <= 1;
						end
					endcase
					Q_present <= Q_next;
				end
		end

	// Don't ask me what made me think I should do it this way...
	// Too tired to combine this with the other always block... it works...
	always @ (Reset, Q_present)
		begin
			if (!Reset)
				begin
					Q_next = WAIT_FOR_DIGEST;
				end
			else
				begin
					// Determine Next State
					case (Q_present)
						WAIT_FOR_DIGEST: begin // Wait
							if (DigestReady)
								begin
									Q_next = GET_NEXT_DIGEST;
								end
							else
								begin
									Q_next = WAIT_FOR_DIGEST;
								end
						end
						GET_NEXT_DIGEST:	begin // Get HEX
							if (hex_available)
								begin
									Q_next = GET_ASCII;
								end
							else
								begin
									Q_next = GET_NEXT_DIGEST;
								end
						end
						GET_ASCII: begin // Get ASCII
							if (ascii_available)
								begin
									Q_next = LOAD_TX_SR;
								end
							else
								begin
									Q_next = GET_ASCII;
								end
						end
						LOAD_TX_SR: begin // Load SR
							if (!sr_empty)
								begin
									Q_next = TX_SHIFT_OUT;
								end
							else
								begin
									Q_next = LOAD_TX_SR;
								end
						end
						TX_SHIFT_OUT: begin // Shift Out
							if (sr_empty)
								begin
									Q_next = TX_SR_EMPTY;
								end
							else
								begin
									Q_next = TX_SHIFT_OUT;
								end
						end
						TX_SR_EMPTY: begin // SR Empty
							if (last_hex)
								begin
									Q_next = TX_CR;
								end
							else
								begin
									Q_next = GET_NEXT_DIGEST;
								end
						end
						TX_CR: begin // Send Carriage Return
							if (cr_sent)
								begin
									Q_next <= TX_LF;
								end
							else
								begin
									Q_next <= GET_ASCII;
								end
						end
						TX_LF: begin // Send Line Feed
							if (lf_sent)
								begin
									Q_next <= TX_COMPLETE;
								end
							else
								begin
									Q_next <= GET_ASCII;
								end
						end
						TX_COMPLETE: begin // TX complete
							Q_next = TX_COMPLETE;
						end
					endcase
				end
		end
	
endmodule
    

