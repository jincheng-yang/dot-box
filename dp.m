% Dynamic Programming

num_of_lines = int32(1 : 16777215);
mod_2 = zeros(24, 16777215, 'logical');

for j = 1 : 24
    mod_2(j, :) = mod(num_of_lines, int32(2));
    num_of_lines = idivide(num_of_lines, int32(2));
end

num_of_lines = sum(mod_2);                  % how many lines have been drawn
current_total = zeros(1, 16777215, 'int8'); % how many boxes have been sealed 
                                            % in the current setting
first_player = zeros(1, 16777215, 'int8');  % at most how many boxes can the
                                            % current player gain
second_player = zeros(1, 16777215, 'int8'); % how many boxes will the next
                                            % player win
strategy = zeros(1, 16777215, 'int8');
                                            
%% Step one: Find how many boxes have been sealed in each setting.
    
boxes = ['ADMN'; 'BENO'; 'CFOP'; 'DGQR'; 'EHRS'; 'FIST'; 'GJUV'; 'HKVW'; 'ILWX'];
for i = 1 : 9
    borders = boxes(i, :) - 'A' + 1;
    edges = sum(mod_2(borders, :));
    current_total = current_total + int8(edges == 4);
end

%% Step two: Decide how many boxes can be won in each setting.
% Starting from 24 edges drawn, and count backwards

for i = int8(23 : -1 : 1)
    disp(i)
    for j = 1 : 16777214
        if (num_of_lines(j) == i)
            for k = 1 : 24    % test a new line
                winning_number = 0;
                if not(mod_2(k, j))
                    test_edge = j + 2 ^ (k - 1);
                    additional_total = current_total(test_edge) ...
                                     - current_total(j); % new boxes sealed
                    if additional_total > 0
                        % if complete a new box, then the total winning
                        % will be the number of boxes won this stage plus
                        % the maximum won next stage
                        winning_number = first_player(test_edge) + additional_total;
                    else
                        % otherwise, win the number of boxes the second
                        % player would win in the next stage
                        winning_number = second_player(test_edge);
                    end
                end
                % update the maximum number of possible wins
                if winning_number > first_player(j)
                    first_player(j) = winning_number;
                    strategy(j) = 'A' + k - 1;
                end
            end
            % the test is finished, update the second player
            second_player(j) = 9 - current_total(j) - first_player(j);
        end
    end
end