% Zephy McKanna
% addPPswitchCols()
% 9/1/15
%
% This function takes a table of Pre/Post switch data, and adds a column
% (deleteThis) indicating which trials should be deleted before calculating
% Switch Cost. These include:
% 1. First trial of any block.
% 2. Practice trials (Block = Training_1 or Training_2).
% 3. Errors or timeouts.
% 4. Any trial immediately following an error or timeout.
% 5. Correct trials that are <> 3 SDs from the mean of the subject's
%       reaction times.
%
% It also adds a new response time column, newRT, which is the reaction
% time in seconds (subtracting StimTime from RespTime and then dividing by 
% 10,000 to get seconds).
%
function [newSwitchTable] = addPPswitchCols(oldSwitchTable, verbose)
    newSwitchTable = oldSwitchTable;
    
    newSwitchTable.deleteThis = zeros(height(newSwitchTable), 1); % create a new variable to mark which trials need to be deleted
    newSwitchTable.error = zeros(height(newSwitchTable), 1); % create a new variable to mark errors, since mixing "timeout" and 0/1 is hard for matlab
    newSwitchTable.afterError = zeros(height(newSwitchTable), 1); % create a new variable to mark the trials immediately after errors
%    newSwitchTable.errorProneSubj = zeros(height(SwitchData), 1); % create a new variable to mark which subjects get more than 50% errors
        
    newSwitchTable.newRT = ((newSwitchTable.RespTime - newSwitchTable.StimTime) / 10000); % get the response time (resp - stim) and put it in seconds (/ 10,000)

    newSwitchTable{strcmpi(newSwitchTable.Block,'Training_1'),'deleteThis'} = 1; % mark all training trials for deletion
    newSwitchTable{strcmpi(newSwitchTable.Block,'Training_2'),'deleteThis'} = 1; % mark all training trials for deletion
         
    allSubjects = unique(newSwitchTable.Subject);
    for subjIndex = 1:length(allSubjects) % loop through each subj
        subj = allSubjects(subjIndex); % get the subject number
        subjTrials = newSwitchTable(newSwitchTable.Subject == subj, :);
        
        subjTrials.deleteThis(1) = 1; % the first trial is by definition the first trial of a block; mark it for deletion
        for trial = 1:height(subjTrials)
            if ((trial > 1) && (strcmpi(subjTrials.Block(trial-1), subjTrials.Block(trial)) == 0)) % this is the first trial of a block
                subjTrials.deleteThis(trial) = 1; % mark it for deletion
            end
            if ((strcmpi(subjTrials.Score{trial},'timeout') == 1) || (subjTrials.Score{trial} == 0)) % this is an error (in pretest, all timeouts are errors)
                subjTrials.error(trial) = 1; % note that it's an error
                subjTrials.deleteThis(trial) = 1; % mark it for deletion
                if (trial < (height(subjTrials))) % we're not at the very last one yet
                    subjTrials.deleteThis(trial+1) = 1; % mark the next one for deletion (note that if it spans two blocks, then this is the first trial of the next block and should be deleted anyway)
                    subjTrials.afterError(trial+1) = 1; % mark the next one as immediately after an error
                end
            end
        end
                
        lower3SDbound = mean(subjTrials.newRT) - (3 * std(subjTrials.newRT));
        upper3SDbound = mean(subjTrials.newRT) + (3 * std(subjTrials.newRT));
        outlierTrials = height(subjTrials(((subjTrials.newRT < lower3SDbound) | (subjTrials.newRT > upper3SDbound)), :));
        if (outlierTrials > 0)
            if (verbose == true)
                fprintf('Subj %d has %d outliers; marking them for deletion.\n', subj, outlierTrials);
            end
            tmpOnesOutside3SDs = array2table(ones(outlierTrials, 1));
            subjTrials(((subjTrials.newRT < lower3SDbound) | (subjTrials.newRT > upper3SDbound)), 'deleteThis') = tmpOnesOutside3SDs; % mark all trials outside of 3 SDs around the mean for deletion
        end
        
        newSwitchTable(newSwitchTable.Subject == subj, :) = subjTrials;
    end
end

