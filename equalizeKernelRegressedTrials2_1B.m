% Zephy McKanna
% equalizeKernelRegressedTrials2_1B
% 12/13/15
%
% This function takes is identical to equalizeKernelRegressedTrials_1B(),
% except that it uses interp1() to get a spline interpoliation rather than
% attempting to calculate a linear one point-by-point.
%
% It is also significantly faster than equalizeKernelRegressedTrials_1B();
% ZEPHY: RENAME THESE FILES SO THAT YOU NEVER USE THE SLOW BAD ONE AGAIN. 
%
function [equalizedTable] = equalizeKernelRegressedTrials2_1B(allKernelEstTable, RFSumTable, printTable, verbose)
    equalizedTable = table(0,{'XXX'},0.0,0,{'XXX'},{'XXX'},0.0,'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift','adjusted_kernelLogitEst'});
    equalizedTableRow = 1;

    newSamplePoints = 0:(median(RFSumTable.Attempted)); % the number of points in all the new, interpolated shifts
    
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
            (allKernelEstTable.ShiftNum == sumTableShift.ShiftNum),: ).kernelLogitEst;
        numTrialsThisShift = length(oldTrials);
        if (numTrialsThisShift < 1)
% this happens a lot when you do (e.g.) single-cluster trials; seems to work ok without warning             fprintf('WARNING: cannot find subj %d shiftNum %d! Skipping.\n', sumTableShift.Subject, sumTableShift.ShiftNum);
            continue;
        end
        
        oldSamplePoints = transpose(0:(numTrialsThisShift-1)) * ((median(RFSumTable.Attempted))/(numTrialsThisShift-1));
        newTrials = interp1(oldSamplePoints, oldTrials, newSamplePoints, 'spline');
        
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
            repmat(shiftToFill,newHeight,1), transpose(newTrials), 'VariableNames', ...
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
