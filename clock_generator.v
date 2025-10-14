module clock_generator(
    input  wire master_clk,
    input  wire reset,
    output wire system_clk,
    output wire display_clk,
    output wire security_clk
);

    assign system_clk   = master_clk;  // For simulation, no division needed
    assign display_clk  = master_clk;
    assign security_clk = master_clk;

endmodule
