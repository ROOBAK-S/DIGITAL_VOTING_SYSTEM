module digital_voting_system_top (
    input wire master_clk,
    input wire reset,
    input wire [7:0] voter_id_input,
    input wire [3:0] candidate_selection,
    input wire submit_vote,
    input wire authenticate_voter,
    input wire display_results_request,
    input wire system_enable,
    output wire [7:0] system_status,
    output wire [7:0] current_voter_id,
    output wire [3:0] current_candidate,
    output wire vote_accepted,
    output wire vote_rejected,
    output wire system_ready,
    output wire [15:0] total_votes_cast,
    output wire [3:0] winning_candidate_id,
    output wire [15:0] winning_candidate_votes,
    output wire results_available,
    output wire [7:0] error_code,
    output wire system_clk_out,
    output wire display_clk_out,
    output wire security_clk_out
);
    // Internal clocks
    wire system_clk, display_clk, security_clk;

    clock_generator clk_gen (
        .master_clk(master_clk),
        .reset(reset),
        .system_clk(system_clk),
        .display_clk(display_clk),
        .security_clk(security_clk)
    );

    voting_system_controller voting_sys (
        .clk(system_clk),
        .reset(reset),
        .voter_id_input(voter_id_input),
        .candidate_selection(candidate_selection),
        .submit_vote(submit_vote),
        .authenticate_voter(authenticate_voter),
        .display_results_request(display_results_request),
        .system_enable(system_enable),
        .system_status(system_status),
        .current_voter_id(current_voter_id),
        .current_candidate(current_candidate),
        .vote_accepted(vote_accepted),
        .vote_rejected(vote_rejected),
        .system_ready(system_ready),
        .total_votes_cast(total_votes_cast),
        .winning_candidate_id(winning_candidate_id),
        .winning_candidate_votes(winning_candidate_votes),
        .results_available(results_available),
        .error_code(error_code)
    );

    assign system_clk_out = system_clk;
    assign display_clk_out = display_clk;
    assign security_clk_out = security_clk;

endmodule
