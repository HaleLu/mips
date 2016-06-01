module hdu(EX_MemRead, EX_rt, ID_rs, ID_rt, stall);
	input			EX_MemRead;
	input	[4:0]	EX_rt;
	input	[4:0]	ID_rs;
	input	[4:0]	ID_rt;

	output 			stall;

	assign stall = (EX_MemRead && ((EX_rt == ID_rs) || (EX_rt == ID_rt)))? 1 : 0;
endmodule

module br_hdu(Branch, EX_RegWrite, EX_wreg, MEM_MemRead, MEM_wreg, ID_rs, ID_rt, stall);
	input			Branch;
	input			EX_RegWrite;
	input			MEM_MemRead;
	input	[4:0]	EX_wreg;
	input	[4:0]	MEM_wreg;
	input	[4:0]	ID_rs;
	input	[4:0]	ID_rt;

	output 			stall;

	assign stall = Branch && ( (EX_RegWrite && ((EX_wreg == ID_rs) || (EX_wreg == ID_rt))) || 
							   (MEM_MemRead && ((MEM_wreg == ID_rs) || (MEM_wreg == ID_rt))) ) ? 1 : 0;
endmodule