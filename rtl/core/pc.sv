module pc (
    input logic clk, reset, cu,
    input logic [31:0] imm,
    output logic [31:0] count
);
    // Apparantly it's better to keep the assignment of output in one always block
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            count <= 32'b0;
        else begin
            if (cu)
                count <= count + imm;
            else
                count <= count + 4; //4 because memory is byte addressed so each instruction has 4 bytes
        end
    end

endmodule