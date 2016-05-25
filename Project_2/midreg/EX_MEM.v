module EX_MEM(clk, EX_RegDst , EX_RegWrite , EX_Branch , EX_MemRead , EX_MemWrite , EX_pc_br , EX_zero , EX_ALU_res , EX_rdata2 , EX_wreg, 
				   MEM_RegDst, MEM_RegWrite, MEM_Branch, MEM_MemRead, MEM_MemWrite, MEM_pc_br, MEM_zero, MEM_ALU_res, MEM_rdata2, MEM_wreg);
	input			clk;
	
	input			EX_RegDst;
	input			EX_RegWrite;
	input			EX_Branch;
	input			EX_MemRead;
	input			EX_MemWrite;
	input	[31:0]	EX_pc_br;
	input			EX_zero;
	input	[31:0]	EX_ALU_res;
	input	[31:0]	EX_rdata2;
	input	[4:0]	EX_wreg;

	output			MEM_RegDst;
	output			MEM_RegWrite;
	output			MEM_Branch;
	output			MEM_MemRead;
	output			MEM_MemWrite;
	output	[31:0]	MEM_pc_br;
	output			MEM_zero;
	output	[31:0]	MEM_ALU_res;
	output	[31:0]	MEM_rdata2;
	output	[4:0]	MEM_wreg;

	reg				RegDst;
	reg				RegWrite;
	reg				Branch;
	reg				MemRead;
	reg				MemWrite;
	reg		[31:0]	pc_br;
	reg				zero;
	reg		[31:0]	ALU_res;
	reg		[31:0]	rdata2;
	reg		[4:0]	wreg;

	initial begin
		RegDst		=	0;
		RegWrite	=	0;
		Branch		=	0;
		MemRead		=	0;
		MemWrite	=	0;
		pc_br		=	0;
		zero		=	0;
		ALU_res		=	0;
		rdata2		=	0;
		wreg		=	0;
	end

	always @(posedge clk) begin
		RegDst		<=	EX_RegDst;
		RegWrite	<=	EX_RegWrite;
		Branch		<=	EX_Branch;
		MemRead		<=	EX_MemRead;
		MemWrite	<=	EX_MemWrite;
		pc_br		<=	EX_pc_br;
		zero		<=	EX_zero;
		ALU_res		<=	EX_ALU_res;
		rdata2		<=	EX_rdata2;
		wreg		<=	EX_wreg;
	end

	assign MEM_RegDst	=	RegDst;
	assign MEM_RegWrite	=	RegWrite;
	assign MEM_Branch	=	Branch;
	assign MEM_MemRead	=	MemRead;
	assign MEM_MemWrite	=	MemWrite;
	assign MEM_pc_br	=	pc_br;
	assign MEM_zero		=	zero;
	assign MEM_ALU_res	=	ALU_res;
	assign MEM_rdata2	=	rdata2;
	assign MEM_wreg		=	wreg;
endmodule