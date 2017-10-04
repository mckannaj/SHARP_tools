% Zephy McKanna
% 11/4/14
%
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% It returns two cell matrices, cleaned in way specified by the other input
% flags (see below). The first matrix contains Switch trials in which the 
% previous trial was a different task than this trial. The second matrix
% contains Switch trials in which the previous trial was the same task as 
% this trial.
%
% It also adds a "TrialCount" column that shows how many Switch trials this
% participant has seen before this one. This is not split between Switch
% and Repetition trials (i.e., if the first five trials in a Switch shift
% were Switch-Rep-Rep-Switch-Rep, they would be numbered 1-2-3-4-5, not
% 1-1-2-2-3). In the same manner, it adds a "ShiftCount" column that shows
% how many Switch shifts this participant has seen.
%   NOTE: we assume for this that all of a participant's trials are in a
%   single large block, not scattered with other participants' info in
%   between. If this is not the case, repetitions in this count will occur.
%
% The "dualTask" flag is just a sanity check; this function is only used to
% return switch trials in single task shifts. If it's set to "true", this
% function will error out. ZNOTE: could just gracefully call the other
% function....
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
function [switchTrials, nonSwitchTrials, allTrials] = getCleanSwitchTrials_RF_1A3(noFirstTrials, noAfterError, ignoreNoResponse, dualTasks, allTrialData)
    error('getCleanSwitchTrials_RF_1A3: this function is deprecated. Please use getCleanSwitchTrials_RF_1B instead (even for 1A-3 data).');

    if (dualTasks == true)
        error('getCleanSwitchTrials_RF_1A3: This function is only intended to return trials in single tasks. Use getCleanSwitchTrials_dualTasks_RF_1A3() for dual tasks.');
    else
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'S'),:); % start with just the switch trials
    end
    
    fprintf('getCleanSwitchTrials_RF_1A3 running... sometimes this first loop takes a minute or two...\n');
    allTrialData.switchTrial = zeros(height(allTrialData), 1); % add a new column that says "this is a switch trial"
    allTrialData.nonSwitchTrial = zeros(height(allTrialData), 1); % add a new column that says "this is a non-switch trial"
    allTrialData.afterError = zeros(height(allTrialData), 1); % add a new column that says "this is after an error"    
    allTrialData.TrialCount = zeros(height(allTrialData), 1); % add a new column that counts the number of Switch trials this participant has seen
    allTrialData.ShiftCount = zeros(height(allTrialData), 1); % add a new column that counts the number of Switch trials this participant has seen
    curSwTrial = 1;
    curSwShift = 1;
    curParticipant = allTrialData.Subject(1); % start with the first subject
    for row = 1:(height(allTrialData)) % loop through all the switch trials %!!! ZEPHY: IS THERE NO BETTER WAY TO DO THIS? LOOPS ARE REALLY SLOW!
        if (row > 1) % some tests only make sense if we're not on the first row (dealing with row-1)
            if (allTrialData.Problem(row) > allTrialData.Problem(row-1)) % these tests also only make sense if they're in the same shift as the previous row
                if (strcmpi(allTrialData.NextState(row), 'TASK_1_STATE_A') || strcmpi(allTrialData.NextState(row), 'TASK_1_STATE_B'))
                    if (strcmpi(allTrialData.NextState(row-1), 'TASK_2_STATE_A') || strcmpi(allTrialData.NextState(row-1), 'TASK_2_STATE_B'))
                        allTrialData.switchTrial(row) = 1; % this is a switch from task 1 to task 2
                    elseif (strcmpi(allTrialData.NextState(row-1), 'TASK_1_STATE_A') || strcmpi(allTrialData.NextState(row-1), 'TASK_1_STATE_B'))
                        allTrialData.nonSwitchTrial(row) = 1; % this trial stayed on task 1
                    end
                elseif (strcmpi(allTrialData.NextState(row), 'TASK_2_STATE_A') || strcmpi(allTrialData.NextState(row), 'TASK_2_STATE_B'))
                    if (strcmpi(allTrialData.NextState(row-1), 'TASK_1_STATE_A') || strcmpi(allTrialData.NextState(row-1), 'TASK_1_STATE_B'))
                        allTrialData.switchTrial(row) = 1; % this is a switch from task 2 to task 1
                    elseif (strcmpi(allTrialData.NextState(row-1), 'TASK_2_STATE_A') || strcmpi(allTrialData.NextState(row-1), 'TASK_2_STATE_B'))
                        allTrialData.nonSwitchTrial(row) = 1; % this trial stayed on task 2
                    end
                end
            end
        end
        if (row < height(allTrialData)) % some tests only make sense if we're not on the last row (dealing with row+1)
            if (allTrialData.Problem(row) < allTrialData.Problem(row+1)) % these tests also only make sense if they're in the same shift as the next row
                if (allTrialData.Correct(row) == false) % they got this trial wrong
                    allTrialData.afterError(row + 1) = 1; % the next row is after an error
                end
            end
        end
        
        % NOTE THAT THIS ASSUMES WE HAVE ALL OF A GIVEN PARTICIPANT'S TRIALS IN A SINGLE BLOCK! 
        if (curParticipant == allTrialData.Subject(row)) % still the same participant
            allTrialData.TrialCount(row) = curSwTrial; % record the count of this trial
            curSwTrial = curSwTrial + 1; % and inc. it
            
            if (row > 1) % just ignore the first row, since it has to be ShiftCount = 1 and it defaults to that
                if (allTrialData.ShiftNum(row) ~= allTrialData.ShiftNum(row - 1)) % changed shift
                    curSwShift = curSwShift + 1;                    
                end
            end
        else % changed participant
            curParticipant = allTrialData.Subject(row); % note the new participant
            allTrialData.TrialCount(row) = 1; % start the count over
            curSwTrial = 2; % next trial will be #2
            curSwShift = 1; % start the shift count over
        end
        allTrialData.ShiftCount(row) = curSwShift; % by this point, curSwShift should be the right shift number
        
    end

    if (noFirstTrials == true)
        allTrialData(allTrialData.Problem == 0,:) = []; % delete the 0th problem in each shift
        fprintf('getCleanSwitchTrials_RF_1A3: ignoring the first trial in each shift.\n');
    end
    if (strcmpi(ignoreNoResponse, 'both') == 1) % we're ignoring all cases where the subject didn't respond
        allTrialData(strcmpi(allTrialData.GivenResp,'NO_ACTION'),:) = []; % delete all trials where the subject didn't respond
        fprintf('getCleanSwitchTrials_RF_1A3: excluding all trials where the subject did not respond.\n');
    elseif (strcmpi(ignoreNoResponse, 'correct') == 1) % we're ignoring only cases where the subject was correct not to respond
        allTrialData(strcmpi(allTrialData.GivenResp,'NO_ACTION') & allTrialData.Correct == true,:) = []; % delete them
        fprintf('getCleanSwitchTrials_RF_1A3: excluding cases where was correct to not respond.\n');
    elseif (strcmpi(ignoreNoResponse, 'incorrect') == 1) % we're ignoring only cases where the subject should have responded but didn't
        allTrialData(strcmpi(allTrialData.GivenResp,'NO_ACTION') & allTrialData.Correct == false,:) = []; % delete them
        fprintf('getCleanSwitchTrials_RF_1A3: excluding cases where the subject should have responded but did not.\n');
    else
        fprintf('getCleanSwitchTrials_RF_1A3: including all NoResponse trials.\n');
    end
    if (noAfterError == true) 
        allTrialData(allTrialData.afterError == 1, :) = []; % delete the ones we marked as after an error
        fprintf('getCleanSwitchTrials_RF_1A3: ignoring trials right after errors.\n');
    end
    
    % testing - if this prints out anything, we've got an error...
    if (isempty(allTrialData((allTrialData.switchTrial == 1) & (allTrialData.nonSwitchTrial == 1), :)) == false)
        allTrialData((allTrialData.switchTrial == 1) & (allTrialData.nonSwitchTrial == 1), :)
        error('we have rows that are both switch and a non-switch trials somehow; they should be printed out above this line.\n');
    end

    switchTrials = allTrialData(allTrialData.switchTrial == 1, :);
    nonSwitchTrials = allTrialData(allTrialData.nonSwitchTrial == 1, :);
    allTrials = allTrialData;
end
