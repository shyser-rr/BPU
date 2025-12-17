module d_mem (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] address,    //Comes from ALU
    input  logic [31:0] wd,
    output logic [31:0] rd
);

    logic [31:0] RAM[63:0];

    // Read 
    assign rd = RAM[address[31:2]]; 

    // Write
    always_ff @(posedge clk) begin
        if (we) 
            RAM[address[31:2]] <= wd;
    end

endmodule