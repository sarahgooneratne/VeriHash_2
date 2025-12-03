module calc_w (Clk, Round, Flat_W_Arr, WOut);
	input Clk;
	input [5:0] Round;
	input [511:0] Flat_W_Arr;
	output reg [31:0] WOut = 32'hFF;

	wire [31:0] W_Arr [0:15];

   assign { W_Arr[15], W_Arr[14], W_Arr[13], W_Arr[12],
             W_Arr[11], W_Arr[10], W_Arr[9],  W_Arr[8],
             W_Arr[7],  W_Arr[6],  W_Arr[5],  W_Arr[4],
             W_Arr[3],  W_Arr[2],  W_Arr[1],  W_Arr[0] } = Flat_W_Arr;

	// Rotated / Right-Shifted verisions of W from 15th last and 2nd last round
	reg [31:0]	I = 32'd0,
					J = 32'd0,
					K = 32'd0,
					P = 32'd0,
					Q = 32'd0,
					R = 32'd0,
					S0 = 32'd0, // XOR'ed w from 15th last round
					S1 = 32'd0; // XOR'ed w from 2nd last round

	always @ (posedge Clk) // Update w on the negative clock edge
		begin
			if (Round < 16) // Not enough rounds have passed to calculate W yet...
				begin
					WOut <= W_Arr[Round]; // Round input is preprocessed user input data
				end
			else
				begin
					I = {W_Arr[1][6:0], W_Arr[1][31:7]}; // RR7
					J = {W_Arr[1][17:0], W_Arr[1][31:18]}; // RR18
					K = W_Arr[1] >> 3; // SR 3
					P = {W_Arr[14][16:0], W_Arr[14][31:17]}; // RR17
					Q = {W_Arr[14][18:0], W_Arr[14][31:19]}; // RR19
					R = W_Arr[14] >> 10; // SR 10
					S0 = (I ^ J ^ K);
					S1 = (P ^ Q ^ R);
					// Current w = last round w + Rotated, Shifted, XOR'ed 15th last round w +
					// 				9th round w + Rotated, Shifted, XOR'ed 2nd last round w
					WOut = (W_Arr[0] + S0 + W_Arr[9] + S1);
			     end
		end
endmodule 