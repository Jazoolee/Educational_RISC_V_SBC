module processor_only (

`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

  input  wire clock, reset, insMemEn,
  input wire [31:0] insMemDataIn, dataMemDataM2P,
  input wire pc_control, debug, //default:0 
  output reg  [8:0] insMemAddr,
  output reg  [4:0] dataMemAddr,
  output reg  dataMemWen,
  output reg  [31:0] gp, a7, dataMemDataP2M, //verifying
  output reg pc_led
);

  reg [31:0] registers  [31:0];
  
  reg [3:0] aluOp;
  reg [4:0] rs1, rs2, rd, opcode;
  reg [2:0] funct3;
  reg [6:0] funct7;
  reg [31:0] ins, imm, pc, data_1, data_2, src1, src2, LoadedData;
  reg signed [31:0] regDataIn, aluOut;
  reg isArithmetic, isImm, isLoadW, isLoadUI, isStoreW, isBranch, isJAL, isJALR, isMUL, isAUIPC, isBranchC, regWriteEn;
  
  assign pc_led = pc[0];
  
  //PC
  always @(posedge clock)
    if (reset) pc <= 0;
    else if (pc_control) pc <= (isJAL|isJALR|isBranchC) ? aluOut : (pc + 4);

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
    if (isImm|isLoadW|isJALR)  imm = 32'($signed(ins[31:20]));                                            //iImm
    else if (isLoadUI|isAUIPC) imm = {ins[31:12], 12'b0};                                                     //uImm
    else if (isStoreW)         imm = 32'($signed({ins[31:25], ins[11:7]}));                                //sImm
    else if (isBranch)         imm = 32'($signed({ins[31]   , ins[7]    , ins[30:25], ins[11:8] , 1'b0})); //sbImm
    else if (isJAL)            imm = 32'($signed({ins[31]   , ins[19:12], ins[20]   , ins[30:21], 1'b0})); //jImm
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
      SLT    : aluOut = 32'($signed  (src1) < $signed  (src2));
      SLTU   : aluOut = 32'($unsigned(src1) < $unsigned(src2));  
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

    dataMemAddr = 5'(aluOut);
    
    if (debug) {gp, a7} = {ins, pc};
    else {gp, a7} = {registers[3], registers[17]}; //For verification

    // Writeback to register bank
    regWriteEn = isArithmetic|isImm|isLoadW|isLoadUI|isJAL|isJALR|isAUIPC;

    // Word Size Decision
    case (funct3[1:0])
      2'b00 : begin 
                LoadedData = funct3[2] ? (32'(dataMemDataM2P[7:0])) : (32'($signed(dataMemDataM2P[7:0]))); //LBU, LB
                dataMemDataP2M = data_2[7:0]; // SB
      end
      2'b01 : begin
                LoadedData = funct3[2] ? (32'(dataMemDataM2P[15:0])) : (32'($signed(dataMemDataM2P[15:0]))); //LHU, LH
                dataMemDataP2M = data_2[15:0]; // SH
      end
      default:begin
                LoadedData = 32'($signed(dataMemDataM2P)); //LW 
                dataMemDataP2M = data_2; //SW
      end
    endcase

    regDataIn  = (isJALR|isJAL) ? (pc + 4) : (isLoadW ? LoadedData : aluOut); //Writeback Mux
    dataMemWen = isStoreW;
  end

  //initial $readmemh("data/registry.dat", registers);
  always @(posedge clock)
    if (regWriteEn) registers[rd] <= regDataIn;

endmodule
