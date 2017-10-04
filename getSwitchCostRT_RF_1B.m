% Zephy McKanna
% getSwitchCostRT_RF_1B
% 6/6/15
%
% This function takes a table made from RobotFactory data. Note: if you
% wish to exclude certain subjects, pass RFData through some exclusion function 
% (e.g. excludeSubjects_RF_1B) before giving it to this function.
%
% Note: The input RobotFactory data must contain a SwitchFlag in which 1 =
% switch and 2 = repetition. For example, data coming from
% putNewColsIntoDataTable_1B().
%
% If the "preprocessed" flag is true, then it assumes the data have already
% been cleaned (for efficiency, e.g. for formalizedFishing()). Note that
% with this flag set, it expects RFdata to have new cols "errors" and "deleteThis".
% Otherwise (preprocessed = false), it cleans the data as follows: 
%   1. Delete all non-switch trials. You can specify whether you want
%   "single" (default), "dual", or "all" with the singleDual flag.
%   2. Marks all trials (except those at the start of a block) as "Switch"
%      or "Repetition".
%           zNOTE: DON'T NEED TO DO THIS; ALREADY DONE IN 1B! 
%   4. Notes any subject with > 50% errors (recommended for exclusion)
%   5. Deletes first trial of each Shift
%   6. Deletes each trial immediately following a trial with an error 
%   7. Deletes all error trials, and all "timeout" trials whether they are errors or not.
%   9. Not doing this yet: Delete all correct trials that have reaction times <> 3 SDs from the mean (of any given
%      subject's Correct Reaction Times)
%
% It then calculates the mean ResponseTime for Switch trials and Repetition
% trials for each of Pretest and Posttest (if the latter data exist) for
% each subect. It returns a table with these values as well as the switch
% cost (difference between mean RT for Repetition and Switch trials).
%
function [SC_table] = getSwitchCostRT_RF_1B(RFData, singleDual, printTable, verbose, preprocessed)
    % preallocate the SCmat array for speed (for formalizedFishing)
    RFsubjectCount = length(unique(RFData.Subject));
    SCmat = [zeros(RFsubjectCount,1) zeros(RFsubjectCount,1) zeros(RFsubjectCount,1) zeros(RFsubjectCount,1) zeros(RFsubjectCount,1) zeros(RFsubjectCount,1)];

    if (preprocessed == false)
        if (strcmpi(singleDual, 'dual'))
            SwitchData = RFData(strcmpi(RFData.Cluster, 'S/I'), :);
            SwitchData = [SwitchData; RFData(strcmpi(RFData.Cluster, 'U/S'), :)];
        elseif (strcmpi(singleDual, 'all'))
            SwitchData = RFData(strcmpi(RFData.Cluster, 'S'), :);
            SwitchData = [SwitchData; RFData(strcmpi(RFData.Cluster, 'S/I'), :)];
            SwitchData = [SwitchData; RFData(strcmpi(RFData.Cluster, 'U/S'), :)];
        else % assume that we're just doing S-alone ('single')
            SwitchData = RFData(strcmpi(RFData.Cluster, 'S'), :);
        end

        SwitchData.deleteThis = zeros(height(SwitchData), 1); % create a new variable to mark which trials need to be deleted
        SwitchData.errors = zeros(height(SwitchData), 1); % create a new variable to mark errors, since mixing "timeout" and 0/1 is hard for matlab
%        SwitchData.errPct = zeros(height(SwitchData), 1); % create a new variable to mark the total error percentage for this subject, since we'll be deleting the errors before we note them down

        allSubjects = unique(RFData.Subject);
        for subjIndex = 1:length(allSubjects) % do we really have to do this whole loop twice?
%            subjMadeTooManyErrors = false; % assume we don't have an error prone subject
            subj = allSubjects(subjIndex); % get the subject number
            subjTrials = SwitchData(SwitchData.Subject == subj, :);

            subjTrials.deleteThis(1) = 1; % the first trial is by definition the first trial of a shift; mark it for deletion
            for trial = 1:height(subjTrials)
                if ( (trial > 1) && (subjTrials.ShiftNum(trial-1) ~= subjTrials.ShiftNum(trial)) ) % this is the first trial of a shift
                    subjTrials.deleteThis(trial) = 1; % mark it for deletion
                end
                if (strcmpi(subjTrials.GivenResp(trial), 'NO_ACTION')) % this was a timeout; response time isn't relevant, so delete it
                    subjTrials.deleteThis(trial) = 1; % mark it for deletion
                end
                if (subjTrials.Correct(trial) == 0) % this is an error
                    subjTrials.errors(trial) = 1; % note that it's an error
                    subjTrials.deleteThis(trial) = 1; % mark it for deletion
                    if (trial < (height(subjTrials))) % we're not at the very last one yet
                        subjTrials.deleteThis(trial+1) = 1; % mark the next one for deletion (note that if it spans two shifts, then this is the first trial of the next shift and should be deleted anyway)
                    end
                end
            end


    % zNOTE: not sure the <>3SDs makes sense when we have 1s for some trials and 2 or 3s for others...??? 
    %        lower3SDbound = mean(subjTrials.RespTime) - (3 * std(subjTrials.RespTime));
    %        upper3SDbound = mean(subjTrials.RespTime) + (3 * std(subjTrials.RespTime));
    %        subjTrials(((subjTrials.RespTime < lower3SDbound) | (subjTrials.RespTime > upper3SDbound)), :) = []; % delete all trials outside of 3 SDs around the mean
    
            SwitchData(SwitchData.Subject == subj, :) = subjTrials; % keep all the error and deletion column changes in the larger dataset
        end
    else
        SwitchData = RFData; % assume we've already limited it to Switch data if it's preprocessed
    end
    
    
    allSubjects = unique(SwitchData.Subject);
    for subjIndex = 1:length(allSubjects) % do we really have to do this whole loop twice?
        subj = allSubjects(subjIndex); % get the subject number
        subjTrials = SwitchData(SwitchData.Subject == subj, :);
            
            errPercent = (height(subjTrials(subjTrials.errors == 1, :))) / (height(subjTrials)); % can only get this pre-deletion

            if (errPercent > .5)
    %            subjTrials.errorProneSubj = 1; % mark as error prone
%                subjMadeTooManyErrors = true; % NOTE: we don't actually use this value right now...
                if (verbose == true)
                    fprintf('Subj %d has an error rate of %f.\n', subj, errPercent);
                end
            end

            subjTrials(subjTrials.deleteThis == 1, :) = []; % delete everything that needs deleting (except the <> 3SDs)
        

        cleanTrials = height(subjTrials); % note that this is just the non-deleted trials
        subjAvgSwRT = mean(table2array(subjTrials(subjTrials.SwitchFlag == 1, 'RespTime')));
        subjAvgRepRT = mean(table2array(subjTrials(subjTrials.SwitchFlag == 2, 'RespTime')));
        subjSC = (subjAvgSwRT-subjAvgRepRT);
        
        SCmat(subjIndex, :) = [subj errPercent cleanTrials subjAvgSwRT subjAvgRepRT subjSC];
    end

    SC_table = array2table(SCmat, 'VariableNames', {'Subject','TotalErrPct','cleanTrials','avgSwRT','avgRepRT','SwCost'});

    % print the table, if requested
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getSwitchCostRT_RF_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(SC_table, fileName);
    end

end