% Zephy McKanna
% getCleanSwitchTrials_RF_1B (updated from getCleanSwitchTrials_RF_1A3, 11/4/14)
% 8/6/15
%
% This function takes as input the "all" table created by formTables_RF_1A3(),
% passed through the function putNewColsIntoDataTable_1A3() or 
% putNewColsIntoDataTable_1B() to get the new columns noting when Switch happens.
% Exclude any desired subjects before passing the data in to this function.
%
% It returns two cell matrices, cleaned in way specified by the other input
% flags (see below). The first matrix contains Switch trials in which the 
% previous trial was a different task than this trial. The second matrix
% contains Switch trials in which the previous trial was the same task as 
% this trial.
%
% It also adds a "SwitchTrialCount" column that shows how many Switch trials this
% participant has seen before this one. This is not split between Switch
% and Repetition trials (i.e., if the first five trials in a Switch shift
% were Switch-Rep-Rep-Switch-Rep, they would be numbered 1-2-3-4-5, not
% 1-1-2-2-3). In the same manner, it adds a "SwitchShiftCount" column that shows
% how many Switch shifts this participant has seen.
%
% The "cluster" flag lets you specify a particular cluster to limit the
% trials to (e.g, S, S/I, or U/I). If this is set to "true" or "false", the
% code throws an error (assuming it's a "dualTask" flag from old,
% deprecated code). Set this to "dual" to return just the dual tasks (S/I
% and U/I). Anything else (e.g., "all") will return trials from these three
% clusters. 
%    NOTE: we don't currently have a way to clean (for Switch) L4 clusters.
%    This code would be simple to update for that, but we haven't had a
%    need as of yet.
%
% If the "noFirstTrials" flag is true, the first trial of each shift is
% ignored.
% If the "noAfterError" flag is true, trials after errors are ignored
% (since we don't know what task they were actually doing during an error).
% If the "ignoreNoResponse" flag is set to "incorrect," then trials which
% the participant got wrong by not responding are ignored. If it's set to 
% "correct", then trials the participant got right by not responding are
% ignored. If it's set to "both", then all trials in which the participant 
% didn't respond are ignored.
%    
%
function [switchTrials, nonSwitchTrials, allTrials] = getCleanSwitchTrials_RF_1B(noFirstTrials, noAfterError, ignoreNoResponse, cluster, allTrialData, verbose)
    if (nargin ~= nargin('getCleanSwitchTrials_RF_1B'))
        error('zError: getCleanSwitchTrials_RF_1B expects %d inputs, but received %d. Please update any calling code.\n', nargin('getCleanSwitchTrials_RF_1B'), nargin);
    end
    
    if (any(ismember(allTrialData.Properties.VariableNames, 'CumShiftNum'))) % this was changed in 2A; make it backwards compatible
        allTrialData.ShiftNum = allTrialData.CumShiftNum;
    end
    
    if (strcmpi(cluster, 'S') == 1) % only use the single-task Switch trials
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'S'),:); % switch-only trials
    elseif (strcmpi(cluster, 'S/I') == 1) % only use the Switch/Inhibit trials
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'S/I'),:);       
    elseif (strcmpi(cluster, 'U/S') == 1) % only use the Update/Switch trials
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'U/S'),:);       
    elseif (strcmpi(cluster, 'dual') == 1) % only use the dual-task trials
        allTrialData = [allTrialData(strcmpi(allTrialData.Cluster,'U/S'),:); allTrialData(strcmpi(allTrialData.Cluster,'S/I'),:)];
    elseif (islogical(cluster)) % assume this is an unintended call to an earlier "dualTasks" flag
        error('getCleanSwitchTrials_RF_1B: cluster flag is currently T/F. Please change it to indicate which cluster you would like.');
    else % assume we want S, S/I, and U/S
        allTrialData = [allTrialData(strcmpi(allTrialData.Cluster,'S'),:); allTrialData(strcmpi(allTrialData.Cluster,'U/S'),:); allTrialData(strcmpi(allTrialData.Cluster,'S/I'),:)];
    end
        
    if ( (~ismember('InhibitFlag',allTrialData.Properties.VariableNames)) || ...
            (~ismember('ScenarioCode',allTrialData.Properties.VariableNames)) )
        error('getCleanSwitchTrials_RF_1B: This function requires added columns onto the data. Use putNewColsIntoDataTable_1B() on the data first.');
    end
    
    % Z NOTE: not doing anything different with different versions right now!!!!!
    if (strcmpi(allTrialData.Version, 'v.3.9.15.Progress'))
