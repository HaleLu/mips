# mips
Mips 处理器仿真设计

## 开发语言、工具和环境
采用 Verilog 语言开发  
Window 10 环境下  
使用了 Sublime Text + ModelSim 的方式进行开发（ModelSim 自带的编辑器真的难用一个tab竟然是8个空格啊啊啊啊啊）

## 开发进度
Project 1 已完成支持9条指令的单周期。
Project 2 目前已完成支持9条指令的流水，暂不支持转发、阻塞和异常。

## Project_1
单周期的 MIPS 处理器  
只支持 add、sub、and、or、lw、sw、slt、beq、j 这9条指令  

具体分为两大部分和处理器部分
### datapath（数据通路）
定义了各种元部件
#### alu.v
模块名：alu  
说明：算逻部件  
输入接口：op（4位，运算符编码）, a, b（32位，运算数）  
输出接口：zero（结果是否为0）, dout（32位，运算结果）  
op的说明：  
　　0010： dout = a + b  
　　0110： dout = a - b  
　　0001： dout = a | b  
　　0000： dout = a & b  
　　0111： dout = a < b ? 1 : 0

#### dm.v
模块名：dm_4k  
说明：数据寄存器，大小为4k（时钟上升沿触发）  
输入接口：addr（10位，数据地址）, din（32位，写数据时的数据端）, we（写数据使能端）, re（读数据使能端）, clk（时钟端）  
输出接口：dout（32位，读数据时的数据输出端）  

#### ext.v
模块名：ext  
说明：符号扩展部件（W 表示输入数据宽度）  
输入接口：din（W 位）  
输出接口：dout（32位）  

#### im.v
模块名：im_4k  
说明：指令存储器，大小为4k  
输入接口：addr（10位，运算符编码）  
输出接口：dout（32位，对应指令）  

#### mux.v
模块名：mux2  
说明：二路选择器（W 表示输入数据宽度）  
输入接口：a, b（W 位，表示0和1对应的数据源）, s（选择信号）  
输出接口：dout（W 位，选择结果）  

#### pc.v
模块名：pc  
说明：程序计数器（时钟上升沿触发）  
输入接口：clk（时钟端）, rst（重置信号）, data（32位，下一指令地址）  
输出接口：dout（32位，当前指令地址）  

#### regheap.v
模块名：regheap  
说明：寄存器堆（时钟上升沿触发）  
输入接口：clk（时钟端）, we（写寄存器使能端）, rreg1（5位，读寄存器1地址）, rreg2（5位，读寄存器2地址）, wreg（5位，写寄存器的地址）, wdata（写入寄存器的数据）  
输出接口：rdata1（32位，读寄存器1的数据）, rdata2（32位，读寄存器2的数据）
另：有部分为方便测试而添加的初始化寄存器的值的代码。  

### control（控制信号）

解析指令，生成对应的控制信号

#### ALUctrl.v
模块名：ALUctrl  
说明：算逻部件控制器  
输入接口：ALUOp（2位）, funct（6位，指令的5-0位）  
输出接口：op（4位，对应的 alu 运算符编码）

#### ctrl.v
模块名：ctrl  
说明：算逻部件控制器  
输入接口：op（6位，指令的31-26位）  
输出接口：RegDst, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Jump, Branch, ALUOp（各种控制信号，其中 ALUOp 为2位）

### mips.v（处理器部分）
模块名：mips  
说明：单周期处理器（时钟上升沿触发）  
输入接口：clk（时钟端）, rst（重置信号）  

### testbench.v（测试代码）
模块名：testbench  
说明：生成时钟信号测试部件可行性  

## Project_2
流水级 MIPS 处理器  
暂时支持 add、sub、and、or、lw、sw、slt、beq、j 这9条指令  
暂时不支持转发、阻塞和异常  

和 Project_1 相比，差别在于添加了中间寄存器

### midreg（中间寄存器）

#### IF_ID.v
模块名：IF_ID  
说明：IF/ID（时钟上升沿触发）  
输入接口：clk（时钟端）, IF_pc_plus_4（32位，pc + 4）, IF_ins（32位，IF取出的指令）  
输出接口：ID_pc_plus_4（32位）, ID_ins（32位）

#### ID_EX.v
模块名：ID_EX  
说明：ID/EX（时钟上升沿触发）  
输入接口：clk（时钟端）,   
　　　　　ID_RegDst, ID_RegWrite, ID_Branch, ID_MemRead, ID_MemWrite, ID_ALUSrc, ID_MemtoReg, ID_ALUOp（除 ID_ALUOp 为2位外其余均为1位，表示对应的控制信号）,  
　　　　　ID_pc_plus_4（32位，pc + 4）, ID_rdata1（32位，rs 寄存器的数据）, ID_rdata2（32位，rt 寄存器的数据）, ID_const_or_addr（32位，I 指令中的地址/立即数）,   
　　　　　ID_rs（5位， 表示 rs 寄存器）, ID_rt（5位， 表示 rt 寄存器）, ID_rd（5位， 表示 rd 寄存器）  
输出接口：EX_RegDst, EX_RegWrite, EX_Branch, EX_MemRead, EX_MemWrite, EX_ALUSrc, EX_MemtoReg,  
　　　　　EX_ALUOp, EX_pc_plus_4, EX_rdata1, EX_rdata2, EX_const_or_addr,  
　　　　　EX_rs, EX_rt, EX_rd（分别表示对应的数据位）  

#### EX_MEM.v
模块名：EX_MEM  
说明：EX/MEM（时钟上升沿触发）  
输入接口：clk（时钟端）,   
　　　　　EX_RegDst , EX_RegWrite , EX_Branch , EX_MemRead , EX_MemWrite（表示对应的控制信号）,  
　　　　　EX_pc_br（32位，分支指令的目标地址）, EX_zero（ALU 运算器结果是否为 0）, EX_ALU_res（32位，ALU 运算结果）, EX_rdata2（32位，rt 寄存器的数据）, EX_wreg（5位，写入的寄存器地址）    
输出接口：MEM_RegDst, MEM_RegWrite, MEM_Branch, MEM_MemRead, MEM_MemWrite,  
　　　　　MEM_pc_br, MEM_zero, MEM_ALU_res, MEM_rdata2, MEM_wreg（分别表示对应的数据位）  

#### MEM_WB.v
模块名：MEM_WB  
说明：MEM/WB（时钟上升沿触发）  
输入接口：clk（时钟端）,   
　　　　　MEM_RegDst, MEM_RegWrite（表示对应的控制信号）,  
　　　　　MEM_rdata（32位，从 dm 中读取的数据）, MEM_ALU_res（ALU 运算结果）, MEM_wreg（5位，写入的寄存器地址）  
输出接口：WB_RegDst, WB_RegWrite,  
　　　　　WB_rdata, WB_ALU_res, WB_wreg（分别表示对应的数据位）  