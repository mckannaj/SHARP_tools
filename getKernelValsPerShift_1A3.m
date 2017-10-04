% Zephy McKanna
% getKernelValsPerShift_1A3()
% 3/31/15
% 
% This function takes as input the table created by
% getAllUpdateTrials_1A3() or getAllSwitchTrials_1A3(). It uses the
% "EFtype" flag to indicate whether this is 'Update' or 'Switch' data.
% NOTE: it expects the TrialCount column to properly represent the order
% the trials were encountered temporally.
%
% It also takes a subject number, since this doesn't make sense to do
% across multiple subjects.
%
% If shiftPlacement = [], then it will loop through the trials and
% determine the shift boundaries itself (takes longer). Otherwise, it
% assumes that shiftPlacement is the height of allTrials1A3, and contains
% all 0s except for 1s at shift boundaries (by preference, the first trial
% of each shift).
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
% It also returns three more matrices of equal length, indicating places of
% potential interest on the graph of these weighted probabilities - first
% trials in a shift, first trials in a dual shift after performing single
% shifts, and first trials in a single shift after performing dual shifts.
%
function [logitProbCorrect, probCorrect, firstTrials, singleToDualTrials, dualToSingleTrials, cluster] = getKernelValsPerShift_1A3(allTrials1A3, shiftPlacement, EFtype, windowLength, subjNum, verbose)
    fprintf('zNote to self: you can use getKernelProbEst() instead of getKernelValsPerShift_1A3() to get kernel prob estimates now.\n');
    if (mod(windowLength,2) == 1) % number is odd
        if (verbose == true)
            fprintf('getAllKernelValues_1A3: windowLength is odd(%d). Changing it to %d.\n', windowLength,windowLength-1);
        end
        windowLength = windowLength-1;
    end

    if (isempty(subjNum) == 0) % we have a subject number
        allTrials1A3(allTrials1A3.Subject ~= subjNum, :) = []; % delete all but subjNum's data
    end
    
    if (strcmpi(EFtype, 'AllTrials'))
        if (verbose == true)
            fprintf('getKernelValsPerShift_1A3: EFtype set to AllTrials. Assuming rows are in trial order. Ignoring dualToSingle and singleToDual.\n');
        end
    else
        allTrials1A3 = sortrows(allTrials1A3, 'TrialCount', 'ascend'); % if we're not just using all trials, they might not be in order; sort them
    end
    
    cluster = allTrials1A3.Cluster;

    if (isempty(shiftPlacement)) % have to figure out shiftPlacement on our own
        shiftPlacement = zeros(height(allTrials1A3),1); % assume most trials are not "first trial of the shift"
        shiftPlacement(1,1) = 1; % obviously the first trial is a first-trial-of-the-shift, though
        for row = 2:(height(allTrials1A3)) % go through all trials other than the first one
            if (allTrials1A3.ShiftNum(row) > allTrials1A3.ShiftNum(row-1))
                shiftPlacement(row,1) = 1; % mark this as the first trial in the shift
