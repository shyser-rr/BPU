module core (
    input  logic        clk,
    input  logic        reset,
    output logic [2:0] WriteData,
    output logic        MemWrite
);


    (* mark_debug = "true" *) logic [31:0] RD1, RD2, ALUResult, PC;
    (* mark_debug = "true" *) logic [3:0] ALUControl;
    logic [31:0] Instr;
    logic [31:0] Imm;            // Extended Immediate
    logic [31:0] SrcB;           // ALU Input B (after Mux)
    logic [31:0] ReadData;       // Data from RAM
    logic [31:0] Result;         // Final data to save
    logic        Zero, PCSrc;    // Branch Logic

    // Control Signals
    logic       RegWrite, ALUSrc, Jump, Branch;
    logic [1:0] ResultSrc;
    logic [2:0] ImmSrc;


    // BRANCH LOGIC
    // PCSrc = 1 if (Branch instruction is True) OR (It's a Jump)
    assign PCSrc = (Branch & Zero) | Jump;

    // ALU MUX
    assign SrcB = ALUSrc ? Imm : RD2;

    // RESULT MUX
    // 0 = Math Result, 1 = Memory Data, 2 = PC+4 (for JAL)
    always_comb begin
        case (ResultSrc)
            2'b00: Result = ALUResult;
            2'b01: Result = ReadData;
            2'b10: Result = PC + 4; 
            default: Result = 32'bx;
        endcase
    end

    // 1. Program Counter
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .cu(PCSrc),       // The decision to Branch/Jump
        .imm(Imm),        // The Offset amount
        .count(PC)        // Output: Current Address
    );

    // 2. Instruction Memory
    ins_mem imem_inst (
        .pc(PC),
        .ins(Instr)
    );

    // 3. Control Unit (The Brain)
    control_unit cu_inst (
        .op_code(Instr[6:0]),
        .funct_3(Instr[14:12]),
        .funct_7_bit_5(Instr[30]),
        .reg_write(RegWrite),
        .imm_src(ImmSrc),
        .alu_src(ALUSrc),
        .mem_write(MemWrite),
        .result_src(ResultSrc),
        .branch(Branch),
        .jump(Jump),
        .alu_control(ALUControl)
    );

    // 4. Register File
    regfile rf_inst (
        .clk(clk),
        .we3(RegWrite),
        .a1(Instr[19:15]),
        .a2(Instr[24:20]),
        .a3(Instr[11:7]),
        .wd3(Result),
        .rd1(RD1),
        .rd2(RD2)
    );

    // 5. Extend Unit
    extend_unit ext_inst (
        .imm_src(ImmSrc),
        .instruction(Instr), // Uses the full instruction to find bits
        .imm(Imm)
    );

    // 6. ALU
    ALU alu_inst (
        .x(RD1),
        .y(SrcB),         // Muxed input
        .ctrl(ALUControl),
        .f(ALUResult),
        .zero(Zero)
    );

    // 7. Data Memory
    d_mem dmem_inst (
        .clk(clk),
        .we(MemWrite),
        .address(ALUResult),
        .wd(RD2),
        .rd(ReadData)
    );

    // Outputs for Simulation Debugging
    assign WriteData = RD2[2:0];
endmodule