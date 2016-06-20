module ctrl(op, RegDst, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Jump, Branch, ALUOp, e);
	input		[5:0]	op;
	output	reg			RegDst;
	output	reg			RegWrite;
	output	reg			ALUSrc;
	output	reg			MemRead;
	output	reg			MemWrite;
	output	reg			MemtoReg;
	output	reg			Jump;
	output	reg			Branch;
	output	reg	[1:0]	ALUOp;
	output	reg			e;

	parameter 	R			= 6'b000000,
				LW			= 6'b100011,
				SW			= 6'b101011,
				BEQ			= 6'b000100,
				J			= 6'b000010,
				ADDI		= 6'b001000;

	initial begin
		RegDst = 0;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		Jump = 0;
		Branch = 0;
		ALUOp = 2'b00;
		e = 0;
	end

	always @(*) begin
		case (op)
			R: begin
				RegDst = 1;
				ALUSrc = 0;
				MemtoReg = 0;
				RegWrite = 1;
				MemRead = 0;
				MemWrite = 0;
				Jump = 0;
				Branch = 0;
				ALUOp = 2'b10;
				e = 0;
			end

			LW: begin
				RegDst = 0;
				ALUSrc = 1;
				MemtoReg = 1;
				RegWrite = 1;
				MemRead = 1;
				MemWrite = 0;
				Jump = 0;
				Branch = 0;
				ALUOp = 2'b00;
				e = 0;
			end

			SW: begin
				ALUSrc = 1;
				RegWrite = 0;
				MemRead = 0;
				MemWrite = 1;
				Jump = 0;
				Branch = 0;
				ALUOp = 2'b00;
				e = 0;
			end

			BEQ: begin
				ALUSrc = 0;
				RegWrite = 0;
				MemRead = 0;
				MemWrite = 0;
				Jump = 0;
				Branch = 1;
				ALUOp = 2'b01;
				e = 0;
			end

			J: begin
				ALUSrc = 0;
				RegWrite = 0;
				MemRead = 0;
				MemWrite = 0;
				Jump = 1;
				Branch = 0;
				ALUOp = 2'b00;
				e = 0;
			end

			ADDI: begin
				RegDst = 0;
				ALUSrc = 1;
				MemtoReg = 0;
				RegWrite = 1;
				MemRead = 0;
				MemWrite = 0;
				Jump = 0;
				Branch = 0;
				ALUOp = 2'b00;
				e = 0;
			end

			default: begin
				RegDst = 0;
				ALUSrc = 0;
				MemtoReg = 0;
				RegWrite = 0;
				MemRead = 0;
				MemWrite = 0;
				Jump = 0;
				Branch = 0;
				ALUOp = 2'b00;
				e = 1;
			end
		endcase
	end

endmodule