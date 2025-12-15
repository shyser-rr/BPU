`timescale 1ns / 1ps

module tb_extend_unit;

    // Signals
    logic [2:0]  imm_src;
    logic [31:0] instruction;
    logic [31:0] imm;

    // Instantiate your module
    extend_unit dut (
        .imm_src(imm_src),
        .instruction(instruction),
        .imm(imm)
    );

    initial begin
        $display("---------------------------------------");
        $display("TOP 1% VERIFICATION: EXTEND UNIT");
        $display("---------------------------------------");

        // -------------------------------------------------------
        // TEST 1: I-Type (Negative)
        // Instruction: addi x0, x0, -1
        // Imm: -1 (0xFFFFFFFF) -> 12 bits of 1s at [31:20]
        // -------------------------------------------------------
        imm_src = 3'd0;
        instruction = 32'hFFF00000; // Top 12 bits are 1
        #5; // Wait for logic
        if (imm === 32'hFFFFFFFF) $display("[PASS] I-Type (-1 Extended correctly)");
        else $display("[FAIL] I-Type. Exp: FFFFFFFF, Got: %h", imm);


        // -------------------------------------------------------
        // TEST 2: S-Type (Split check)
        // We want Imm = 5 (binary 00...00101)
        // imm[4:0] comes from instr[11:7] -> Set to 5 (00101)
        // imm[11:5] comes from instr[31:25] -> Set to 0
        // -------------------------------------------------------
        imm_src = 3'd1;
        // instr[11:7] = 00101 (5), rest 0
        instruction = 32'b0000000_00000_00000_000_00101_0000000; 
        #5;
        if (imm === 32'd5) $display("[PASS] S-Type (Split bits reassembled)");
        else $display("[FAIL] S-Type. Exp: 5, Got: %d", imm);


        // -------------------------------------------------------
        // TEST 3: B-Type (The Scramble)
        // We want Imm = -2 (0xFFFFFFFE)
        // B-Type logic forces bit 0 to 0. 
        // Sign bit (bit 31) needs to be 1.
        // -------------------------------------------------------
        imm_src = 3'd2;
        instruction = 32'h80000000; // Bit 31 is 1 (Sign), rest 0
        // Expect: Sign extension works, but LSB is 0. 
        // With only MSB set, B-type decodes to -4096 (bit 12 set).
        // Let's test specific bit 12 placement.
        #5;
        // B-Type scrambles instr[31] to imm[12].
        // If instr[31]=1, imm should be sign extended F...F800 (-4096)
        // wait... instr[31] is sign bit (imm[12]). 
        // So imm should be 1111...1111_1000_0000_0000 (0xFFFFF000)
        if (imm === 32'hFFFFF000) $display("[PASS] B-Type (Sign bit & Scramble)");
        else $display("[FAIL] B-Type. Exp: FFFFF000, Got: %h", imm);


        // -------------------------------------------------------
        // TEST 4: U-Type (LUI)
        // Load upper immediate. Bottom 12 bits MUST be 0.
        // Instr: FFFFF...
        // -------------------------------------------------------
        imm_src = 3'd4;
        instruction = 32'hFFFFFFFF;
        #5;
        // Should grab top 20 bits (FFFFF) and pad bottom with 000
        if (imm === 32'hFFFFF000) $display("[PASS] U-Type (Zero padding correct)");
        else $display("[FAIL] U-Type. Exp: FFFFF000, Got: %h", imm);

        $display("---------------------------------------");
        $finish;
    end

endmodule