% just for testing                if (strcmpi(cluster(row), cluster(row-1)) == 1) % going from a cluster to the same cluster???
% just for testing                    fprintf('Going from %s to itself; subj=%d, shift1=%d, shift2=%d.\n', cluster{row}, allTrials1A3.Subject(row), allTrials1A3.ShiftNum(row-1), allTrials1A3.ShiftNum(row));
% just for testing                end
            elseif (allTrials1A3.Subject(row) ~= allTrials1A3.Subject(row-1)) % started a new subject
                shiftPlacement(row,1) = 99; % mark this as the first trial for this subject
            end
        end
    end    
    if (length(shiftPlacement) ~= height(allTrials1A3)) % make sure shiftPlacement is the right size at least
        error('shiftPlacement length (%d) must be equal to allTrials height (%d).\n', length(shiftPlacement), height(allTrials1A3));
    end
    firstTrials = shiftPlacement; % we know this now; we can just return it
    
    middle = windowLength / 2;
    multMatrix = zeros(windowLength + 1, 1);
    for k = 1:(length(multMatrix))
        multMatrix(k,1) = (1 - ((middle - k) / windowLength)^3)^3;
    end
    
    maxKernelVal = sum(multMatrix(:,1));
    
    probCorrect = zeros(height(allTrials1A3), 1);
    logitProbCorrect = zeros(height(allTrials1A3), 1);
    singleToDualTrials = zeros(height(allTrials1A3), 1);
    dualToSingleTrials = zeros(height(allTrials1A3), 1);
    
    % do we really have to do this in a loop? so slow!!
    for row = 1:(height(allTrials1A3))
        tmpBegRow = 0; % assume we're not near the beginning of a shift
        if (row < ((windowLength / 2) + 1)) % at the beginning of the whole loop
            tmpBegRow = 1; % note that the moving window should start here
        elseif (sum(shiftPlacement((row - middle):row, 1)) > 0) % we're close to the start of a shift
            for check = row:-1:(row - middle) % iterate backwards to be sure to get the one closest to [row]
                if (shiftPlacement(check) > 0)
                    tmpBegRow = check; % note that the moving window should start here
                    break;
                end
            end
        end
        tmpEndRow = 0; % assume we're not near the end of a shift
        if (row > ((height(allTrials1A3)) - (windowLength / 2))) % at the end of the whole loop
            tmpEndRow = height(allTrials1A3); % note that the moving window should end here
        elseif (sum(shiftPlacement((row+1):(row + middle), 1)) > 0) % we're close to the end of a shift
            for check = (row+1):(row + middle) % start with [row+1] so that a given row can't be both tmpBeg and tmpEnd
                if (shiftPlacement(check) > 0)
                    tmpEndRow = check - 1; % note that the moving window should end here (just before the start of the next shift)
                    break;
                end
            end
        end
        
        if (tmpBegRow == 0) % we're not near the beginning of a shift
            tmpBegRow = row - middle; % default window size
        end
        if (tmpEndRow == 0) % we're not near the end of a shift
            tmpEndRow = row + middle; % default window size
        end
        
        windowVals = allTrials1A3.Correct(tmpBegRow:tmpEndRow);
%        tempWindowLength = tmpEndRow - tmpBegRow + 1;

            begWindowSpot = (middle - (row - tmpBegRow)) + 1;
            endWindowSpot = (middle + (tmpEndRow - row)) + 1;
