module regfile(
    input logic clk, we3,
    input logic [4:0] a1,a2,a3,
    input logic [31:0] wd3,
    output logic [31:0] rd1,rd2
);

    initial begin
        for (int i = 0; i < 32 ; i++)
            nigga[i] = 32'b0;
    end

    // created a 32*32 memory
    logic [31:0] nigga [31:0];

    //asynchronous read
    always_comb begin
        rd1 = nigga[a1];
        rd2 = nigga[a2];
    end

    //synchronous write
    always_ff @(posedge clk) begin
        if (we3 == 1 & a3 != 0)
            nigga[a3] <= wd3;
    end

    
endmodule