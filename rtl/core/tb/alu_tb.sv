// the tb is AI generated

`timescale 1ns / 1ps

module alu_tb;

    // 1. Signals matching YOUR ALU ports
    logic [31:0] x, y;
    logic [3:0]  ctrl; // 4-bit control
    logic [31:0] f;
    logic        zero;

    // 2. Define the codes manually (Since TB can't see the ALU's enum)
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLL  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SRS  = 4'b0111;
    localparam ALU_SLT  = 4'b1000;
    localparam ALU_USLT = 4'b1001;

    // 3. Instantiate YOUR ALU
    // Notice we connect .x(x) because that is what YOU named them.
    ALU dut(
        .x(x),
        .y(y),
        .ctrl(ctrl),
        .f(f),
        .zero(zero)
    );

    // 4. Verification
    initial begin
        $display("----------------------------------------------");
        $display("STARTING SIMULATION (Custom ALU)");
        $display("----------------------------------------------");

        // TEST 1: ADD (10 + 20)
        x = 32'd10; y = 32'd20; ctrl = ALU_ADD;
        #10;
        if (f !== 32'd30) $error("FAIL: ADD 10+20. Got %d", f);
        else $display("PASS: ADD");

        // TEST 2: SUB (20 - 5)
        x = 32'd20; y = 32'd5; ctrl = ALU_SUB;
        #10;
        if (f !== 32'd15) $error("FAIL: SUB 20-5. Got %d", f);
        else $display("PASS: SUB");

        // TEST 3: SHIFT LEFT (1 << 4 = 16)
        x = 32'd1; y = 32'd4; ctrl = ALU_SLL;
        #10;
        if (f !== 32'd16) $error("FAIL: SLL 1<<4. Got %d", f);
        else $display("PASS: SLL");

        // TEST 4: SLT Signed (-10 < 10 -> True/1)
        x = -32'd10; y = 32'd10; ctrl = ALU_SLT;
        #10;
        if (f !== 32'd1) $error("FAIL: SLT Signed. Got %d", f);
        else $display("PASS: SLT Signed");

        // TEST 5: SLT Unsigned (0xFFFFFFFF > 10)
        // -1 (signed) is MAX_INT (unsigned). So -1 < 10 is FALSE in unsigned.
        x = -32'd1; y = 32'd10; ctrl = ALU_USLT;
        #10;
        if (f !== 32'd0) $error("FAIL: USLT. Expected 0, Got %d", f);
        else $display("PASS: USLT (Unsigned Check)");

        $display("----------------------------------------------");
        $finish;
    end

endmodule