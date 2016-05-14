module mips(clk, rst) ;
	input	clk ;	// clock
	input	rst ;	// reset

	wire	[31:0]	pc_now;
	wire	[31:0]	pc_tmp;
	wire	[31:0]	pc_next;
	wire	[31:0]	pc_plus_4;
	wire	[31:0]	pc_br;
	wire	[31:0]	ins;
	wire	[4:0]	wreg;
	wire	[31:0]	rdata1;
	wire	[31:0]	rdata2;
	wire	[31:0]	const_or_addr;
	wire	[31:0]	ALUSrc_data1;
	wire	[31:0]	ALUSrc_data2;
	wire			zero;
	wire	[31:0]	ALU_res;
	wire	[31:0]	rdata;
	wire	[31:0]	wdata;
	wire	[3:0]	op;


	wire			RegDst;
	wire			RegWrite;
	wire			ALUSrc;
	wire			MemRead;
	wire			MemWrite;
	wire			MemtoReg;
	wire			Jump;
	wire			Branch;
	wire	[1:0]	ALUOp;

	pc pc(.clk(clk), .rst(rst), .data(pc_next), .dout(pc_now));
	assign pc_plus_4 = pc_now + 4;

	
	alu pc_alu(.op(4'b0010), .a(pc_plus_4), .b({const_or_addr[29:0], 2'b00}), .dout(pc_br));
	mux2 #(32) br_mux(.a(pc_plus_4), .b(pc_br), .s(Branch & zero), .dout(pc_tmp));
	mux2 #(32) j_mux(.a({pc_plus_4[31:28],ins[25:0],2'b00}), .b(pc_tmp), .s(Jump), .dout(pc_next));
	im_4k im(.addr(pc_now[11:2]), .dout(ins));

	ctrl ctrl(	.op(ins[31:26]), .RegDst(RegDst), .RegWrite(RegWrite), .ALUSrc(ALUSrc),
				.MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg),
				.Jump(Jump), .Branch(Branch), .ALUOp(ALUOp));

	mux2 #(5) wreg_mux(.a(ins[20:16]), .b(ins[15:11]), .s(RegDst), .dout(wreg));
	regheap regheap(.clk(clk), .we(RegWrite), .rreg1(ins[25:21]), .rreg2(ins[20:16]),
					.wreg(wreg), .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));
	ext #(16) ext(.in(ins[15:0]), .dout(const_or_addr));
	assign ALUSrc_data1 = rdata1;
	mux2 #(32) ALUSrc_mux(.a(rdata2), .b(const_or_addr), .s(ALUSrc), .dout(ALUSrc_data2));
	ALUctrl ALUctrl(.ALUOp(ALUOp), .funct(ins[5:0]), .op(op));
	alu alu(.op(op), .a(ALUSrc_data1), .b(ALUSrc_data2), .zero(zero), .dout(ALU_res));
	dm_4k dm(.addr(ALU_res), .din(rdata2), .we(MemWrite), .re(MemRead), .clk(clk), .dout(rdata));
	mux2 #(32) RegSrc_mux(.a(ALU_res), .b(rdata), .s(MemtoReg), .dout(wdata));

	
endmodule