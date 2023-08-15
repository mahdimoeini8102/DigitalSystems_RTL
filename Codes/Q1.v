`timescale 1ns/1ns

module mux (input s0, s1, a, b, c, d, output w);
	assign #(28,30) w = (s0==0 & s1==0) ? a:
						(s0==0 & s1==1) ? b:
						(s0==1 & s1==0) ? c:
						(s0==1 & s1==1) ? d:
						1'bx;
endmodule

module TB ();
	reg aa, bb, cc, dd, ss0, ss1;
	wire ww;
	mux my_ic(ss0, ss1, aa, bb, cc, dd, ww);
	initial begin
		#50 aa=0; bb=1; cc=0; dd=1; ss0=0; ss1=0;
		#50 ss0=1;
		#50 ss1=1;
		#50 dd=0;
		#50 $stop;
	end
endmodule