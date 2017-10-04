% Zephy McKanna
% getCleanSwitchTrials_PP_1A3()
% 3/9/14
%
% This function takes as input a table created by formTables_RF_1A3() from
% the pre/post Switch test data.
%
% It first takes these data and reformats the response times into seconds
% of actual response time, similar to those reported by RobotFactory,
% rather than the deci-milliseconds since the onset of the test, as
% reported by Presentation (i.e., pre/post tests).
%
% It returns two cell matrices, cleaned in way specified by the other input
% flags (see below). The first matrix contains Switch trials in which the 
% previous trial was a different task than this trial. The second matrix
% contains Switch trials in which the previous trial was the same task as 
% this trial.
%
% If the "noFirstTrials" flag is true, the first trial of each shift is
% ignored.
% If the "noAfterError" flag is true, trials after errors are ignored
% (since we don't know what task they were actually doing during an error).
% If the "ignoreNoResponse" flag is set to "incorrect," then trials which
% the participant got wrong by not responding are ignored. If it's set to 
% "correct", then trials the participant got right by not responding are
% ignored (though there should be none of these in pre/post tests anyway). 
% If it's set to "both", then all trials in which the participant didn't 
% respond are ignored.
% If the "justPrePost" flag is "pre", then it'll only return trials in the
% pretest. If it's "post", then it'll return only posttest trials.
% Otherwise, it'll return both.
% If the "justPerform" flag is true, it'll just return trials in the
% performance blocks. If it's false, it'll also return trials in the
% training and warmup blocks.
%
function [switchTrials, nonSwitchTrials, allData] = getCleanSwitchTrials_PP_1A3(noFirstTrials, noAfterError, ignoreNoResponse, justPrePost, justPerform, allTrialData)
    if (nargin ~= nargin('getCleanSwitchTrials_PP_1A3'))
        error('zError: getCleanSwitchTrials_PP_1A3 expects %d inputs, but received %d. Please update any calling code.\n', nargin('getCleanSwitchTrials_PP_1A3'), nargin);
    end

    if (strcmpi(justPrePost, 'pre') == 1) % we're only including pretest trials
        allTrialData(strcmpi(allTrialData.Period,'4-PostTest'),:) = []; % delete all posttest trials
        fprintf('getCleanSwitchTrials_PP_1A3: only including pretest trials.\n');
    elseif (strcmpi(justPrePost, 'post') == 1) % we're only including posttest trials
        allTrialData(strcmpi(allTrialData.Period,'0-PreTest'),:) = []; % delete all pretest trials
        fprintf('getCleanSwitchTrials_PP_1A3: only including posttest trials.\n');
    end    
    
    if (justPerform == true) % we're only including performance trials
        allTrialData(strcmpi(allTrialData.Block,'Training_1'),:) = []; % delete
        allTrialData(strcmpi(allTrialData.Block,'Training_2'),:) = []; % delete
        allTrialData(strcmpi(allTrialData.Block,'Warmup_1'),:) = []; % delete
        allTrialData(strcmpi(allTrialData.Block,'Warmup_2'),:) = []; % delete
        allTrialData(strcmpi(allTrialData.Block,'Warmup_3'),:) = []; % delete
        allTrialData(strcmpi(allTrialData.Block,'Warmup_4'),:) = []; % delete
        fprintf('getCleanSwitchTrials_PP_1A3: only including performance trials.\n');
    else
        fprintf('getCleanSwitchTrials_PP_1A3: including training, warmup, and performance trials.\n');
    end    

    % first, mark Switch as either 0 (repetition) or 1 (switch)
    tmpClusterTable = allTrialData(isnan(allTrialData.IsSwitch),:).IsSwitch; % make a table the right height
    tmpClusterTable(:,1) = 0; % fill that table with 0
    allTrialData(isnan(allTrialData.IsSwitch),:).IsSwitch = tmpClusterTable; % then assign it to the right rows

    % "Score" is a cell array mixing strings and logicals (ARGH); let's just make a new Double array containing the same info
    allTrialData.Correct = zeros(height(allTrialData), 1) + 999; % Call it "Correct" for consistency with RF, and make "timeout" = 999
    for row = 1:(height(allTrialData)) % loop through all the switch trials %!!! ZEPHY: IS THERE NO BETTER WAY TO DO THIS? LOOPS ARE REALLY SLOW! AND NOW WE HAVE TO DO IT TWICE???
        if (islogical(allTrialData.Score{row})) % don't test the strings, they'll error out on an ==
            if (allTrialData.Score{row} == false) % logical inside cell
                allTrialData.Correct(row) = 0; % double not inside cell
            elseif (allTrialData.Score{row} == true) % logical inside cell
                allTrialData.Correct(row) = 1; % double not inside cell
            end
        end
    end
    
    allTrialData.afterError = zeros(height(allTrialData), 1); % add a new column that says "this is after an error"    
    for row = 1:(height(allTrialData)) % loop through all the switch trials %!!! ZEPHY: IS THERE NO BETTER WAY TO DO THIS? LOOPS ARE REALLY SLOW!
        if (row < height(allTrialData)) % some tests only make sense if we're not on the last row (dealing with row+1)
            if (strcmpi(allTrialData.Block(row), allTrialData.Block(row+1)) == 1) % these tests also only make sense if they're in the same block as the next row
                if ((allTrialData.Correct(row) == 0) || (allTrialData.Correct(row) == 999)) % they got this trial wrong or timed out
                    allTrialData.afterError(row + 1) = 1; % the next row is after an error
                end
            end
        end
    end

    if (noFirstTrials == true)
        allTrialData(allTrialData.Problem == 1,:) = []; % delete the 0th problem in each block
        fprintf('getCleanSwitchTrials_PP_1A3: ignoring the first trial in each block.\n');
    end
    if (strcmpi(ignoreNoResponse, 'both') == 1) % we're ignoring all cases where the subject didn't respond (NOTE: just for compatibility with other 1A3 functions)
        allTrialData(allTrialData.Correct == 999,:) = []; % delete all trials where the subject didn't respond
        fprintf('getCleanSwitchTrials_PP_1A3: excluding all trials where the subject did not respond.\n');
    elseif (strcmpi(ignoreNoResponse, 'correct') == 1) % we're ignoring only cases where the subject was correct not to respond... NONE!
        fprintf('ALERT getCleanSwitchTrials_PP_1A3: excluding cases where was correct to not respond, but there are no such cases in Pre/Post tests!\n');
    elseif (strcmpi(ignoreNoResponse, 'incorrect') == 1) % we're ignoring only cases where the subject should have responded but didn't
        allTrialData(allTrialData.Correct == 999,:) = []; % delete them
        fprintf('getCleanSwitchTrials_PP_1A3: excluding cases where the subject should have responded but did not (i.e., all timeout cases).\n');
    else
        fprintf('getCleanSwitchTrials_PP_1A3: including all NoResponse trials.\n');
    end
    if (noAfterError == true) 
        allTrialData(allTrialData.afterError == 1, :) = []; % delete the ones we marked as after an error
        fprintf('getCleanSwitchTrials_PP_1A3: ignoring trials right after errors.\n');
    end
    
    % response time is different in pre/post compared to RF; fix it
    allTrialData.PP_RespTime = allTrialData.RespTime; % first, store the pre/post RespTime in case we ever need it
    allTrialData.RespTime = allTrialData.RespTime - allTrialData.StimTime; % first, subtract each stimulus time from the response time
    allTrialData.RespTime = allTrialData.RespTime / 10000; % then divide by 10,000 to get seconds (as used by RF RT)
    
    switchTrials = allTrialData(allTrialData.IsSwitch == 1, :);
    nonSwitchTrials = allTrialData(allTrialData.IsSwitch == 0, :);
    allData = allTrialData;
end
