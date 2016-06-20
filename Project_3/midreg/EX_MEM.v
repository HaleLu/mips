module EX_MEM(clk, rst, EX_MemtoReg , EX_RegWrite , EX_MemRead , EX_MemWrite , EX_ALU_res , EX_rdata2 , EX_wreg, 
						MEM_MemtoReg, MEM_RegWrite, MEM_MemRead, MEM_MemWrite, MEM_ALU_res, MEM_rdata2, MEM_wreg);
	input			clk;
	input			rst;
	
	input			EX_MemtoReg;
	input			EX_RegWrite;
	input			EX_MemRead;
	input			EX_MemWrite;
	input	[31:0]	EX_ALU_res;
	input	[31:0]	EX_rdata2;
	input	[4:0]	EX_wreg;

	output			MEM_MemtoReg;
	output			MEM_RegWrite;
	output			MEM_MemRead;
	output			MEM_MemWrite;
	output	[31:0]	MEM_ALU_res;
	output	[31:0]	MEM_rdata2;
	output	[4:0]	MEM_wreg;

	reg				MemtoReg;
	reg				RegWrite;
	reg				MemRead;
	reg				MemWrite;
	reg		[31:0]	ALU_res;
	reg		[31:0]	rdata2;
	reg		[4:0]	wreg;

	initial begin
		MemtoReg	=	0;
		RegWrite	=	0;
		MemRead		=	0;
		MemWrite	=	0;
		ALU_res		=	0;
		rdata2		=	0;
		wreg		=	0;
	end

	always @(posedge clk) begin
		if (rst) begin
			MemtoReg	=	0;
			RegWrite	=	0;
			MemRead		=	0;
			MemWrite	=	0;
			ALU_res		=	0;
			rdata2		=	0;
			wreg		=	0;
		end
		else begin
			MemtoReg	<=	EX_MemtoReg;
			RegWrite	<=	EX_RegWrite;
			MemRead		<=	EX_MemRead;
			MemWrite	<=	EX_MemWrite;
			ALU_res		<=	EX_ALU_res;
			rdata2		<=	EX_rdata2;
			wreg		<=	EX_wreg;
		end
		
	end

	assign MEM_MemtoReg	=	MemtoReg;
	assign MEM_RegWrite	=	RegWrite;
	assign MEM_MemRead	=	MemRead;
	assign MEM_MemWrite	=	MemWrite;
	assign MEM_ALU_res	=	ALU_res;
	assign MEM_rdata2	=	rdata2;
	assign MEM_wreg		=	wreg;
endmodule