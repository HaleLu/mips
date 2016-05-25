module ID_EX(clk, ID_RegDst, ID_RegWrite, ID_Branch, ID_MemRead, ID_MemWrite, ID_ALUSrc, ID_MemtoReg, ID_ALUOp, ID_pc_plus_4, ID_rdata1, ID_rdata2, ID_const_or_addr, ID_rs, ID_rt, ID_rd, 
				  EX_RegDst, EX_RegWrite, EX_Branch, EX_MemRead, EX_MemWrite, EX_ALUSrc, EX_MemtoReg, EX_ALUOp, EX_pc_plus_4, EX_rdata1, EX_rdata2, EX_const_or_addr, EX_rs, EX_rt, EX_rd);
	input			clk;

	input			ID_RegDst;
	input			ID_RegWrite;
	input			ID_Branch;
	input			ID_MemRead;
	input			ID_MemWrite;
	input			ID_ALUSrc;
	input			ID_MemtoReg;
	input	[1:0]	ID_ALUOp;
	input	[31:0]	ID_pc_plus_4;
	input	[31:0]	ID_rdata1;
	input	[31:0]	ID_rdata2;
	input	[31:0]	ID_const_or_addr;
	input	[4:0]	ID_rs;
	input	[4:0]	ID_rt;
	input	[4:0]	ID_rd;

	output			EX_RegDst;
	output			EX_RegWrite;
	output			EX_Branch;
	output			EX_MemRead;
	output			EX_MemWrite;
	output			EX_ALUSrc;
	output			EX_MemtoReg;
	output	[1:0]	EX_ALUOp;
	output	[31:0]	EX_pc_plus_4;
	output	[31:0]	EX_rdata1;
	output	[31:0]	EX_rdata2;
	output	[31:0]	EX_const_or_addr;
	output	[4:0]	EX_rs;
	output	[4:0]	EX_rt;
	output	[4:0]	EX_rd;

	reg				RegDst;
	reg				RegWrite;
	reg				Branch;
	reg				MemRead;
	reg				MemWrite;
	reg				ALUSrc;
	reg				MemtoReg;
	reg		[1:0]	ALUOp;
	reg		[31:0]	pc_plus_4;
	reg		[31:0]	rdata1;
	reg		[31:0]	rdata2;
	reg		[31:0]	const_or_addr;
	reg		[4:0]	rs;
	reg		[4:0]	rt;
	reg		[4:0]	rd;

	initial begin
		RegDst			=	0;
		RegWrite		=	0;
		Branch			=	0;
		MemRead			=	0;
		MemWrite		=	0;
		ALUSrc			=	0;
		MemtoReg		=	0;
		ALUOp			=	0;
		pc_plus_4		=	0;
		rdata1			=	0;
		rdata2			=	0;
		const_or_addr	=	0;
		rs				=	0;
		rt				=	0;
		rd				=	0;
	end

	always @(posedge clk) begin
		RegDst			<=	ID_RegDst;
		RegWrite		<=	ID_RegWrite;
		Branch			<=	ID_Branch;
		MemRead			<=	ID_MemRead;
		MemWrite		<=	ID_MemWrite;
		ALUSrc			<=	ID_ALUSrc;
		MemtoReg		<=	ID_MemtoReg;
		ALUOp			<=	ID_ALUOp;
		pc_plus_4		<=	ID_pc_plus_4;
		rdata1			<=	ID_rdata1;
		rdata2			<=	ID_rdata2;
		const_or_addr	<=	ID_const_or_addr;
		rs				<=	ID_rs;
		rt				<=	ID_rt;
		rd				<=	ID_rd;
	end

	assign EX_RegDst		=	RegDst;
	assign EX_RegWrite		=	RegWrite;
	assign EX_Branch		=	Branch;
	assign EX_MemRead		=	MemRead;
	assign EX_MemWrite		=	MemWrite;
	assign EX_ALUSrc		=	ALUSrc;
	assign EX_MemtoReg		=	MemtoReg;
	assign EX_ALUOp			=	ALUOp;
	assign EX_pc_plus_4		=	pc_plus_4;
	assign EX_rdata1		=	rdata1;
	assign EX_rdata2		=	rdata2;
	assign EX_const_or_addr	=	const_or_addr;
	assign EX_rs			=	rs;
	assign EX_rt			=	rt;
	assign EX_rd			=	rd;
endmodule