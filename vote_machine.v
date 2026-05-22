`timescale 1ns / 1ps

module voting_machine(
    input clk,
    input rst,

    input voter1,
    input voter2,
    input voter3,
    input voter4,

    input cast_vote,

    output reg [3:0] candidate1_votes,
    output reg [3:0] candidate2_votes,
    output reg [3:0] candidate3_votes,
    output reg [3:0] candidate4_votes,

    output reg invalid_vote
);

always @(posedge clk or negedge rst)
begin

    if(!rst)
    begin
        candidate1_votes <= 0;
        candidate2_votes <= 0;
        candidate3_votes <= 0;
        candidate4_votes <= 0;
        invalid_vote <= 0;
    end

    else
    begin

        invalid_vote <= 0;

        if(cast_vote)
        begin

            case({voter4,voter3,voter2,voter1})

                4'b0001:
                begin
                    candidate1_votes <= candidate1_votes + 1;
                end

                4'b0010:
                begin
                    candidate2_votes <= candidate2_votes + 1;
                end

                4'b0100:
                begin
                    candidate3_votes <= candidate3_votes + 1;
                end

                4'b1000:
                begin
                    candidate4_votes <= candidate4_votes + 1;
                end

                default:
                begin
                    invalid_vote <= 1;
                end

            endcase

        end

    end

end

endmodule
