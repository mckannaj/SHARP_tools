% Zephy McKanna
% equalizeKernelRegressedTrials_1B
% 12/13/15
%
% This function takes the allKernelEstTable result of
% getKernelRegressedPerf_Shifts_1B() and makes all the kernel-smoothed
% logit estimates of performance the same length, by stretching them into
% the longest set of trials in the dataset (note that it uses the SUM file
% to find this number, just for the sake of speed). 
%
% It returns a table wherein the numbers of trials are all the same, so
% that they can be averaged to get at the learning curves.
% 
function [equalizedTable] = equalizeKernelRegressedTrials_1B(allKernelEstTable, RFSumTable, printTable, verbose)
    error('equalizeKernelRegressedTrials_1B() is deprecated. Please use equalizeKernelRegressedTrials2_1B() instead.');
    equalizedTable = table(0,{'XXX'},0.0,0,{'XXX'},{'XXX'},0.0,'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift','adjusted_kernelLogitEst'});
    equalizedTableRow = 1;

    numTrialsInStretched = max(RFSumTable.Attempted); % theoretically, this is the largest number of trials that there are in any shift
    
    lastSubj = 0;
    for shiftNumber = 1:height(RFSumTable)
        sumTableShift = RFSumTable(shiftNumber,:);
        if (lastSubj ~= sumTableShift.Subject) % new subject; make a note if we're verbose
            lastSubj = sumTableShift.Subject;
            if (verbose == true)
                fprintf('equalizeKernelRegressedTrials_1B working on subject %d.\n', sumTableShift.Subject);
            end
        end
        
        oldTrials = allKernelEstTable( (allKernelEstTable.Subject == sumTableShift.Subject) & ...
            (allKernelEstTable.ShiftNum == sumTableShift.ShiftNum) & ...
            (strcmpi(allKernelEstTable.Cluster, sumTableShift.Cluster) == 1) & ...
            (strcmpi(allKernelEstTable.Shift, sumTableShift.Shift) == 1),: ).kernelLogitEst;
        numTrialsThisShift = length(oldTrials);
        if (numTrialsThisShift < 1)
% this happens a lot when you do (e.g.) single-cluster trials; seems to work ok              fprintf('WARNING: cannot find subj %d shiftNum %d! Skipping.\n', sumTableShift.Subject, sumTableShift.ShiftNum);
            continue;
        end
        
        newTrials = zeros(numTrialsInStretched, 1) - 9.99;
        newEstimateNum = 1; % the row of numTrialsThisShift we're on
        numAfterDecimal = (numTrialsInStretched / (numTrialsThisShift-1)) - floor((numTrialsInStretched / (numTrialsThisShift-1)));
        numOfExtraToInsert = fix((numAfterDecimal * (numTrialsThisShift-1)) - 1); % "fix" just rounds to the number nearest 0
        for oldTrialIndex = 1:(numTrialsThisShift-1)
            trialsToEstimate = floor(numTrialsInStretched / (numTrialsThisShift-1));
            if (numOfExtraToInsert > 0)
                trialsToEstimate = trialsToEstimate + 1; % add one extra trial per iteration until we run out of extras
                numOfExtraToInsert = numOfExtraToInsert - 1;
            end

% just for testing            fprintf('trialsToEstimate = %d; estimating trial %d to %d from realTrial %d and %d.\n', trialsToEstimate, newEstimateNum, newEstimateNum+trialsToEstimate-1, oldTrialIndex, oldTrialIndex+1);
            slope = (oldTrials(oldTrialIndex+1) - oldTrials(oldTrialIndex)) / trialsToEstimate; % grab the slope for this section of trials
% just for testing            fprintf('estimating oldTrial: %f, oldTrial+1: %f, slope: %f.\n', oldTrials(oldTrialIndex), oldTrials(oldTrialIndex+1), slope);
            newTrials(newEstimateNum:(newEstimateNum+trialsToEstimate),1) = ...
                zeros(trialsToEstimate+1,1) + ((transpose(0:(trialsToEstimate)) * slope) + oldTrials(oldTrialIndex));
            newEstimateNum = newEstimateNum + trialsToEstimate; % jump over the trials we already estimated
        end

        % should now have the new stretched logit estimates; put them in the table 
        subjToFill = sumTableShift.Subject;
        conditionToFill = sumTableShift.Condition;
        dateToFill = sumTableShift.Date;
        shiftNumToFill = sumTableShift.ShiftNum;
        clusterToFill = sumTableShift.Cluster;
        shiftToFill = sumTableShift.Shift;
        newHeight = length(newTrials);
        
        thisShiftTrials = table(repmat(subjToFill,newHeight,1), repmat(conditionToFill,newHeight,1), ...
            repmat(dateToFill,newHeight,1), repmat(shiftNumToFill,newHeight,1), repmat(clusterToFill,newHeight,1), ...
            repmat(shiftToFill,newHeight,1), newTrials, 'VariableNames', ...
            {'Subject','Condition','Date','ShiftNum','Cluster','Shift','adjusted_kernelLogitEst'});
                
        equalizedTable(equalizedTableRow:(equalizedTableRow + length(newTrials) - 1),:) = thisShiftTrials;
        equalizedTableRow = equalizedTableRow + length(newTrials);
    end

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('equalizeKernelRegressedTrials_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(equalizedTable, fileName);
    end
    
end
