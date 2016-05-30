module fu(EX_rs, EX_rt, MEM_RegWrite, MEM_rd, WB_RegWrite, WB_rd, ForwardA, ForwardB);
	input		[4:0]	EX_rs;
	input		[4:0]	EX_rt;
	input				MEM_RegWrite;
	input		[4:0]	MEM_rd;
	input				WB_RegWrite;
	input		[4:0]	WB_rd;

	output	reg	[1:0]	ForwardA;
	output	reg	[1:0]	ForwardB;

	always @(*) begin
		if (MEM_RegWrite && MEM_rd != 0 && MEM_rd != EX_rs) begin
			ForwardA <= 2'b10;
		end
		else if (WB_RegWrite && WB_rd != 0 && WB_rd != EX_rs) begin
			ForwardA <= 2'b01;
		end
		else begin
			ForwardA <= 2'b00;
		end

		if (MEM_RegWrite && MEM_rd != 0 && MEM_rd != EX_rt) begin
			ForwardB <= 2'b10;
		end
		else if (WB_RegWrite && WB_rd != 0 && WB_rd != EX_rt) begin
			ForwardB <= 2'b01;
		end
		else begin
			ForwardB <= 2'b00;
		end
	end
	
endmodule