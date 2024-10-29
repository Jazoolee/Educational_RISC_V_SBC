module dmem (

`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input wire clock,
    input wire [4:0] dataMemAddr,
    input wire [31:0] dataMemDataP2M,
    input wire dataMemWen,
    output reg [31:0] dataMemDataM2P
    
);

    reg [31:0] dataMemory [31:0];
    
    //Data memory
    always @(posedge clock) 
        if (dataMemWen) dataMemory[dataMemAddr] <= dataMemDataP2M;
        
    assign dataMemDataM2P = dataMemory[dataMemAddr];

endmodule
