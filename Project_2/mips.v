module mips(clk, rst) ;
	input	clk ;	// clock
	input	rst ;	// reset

	wire	[31:0]	pc_now;
	wire	[31:0]	pc_tmp;
	wire	[31:0]	pc_next;
	wire	[31:0]	IF_pc_plus_4;
	wire	[31:0]	ID_pc_plus_4;
	wire	[31:0]	EX_pc_plus_4;
	wire	[31:0]	EX_pc_br;
	wire	[31:0]	MEM_pc_br;
	wire	[31:0]	IF_ins;
	wire	[31:0]	ID_ins;
	wire	[4:0]	EX_rs;
	wire	[4:0]	EX_rt;
	wire	[4:0]	EX_rd;
	wire	[4:0]	EX_wreg;
	wire	[4:0]	MEM_wreg;
	wire	[4:0]	WB_wreg;
	wire	[31:0]	ID_rdata1;
	wire	[31:0]	ID_rdata2;
	wire	[31:0]	EX_rdata1;
	wire	[31:0]	EX_rdata2;
	wire	[31:0]	MEM_rdata2;
	wire	[31:0]	ID_const_or_addr;
	wire	[31:0]	EX_const_or_addr;
	wire	[31:0]	ALUSrc_data1;
	wire	[31:0]	ALUSrc_data2;
	wire			EX_zero;
	wire			MEM_zero;
	wire	[31:0]	EX_ALU_res;
	wire	[31:0]	WB_ALU_res;
	wire	[31:0]	MEM_ALU_res;
	wire	[31:0]	MEM_rdata;
	wire	[31:0]	WB_rdata;
	wire	[31:0]	wdata;
	wire	[3:0]	op;

	// WB_Reg
	wire			ID_RegDst;
	wire			ID_RegWrite;
	wire			EX_RegDst;
	wire			EX_RegWrite;
	wire			MEM_RegDst;
	wire			MEM_RegWrite;
	wire			WB_RegDst;
	wire			WB_RegWrite;

	// M_Reg
	wire			ID_Branch;
	wire			ID_MemRead;
	wire			ID_MemWrite;
	wire			EX_Branch;
	wire			EX_MemRead;
	wire			EX_MemWrite;
	wire			MEM_Branch;
	wire			MEM_MemRead;
	wire			MEM_MemWrite;

	// EX_Reg
	wire			ID_ALUSrc;
	wire			ID_MemtoReg;
	wire	[1:0]	ID_ALUOp;
	wire			EX_ALUSrc;
	wire			EX_MemtoReg;
	wire	[1:0]	EX_ALUOp;


	wire			ID_Jump;
	wire			EX_Jump;

	// IF
	mux2 #(32) br_mux(.a(IF_pc_plus_4), .b(MEM_pc_br), .s(MEM_Branch & MEM_zero), .dout(pc_next));
