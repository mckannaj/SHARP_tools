% Zephy McKanna
% getAllUpdateTrials_1A3()
% 3/15/15
% 
% This function takes as input:
%   - the "all" table created by formTables_RF_1A3(), or 
%   - (if some subjects should be excluded), the table produced by
%         excludeSubjects_RF_1A3(), or
%   - if only a single subject should be used, just the data from that
%         subject
%
% It calls either getCleanUpdateTrials_RF_1A3() or
% getCleanUpdateTrials_dualTasks_RF_1A3(), or both, and returns the
% requested cleaned update trials. It also re-orders the TrialCount and
% ShiftCount to indicate the correct order in which these trials were seen
% (interleaving the single and dual tasks as they were originally).
%
% If 'dualTasks' is 'dual', the function returns only data from U/S and U/I
% shifts. If it's 'both', then it returns data from U, U/S, and U/I shifts.
% Otherwise (default), it just returns data from the single-EF (U) shifts.
%
% If the "ignoreNoResponse" flag is set to "incorrect," then trials which
% the participant got wrong by not responding are ignored. If it's set to 
% "correct", then trials the participant got right by not responding are
% ignored. If it's set to "both", then all trials in which the participant
% didn't respond are ignored.
% 
% If the "cluster" flag is set to either 'U/S' or 'U/I', it will return
% only the data from that dual-task cluster. Otherwise, it will return data
% from both. 
% NOTE: if "dualTasks" is set to 'both' and "cluster" is set to 'U/S' (for
% example), it will only return data from 'U' and 'U/S'.
%
function [requestedUpdateTrials] = getAllUpdateTrials_1A3(preExcludedData1A3, ignoreNoResponse, cluster, dualTasks, verbose)

    if (strcmpi(dualTasks, 'dual')) % just use dual tasks
        if (verbose == true)
            fprintf('getAllUpdateTrials_1A3: just returning data from dual EFs.\n');
        end
        [~,~,~, requestedUpdateTrials] = getCleanUpdateTrials_dualTasks_RF_1A3(ignoreNoResponse, cluster, true, preExcludedData1A3);
    elseif (strcmpi(dualTasks, 'both')) % use single and dual tasks
        if (verbose == true)
            fprintf('getAllUpdateTrials_1A3: returning data from single and dual EFs.\n');
        end
        [~,~,~, singleEFtrials] = getCleanUpdateTrials_RF_1A3(ignoreNoResponse, false, preExcludedData1A3, verbose);
        [~,~,~, dualEFtrials] = getCleanUpdateTrials_dualTasks_RF_1A3(ignoreNoResponse, cluster, true, preExcludedData1A3);
        singleEFtrials.updateTrial = ones(height(singleEFtrials), 1); % dualEFtrials has this col, so need it to merge
        allUpdateTrials = [singleEFtrials;dualEFtrials];
        
        if (verbose == true)
            fprintf('getAllUpdateTrials_1A3: using both single and dual tasks... loop may take a couple minutes...\n');
        end
        % re-order ShiftCount and TrialCount, interleaving single and dual EF trials based on Subj and ShiftNum
        requestedUpdateTrials = []; % clear this so we can build it up subject by subject
        tNum = 1;
        sNum = 1;
        subjs = unique(allUpdateTrials.Subject);
        for subj = 1:(length(subjs))
            singleSubjUpdateTrials = allUpdateTrials(allUpdateTrials.Subject == subjs(subj),:);
            shifts = unique(singleSubjUpdateTrials.ShiftNum);
%            shifts = unique(requestedUpdateTrials(requestedUpdateTrials.Subject == subjs(subj),:).ShiftNum);
            for shift = 1:length(shifts)
                tmpCountTable = singleSubjUpdateTrials(singleSubjUpdateTrials.ShiftNum == shifts(shift), :).TrialCount;
                tmpCountTable(:,1) = tNum:(tNum+length(tmpCountTable)-1); % fill that table with numbers in order starting with tNum
                singleSubjUpdateTrials(singleSubjUpdateTrials.ShiftNum == shifts(shift), :).TrialCount = tmpCountTable; % then assign it to the right rows
                tNum = tNum + length(tmpCountTable);
                tmpCountTable(:,1) = sNum; % now just fill it with the one shift number
                singleSubjUpdateTrials(singleSubjUpdateTrials.ShiftNum == shifts(shift), :).ShiftCount = tmpCountTable; % then assign it to the right rows
                sNum = sNum + 1;
            end
            requestedUpdateTrials = [requestedUpdateTrials; singleSubjUpdateTrials]; % add this subject's (Trial- and ShiftCount correct) trials to the growing total
        end
    else % default to just single tasks
        if (verbose == true)
            fprintf('getAllUpdateTrials_1A3: just returning data from single EFs.\n');
        end
        [~,~,~, requestedUpdateTrials] = getCleanUpdateTrials_RF_1A3(ignoreNoResponse, false, preExcludedData1A3, verbose);
     end

end