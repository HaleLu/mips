module mips(clk, rst) ;
	input	clk ;	// clock
	input	rst ;	// reset

	wire	[31:0]	pc_now;
	wire	[31:0]	pc_next;
	wire	[31:0]	IF_pc_plus_4;
	wire	[31:0]	ID_pc_plus_4;
	wire	[31:0]	ID_pc_br;
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
	wire	[31:0]	EX_rtemp1;
	wire	[31:0]	EX_rdata1;
	wire	[31:0]	EX_rtemp2;
	wire	[31:0]	EX_rdata2;
	wire	[31:0]	MEM_rdata2;
	wire	[31:0]	ID_const_or_addr;
	wire	[31:0]	EX_const_or_addr;
	wire	[31:0]	ALUSrc_data1;
	wire	[31:0]	ALUSrc_data2;
	wire	[31:0]	EX_ALU_res;
	wire	[31:0]	WB_ALU_res;
	wire	[31:0]	MEM_ALU_res;
	wire	[31:0]	MEM_rdata;
	wire	[31:0]	WB_rdata;
	wire	[31:0]	wdata;
	wire	[3:0]	op;
	wire			Jump;

	wire			RegDst;
	wire			RegWrite;
	wire			ALUSrc;
	wire			MemRead;
	wire			MemWrite;
	wire			MemtoReg;
	wire			Branch;
	wire	[1:0]	ALUOp;

	// WB_Reg
	wire			ID_MemtoReg;
	wire			ID_RegWrite;
	wire			EX_MemtoReg;
	wire			EX_RegWrite;
	wire			MEM_MemtoReg;
	wire			MEM_RegWrite;
	wire			WB_MemtoReg;
	wire			WB_RegWrite;

	// M_Reg
	wire			ID_MemRead;
	wire			ID_MemWrite;
	wire			EX_MemRead;
	wire			EX_MemWrite;
	wire			MEM_MemRead;
	wire			MEM_MemWrite;

	// EX_Reg
	wire			ID_ALUSrc;
	wire			ID_RegDst;
	wire	[1:0]	ID_ALUOp;
	wire			EX_ALUSrc;
	wire			EX_RegDst;
	wire	[1:0]	EX_ALUOp;

	wire	[1:0]	ForwardA;
	wire	[1:0]	ForwardB;

	wire			ls_Stall;
	wire			rdata_equal;
	wire			IF_Flush;
	wire			Stall;


	wire	[31:0]	br_ID_rdata1;
	wire	[31:0]	br_ID_rdata2;
	wire	[1:0]	br_ForwardA;
	wire	[1:0]	br_ForwardB;
	wire			br_Stall;

	// IF
	pc pc(.clk(clk), .rst(rst), .en(~Stall), .data(pc_next), .dout(pc_now));
	assign IF_pc_plus_4 = pc_now + 4;	
	assign IF_Flush = ~br_Stall & rdata_equal & Branch;
	mux3 #(32) pc_mux(.a(IF_pc_plus_4), .b(ID_pc_br), .c({ID_pc_plus_4[31:28],ID_ins[25:0],2'b00}), .s({Jump, IF_Flush}), .dout(pc_next));
	im_4k im(.addr(pc_now[11:2]), .dout(IF_ins));

	// IF/ID
	IF_ID IF_ID(.clk(clk), .en(~Stall), .rst(IF_Flush | Jump), .IF_pc_plus_4(IF_pc_plus_4), .IF_ins(IF_ins), .ID_pc_plus_4(ID_pc_plus_4), .ID_ins(ID_ins));

	// ID
	assign ID_pc_br = ID_pc_plus_4 + {ID_const_or_addr[29:0], 2'b00};
	ctrl ctrl(	.op(ID_ins[31:26]), .RegDst(RegDst), .RegWrite(RegWrite), .ALUSrc(ALUSrc),
				.MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg),
				.Jump(Jump), .Branch(Branch), .ALUOp(ALUOp));
	regheap regheap(.clk(clk), .we(WB_RegWrite), .rreg1(ID_ins[25:21]), .rreg2(ID_ins[20:16]),
					.wreg(WB_wreg), .wdata(wdata), .rdata1(ID_rdata1), .rdata2(ID_rdata2));
	ext #(16) ext(.din(ID_ins[15:0]), .dout(ID_const_or_addr));
	mux3 br_rdata1_mux(.a(ID_rdata1), .b(wdata), .c(MEM_ALU_res), .s(br_ForwardA), .dout(br_ID_rdata1));
	mux3 br_rdata2_mux(.a(ID_rdata2), .b(wdata), .c(MEM_ALU_res), .s(br_ForwardB), .dout(br_ID_rdata2));
	assign rdata_equal = br_ID_rdata1 == br_ID_rdata2 ? 1 : 0;
	

	// Hazard Detection Unit
	hdu hdu(.EX_MemRead(EX_MemRead), .EX_rt(EX_rt), .ID_rs(ID_ins[25:21]), .ID_rt(ID_ins[20:16]), .stall(ls_Stall));
	br_hdu br_hdu(.Branch(Branch), .EX_RegWrite(EX_RegWrite), .EX_wreg(EX_wreg), 
				  .MEM_MemRead(MEM_MemRead), .MEM_wreg(MEM_wreg),
				  .ID_rs(ID_ins[25:21]), .ID_rt(ID_ins[20:16]), .stall(br_Stall));
	assign Stall = br_Stall | ls_Stall;
	
	mux2 #(8) stall_mux(.a({RegDst,RegWrite,ALUSrc,MemRead,MemWrite,MemtoReg,ALUOp}), .b(8'b0000_0000), .s(Stall), 
						.dout({ID_RegDst,ID_RegWrite,ID_ALUSrc,ID_MemRead,ID_MemWrite,ID_MemtoReg,ID_ALUOp}));
	// ID/EX
	ID_EX ID_EX(.clk(clk), .ID_RegDst(ID_RegDst), .ID_RegWrite(ID_RegWrite),
				.ID_MemRead(ID_MemRead), .ID_MemWrite(ID_MemWrite),
				.ID_ALUSrc(ID_ALUSrc), .ID_MemtoReg(ID_MemtoReg), .ID_ALUOp(ID_ALUOp),
				.ID_rdata1(ID_rdata1), .ID_rdata2(ID_rdata2),
				.ID_const_or_addr(ID_const_or_addr), .ID_rs(ID_ins[25:21]), .ID_rt(ID_ins[20:16]), .ID_rd(ID_ins[15:11]),
				.EX_RegDst(EX_RegDst), .EX_RegWrite(EX_RegWrite),
				.EX_MemRead(EX_MemRead), .EX_MemWrite(EX_MemWrite),
				.EX_ALUSrc(EX_ALUSrc), .EX_MemtoReg(EX_MemtoReg), .EX_ALUOp(EX_ALUOp),
				.EX_rdata1(EX_rtemp1), .EX_rdata2(EX_rtemp2),
				.EX_const_or_addr(EX_const_or_addr), .EX_rs(EX_rs), .EX_rt(EX_rt), .EX_rd(EX_rd));

	// EX
	mux3 #(32) ALUSrc1_mux(.a(EX_rtemp1), .b(wdata), .c(MEM_ALU_res), .s(ForwardA), .dout(EX_rdata1));
	mux3 #(32) ALUSrc2_mux(.a(EX_rtemp2), .b(wdata), .c(MEM_ALU_res), .s(ForwardB), .dout(EX_rdata2));
	ALUctrl ALUctrl(.ALUOp(EX_ALUOp), .funct(EX_const_or_addr[5:0]), .op(op));
	assign ALUSrc_data1 = EX_rdata1;
	mux2 #(32) ALUSrc_mux(.a(EX_rdata2), .b(EX_const_or_addr), .s(EX_ALUSrc), .dout(ALUSrc_data2));
	alu alu(.op(op), .a(ALUSrc_data1), .b(ALUSrc_data2), .dout(EX_ALU_res));
	mux2 #(5) wreg_mux(.a(EX_rt), .b(EX_rd), .s(EX_RegDst), .dout(EX_wreg));

	// Forwarding Unit
	fu forwardingUnit(.EX_rs(EX_rs), .EX_rt(EX_rt), .MEM_RegWrite(MEM_RegWrite), .MEM_rd(MEM_wreg),
					  .WB_RegWrite(WB_RegWrite), .WB_rd(WB_wreg), .ForwardA(ForwardA), .ForwardB(ForwardB));
	fu br_forwardingUnit(.EX_rs(ID_ins[25:21]), .EX_rt(ID_ins[20:16]), .MEM_RegWrite(MEM_RegWrite), .MEM_rd(MEM_wreg),
					  .WB_RegWrite(WB_RegWrite), .WB_rd(WB_wreg), .ForwardA(br_ForwardA), .ForwardB(br_ForwardB));
	
	// EX/MEM
	EX_MEM EX_MEM(.clk(clk), .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite),
				  .EX_MemRead(EX_MemRead), .EX_MemWrite(EX_MemWrite),
				  .EX_ALU_res(EX_ALU_res), .EX_rdata2(EX_rdata2), .EX_wreg(EX_wreg), 
				  .MEM_MemtoReg(MEM_MemtoReg), .MEM_RegWrite(MEM_RegWrite),
				  .MEM_MemRead(MEM_MemRead), .MEM_MemWrite(MEM_MemWrite),
				  .MEM_ALU_res(MEM_ALU_res), .MEM_rdata2(MEM_rdata2), .MEM_wreg(MEM_wreg));

	// MEM
	dm_4k dm(.addr(MEM_ALU_res), .din(MEM_rdata2), .we(MEM_MemWrite), .re(MEM_MemRead), .clk(clk), .dout(MEM_rdata));

	// MEM/WB
	MEM_WB MEM_WB(.clk(clk), .MEM_MemtoReg(MEM_MemtoReg), .MEM_RegWrite(MEM_RegWrite),
				  .MEM_rdata(MEM_rdata), .MEM_ALU_res(MEM_ALU_res), .MEM_wreg(MEM_wreg),
				  .WB_MemtoReg(WB_MemtoReg), .WB_RegWrite(WB_RegWrite),
				  .WB_rdata(WB_rdata), .WB_ALU_res(WB_ALU_res), .WB_wreg(WB_wreg));

	// WB
	mux2 #(32) RegSrc_mux(.a(WB_ALU_res), .b(WB_rdata), .s(WB_MemtoReg), .dout(wdata));

endmodule