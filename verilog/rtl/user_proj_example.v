// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    BITS = 32 , WIDTH = 32, IMEM_DEPTH = 512, DMEM_DEPTH = 32, NUM_REGS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,

    // Logic Analyzer Signals
    input  [64:0] la_data_in,
    output [110:0] la_data_out,
    //input  [127:0] la_oenb,

    // IOs
    //input  [BITS-1:0] io_in,
    //output [BITS-1:0] io_out,
    //output [BITS-1:0] io_oeb,

    // IRQ
    //output [2:0] irq
);

  processor_only #(
    .WIDTH(WIDTH), .IMEM_DEPTH(IMEM_DEPTH), .DMEM_DEPTH(DMEM_DEPTH), .NUM_REGS(NUM_REGS)
  ) processor_only (
    .clock(wb_clk_i),
    .reset(wb_rst_i),
    .insMemEn(la_data_in[0]),
    .insMemDataIn(la_data_in[32:1]),
    .dataMemDataIn(la_data_in[64:33]),
    .insMemAddr(la_data_out[8:0]),
    .dataMemAddr(la_data_out[13:9]),
    .dataMemWen(la_data_out[14]),
    .dataMemDataOut(la_data_out[46:15]),
    .gp(la_data_out[78:47]),
    .a7(la_data_out[110:79])
  );

endmodule

