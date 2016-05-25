module MEM_WB(clk, MEM_RegDst, MEM_RegWrite, MEM_rdata, MEM_ALU_res, MEM_wreg,
				   WB_RegDst, WB_RegWrite, WB_rdata , WB_ALU_res, WB_wreg);
	input			clk;
	input			MEM_RegDst;
	input			MEM_RegWrite;
	input	[31:0]	MEM_rdata;
	input	[31:0]	MEM_ALU_res;
	input	[4:0]	MEM_wreg;

	output			WB_RegDst;
	output			WB_RegWrite;
	output	[31:0]	WB_rdata;
	output	[31:0]	WB_ALU_res;
	output	[4:0]	WB_wreg;

	reg				RegDst;
	reg				RegWrite;
	reg		[31:0]	rdata;
	reg		[31:0]	ALU_res;
	reg		[4:0]	wreg;

	initial begin
		RegDst		=	0;
		RegWrite	=	0;
		rdata		=	0;
		ALU_res		=	0;
		wreg		=	0;
	end

	always @(posedge clk) begin
		RegDst		<=	MEM_RegDst;
		RegWrite	<=	MEM_RegWrite;
		rdata		<=	MEM_rdata;
		ALU_res		<=	MEM_ALU_res;
		wreg		<=	MEM_wreg;
	end

	assign WB_RegDst	=	RegDst;
	assign WB_RegWrite	=	RegWrite;
	assign WB_rdata		=	rdata;
	assign WB_ALU_res	=	ALU_res;
	assign WB_wreg 		= 	wreg;
endmodule