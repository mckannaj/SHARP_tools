% Zephy McKanna
% getUpdateKernelValues_1A3()
% 3/9/15
% 
% This function takes as input the table created by getAllUpdateTrials_1A3().
% NOTE: it expects the TrialCount column to properly represent the order
% the trials were encountered temporally.
%
% It also takes a subject number, since this doesn't make sense to do
% across multiple subjects.
%
% It returns the probability of correct at each time point, taking the
% surrounding trials into account weighted by the surrounding trials via a
% kernel function.
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
% It also returns three more matrices of equal length, indicating places of
% potential interest on the graph of these weighted probabilities - first
% trials in a shift, first trials in a dual shift after performing single
% shifts, and first trials in a single shift after performing dual shifts.
%
function [yVals, firstTrials, singleToDualTrials, dualToSingleTrials] = getUpdateKernelValues_1A3(allUpdateTrials1A3, windowLength, subjNum)
    if (mod(windowLength,2) == 1) % number is odd
        fprintf('getUpdateKernelValues_1A3: windowLength is odd(%d). Changing it to %d.\n', windowLength,windowLength-1);
        windowLength = windowLength-1;
    end
            
    allUpdateTrials1A3(allUpdateTrials1A3.Subject ~= subjNum, :) = []; % delete all but subjNum's data

    sortrows(allUpdateTrials1A3, 'TrialCount', 'ascend');

    middle = windowLength / 2;
    multMatrix = zeros(windowLength + 1, 1);
    for k = 1:(length(multMatrix))
        multMatrix(k,1) = (1 - ((middle - k) / windowLength)^3)^3;
    end
    
    yVals = zeros(height(allUpdateTrials1A3), 1);
    firstTrials = zeros(height(allUpdateTrials1A3), 1);
    singleToDualTrials = zeros(height(allUpdateTrials1A3), 1);
    dualToSingleTrials = zeros(height(allUpdateTrials1A3), 1);
    
    % do we really have to do this in a loop? so slow!!
    for row = ((windowLength / 2) + 1):((height(allUpdateTrials1A3)) - (windowLength / 2))
%        if (row > ((windowLength / 2) + 1)) % skip the first few trials before we have enough to calculate
            windowVals = allUpdateTrials1A3.Correct((row-middle):(row+middle));
%            length(windowVals)
%            length(multMatrix)
            yVals(row) = sum(windowVals .* multMatrix);
%        end
        if (allUpdateTrials1A3.Problem(row) < allUpdateTrials1A3.Problem(row-1))
            firstTrials(row) = 1; % mark this as the first trial in the shift
            if ((strcmpi(allUpdateTrials1A3.Cluster(row-1), 'U') == 1) && (strcmpi(allUpdateTrials1A3.Cluster(row), 'U') == 0))
                singleToDualTrials(row) = 1; % mark this as a first dual shift after single shifts
            elseif ((strcmpi(allUpdateTrials1A3.Cluster(row-1), 'U') == 0) && (strcmpi(allUpdateTrials1A3.Cluster(row), 'U') == 1))
                dualToSingleTrials(row) = 1; % mark this as a first single shift after dual shifts
            end
        end
    end
end