module processor_only #(
  WIDTH = 32, IMEM_DEPTH=512, DMEM_DEPTH=32, NUM_REGS=32, W_DMEM_ADDR=$clog2(DMEM_DEPTH)
)(
  input  wire clock, reset, insMemEn,
  input  wire [WIDTH-1:0] insMemDataIn, dataMemDataIn,
  output reg  [$clog2(IMEM_DEPTH)-1:0] insMemAddr, 
  output reg  [W_DMEM_ADDR-1:0] dataMemAddr,
  output reg  dataMemWen,
  output reg  [WIDTH-1:0] gp, a7, dataMemDataOut //verifying
);

  reg [WIDTH-1:0] registers  [NUM_REGS  -1:0];
  reg [3:0] aluOp;
  reg [4:0] rs1, rs2, rd, opcode;
  reg [2:0] funct3;
  reg [6:0] funct7;
  reg [WIDTH-1:0] ins, imm, pc, data_1, data_2, src1, src2, LoadedData;
  reg signed [WIDTH-1:0] regDataIn, aluOut;
  reg isArithmetic, isImm, isLoadW, isLoadUI, isStoreW, isBranch, isJAL, isJALR, isMUL, isAUIPC, isBranchC, regWriteEn;
  
  //PC
  always @(posedge clock)
    if (!reset) pc <= 0;
    else       pc <= (isJAL|isJALR|isBranchC) ? aluOut : (pc + 4);

  always @* begin

    insMemAddr = pc[10:2];
    ins = insMemEn ? 32'h13 : insMemDataIn;

    //Instruction decoder
    {funct7, rs2, rs1, funct3, rd, opcode} = ins[31:2];
    
    isArithmetic = (opcode == 5'b01100) & (funct7[0] == 1'b0);
    isMUL        = (opcode == 5'b01100) & (funct7[0] == 1'b1); //For MUL and DIV
    isImm        = (opcode == 5'b00100);
    isLoadW      = (opcode == 5'b00000);
    isLoadUI     = (opcode == 5'b01101);
    isStoreW     = (opcode == 5'b01000);
    isBranch     = (opcode == 5'b11000);
    isJAL        = (opcode == 5'b11011);
    isJALR       = (opcode == 5'b11001);
    isAUIPC      = (opcode == 5'b00101);

    // Immediate generation
    if (isImm|isLoadW|isJALR)  imm = WIDTH'($signed(ins[31:20]));                                            //iImm
    else if (isLoadUI|isAUIPC) imm = {ins[31:12], 12'b0};                                                     //uImm
    else if (isStoreW)         imm = WIDTH'($signed({ins[31:25], ins[11:7]}));                                //sImm
    else if (isBranch)         imm = WIDTH'($signed({ins[31]   , ins[7]    , ins[30:25], ins[11:8] , 1'b0})); //sbImm
    else if (isJAL)            imm = WIDTH'($signed({ins[31]   , ins[19:12], ins[20]   , ins[30:21], 1'b0})); //jImm
    else                       imm = 0;

    //Read Registers     
    data_1 = (rs1 == 0) ? 0 : registers[rs1];
    data_2 = (rs2 == 0) ? 0 : registers[rs2];

    //Branch decision
    case (funct3[2:1])
      2'b00  : isBranchC = isBranch & (funct3[0] ^ (data_1 == data_2));                  //BNE, BEQ 
      2'b10  : isBranchC = isBranch & (funct3[0] ^ ($signed(data_1) < $signed(data_2))); //BLT, BGE
      2'b11  : isBranchC = isBranch & (funct3[0] ^ (data_1 < data_2));                   //BLTU, BGEU
      default: isBranchC = 1'b0;
    endcase
  end  

  //ALU
  localparam [3:0] ADD=0, SLL=1, SLT=2, SLTU=3, XOR=4, SRL=5, OR=6, AND=7, SUB=8, MUL=9, DIV=10, SRA=13, PASS=15;

  always @* begin
    if      (isMUL)                                          aluOp = (funct3[2] ? DIV : MUL);
    else if (isArithmetic)                                   aluOp = {funct7[5]                   , funct3};
    else if (isImm)                                          aluOp = {funct7[5] & (funct3==3'b101), funct3};
    else if (isAUIPC|isJAL|isJALR|isBranch|isLoadW|isStoreW) aluOp = ADD ;   //Can put with load and store
    else                                                     aluOp = PASS;

    src1 = (isJAL|isBranch|isAUIPC)                                        ? pc  : data_1;
    src2 = (isImm|isLoadW|isLoadUI|isJAL|isJALR|isStoreW|isBranch|isAUIPC) ? imm : data_2;

    case (aluOp)
      ADD    : aluOut = src1 + src2;
      SUB    : aluOut = src1 - src2;                                      
      SLL    : aluOut = src1 << src2[4:0];                                
      SLT    : aluOut = WIDTH'($signed  (src1) < $signed  (src2));
      SLTU   : aluOut = WIDTH'($unsigned(src1) < $unsigned(src2));  
      XOR    : aluOut = src1 ^ src2;                    
      SRL    : aluOut = src1 >> src2[4:0];
      SRA    : aluOut = $signed(src1) >>> src2[4:0];
      OR     : aluOut = src1 | src2;
      AND    : aluOut = src1 & src2;
      MUL    : aluOut = src1 * src2;
      DIV    : aluOut = src1 / src2;
      PASS   : aluOut = src2;                                             
      default: aluOut = 0;
    endcase 

    dataMemAddr = W_DMEM_ADDR'(aluOut);
    {gp, a7} = {registers[3], registers[17]}; //For verification

    // Writeback to register bank
    regWriteEn = isArithmetic|isImm|isLoadW|isLoadUI|isJAL|isJALR|isAUIPC;

    // Word Size Decision
    case (funct3[1:0])
      2'b00 : begin 
                LoadedData = funct3[2] ? (WIDTH'(dataMemDataIn[7:0])) : (WIDTH'($signed(dataMemDataIn[7:0]))); //LBU, LB
                dataMemDataOut = data_2[7:0]; // SB
      end
      2'b01 : begin
                LoadedData = funct3[2] ? (WIDTH'(dataMemDataIn[15:0])) : (WIDTH'($signed(dataMemDataIn[15:0]))); //LHU, LH
                dataMemDataOut = data_2[15:0]; // SH
      end
      default:begin
                LoadedData = WIDTH'($signed(dataMemDataIn)); //LW 
                dataMemDataOut = data_2; //SW
      end
    endcase

    regDataIn  = (isJALR|isJAL) ? (pc + 4) : (isLoadW ? LoadedData : aluOut); //Writeback Mux
    dataMemWen = isStoreW;
  end

  //initial $readmemh("data/registry.dat", registers);
  always @(posedge clock)
    if (regWriteEn) registers[rd] <= regDataIn;

endmodule
`default_nettype wire