%            fprintf('row = %d, tmpBegRow = %d, tmpEndRow = %d, begWindowSpot = %d, endWindowSpot = %d.\n', row, tmpBegRow, tmpEndRow, begWindowSpot, endWindowSpot);
            
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

            
%{        
        if (row < ((windowLength / 2) + 1)) % edge condition that will break the other if statements (but equal to (row - middle):row > 0)
            fprintf('got to beginning of the whole thing.\n');
            tempMaxKernelVal = sum(multMatrix((length(multMatrix) - (tempWindowLength - 1)):end,1));
            yVals(row) = (sum( windowVals .* multMatrix((length(multMatrix) - (tempWindowLength - 1)):end) )) / tempMaxKernelVal;
        elseif (row > ((height(allTrials1A3)) - (windowLength / 2)))  % edge condition that will break the other if statements (but equal to row:(row + middle) > 0)
            fprintf('got to end  of the whole thing.\n');
            tempMaxKernelVal = sum(multMatrix(1:tempWindowLength,1));
            yVals(row) = (sum( windowVals .* multMatrix(1:tempWindowLength) )) / tempMaxKernelVal;
%        elseif (sum(shiftPlacement((row - middle):(row + middle), 1)) > 1) % we have a shift with fewer than [window] trials
        elseif (tempWindowLength < middle) % we have a shift with fewer than [window] trials
            fprintf('got to a strange, short shift.\n');
            
            begWindowSpot = (middle - (row - tmpBegRow)) + 1;
            endWindowSpot = (middle + (tmpEndRow - row)) + 1;
            fprintf('row = %d, tmpBegRow = %d, tmpEndRow = %d, begWindowSpot = %d, endWindowSpot = %d.\n', row, tmpBegRow, tmpEndRow, begWindowSpot, endWindowSpot);
%            length(windowVals)
%            length(multMatrix(begWindowSpot:endWindowSpot))
            
            tempMaxKernelVal = sum(multMatrix(begWindowSpot:endWindowSpot,1));
            yVals(row) = (sum( windowVals .* multMatrix(begWindowSpot:endWindowSpot) )) / tempMaxKernelVal;
            
        elseif (sum(shiftPlacement((row - middle):row, 1)) > 0) % we're close to the start of a shift
            fprintf('got to the beginning of a shift; row = %d, tmpBegRow = %d.\n', row, tmpBegRow);
            tempMaxKernelVal = sum(multMatrix((length(multMatrix) - (tempWindowLength - 1)):end,1));
            yVals(row) = (sum( windowVals .* multMatrix((length(multMatrix) - (tempWindowLength - 1)):end) )) / tempMaxKernelVal;
        elseif (sum(shiftPlacement((row+1):(row + middle), 1)) > 0) % we're close to the end of a shift
            fprintf('got to the end of a shift; row = %d, tmpEndRow = %d.\n', row, tmpEndRow);
            tempMaxKernelVal = sum(multMatrix(1:tempWindowLength,1));
            yVals(row) = (sum( windowVals .* multMatrix(1:tempWindowLength) )) / tempMaxKernelVal;
            
        else % we're somewhere blissfully in the middle of a shift with enough trials
            windowVals = allTrials1A3.Correct((row-middle):(row+middle));
            yVals(row) = (sum(windowVals .* multMatrix)) / maxKernelVal;
        end
        
%}        
        if (row > 1)
            % now figure out if we're going from singles to duals or vice versa
            if (allTrials1A3.ShiftNum(row) > allTrials1A3.ShiftNum(row-1))
                if (strcmpi(EFtype, 'Update'))
                    if ((strcmpi(allTrials1A3.Cluster(row-1), 'U') == 1) && (strcmpi(allTrials1A3.Cluster(row), 'U') == 0))
                        singleToDualTrials(row) = 1; % mark this as a first dual shift after single shifts
                        if (verbose == true)
                            fprintf('getAllKernelValues_1A3: singleToDualTrials %d: %s to %s.\n', allTrials1A3.Subject(row), allTrials1A3.Cluster{row-1},allTrials1A3.Cluster{row});                   
                        end
                    elseif ((strcmpi(allTrials1A3.Cluster(row-1), 'U') == 0) && (strcmpi(allTrials1A3.Cluster(row), 'U') == 1))
                        dualToSingleTrials(row) = 1; % mark this as a first single shift after dual shifts
                        if (verbose == true)
                            fprintf('getAllKernelValues_1A3: dualToSingleTrials %d: %s to %s.\n', allTrials1A3.Subject(row), allTrials1A3.Cluster{row-1},allTrials1A3.Cluster{row});                   
                        end
                    end
                elseif (strcmpi(EFtype, 'Switch'))
                    if ((strcmpi(allTrials1A3.Cluster(row-1), 'S') == 1) && (strcmpi(allTrials1A3.Cluster(row), 'S') == 0))
                        singleToDualTrials(row) = 1; % mark this as a first dual shift after single shifts
                        if (verbose == true)
                            fprintf('getAllKernelValues_1A3: singleToDualTrials %d: %s to %s.\n', allTrials1A3.Subject(row), allTrials1A3.Cluster{row-1},allTrials1A3.Cluster{row});                   
                        end
                    elseif ((strcmpi(allTrials1A3.Cluster(row-1), 'S') == 0) && (strcmpi(allTrials1A3.Cluster(row), 'S') == 1))
                        dualToSingleTrials(row) = 1; % mark this as a first single shift after dual shifts
                        if (verbose == true)
                            fprintf('getAllKernelValues_1A3: dualToSingleTrials %d: %s to %s.\n', allTrials1A3.Subject(row), allTrials1A3.Cluster{row-1},allTrials1A3.Cluster{row});                   
                        end
                    end
                elseif (strcmpi(EFtype, 'AllTrials')) % we're doing all trials, so ignore the dual/single stuff
                else
                    error('EFtype is %s; expecting either Update or Switch (or AllTrials).\n', EFtype);
                end
            elseif (allTrials1A3.ShiftNum(row) < allTrials1A3.ShiftNum(row-1))
                if (allTrials1A3.Subject(row) ~= allTrials1A3.Subject(row-1)) % started a new subject
                    if (verbose == true)
                        fprintf('getAllKernelValues_1A3: moving from subjNum %d to subjNum %d.\n', allTrials1A3.Subject(row-1), allTrials1A3.Subject(row));                   
                    end
                else
                    if (verbose == true)
                        fprintf('getAllKernelValues_1A3: subjNum %d: row %d has shiftNum %d; row %d has shiftNum %d.\n', allTrials1A3.Subject(row), (row-1), allTrials1A3.ShiftNum(row-1), row, allTrials1A3.ShiftNum(row));                   
                    end
                end
            end
        end
    end
    
end

