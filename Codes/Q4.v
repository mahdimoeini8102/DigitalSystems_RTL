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

module barrel_shifter_16bit (input [15:0] I, [3:0] S, output [15:0] SHO);
	reg [15:0] IA [0:16];
	reg temp [0:16];
		
	assign IA[0] = I;
	for (genvar n=1;n<17;n=n+1)begin
		assign temp[n-1]=IA[n-1][15];
		for (genvar m=0;m<15;m=m+1)begin
			assign IA[n][15-m]=IA[n-1][15-m-1];
		end
		assign IA[n][0]=temp[n-1];
	end
	
	mux_16to1 	mux1 (IA[1], S,SHO[15]), mux2 (IA[2], S,SHO[14]),
				mux3 (IA[3], S,SHO[13]), mux4 (IA[4], S,SHO[12]),
				mux5 (IA[5], S,SHO[11]), mux6 (IA[6], S,SHO[10]),
				mux7 (IA[7], S, SHO[9]), mux8 (IA[8], S, SHO[8]),
				mux9 (IA[9], S, SHO[7]), mux10(IA[10],S, SHO[6]),
				mux11(IA[11],S, SHO[5]), mux12(IA[12],S, SHO[4]),
				mux13(IA[13],S, SHO[3]), mux14(IA[14],S, SHO[2]),
				mux15(IA[15],S, SHO[1]), mux16(IA[16],S, SHO[0]);
	
endmodule

module TB ();
	reg  [15:0] II;
	reg  [3:0]  SS;
	wire [15:0] ff;
	barrel_shifter_16bit my_ic(II,SS,ff);
	initial begin
		#200 II=16'b1010101101011100; SS=4'b0000;
		#200 II=16'b1010101101011101;
		#200 SS=4'b1111;
		#200 II=16'b0010101101011101;
		#200 II=16'B0000000000000000;
		#200 $stop;
	end
endmodule