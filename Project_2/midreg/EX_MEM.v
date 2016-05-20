module EX_MEM(clk, EX_pc_br , EX_zero , EX_ALU_res , EX_rdata2 , EX_wreg, 
				   MEM_pc_br, MEM_zero, MEM_ALU_res, MEM_rdata2, MEM_wreg)
	input			clk;
	
	input	[31:0]	EX_pc_br;
	input			EX_zero;
	input	[31:0]	EX_ALU_res;
	input	[31:0]	EX_rdata2;
	input	[4:0]	EX_wreg;

	output	[31:0]	MEM_pc_br;
	output			MEM_zero;
	output	[31:0]	MEM_ALU_res;
	output	[31:0]	MEM_rdata2;
	output	[4:0]	MEM_wreg;

	reg		[31:0]	pc_br;
	reg				zero;
	reg		[31:0]	ALU_res;
	reg		[31:0]	rdata2;
	reg		[4:0]	wreg;

	always @(posedge clk) begin
		pc_br		<=	EX_pc_br;
		zero		<=	EX_zero;
		ALU_res		<=	EX_ALU_res;
		rdata2		<=	EX_rdata2;
		wreg		<=	EX_wreg;
	end

	assign MEM_pc_br	=	pc_br;
	assign MEM_zero		=	zero;
	assign MEM_ALU_res	=	ALU_res;
	assign MEM_rdata2	=	rdata2;
	assign MEM_wreg		=	wreg;
endmodule