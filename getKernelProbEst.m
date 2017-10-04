% Zephy McKanna
% getKernelProbEst()
% 1/24/16
% 
% This function takes a column of 1s and 0s, which are assumed to be
% indicative of "correct" and "incorrect" on a particular task, and uses
% those to estimate probability of 1 (correct) at any given time.
% 
% It takes a moving window (length determined by input) and uses that to
% calculate the probability at each point, by weighting the points close to
% that point higher and the ones further out lower.
% 
% It also assumes a hypothetical extra point for any window that is
% entirely 1s or 0s, so that the probability is never exactly 1 or 0 (so
% that the Logit can be calculated).
% 
% It returns a column the same length as the input column of 1s and 0s, in
% which each point is the Kernel-smoothed probability.
% 
% Probability function (sum from -L/2 to L/2 + 1):
% P(t) = 
%       k = (L/2 + 1) 
%               Sigma [X(t-k) * w(k)]
%       (k = -L/2)
%   where...
%       L = length of the window (default 10)
%       Sigma = sum from (-L/2) to (L/2 + 1)
%       X(t) = the correctness of the response at trial t (0 or 1)
%
% To keep P(t) between 0 and 1, we divide by the maximum possible value of Sigma [X(t-k) * w(k)]
%       (given the Kernel function with a particular window length) after calculating Sigma.
%
% Kernel function:
% w(k) = (1 - (k / L)^3)^3
%   where...
%       k = particular place(trial) in the window
%       L = length of the window
%       w = weight
%
% Example:
% calculate the 8th point, with a window of 10, where the first 15 are 0 1 1 1 0 0 1 1 0 1 1 1 0 1 0
% window = (#3 to #14) 1 1 0 0 1 1 0 1 1 1 0 1
% 
function [logitProbCorrect, probCorrect] = getKernelProbEst(onesAndZerosCol, windowLength, verbose)
    if (mod(windowLength,2) == 1) % number is odd
        if (verbose == true)
            fprintf('getKernelProbEst: windowLength is odd(%d). Changing it to %d.\n', windowLength,windowLength-1);
        end
        windowLength = windowLength-1;
    end
        
    middle = windowLength / 2;
    multMatrix = zeros(windowLength + 1, 1);
    for k = 1:(length(multMatrix))
        multMatrix(k,1) = (1 - ((middle - k) / windowLength)^3)^3;
    end
    
    maxKernelVal = sum(multMatrix(:,1));
    
    probCorrect = zeros(length(onesAndZerosCol), 1);
    logitProbCorrect = zeros(length(onesAndZerosCol), 1);
    
    % do we really have to do this in a loop? so slow!!
    for row = 1:(length(onesAndZerosCol))
        tmpBegRow = 0; % assume we're not near the beginning of a shift
        if (row < ((windowLength / 2) + 1)) % at the beginning of the whole loop
            tmpBegRow = 1; % note that the moving window should start here
        end
        tmpEndRow = 0; % assume we're not near the end of a shift
        if (row > ((length(onesAndZerosCol)) - (windowLength / 2))) % at the end of the whole loop
            tmpEndRow = length(onesAndZerosCol); % note that the moving window should end here
        end
        
        if (tmpBegRow == 0) % we're not near the beginning of a shift
            tmpBegRow = row - middle; % default window size
        end
        if (tmpEndRow == 0) % we're not near the end of a shift
            tmpEndRow = row + middle; % default window size
        end
        
        windowVals = onesAndZerosCol(tmpBegRow:tmpEndRow);
        
% Z: I don't think this is right. Looks like at the very start you'd be going from row 6 or 7...? ????        
%   Z: that's what we want. The multiplication matrix is biggest in the
%   middle (6, for a window length of 10). So if you're calculating it for
%   point #1, you want to multiply by multMatrix points 6-11.
% Z: But note: if the window length is larger than the whole onesAndZerosCol, this doesn't seem to work well! 
%   Z: ok. Assuming that is the rare case for now.
        begWindowSpot = (middle - (row - tmpBegRow)) + 1;
        endWindowSpot = (middle + (tmpEndRow - row)) + 1;
        if (verbose == true)
            fprintf('row = %d, tmpBegRow = %d, tmpEndRow = %d, begWindowSpot = %d, endWindowSpot = %d.\n', row, tmpBegRow, tmpEndRow, begWindowSpot, endWindowSpot);
        end
            
        tempMaxKernelVal = sum(multMatrix(begWindowSpot:endWindowSpot,1));
        probCorrect(row) = (sum( windowVals .* multMatrix(begWindowSpot:endWindowSpot) )) / tempMaxKernelVal;
            
        if (probCorrect(row) == 0) % special case: all 0s. Treat the prob as slightly higher than 0 so that the logit can deal with it
            tempWindowMatrix = zeros(length(multMatrix(:,1)),1);
            tempWindowMatrix(end,1) = 1; % assume we have all 0s except the last one
            probCorrect(row) = (sum( tempWindowMatrix .* multMatrix(1:end) )) / maxKernelVal;
        elseif (probCorrect(row) == 1) % special case: all 1s. Treat the prob as slightly lower than 1 so that the logit can deal with it
            tempWindowMatrix = ones(length(multMatrix(:,1)),1);
            tempWindowMatrix(1,1) = 0; % assume we have all 1s except the first one
            probCorrect(row) = (sum( tempWindowMatrix .* multMatrix(1:end) )) / maxKernelVal;
        end
            
        logitProbCorrect(row) = log(probCorrect(row) / (1 - probCorrect(row)));
        
        if (isinf(logitProbCorrect(row)))
            error('row = %d, probCorr = %d\n', row, probCorrect(row));
        end
    end
end

