module voter_authentication(
    input wire clk,
    input wire reset,
    input wire [7:0] voter_id_input,
    input wire authenticate_voter,
    input wire system_enable,
    output reg authenticated,
    output reg already_voted,
    output reg valid_voter
);

    reg [7:0] registered_voters [0:15];
    reg voted [0:15];
    integer i;

    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            registered_voters[i] = 8'h10 + i; // Voter IDs from 0x10 to 0x1F
            voted[i] = 0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            authenticated <= 0;
            already_voted <= 0;
            valid_voter <= 0;
            for (i = 0; i < 16; i = i + 1)
                voted[i] <= 0;
        end else if (system_enable && authenticate_voter) begin
            valid_voter <= 0;
            already_voted <= 0;
            authenticated <= 0;
            for (i = 0; i < 16; i = i + 1) begin
                if (voter_id_input == registered_voters[i]) begin
                    valid_voter <= 1;
                    if (voted[i]) begin
                        already_voted <= 1;
                        authenticated <= 0;
                    end else begin
                        authenticated <= 1;
                        already_voted <= 0;
                        voted[i] <= 1;
                    end
                end
            end
        end
    end
endmodule
