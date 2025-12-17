module ins_mem (
    input logic [31:0]pc,
    output logic [31:0] ins
);

    logic [31:0] RAM [63:0]; //64 word ROM

    // adding data to the rom
    initial begin
        $readmemh("program.mem", RAM);
    end

    // The pc counts in bytes but we want words tf divide by 4
        assign ins = RAM[pc[31:2]];
    

endmodule