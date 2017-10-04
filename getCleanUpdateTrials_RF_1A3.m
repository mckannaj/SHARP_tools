% Zephy McKanna
% 11/4/14
%
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% The "dualTask" flag is just a sanity check; this function is only used to
% return switch trials in single task shifts. If it's set to "true", this
% function will error out. ZNOTE: could just gracefully call the other
% function....
%
% It returns four cell matrices, cleaned in way specified by the other input
% flags (see below). The first matrix contains Update trials during shifts
% where N=1. The second and third are N=2 and N=3, respectively. The last
% matrix contains Update trials from all Ns together.
%
% It also adds a "TrialCount" column that shows how many Update trials this
% participant has seen before this one. In the same manner, it adds a "ShiftCount" column that shows
% how many Update shifts this participant has seen.
%   NOTE: we assume for this that all of a participant's trials are in a
%   single large block, not scattered with other participants' info in
%   between. If this is not the case, repetitions in this count will occur.
%
% If the "ignoreNoResponse" flag is set to "incorrect," then trials which
% the participant got wrong by not responding are ignored. If it's set to 
% "correct", then trials the participant got right by not responding are
% ignored. If it's set to "both", then all trials in which the participant
% didn't respond are ignored.
%    
%
function [N1Trials,N2Trials,N3Trials, allUpdateTrials] = getCleanUpdateTrials_RF_1A3(ignoreNoResponse, dualTasks, allTrialData, verbose)
    if (dualTasks == true)
        error('getCleanUpdateTrials_RF_1A3: This function is only intended to return trials in single tasks. Use getCleanUpdateTrials_dualTasks_RF_1A3() for dual tasks.');
    else
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'U'),:); % start with just the update-shift trials
    end
    
    if (any(ismember(allTrialData.Properties.VariableNames, 'CumShiftNum'))) % this was changed in 2A; make it backwards compatible
        allTrialData.ShiftNum = allTrialData.CumShiftNum;
    end
        
    allUpdateTrials = allTrialData(strcmpi(allTrialData.NextState,'ACTION'),:); % all "ACTION" trials are actual N-back trials

    if (strcmpi(ignoreNoResponse, 'both') == 1) % we're ignoring all cases where the subject didn't respond
        allUpdateTrials(strcmpi(allUpdateTrials.GivenResp,'NO_ACTION'),:) = []; % delete all trials where the subject didn't respond
        if (verbose == true)
            fprintf('getCleanUpdateTrials_RF_1A3: excluding all trials where the subject did not respond.\n');
        end
    elseif (strcmpi(ignoreNoResponse, 'correct') == 1) % we're ignoring only cases where the subject was correct not to respond
        allUpdateTrials(strcmpi(allUpdateTrials.GivenResp,'NO_ACTION') & allUpdateTrials.Correct == true,:) = []; % delete them
        if (verbose == true)
            fprintf('getCleanUpdateTrials_RF_1A3: excluding cases where was correct to not respond.\n');
        end
    elseif (strcmpi(ignoreNoResponse, 'incorrect') == 1) % we're ignoring only cases where the subject should have responded but didn't
        allUpdateTrials(strcmpi(allUpdateTrials.GivenResp,'NO_ACTION') & allUpdateTrials.Correct == false,:) = []; % delete them
        if (verbose == true)
            fprintf('getCleanUpdateTrials_RF_1A3: excluding cases where the subject should have responded but did not.\n');
        end
    else
        if (verbose == true)
            fprintf('getCleanUpdateTrials_RF_1A3: including all NoResponse trials.\n');
        end
    end
    
    % zNote: it sucks that we have to loop to do this. Is there a better way?
    allUpdateTrials.TrialCount = zeros(height(allUpdateTrials), 1); % add a new column that counts the number of Switch trials this participant has seen
    allUpdateTrials.ShiftCount = zeros(height(allUpdateTrials), 1); % add a new column that counts the number of Switch trials this participant has seen
    curUpdateTrial = 1;
    curUpdateShift = 1;
    curParticipant = allUpdateTrials.Subject(1); % start with the first subject
    for row = 1:(height(allUpdateTrials)) % loop through all the update trials %!!! ZEPHY: IS THERE NO BETTER WAY TO DO THIS? LOOPS ARE REALLY SLOW!
        % NOTE THAT THIS ASSUMES WE HAVE ALL OF A GIVEN PARTICIPANT'S TRIALS IN A SINGLE BLOCK! 
        if (curParticipant == allUpdateTrials.Subject(row)) % still the same participant
            allUpdateTrials.TrialCount(row) = curUpdateTrial; % record the count of this trial
            curUpdateTrial = curUpdateTrial + 1; % and inc. it
            
            if (row > 1) % just ignore the first row, since it has to be ShiftCount = 1 and it defaults to that
                if (allUpdateTrials.ShiftNum(row) ~= allUpdateTrials.ShiftNum(row - 1)) % changed shift
                    curUpdateShift = curUpdateShift + 1;                    
                end
            end
        else % changed participant
            curParticipant = allUpdateTrials.Subject(row); % note the new participant
            allUpdateTrials.TrialCount(row) = 1; % start the count over
            curUpdateTrial = 2; % next trial will be #2
            curUpdateShift = 1; % start the shift count over
        end
        allUpdateTrials.ShiftCount(row) = curUpdateShift; % by this point, curSwShift should be the right shift number
        
    end

    
    N1Trials = allUpdateTrials(allUpdateTrials.ActualN == 1, :);
    N2Trials = allUpdateTrials(allUpdateTrials.ActualN == 2, :);
    N3Trials = allUpdateTrials(allUpdateTrials.ActualN == 3, :);

    %testing
    %height(N2Trials)
end
