module vote_counter(
    input wire clk,
    input wire reset,
    input wire valid_vote,
    input wire [3:0] candidate,
    input wire result_request,
    output reg [15:0] total_votes_cast,
    output reg [3:0] winning_candidate_id,
    output reg [15:0] winning_candidate_votes,
    output reg results_available
);
    reg [15:0] votes [0:3];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            total_votes_cast <= 0;
            for (i = 0; i < 4; i = i + 1)
                votes[i] <= 0;
            winning_candidate_id <= 0;
            winning_candidate_votes <= 0;
            results_available <= 0;
        end else begin
            if (valid_vote && candidate < 4) begin
                votes[candidate] <= votes[candidate] + 1;
                total_votes_cast <= total_votes_cast + 1;
            end
            if (result_request) begin
                winning_candidate_id <= 0;
                winning_candidate_votes <= votes[0];
                for (i = 1; i < 4; i = i + 1) begin
                    if (votes[i] > winning_candidate_votes) begin
                        winning_candidate_votes <= votes[i];
                        winning_candidate_id <= i[3:0];
                    end
                end
                results_available <= 1;
            end else begin
                results_available <= 0;
            end
        end
    end
endmodule
