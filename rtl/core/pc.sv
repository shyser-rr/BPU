//No idea if this is correct

module pc (
    input logic clk, reset, cu,
    input logic [31:0] imm,
    output logic [31:0] count
);
    //updating the counter
    always_ff @(posedge clk) begin
        if (~cu)
            count <= count + 1;
        else
            count <= count + imm;
    end

    //Asynchronous reset
    always_comb begin
        if (reset)
            count = 0;
    end

endmodule