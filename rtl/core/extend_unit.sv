module extend_unit (
    input logic [2:0] imm_src,
    input logic [31:0] instruction,
    output logic [31:0] imm
);
    
    always_comb begin
        case (imm_src)
        //R type instruction has no imm

        // I type has signed extend
        3'd0: imm = {{20{instruction[31]}},instruction[31:20]};
        // S Type signed extend
        3'd1: imm = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
        // B Type signed extend
        3'd2: imm = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};
        // U type
        3'd4: imm = {instruction[31:12],12'b0};
        // J type
        3'd3: imm = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0};

        default: imm = 32'bx;
        endcase
    end

endmodule