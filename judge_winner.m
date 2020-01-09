function [winner, strategy] = judge_winner(test_string)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    boxes = ["ADMN", "BENO", "CFOP", "DGQR", "EHRS", "FIST", "GJUV", "HKVW", "ILWX"];

    playerBox = [0, 0];
    current_box = zeros(1, 9);

    % Test if one player has already won the game
    player = 1;
    for i = test_string
        new_box = 0;
        for j = 1 : 9
            if contains(boxes(j), i)
                current_box(j) = current_box(j) + 1;
                if current_box(j) == 4
                    new_box = new_box + 1;
                end
            end
        end
        if new_box > 0
            playerBox(player) = playerBox(player) + new_box;
            if playerBox(player) > 4
                winner = player;
                return
            end
        else
            player = 3 - player;
        end
    end
    
    % Otherwise, enumerate current player's option
    for test_step = 'A' : 'X'
        if contains(test_string, test_step)
            continue
        else
            result = judge_winner([test_string, test_step]);
        end
        if result == player
            winner = player;
            strategy = test_step;
            return
        end
    end
    
    winner = 3 - player;
end