//	mux2 #(32) j_mux(.a({MEM_pc_plus_4[31:28],ins[25:0],2'b00}), .b(pc_tmp), .s(Jump), .dout(pc_next));
	pc pc(.clk(clk), .rst(rst), .data(pc_next), .dout(pc_now));
	assign IF_pc_plus_4 = pc_now + 4;	
	im_4k im(.addr(pc_now[11:2]), .dout(IF_ins));

	// IF/ID
	IF_ID IF_ID(.clk(clk), .IF_pc_plus_4(IF_pc_plus_4), .IF_ins(IF_ins), .ID_pc_plus_4(ID_pc_plus_4), .ID_ins(ID_ins));

	// ID
	ctrl ctrl(	.op(ID_ins[31:26]), .RegDst(ID_RegDst), .RegWrite(ID_RegWrite), .ALUSrc(ID_ALUSrc),
				.MemRead(ID_MemRead), .MemWrite(ID_MemWrite), .MemtoReg(ID_MemtoReg),
				.Jump(Jump), .Branch(ID_Branch), .ALUOp(ID_ALUOp));
	regheap regheap(.clk(clk), .we(WB_RegWrite), .rreg1(ID_ins[25:21]), .rreg2(ID_ins[20:16]),
					.wreg(WB_wreg), .wdata(wdata), .rdata1(ID_rdata1), .rdata2(ID_rdata2));
	ext #(16) ext(.din(ID_ins[15:0]), .dout(ID_const_or_addr));

	// ID/EX
	ID_EX ID_EX(.clk(clk), .ID_RegDst(ID_RegDst), .ID_RegWrite(ID_RegWrite),
				.ID_Branch(ID_Branch), .ID_MemRead(ID_MemRead), .ID_MemWrite(ID_MemWrite),
				.ID_ALUSrc(ID_ALUSrc), .ID_MemtoReg(ID_MemtoReg), .ID_ALUOp(ID_ALUOp),
				.ID_pc_plus_4(ID_pc_plus_4), .ID_rdata1(ID_rdata1), .ID_rdata2(ID_rdata2),
				.ID_const_or_addr(ID_const_or_addr), .ID_rs(ID_ins[25:21]), .ID_rt(ID_ins[20:16]), .ID_rd(ID_ins[15:11]),
				.EX_RegDst(EX_RegDst), .EX_RegWrite(EX_RegWrite),
				.EX_Branch(EX_Branch), .EX_MemRead(EX_MemRead), .EX_MemWrite(EX_MemWrite),
				.EX_ALUSrc(EX_ALUSrc), .EX_MemtoReg(EX_MemtoReg), .EX_ALUOp(EX_ALUOp),
				.EX_pc_plus_4(EX_pc_plus_4), .EX_rdata1(EX_rdata1), .EX_rdata2(EX_rdata2),
				.EX_const_or_addr(EX_const_or_addr), .EX_rs(EX_rs), .EX_rt(EX_rt), .EX_rd(EX_rd));

	// EX
	alu pc_alu(.op(4'b0010), .a(EX_pc_plus_4), .b({EX_const_or_addr[29:0], 2'b00}), .dout(EX_pc_br));
	ALUctrl ALUctrl(.ALUOp(EX_ALUOp), .funct(EX_const_or_addr[5:0]), .op(op));
	assign ALUSrc_data1 = EX_rdata1;
	mux2 #(32) ALUSrc_mux(.a(EX_rdata2), .b(EX_const_or_addr), .s(EX_ALUSrc), .dout(ALUSrc_data2));
	alu alu(.op(op), .a(ALUSrc_data1), .b(ALUSrc_data2), .zero(EX_zero), .dout(EX_ALU_res));
	mux2 #(5) wreg_mux(.a(EX_rt), .b(EX_rd), .s(EX_RegDst), .dout(EX_wreg));
	
	// EX/MEM
	EX_MEM EX_MEM(.clk(clk), .EX_RegDst(EX_RegDst), .EX_RegWrite(EX_RegWrite),
				  .EX_Branch(EX_Branch), .EX_MemRead(EX_MemRead), .EX_MemWrite(EX_MemWrite),
				  .EX_pc_br(EX_pc_br), .EX_zero(EX_zero), .EX_ALU_res(EX_ALU_res),
				  .EX_rdata2(EX_rdata2), .EX_wreg(EX_wreg), 
				  .MEM_RegDst(MEM_RegDst), .MEM_RegWrite(MEM_RegWrite),
				  .MEM_Branch(MEM_Branch), .MEM_MemRead(MEM_MemRead), .MEM_MemWrite(MEM_MemWrite),
				  .MEM_pc_br(MEM_pc_br), .MEM_zero(MEM_zero),
				  .MEM_ALU_res(MEM_ALU_res), .MEM_rdata2(MEM_rdata2), .MEM_wreg(MEM_wreg));

	// MEM
	dm_4k dm(.addr(MEM_ALU_res), .din(MEM_rdata2), .we(MEM_MemWrite), .re(MEM_MemRead), .clk(clk), .dout(MEM_rdata));

	// MEM/WB
	MEM_WB MEM_WB(.clk(clk), .MEM_RegDst(MEM_RegDst), .MEM_RegWrite(MEM_RegWrite),
				  .MEM_rdata(MEM_rdata), .MEM_ALU_res(MEM_ALU_res), .MEM_wreg(MEM_wreg),
				  .WB_RegDst(WB_RegDst), .WB_RegWrite(WB_RegWrite),
				  .WB_rdata(WB_rdata), .WB_ALU_res(WB_ALU_res), .WB_wreg(WB_wreg));

	// WB
	mux2 #(32) RegSrc_mux(.a(WB_ALU_res), .b(WB_rdata), .s(WB_RegDst), .dout(wdata));

endmodule