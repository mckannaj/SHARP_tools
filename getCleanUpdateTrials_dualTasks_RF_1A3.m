% Zephy McKanna
% 11/4/14
%
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% The "dualTask" flag is just a sanity check; this function is only used to
% return switch trials in dual task shifts. If it's set to "false", this
% function will error out. ZNOTE: could just gracefully call the other
% function....
%
% The "cluster" flag lets you specify a particular cluster to limit the
% trials to (e.g, S/I, or U/I).
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
function [N1Trials,N2Trials,N3Trials, allUpdateTrials] = getCleanUpdateTrials_dualTasks_RF_1A3(ignoreNoResponse, cluster, dualTasks, allTrialData)
    if (dualTasks == true)
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'U/S') | strcmpi(allTrialData.Cluster,'U/I'),:); % start with the dual-task shifts that involve update
    else
        error('getCleanUpdateTrials_dualTasks_RF_1A3: This function is only intended to return trials in dual tasks. Use getCleanUpdateTrials_RF_1A3() for single tasks.');
    end
    
    if (strcmpi(cluster, 'U/S') == 1) % only use the Update/Switch trials
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'U/S'),:);       
    elseif (strcmpi(cluster, 'U/I') == 1) % only use the Update/Inhibit trials
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'U/I'),:);       
    end
    
    % these shifts don't seem to exist in the data and I don't know how to
    % deal with them; excluding them for now
    allTrialData(strcmpi(allTrialData.Shift, 'Advanced Categorization (U/S)'), :) = [];

    allTrialData.updateTrial = zeros(height(allTrialData), 1); % add a new column that says "this is an update trial"
    
    % switch trials are based on update for several of these shifts; have
    % to run through them and see if they switched tasks to see if it was
    % an update trial
    allTrialData.TrialCount = zeros(height(allTrialData), 1); % add a new column that counts the number of Switch trials this participant has seen
    allTrialData.ShiftCount = zeros(height(allTrialData), 1); % add a new column that counts the number of Switch trials this participant has seen
    curUpdateTrial = 1;
    curUpdateShift = 1;
    curParticipant = allTrialData.Subject(1); % start with the first subject
    for row = 1:(height(allTrialData)) % loop through all the switch trials %!!! ZEPHY: IS THERE NO BETTER WAY TO DO THIS? LOOPS ARE REALLY SLOW!
        if (row > 1) % switching only make sense if we're not on the first row (dealing with row-1)
            if (allTrialData.Problem(row) > allTrialData.Problem(row-1)) % these tests also only make sense if they're in the same shift as the previous row
                % these shifts are STATE_A and STATE_B
                if (strcmpi(allTrialData.Shift(row), 'Optical Positioning (U/S)') || strcmpi(allTrialData.Shift(row), 'Achievement Hunting (U/S)') )
                    if (strcmpi(allTrialData.NextState(row), 'TASK_1_STATE_A') || strcmpi(allTrialData.NextState(row), 'TASK_1_STATE_B'))
                        if (strcmpi(allTrialData.NextState(row-1), 'TASK_2_STATE_A') || strcmpi(allTrialData.NextState(row-1), 'TASK_2_STATE_B'))
                            allTrialData.updateTrial(row) = 1; % this is a switch from task 1 to task 2
                        end
                    elseif (strcmpi(allTrialData.NextState(row), 'TASK_2_STATE_A') || strcmpi(allTrialData.NextState(row), 'TASK_2_STATE_B'))
                        if (strcmpi(allTrialData.NextState(row-1), 'TASK_1_STATE_A') || strcmpi(allTrialData.NextState(row-1), 'TASK_1_STATE_B'))
                            allTrialData.updateTrial(row) = 1; % this is a switch from task 2 to task 1
                        end
                    end
                % these shifts are RIGHT and LEFT
                elseif (strcmpi(allTrialData.Shift(row), 'Part ID Gleaning (U/S)') || strcmpi(allTrialData.Shift(row), 'Eye Scrobbling (U/S)') || strcmpi(allTrialData.Shift(row), 'Cross Checking (U/S)') || strcmpi(allTrialData.Shift(row), 'Aviation Aspectizing (U/S)') || strcmpi(allTrialData.Shift(row), 'Intent Estimation (U/S)') || strcmpi(allTrialData.Shift(row), 'Naturalized Decommissioning (U/S)') )
                    if (strcmpi(allTrialData.NextState(row), 'TASK_1_RIGHT') || strcmpi(allTrialData.NextState(row), 'TASK_1_LEFT'))
                        if (strcmpi(allTrialData.NextState(row-1), 'TASK_2_RIGHT') || strcmpi(allTrialData.NextState(row-1), 'TASK_2_LEFT'))
                            allTrialData.updateTrial(row) = 1; % this is a switch from task 1 to task 2
                        end
                    elseif (strcmpi(allTrialData.NextState(row), 'TASK_2_RIGHT') || strcmpi(allTrialData.NextState(row), 'TASK_2_LEFT'))
                        if (strcmpi(allTrialData.NextState(row-1), 'TASK_1_RIGHT') || strcmpi(allTrialData.NextState(row-1), 'TASK_1_LEFT'))
                            allTrialData.updateTrial(row) = 1; % this is a switch from task 2 to task 1
                        end
                    end
                end
            end
        end
        
        % NOTE THAT THIS ASSUMES WE HAVE ALL OF A GIVEN PARTICIPANT'S TRIALS IN A SINGLE BLOCK! 
        if (curParticipant == allTrialData.Subject(row)) % still the same participant
            allTrialData.TrialCount(row) = curUpdateTrial; % record the count of this trial
            curUpdateTrial = curUpdateTrial + 1; % and inc. it
            
            if (row > 1) % just ignore the first row, since it has to be ShiftCount = 1 and it defaults to that
                if (allTrialData.ShiftNum(row) ~= allTrialData.ShiftNum(row - 1)) % changed shift
                    curUpdateShift = curUpdateShift + 1;                    
                end
            end
        else % changed participant
            curParticipant = allTrialData.Subject(row); % note the new participant
            allTrialData.TrialCount(row) = 1; % start the count over
            curUpdateTrial = 2; % next trial will be #2
            curUpdateShift = 1; % start the shift count over
        end
        allTrialData.ShiftCount(row) = curUpdateShift; % by this point, curSwShift should be the right shift number

    end

    % These shifts all have Update as the Inhibit mechanism, so check for
    % Inhibit to see if there was an N-back
    updateRows1 = allTrialData((strcmpi(allTrialData.Shift,'Eye Inspection (U/I)') | strcmpi(allTrialData.Shift,'Head and Shoulders (U/I)') | strcmpi(allTrialData.Shift,'Odditizing (U/I)') | strcmpi(allTrialData.Shift,'Chest Digitizing (U/I)') | strcmpi(allTrialData.Shift,'Limb Reparations (U/I)') | strcmpi(allTrialData.Shift,'Face Numbering (U/I)')) & (strcmpi(allTrialData.NextState,'INHIBIT')), :);
    
    % These shifts all have Update noted as TASK_1_STATE_A 
    updateRows2 = allTrialData((strcmpi(allTrialData.Shift,'Cranial Equilibrium (U/I)') | strcmpi(allTrialData.Shift,'Arm Matching (U/I)') | strcmpi(allTrialData.Shift,'Brain Deficiencies (U/I)') | strcmpi(allTrialData.Shift,'Terrestrial Tiering (U/I)')) & (strcmpi(allTrialData.NextState,'TASK_1_STATE_A')), :);
    
    updateRows3 = allTrialData(allTrialData.updateTrial == 1,:); % also grab all trials that have been marked as Update trials
    
    allUpdateTrials = [updateRows1;updateRows2;updateRows3]; 
    
    if (strcmpi(ignoreNoResponse, 'both') == 1) % we're ignoring all cases where the subject didn't respond
        allUpdateTrials(strcmpi(allUpdateTrials.GivenResp,'NO_ACTION'),:) = []; % delete all trials where the subject didn't respond
        fprintf('getCleanUpdateTrials_dualTasks_RF_1A3: excluding all trials where the subject did not respond.\n');
    elseif (strcmpi(ignoreNoResponse, 'correct') == 1) % we're ignoring only cases where the subject was correct not to respond
        allUpdateTrials(strcmpi(allUpdateTrials.GivenResp,'NO_ACTION') & allUpdateTrials.Correct == true,:) = []; % delete them
        fprintf('getCleanUpdateTrials_dualTasks_RF_1A3: excluding cases where was correct to not respond.\n');
    elseif (strcmpi(ignoreNoResponse, 'incorrect') == 1) % we're ignoring only cases where the subject should have responded but didn't
        allUpdateTrials(strcmpi(allUpdateTrials.GivenResp,'NO_ACTION') & allUpdateTrials.Correct == false,:) = []; % delete them
        fprintf('getCleanUpdateTrials_dualTasks_RF_1A3: excluding cases where the subject should have responded but did not.\n');
    else
        fprintf('getCleanUpdateTrials_dualTasks_RF_1A3: including all NoResponse trials.\n');
    end
    
    N1Trials = allUpdateTrials(allUpdateTrials.ActualN == 1, :);
    N2Trials = allUpdateTrials(allUpdateTrials.ActualN == 2, :);
    N3Trials = allUpdateTrials(allUpdateTrials.ActualN == 3, :);

end
