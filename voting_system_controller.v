module voting_system_controller(
    input wire clk,
    input wire reset,
    input wire [7:0] voter_id_input,
    input wire [3:0] candidate_selection,
    input wire submit_vote,
    input wire authenticate_voter,
    input wire display_results_request,
    input wire system_enable,
    output reg [7:0] system_status,
    output reg [7:0] current_voter_id,
    output reg [3:0] current_candidate,
    output reg vote_accepted,
    output reg vote_rejected,
    output reg system_ready,
    output wire [15:0] total_votes_cast,
    output wire [3:0] winning_candidate_id,
    output wire [15:0] winning_candidate_votes,
    output wire results_available,
    output reg [7:0] error_code
);
    wire authenticated, already_voted, valid_voter;
    reg allow_vote;
    reg result_request_pulse;

    voter_authentication auth (
        .clk(clk),
        .reset(reset),
        .voter_id_input(voter_id_input),
        .authenticate_voter(authenticate_voter),
        .system_enable(system_enable),
        .authenticated(authenticated),
        .already_voted(already_voted),
        .valid_voter(valid_voter)
    );

    vote_counter vcount (
        .clk(clk),
        .reset(reset),
        .valid_vote(allow_vote),
        .candidate(candidate_selection),
        .result_request(display_results_request),
        .total_votes_cast(total_votes_cast),
        .winning_candidate_id(winning_candidate_id),
        .winning_candidate_votes(winning_candidate_votes),
        .results_available(results_available)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            system_status <= 0;
            current_voter_id <= 0;
            current_candidate <= 0;
            vote_accepted <= 0;
            vote_rejected <= 0;
            system_ready <= 0;
            error_code <= 0;
            allow_vote <= 0;
        end else begin
            system_ready <= system_enable;
            if (system_enable) begin
                // Authentication phase
                if (authenticate_voter) begin
                    current_voter_id <= voter_id_input;
                    if (!valid_voter) begin
                        system_status <= 0;
                        error_code <= 8'h01; // invalid
                        vote_accepted <= 0;
                        vote_rejected <= 1;
                        allow_vote <= 0;
                    end else if (already_voted) begin
                        system_status <= 0;
                        error_code <= 8'h02; // duplicate
                        vote_accepted <= 0;
                        vote_rejected <= 1;
                        allow_vote <= 0;
                    end else if (authenticated) begin
                        system_status <= 8'h01;
                        error_code <= 0;
                        vote_accepted <= 0;
                        vote_rejected <= 0;
                        allow_vote <= 0;
                    end
                end
                
                // Voting phase
                if (system_status == 8'h01 && submit_vote) begin
                    current_candidate <= candidate_selection;
                    if (candidate_selection < 4) begin
                        vote_accepted <= 1;
                        vote_rejected <= 0;
                        allow_vote <= 1;
                        error_code <= 0;
                    end else begin
                        vote_accepted <= 0;
                        vote_rejected <= 1;
                        error_code <= 8'h03; // invalid candidate
                        allow_vote <= 0;
                    end
                end else begin
                    vote_accepted <= 0;
                    vote_rejected <= 0;
                    allow_vote <= 0;
                end
            end else begin
                system_status <= 0;
                system_ready <= 0;
            end
        end
    end

endmodule
