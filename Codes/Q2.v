`timescale 1ns/1ns

module mux (input s0, s1, a, b, c, d, output w);
	assign #(28,30) w = (s0==0 & s1==0) ? a:
						(s0==0 & s1==1) ? b:
						(s0==1 & s1==0) ? c:
						(s0==1 & s1==1) ? d:
						1'bx;
endmodule

module barrel_shifter (input [3:0] A, [1:0] S, output [3:0] SHO);
	mux mux1 (S[1], S[0], A[3], A[0], A[1], A[2], SHO[3]),
		mux2 (S[1], S[0], A[2], A[3], A[0], A[1], SHO[2]),
		mux3 (S[1], S[0], A[1], A[2], A[3], A[0], SHO[1]),
		mux4 (S[1], S[0], A[0], A[1], A[2], A[3], SHO[0]);
endmodule

module TB ();
	reg [3:0] AA;
	reg [1:0] SS;
	wire [3:0] WW;
	barrel_shifter my_ic(AA, SS, WW);
	initial begin
		#50 AA=4'b1001; SS=2'b11;
		#50 AA=4'b0110;
		#50 SS=2'b00;
		#50 $stop;
	end
endmodule