% Z NOTE: is this the same version for 2A???
        Version = '1B'; % assume we're dealing with 1B data
    elseif (strcmpi(allTrialData.Version, '1A3'))
        Version = '1A3'; 
    else
        error('getCleanSwitchTrials_RF_1B: unknown Version: %s.', allTrialData.Version);
    end
    
    if (verbose == true)
        fprintf('getCleanSwitchTrials_RF_1B: if you are using legacy code, note:\n');
        fprintf('    - switchTrial is now contained within SwitchFlag (1=switch)\n');
        fprintf('    - nonSwitchTrial is now contained within SwitchFlag (2=repetition)\n');
        fprintf('    - afterError is now AfterErrorFlag\n');
        fprintf('    - TrialCount is now SwitchTrialCount (use TotalTrialCount for total)\n');
        fprintf('    - ShiftCount is now SwitchShiftCount (use ShiftNum for total)\n');
    end
    
    allTrialData.SwitchTrialCount = zeros(height(allTrialData),1);
    allTrialData.SwitchShiftCount = zeros(height(allTrialData),1);
    
    allSubjects = unique(allTrialData.Subject);
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        subjTrials = allTrialData(allTrialData.Subject == subj, :);
        swTrialCount = array2table(transpose(1:(height(subjTrials)))); % just number them in order, since at this point they're all switch already
        allTrialData(allTrialData.Subject == subj, 'SwitchTrialCount') = swTrialCount;
    
        shiftCount = 1; % each subject starts out at swShift = 1
        allDays = unique(subjTrials.Date);
        for dayIndex = 1:length(allDays)
            day = allDays(dayIndex); % get the date (note it's in some weird format)
            dayTrials = subjTrials(subjTrials.Date == day, :);
            
            allShifts = unique(dayTrials.ShiftNum);
            for shiftIndex = 1:length(allShifts)
                shift = allShifts(shiftIndex); % get the shiftNum
                shiftCountTable = array2table(zeros(height( ...
                    allTrialData( ((allTrialData.Subject == subj) & ...
                    (allTrialData.Date == day) & (allTrialData.ShiftNum == shift)), ...
                    'SwitchShiftCount')),1) + shiftCount); % create a 1-col table that's the right height, filled with (0 + shiftCount)
                allTrialData( ((allTrialData.Subject == subj) & ...
                    (allTrialData.Date == day) & ... 
                    (allTrialData.ShiftNum == shift)), 'SwitchShiftCount') = shiftCountTable;
                shiftCount = shiftCount + 1; % inc the count
            end
           
        end
        

    end
    
    % now delete some trials, depending on flags
    if (noFirstTrials == true)
        allTrialData(allTrialData.Problem == 1,:) = []; % delete the first problem in each shift
        if (verbose == true)
            fprintf('getCleanSwitchTrials_RF_1B: deleting the first trial in each shift.\n');
        end
    end
    if (strcmpi(ignoreNoResponse, 'both') == 1) % we're ignoring all cases where the subject didn't respond
        allTrialData(strcmpi(allTrialData.GivenResp,'NO_ACTION'),:) = []; % delete all trials where the subject didn't respond
        if (verbose == true)
            fprintf('getCleanSwitchTrials_RF_1B: deleting all trials where the subject did not respond.\n');
        end
    elseif (strcmpi(ignoreNoResponse, 'correct') == 1) % we're ignoring only cases where the subject was correct not to respond
        allTrialData(strcmpi(allTrialData.GivenResp,'NO_ACTION') & allTrialData.Correct == true,:) = []; % delete them
        if (verbose == true)
            fprintf('getCleanSwitchTrials_RF_1B: deleting cases where was correct to not respond.\n');
        end
    elseif (strcmpi(ignoreNoResponse, 'incorrect') == 1) % we're ignoring only cases where the subject should have responded but didn't
        allTrialData(strcmpi(allTrialData.GivenResp,'NO_ACTION') & allTrialData.Correct == false,:) = []; % delete them
        if (verbose == true)
            fprintf('getCleanSwitchTrials_RF_1B: deleting cases where the subject should have responded but did not.\n');
        end
    else
        if (verbose == true)
            fprintf('getCleanSwitchTrials_RF_1B: including all NoResponse trials.\n');
        end
    end
    if (noAfterError == true) 
        allTrialData(allTrialData.AfterErrorFlag == 1, :) = []; % delete the ones we marked as after an error
        if (verbose == true)
            fprintf('getCleanSwitchTrials_RF_1B: deleting trials right after errors.\n');
        end
    end
    
    switchTrials = allTrialData(allTrialData.SwitchFlag == 1, :);
    nonSwitchTrials = allTrialData(allTrialData.SwitchFlag == 2, :);
    allTrials = allTrialData;
end
