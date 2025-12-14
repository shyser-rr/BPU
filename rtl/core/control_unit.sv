//This code is AI Generated

module ControlUnit(
    input  logic [6:0] Opcode,
    input  logic [2:0] Funct3,
    input  logic       Funct7Bit5, // bit 30 of instruction
    output logic       RegWrite,
    output logic [2:0] ImmSrc,
    output logic       ALUSrc,
    output logic       MemWrite,
    output logic [1:0] ResultSrc,
    output logic       Branch,
    output logic       Jump,
    output logic [3:0] ALUControl  // The actual ALU command
);

    logic [1:0] ALUOp;
    logic [11:0] controls;

    // 1. MAIN DECODER (Opcode -> Signals)
    assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, Jump, ALUOp} = controls;

    always_comb begin
        case(Opcode)
            //                  RegW ImmSrc  ALUSrc MemW ResSrc Brnch Jump ALUOp
            7'b0110011: controls = 12'b1_xxx_0_0_00_0_0_10; // R-Type
            7'b0010011: controls = 12'b1_000_1_0_00_0_0_10; // I-Type (ALU)
            7'b0000011: controls = 12'b1_000_1_0_01_0_0_00; // lw
            7'b0100011: controls = 12'b0_001_1_1_xx_0_0_00; // sw
            7'b1100011: controls = 12'b0_010_0_0_xx_1_0_01; // beq
            7'b1101111: controls = 12'b1_011_x_0_10_0_1_xx; // jal
            7'b0110111: controls = 12'b1_100_1_0_00_0_0_11; // lui (U-type)
            default:    controls = 12'b0_xxx_x_0_xx_0_0_xx; 
        endcase
    end

    // 2. ALU DECODER (ALUOp + Funct -> ALUControl)
    always_comb begin
        case(ALUOp)
            2'b00: ALUControl = 4'b0000; // LW/SW -> ADD
            2'b01: ALUControl = 4'b0001; // BEQ   -> SUB
            2'b11: ALUControl = 4'b1001; // LUI   -> Pass B
            2'b10: begin // R-Type or I-Type (Check Funct3)
                case(Funct3)
                    3'b000: begin
                         // If R-type (Opcode[5]=1) AND Funct7[5]=1 -> SUB, else ADD
                         if (Opcode[5] && Funct7Bit5) ALUControl = 4'b0001; 
                         else                         ALUControl = 4'b0000;
                    end
                    3'b001: ALUControl = 4'b0100; // SLL
                    3'b010: ALUControl = 4'b0101; // SLT
                    3'b100: ALUControl = 4'b0110; // XOR
                    3'b101: begin
                         if (Funct7Bit5) ALUControl = 4'b1000; // SRA
                         else            ALUControl = 4'b0111; // SRL
                    end
                    3'b110: ALUControl = 4'b0011; // OR
                    3'b111: ALUControl = 4'b0010; // AND
                    default: ALUControl = 4'bxxxx;
                endcase
            end
            default: ALUControl = 4'bxxxx;
        endcase
    end

endmodule