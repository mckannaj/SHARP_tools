% James/Zephy McKanna
% Data Incubator Challenge Q1 script 2: actually calculate it
% Due: 5/1/17
%
% Brief description:
% N coins with values 1 through N are put into a bag and drawn out at random
% You are paid the difference between each coin and the next
%
function [pricesAndCounts, updatedInitSeqs] = dataIncubatorQ1build(initSeqLength, prevInitSeqs, prevPricesAndCounts, totalN, verbose)
    % [~, initSeqLength] = size(prevInitSeqs);
    initSeq = randperm(initSeqLength);
    if (~isempty(prevInitSeqs))
        while (ismember(initSeq, prevInitSeqs, 'rows')) % we already tried this one
            initSeq = randperm(initSeqLength); % grab another
        end
    end
    updatedInitSeqs = [prevInitSeqs; initSeq]; % store this as already used, for future runs

    % now, let's run the rest of this N with this initial sequence
    priceOfInitSeq = initSeq(1); % first grab the value of the initial seq
    for initPriceDraw = 2:length(initSeq)
        priceOfInitSeq = priceOfInitSeq + ...
            (abs(initSeq(initPriceDraw) - initSeq(initPriceDraw-1)));
    end
    
    N = totalN - length(initSeq);
    
    coinDraws = perms(1:N); % this quickly gets large; consider when refactoring
%    priceList = zeros(length(coinDraws), 1); 
    for seq = 1:length(coinDraws)
        if (mod(seq,length(coinDraws)/10) == 0)
            if (verbose == true)
                fprintf('Staying alive feedback; seq = %d.\n', seq);
            end
        end
        price = priceOfInitSeq + ...
            (abs(coinDraws(seq, 1) - initSeq(length(initSeq)))); % first coin in this seq
%        priceList(seq,1) = priceOfInitSeq + ...
%            (abs(coinDraws(seq, 1) - initSeq(length(initSeq)))); % first coin in this seq
        for nextDraw = 2:N
            price = price + ...
                (abs(coinDraws(seq, nextDraw) - coinDraws(seq, (nextDraw-1))));
%            priceList(seq,1) = priceList(seq,1) + ...
%                (abs(coinDraws(seq, nextDraw) - coinDraws(seq, (nextDraw-1))));
        end
        
%        prevPricesAndCounts(find(prevPricesAndCounts(:,1) == price), 2) = ...
%            prevPricesAndCounts(find(prevPricesAndCounts(:,1) == price), 2) + 1;

% taking advantage of the fact that we know it has to be from N to (N(N+1))/2
        prevPricesAndCounts(price - totalN + 1, 2) = ...
            prevPricesAndCounts(price - totalN + 1, 2) + 1;
    end
    
    pricesAndCounts = prevPricesAndCounts;

%    if (verbose == true)
%        fprintf('Mean payment = %f, SD = %f\n', mean(priceList(:,1)),std(priceList(:,1)));
%    end
end

