% Zephy McKanna
% getAllSwitchTrials_1A3()
% 3/15/15
% 
% This function takes as input:
%   - the "all" table created by formTables_RF_1A3(), or 
%   - (if some subjects should be excluded), the table produced by
%         excludeSubjects_RF_1A3(), or
%   - if only a single subject should be used, just the data from that
%         subject
%
% It calls getCleanSwitchTrials_RF_1B and returns the
% requested cleaned switch trials. It also re-orders the TrialCount and
% ShiftCount to indicate the correct order in which these trials were seen
% (interleaving the single and dual tasks as they were originally).
%
% If 'dualTasks' is 'dual', the function returns only data from U/S and S/I
% shifts. If it's 'both', then it returns data from S, U/S, and S/I shifts.
% Otherwise (default), it just returns data from the single-EF (S) shifts.
%
% If the "ignoreNoResponse" flag is set to "incorrect," then trials which
% the participant got wrong by not responding are ignored. If it's set to 
% "correct", then trials the participant got right by not responding are
% ignored. If it's set to "both", then all trials in which the participant
% didn't respond are ignored.
% 
% If the "cluster" flag is set to either 'U/S' or 'S/I', it will return
% only the data from that dual-task cluster. Otherwise, it will return data
% from both. 
% NOTE: if "dualTasks" is set to 'both' and "cluster" is set to 'U/S' (for
% example), it will only return data from 'S' and 'U/S'.
%
function [requestedSwitchTrials] = getAllSwitchTrials_1A3(preExcludedData1A3, ignoreNoResponse, cluster, dualTasks)
    error('getAllSwitchTrials_1A3 is deprecated. Please call getCleanSwitchTrials_RF_1B() instead.\n');

    if (strcmpi(dualTasks, 'dual')) % just use dual tasks
        error('zNOTE!: getAllSwitchTrials_1A3 works properly with S_only (uses extra cols), but not yet with dual tasks (still using crappy methods for the duals) - FIX THIS BEFORE USING IT!!!.\n');
        fprintf('getAllSwitchTrials_1A3: just returning data from dual EFs.\n');
        [swTrials, repTrials, requestedSwitchTrials] = getCleanSwitchTrials_dualTasks_RF_1A3(true, true, ignoreNoResponse, cluster, true, preExcludedData1A3);
    elseif (strcmpi(dualTasks, 'both')) % use single and dual tasks
        error('zNOTE!: getAllSwitchTrials_1A3 works properly with S_only (uses extra cols), but not yet with dual tasks (still using crappy methods for the duals) - FIX THIS BEFORE USING IT!!!.\n');
        fprintf('getAllSwitchTrials_1A3: returning data from single and dual EFs.\n');
        [SingleSwTrials, SingleRepTrials, singleTrials] = getCleanSwitchTrials_RF_1A3(true, true, ignoreNoResponse, false, preExcludedData1A3);
        [DualSwTrials, DualRepTrials, dualTrials] = getCleanSwitchTrials_dualTasks_RF_1A3(true, true, ignoreNoResponse, cluster, true, preExcludedData1A3);
        
        fprintf('getAllSwitchTrials_1A3: interleaving single and dual tasks... loop may take a couple minutes...\n');
        % re-order ShiftCount and TrialCount, interleaving single and dual EF trials based on Subj and ShiftNum
        allSwitchTrials = [singleTrials;dualTrials];
        requestedSwitchTrials = []; % clear this so we can build it up subject by subject
        tNum = 1;
        sNum = 1;
        subjs = unique(allSwitchTrials.Subject);
        for subj = 1:(length(subjs))
            singleSubjSwitchTrials = allSwitchTrials(allSwitchTrials.Subject == subjs(subj),:);
            shifts = unique(singleSubjSwitchTrials.ShiftNum);
            for shift = 1:length(shifts)
                tmpCountTable = singleSubjSwitchTrials(singleSubjSwitchTrials.ShiftNum == shifts(shift), :).TrialCount;
                tmpCountTable(:,1) = tNum:(tNum+length(tmpCountTable)-1); % fill that table with numbers in order starting with tNum
                singleSubjSwitchTrials(singleSubjSwitchTrials.ShiftNum == shifts(shift), :).TrialCount = tmpCountTable; % then assign it to the right rows
                tNum = tNum + length(tmpCountTable);
                tmpCountTable(:,1) = sNum; % now just fill it with the one shift number
                singleSubjSwitchTrials(singleSubjSwitchTrials.ShiftNum == shifts(shift), :).ShiftCount = tmpCountTable; % then assign it to the right rows
                sNum = sNum + 1;
            end
            requestedSwitchTrials = [requestedSwitchTrials; singleSubjSwitchTrials]; % add this subject's (Trial- and ShiftCount correct) trials to the growing total
        end                
    else % default to just single tasks
        fprintf('getAllSwitchTrials_1A3: just returning data from single EFs.\n');
        [swTrials, repTrials, requestedSwitchTrials] = getCleanSwitchTrials_RF_1B(true, true, ignoreNoResponse, false, preExcludedData1A3);
    end

end