`timescale 1ns/1ns

module mux (input s0, s1, a, b, c, d, output w);
	assign #(28,30) w = (s0==0 & s1==0) ? a:
						(s0==0 & s1==1) ? b:
						(s0==1 & s1==0) ? c:
						(s0==1 & s1==1) ? d:
						1'bx;
endmodule

module mux_16to1 (input [15:0] I, [3:0] S, output f);
	wire O0, O1, O2, O3;
	mux mux1 (S[1], S[0], I[0],  I[1],  I[2],  I[3],  O0),
		mux2 (S[1], S[0], I[4],  I[5],  I[6],  I[7],  O2),
		mux3 (S[1], S[0], I[8],  I[9],  I[10], I[11], O1),
		mux4 (S[1], S[0], I[12], I[13], I[14], I[15], O3),
		muxo (S[3], S[2], O0,  O1,  O2,  O3,  f);
endmodule

module TB ();
	reg [15:0] II;
	reg [3:0] SS;
	wire ff;
	mux_16to1 my_ic(II, SS, ff);
	initial begin
		#100 II=16'b1010101101011100; SS=4'b0000;
		#100 II=16'b1010101101011101;
		#100 SS=4'b1111;
		#100 II=16'b0010101101011101;
		#100 II=16'B0000000000000000;
		#100 $stop;
	end
endmodule