//This code is AI Generated

module control_unit(
    input  logic [6:0] op_code,
    input  logic [2:0] funct_3,
    input  logic       funct_7_bit_5, // bit 30 of instruction
    output logic       reg_write,
    output logic [2:0] imm_src,
    output logic       alu_src,
    output logic       mem_write,
    output logic [1:0] result_src,
    output logic       branch,
    output logic       jump,
    output logic [3:0] alu_control  // The actual ALU command
);

    logic [1:0] ALUOp;
    logic [11:0] controls;

    // 1. MAIN DECODER (op_code -> Signals)
    assign {reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, ALUOp} = controls;

    always_comb begin
        case(op_code)
            //                  RegW imm_src  alu_src MemW ResSrc Brnch jump ALUOp
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

    // 2. ALU DECODER (ALUOp + Funct -> alu_control)
    always_comb begin
        case(ALUOp)
            2'b00: alu_control = 4'b0000; // LW/SW -> ADD
            2'b01: alu_control = 4'b0001; // BEQ   -> SUB
            2'b11: alu_control = 4'b1001; // LUI   -> Pass B
            2'b10: begin // R-Type or I-Type (Check funct_3)
                case(funct_3)
                    3'b000: begin
                         // If R-type (op_code[5]=1) AND Funct7[5]=1 -> SUB, else ADD
                         if (op_code[5] && funct_7_bit_5) alu_control = 4'b0001; 
                         else                         alu_control = 4'b0000;
                    end
                    3'b001: alu_control = 4'b0100; // SLL
                    3'b010: alu_control = 4'b0101; // SLT
                    3'b100: alu_control = 4'b0110; // XOR
                    3'b101: begin
                         if (funct_7_bit_5) alu_control = 4'b1000; // SRA
                         else            alu_control = 4'b0111; // SRL
                    end
                    3'b110: alu_control = 4'b0011; // OR
                    3'b111: alu_control = 4'b0010; // AND
                    default: alu_control = 4'bxxxx;
                endcase
            end
            default: alu_control = 4'bxxxx;
        endcase
    end

endmodule