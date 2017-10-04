% James/Zephy McKanna
% Data Incubator Challenge Q1 script 2: actually calculate it
% Due: 5/1/17
%
% Brief description:
% N coins with values 1 through N are put into a bag and drawn out at random
% You are paid the difference between each coin and the next
%
% This takes about 10sec to run with N=10.
function [priceList, permsWithParticularPrice] = dataIncubatorQ1actual(N, countPermsWithThisPrice)
    permsWithParticularPrice = zeros(1, N);
    nextParticularPerm = 1;
    coinDraws = perms(1:N); % NOTE THIS QUICKLY GETS HUGE! N=20 will definitely give an error, but we can do N=10 this way
    priceList = zeros(length(coinDraws), 1); 
    for seq = 1:length(coinDraws)
        if (mod(seq,length(coinDraws)/10) == 0)
            fprintf('Staying alive feedback; seq = %d.\n', seq);
        end
        priceList(seq,1) = coinDraws(seq, 1); % grab the first coin; abs(0-value) = value
        for nextDraw = 2:N
            priceList(seq,1) = priceList(seq,1) + ...
                (abs(coinDraws(seq, nextDraw) - coinDraws(seq, (nextDraw-1))));
        end
        if (priceList(seq,1) == countPermsWithThisPrice)
            permsWithParticularPrice(nextParticularPerm, :) = coinDraws(seq,:);
            nextParticularPerm = nextParticularPerm + 1;
        end
    end

    fprintf('Mean payment = %f, SD = %f\n', mean(priceList(:,1)),std(priceList(:,1)));
    fprintf('Total permutations with given price = %d.\n', nextParticularPerm - 1);
end


%{
 N      Mean                        SD
1       1                           0
2       2.5                         .707107
3       4.666667                    1.032796
4       7.5                         1.532262
5       11                          2.153754
6       15.16666667                 2.866525
7       20                          3.651846
8       25.5                        4.500056
9       31.66666667                 5.405766
10      38.500000000000000          6.365271230040156
11      46                          7.375636
12      too big to deal with this way
%}

%{
Simulator answers (10000 reps)
10      38.580500          6.297879
10      38.611700          6.399923
10      38.452600          6.408265
%}

%{
Simulator answers (100000 reps)
10      38.541590          6.347703
10      38.515820          6.365818
10      38.494220          6.379641
%}



% another way to look at it: each order matters, sort of
% For N = 10, there are P(10,10) = 10!/1 = 10! = 3628800 orders
% ... but presumably, many of these would give the same actual price
% e.g.:
% 10 9 8 7 6 5 4 3 2 1 = 10+1+1+1+1+1+1+1+1+1 = 19
% 9 10 8 7 6 5 4 3 2 1 = 9+1+2+1+1+1+1+1+1+1 = 19
% 8 9 10 7 6 5 4 3 2 1 = 8+1+1+3+1+1+1+1+1+1 = 19


%{ 
Let's think about N = 5, since we know the mean is 11...
Total permutations: 120
Minimum: N
1 2 3 4 5 = N = 5
Maximum: (n(n+1)) / 2
5 1 4 2 3 = 5 + 4 + 3 + 2 + 1 = (n(n+1)) / 2 = 15

Min+1 (N+1) permutations: 1
1 2 3 5 4

Min+2 (N+2) permutations: 5
     2     1     3     4     5
     1     3     2     4     5
     1     2     4     3     5
     1     2     4     5     3
     1     2     5     4     3

%}
%{
Counts
N = 3
Price = 3 4 5 6
Count = 1 1 3 1

N = 4
Price = 4 5 6 7 8 9 10
Count = 1 1 4 6 5 5 2

N = 5
Price = 5 6 7 8 9  10 11 12 13 14 15
Count = 1 1 5 7 19 13 25 15 18 12 4

N = 6
Price = 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
Count = 1 1 6 8 26 38 56 68 85 97 82 88 72 48 32 12 

N = 7
Price = 7 8 9 10 11 12 13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28
Count = 1 1 7 9  34 48 128 124 271 243 445 363 566 424 604 432 436 312 280 168 108 36 

%}





