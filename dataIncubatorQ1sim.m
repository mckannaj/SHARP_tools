% James/Zephy McKanna
% Data Incubator Challenge Q1 script 1: simulate it from random draws
% Due: 5/1/17
%
% Brief description:
% N coins with values 1 through N are put into a bag and drawn out at random
% You are paid the difference between each coin and the next
%
function [totalPrices, probGreaterThan] = dataIncubatorQ1sim(N, repetitions, greaterThanVal)
    totalPrices = zeros(repetitions, 1); 
    greaterThanCount = 0;
    for rep = 1:repetitions
        if (mod(rep,repetitions/10) == 0)
            fprintf('Staying alive feedback; rep = %d.\n', rep);
        end
        coins = 1:N;
        lastVal = 0;
        for draw = 1:N
            drawThisOne = randi([1 length(coins)], 1, 1);
            drawThisVal = coins(drawThisOne);
            totalPrices(rep, 1) = totalPrices(rep, 1) + (abs(drawThisVal - lastVal));
            lastVal = drawThisVal;
            coins(ismember(coins, drawThisVal)) = []; % remove that coin
        end
        if (totalPrices(rep, 1) >= greaterThanVal)
            greaterThanCount = greaterThanCount + 1;
        end
            
    end
    probGreaterThan = greaterThanCount / repetitions;

    fprintf('Mean payment = %f, SD = %f; probGreaterThan = %f\n', mean(totalPrices(:,1)),std(totalPrices(:,1)), probGreaterThan);

end

% another way to look at it: each order matters, sort of
% For N = 10, there are P(10,10) = 10!/1 = 10! = 3628800 orders
% ... but presumably, many of these would give the same actual price
% e.g.:
% 10 9 8 7 6 5 4 3 2 1 = 10+1+1+1+1+1+1+1+1+1 = 19
% 9 10 8 7 6 5 4 3 2 1 = 9+1+2+1+1+1+1+1+1+1 = 19
% 8 9 10 7 6 5 4 3 2 1 = 8+1+1+3+1+1+1+1+1+1 = 19

% 4 3 2 1 5 6 7 8 9 10 = 4+1+1+1+4+1+1+1+1+1 = 16
% 5 4 3 2 1 6 7 8 9 10 = 5+1+1+1+1+5+1+1+1+1 = 18
% 6 5 4 3 2 1 7 8 9 10 = 6+1+1+1+1+1+6+1+1+1 = 20





