% Zephy McKanna
% addRFswitchCols()
% 9/7/15
%
% This function takes a table of RobotFactory switch data, and adds a column
% (deleteThis) indicating which trials should be deleted before calculating
% Switch Cost. These include:
% 1. First trial of any shift.
% 2. Errors or timeouts. (zNOTE: timeouts are questionable for RF, but for
%       now we're removing them!)
% 3. Any trial immediately following an error (though not a non-error timeout!).
% 4. Correct trials that are <> 3 SDs from the mean of the subject's
%       reaction times.
%
% Note that this is only intended for single-duration (1s, 2s, or 3s)
% trials. Otherwise marking <> 3 SDs from the mean reaction time doesn't
% make sense.
%
function [newSwitchTable] = addRFswitchCols(oldSwitchTable, verbose)
    clusters = unique(oldSwitchTable.Cluster);
    if ( ismember('U',clusters) || ismember('I',clusters) || ...
            ismember('U/I',clusters) || ismember('I/Logic',clusters) || ...
            ismember('U/Logic',clusters) || ismember('U/I/Logic',clusters) || ...
            ismember('U/Logic(xOR)',clusters) )
        clusters
        error('addRFswitchCols: This function only works with Switch data. Shifts are listed above this line; please remove all non-switch shifts before calling this.');
    end        
    if ( ~ismember('SwitchFlag',oldSwitchTable.Properties.VariableNames) )
        error('addRFswitchCols: This function requires added columns onto the data. Use putNewColsIntoDataTable_1B() on the data first.');
    end
    if (length(unique(oldSwitchTable.StimTime)) > 1)
        error('addRFswitchCols: This function is only intended to work with single stimulus times (e.g., only 1s trials); otherwise, removing <> 3 SDs makes no sense.');
    end
    
    newSwitchTable = oldSwitchTable;
    
    newSwitchTable.deleteThis = zeros(height(newSwitchTable), 1); % create a new variable to mark which trials need to be deleted
         
    allSubjects = unique(newSwitchTable.Subject);
    for subjIndex = 1:length(allSubjects) % loop through each subj
        subj = allSubjects(subjIndex); % get the subject number
        subjTrials = newSwitchTable(newSwitchTable.Subject == subj, :);
        
        subjTrials.deleteThis(1) = 1; % the first trial is by definition the first trial of a block; mark it for deletion
        for trial = 1:height(subjTrials)
            if ((trial > 1) && (strcmpi(subjTrials.Shift(trial-1), subjTrials.Shift(trial)) == 0)) % this is the first trial of a block
                subjTrials.deleteThis(trial) = 1; % mark it for deletion
            end
            if (subjTrials.Correct == 0) % this trial was an error
                subjTrials.deleteThis(trial) = 1;
            end
            if (subjTrials.AfterErrorFlag(trial) == 1) % this trial was after an error
                subjTrials.deleteThis(trial) = 1;
            end                
            if (strcmpi(subjTrials.GivenResp(trial), 'NO_ACTION')) % this trial was a timeout
                subjTrials.deleteThis(trial) = 1;
            end                
        end
        
        lower3SDbound = mean(subjTrials.RespTime) - (3 * std(subjTrials.RespTime));
        upper3SDbound = mean(subjTrials.RespTime) + (3 * std(subjTrials.RespTime));
        outlierTrials = height(subjTrials(((subjTrials.RespTime < lower3SDbound) | (subjTrials.RespTime > upper3SDbound)), :));
        if (outlierTrials > 0)
            if (verbose == true)
                fprintf('Subj %d has %d outliers; marking them for deletion.\n', subj, outlierTrials);
            end
            tmpOnesOutside3SDs = array2table(ones(outlierTrials, 1));
            subjTrials(((subjTrials.RespTime < lower3SDbound) | (subjTrials.RespTime > upper3SDbound)), 'deleteThis') = tmpOnesOutside3SDs; % mark all trials outside of 3 SDs around the mean for deletion
        end
        
        newSwitchTable(newSwitchTable.Subject == subj, :) = subjTrials;
    end
end

