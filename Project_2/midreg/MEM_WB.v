module MEM_WB(clk, MEM_rdata, MEM_ALU_res,
				   WB_rdata , WB_ALU_res);
	input			clk;
	input	[31:0]	MEM_rdata;
	input	[31:0]	MEM_ALU_res;

	output	[31:0]	WB_rdata;
	output	[31:0]	WB_ALU_res;

	reg		[31:0]	rdata;
	reg		[31:0]	ALU_res;

	always @(posedge clk) begin
		rdata	<=	MEM_rdata;
		ALU_res	<=	MEM_ALU_res;
	end

	assign WB_rdata		=	rdata;
	assign WB_ALU_res	=	ALU_res;
endmodule