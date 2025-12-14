//prefix is used cause it was giving error on using just "and"
typedef enum logic [3:0] {
    ALU_ADD,        // 0000
    ALU_SUB,        // 0001
    ALU_AND,        // 0010
    ALU_OR,         // 011
    ALU_XOR,        // 100
    ALU_SLL,        // 0101 Shift LEft
    ALU_SRL,        // 0110 Shift Right
    ALU_SRS,        // 111 Shift Right SIgned
    ALU_SLT,        // 1000 Signed Less Than
    ALU_USLT        // 1001 Unsigned Less than
} alu_ctrl_codes;

module ALU (
    input logic [31:0] x,y,
    input logic [3:0] ctrl,
    output logic [31:0] f,
    output logic zero
);

    always_comb begin
        case (ctrl)
            ALU_ADD:    f = x + y;
            ALU_SUB:    f = x - y;
            ALU_AND:    f = x & y;
            ALU_OR:     f = x | y;
            ALU_XOR:    f = x ^ y;
            ALU_SLL:    f = x << y;
            ALU_SRL:    f = x >> y;
            ALU_SRS:    f = x >>> y;
            ALU_SLT:    f = $signed(x) < $signed(y);
            ALU_USLT:   f = x < y;
            default: f = x;
        endcase
    end

    always_comb begin
        if (f == 0)
            zero = 1;
        else
            zero = 0;
    end

endmodule