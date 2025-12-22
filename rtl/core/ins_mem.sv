module ins_mem (
    input logic [31:0]pc,
    output logic [31:0] ins
);

    logic [31:0] RAM [0:63]; //64 word ROM

    // adding data to the rom
    initial begin
        $readmemh("program.mem", RAM,0,63); //icarus was throuwing error telling to add start and end. Just added it so it works. Don't know what it does.
    end

    // The pc counts in bytes but we want words tf divide by 4
        assign ins = RAM[pc[31:2]];
    

endmodule