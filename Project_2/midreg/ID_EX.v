module ID_EX(clk, ID_RegDst, ID_RegWrite, ID_pc_plus_4, ID_rdata1, ID_rdata2, ID_const_or_addr, ID_rt, ID_rd, 
				  EX_RegDst, EX_RegWrite, EX_pc_plus_4, EX_rdata1, EX_rdata2, EX_const_or_addr, EX_rt, EX_rd);
	input			clk;

	input			ID_RegDst;
	input			ID_RegWrite;
	input	[31:0]	ID_pc_plus_4;
	input	[31:0]	ID_rdata1;
	input	[31:0]	ID_rdata2;
	input	[31:0]	ID_const_or_addr;
	input	[4:0]	ID_rt;
	input	[4:0]	ID_rd;

	output			EX_RegDst;
	output			EX_RegWrite;
	output	[31:0]	EX_pc_plus_4;
	output	[31:0]	EX_rdata1;
	output	[31:0]	EX_rdata2;
	output	[31:0]	EX_const_or_addr;
	output	[4:0]	EX_rt;
	output	[4:0]	EX_rd;

	reg				RegDst;
	reg				RegWrite;
	reg		[31:0]	pc_plus_4;
	reg		[31:0]	rdata1;
	reg		[31:0]	rdata2;
	reg		[31:0]	const_or_addr;
	reg		[4:0]	rt;
	reg		[4:0]	rd;

	always @(posedge clk) begin
		RegDst			<=	ID_RegDst;
		RegWrite		<=	ID_RegWrite;
		pc_plus_4		<=	ID_pc_plus_4;
		rdata1			<=	ID_rdata1;
		rdata2			<=	ID_rdata2;
		const_or_addr	<=	ID_const_or_addr;
		rt				<=	ID_rt;
		rd				<=	ID_rd;
	end

	assign EX_RegDst		=	RegDst;
	assign EX_RegWrite		=	RegWrite;
	assign EX_pc_plus_4		=	pc_plus_4;
	assign EX_rdata1		=	rdata1;
	assign EX_rdata2		=	rdata2;
	assign EX_const_or_addr	=	const_or_addr
	assign EX_rt			=	rt;
	assign EX_rd			=	rd;
endmodule