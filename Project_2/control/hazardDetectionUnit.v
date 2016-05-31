module hdu(EX_MemRead, EX_rt, ID_rs, ID_rt, stall);
	input			EX_MemRead;
	input	[4:0]	EX_rt;
	input	[4:0]	ID_rs;
	input	[4:0]	ID_rt;

	output 			stall;

	assign stall = (EX_MemRead && ((EX_rt == ID_rs) || (EX_rt == ID_rt)))? 1 : 0;
endmodule