% Zephy McKanna
% getCleanUpdateTrials_PP_1A3()
% 3/9/14
%
% This function takes as input a table created by formTables_RF_1A3() from
% the pre/post Update test data.
%
% It first takes these data and reformats the responses into one row per
% response, rather than one row per four responses. All other information
% is kept the same for each of the four letters of response.
%
% It then turns response times into seconds
% of actual response time, similar to those reported by RobotFactory,
% rather than the deci-milliseconds since the onset of the test, as
% reported by Presentation (i.e., pre/post tests).
%
% It returns one table, containing all the Update trials (~ four times as
% many as in the original).
%
% If the "ignoreNoResponse" flag is set to "incorrect," then trials which
% the participant got wrong by not responding are ignored. If it's set to 
% "correct", then trials the participant got right by not responding are
% ignored (though there should be none of these in pre/post tests anyway). 
% If it's set to "both", then all trials in which the participant didn't 
% respond are ignored.
%    
% If the "justPrePost" flag is "pre", then it'll only return trials in the
% pretest. If it's "post", then it'll return only posttest trials.
% Otherwise, it'll return both.
%
function [newUpdate] = getCleanUpdateTrials_PP_1A3(ignoreNoResponse, justPrePost, allTrialData)
    if (strcmpi(justPrePost, 'pre') == 1) % we're only including pretest trials
        allTrialData(strcmpi(allTrialData.Period,'4-PostTest'),:) = []; % delete all posttest trials
        fprintf('getCleanSwitchTrials_PP_1A3: only including pretest trials.\n');
    elseif (strcmpi(justPrePost, 'post') == 1) % we're only including posttest trials
        allTrialData(strcmpi(allTrialData.Period,'0-PreTest'),:) = []; % delete all pretest trials
        fprintf('getCleanSwitchTrials_PP_1A3: only including posttest trials.\n');
    end
    
    % now separate the data into 1-response-per-row (rather than 4), add a "Correct" column, and fix the stimulus time to be compatible with RobotFactory 
    allTrialData.PP_RespTime = allTrialData.RespTime; % first, store the pre/post RespTime in case we ever need it
    curNewUpdateRow = 1; % keep track of the row we're on for the new table
    newUpdate(curNewUpdateRow, :) = allTrialData(1, :); % start with the row, as is
%    tempRespMat(curNewUpdateRow, 1) = 'NO_ACTION'; % just assume the first one will be no response; unlikely, but helps create the col as a str rather than char
    for row = 1:(height(allTrialData)) % loop through all the switch trials %!!! ZEPHY: IS THERE NO BETTER WAY TO DO THIS? LOOPS ARE REALLY SLOW! AND NOW WE'RE NESTING THEM?!
% NOTE THIS IS NOT RIGHT YET!!!        respStartTime = allTrialData.StimTime(row) + (25000 * allTrialData.StimLen(row)); % each stimulus letter takes 2.5s, or 25,000 deci-millisecs        
        respStartTime = allTrialData.StimTime(row); % each stimulus letter takes 2.5s, or 25,000 deci-millisecs        
        if (isnan(allTrialData.Response{row})) % first check if there's a string here to use
%            newUpdate.ThisResp(curNewUpdateRow) = 'NO_ACTION'; % keep the "no response" syntax the same as RobotFactory, for compatibility
            newUpdate(curNewUpdateRow, :) = allTrialData(row, :); % just one row for this single non-response
            newUpdate.RespTime(curNewUpdateRow) = 150000; % apparently we time out on this task after 15 secs, or 150,000 deci-ms
            tempMemBack(curNewUpdateRow, 1) = 4; % if they timed out on the first one, they were remembering 4 letters ago
            tempRespMat(curNewUpdateRow, 1) = 'X'; % X will be our equivalent of RobotFactory's NO_ACTION (just to keep it a char column)
            tempCorrMat(curNewUpdateRow, 1) = 0; % timeouts are incorrect in this test
            curNewUpdateRow = curNewUpdateRow + 1; % write a new row in newUpdate next time
        else % there is a string here; store it in different rows
            for strPlace = 1:(length(allTrialData.Response{row}))
                newUpdate(curNewUpdateRow, :) = allTrialData(row, :); % one row for each response

                % now note the reaction time (have to subtract the start-of-responding time, because Presentation just gives you a tickCount
                if (strPlace == 1)
                    newUpdate.RespTime(curNewUpdateRow) = allTrialData.PP_RespTime(row) - respStartTime;
                elseif (strPlace == 2)
                    newUpdate.RespTime(curNewUpdateRow) = allTrialData.R2(row) - respStartTime;
                elseif (strPlace == 3)
                    newUpdate.RespTime(curNewUpdateRow) = allTrialData.R3(row) - respStartTime;
                elseif (strPlace == 4)
                    newUpdate.RespTime(curNewUpdateRow) = allTrialData.R4(row) - respStartTime;
                else
                    fprintf('ERROR: getCleanUpdateTrials_PP_1A3 has an unknown strPlace (%d) on row %d\n', strPlace, row);
                end
                
                tempMemBack(curNewUpdateRow, 1) = 5 - strPlace; % furthest back in time to remember is 4, most recent is 1

                % note whether they got this one (strictly) right or not
                if (allTrialData.Stimulus{row}(length(allTrialData.Stimulus{row}) - (4 - strPlace)) == allTrialData.Response{row}(strPlace))
                    tempCorrMat(curNewUpdateRow, 1) = 1; % got it right
                else
                    tempCorrMat(curNewUpdateRow, 1) = 0; % wrong
                end
                
                tempRespMat(curNewUpdateRow, 1) = allTrialData.Response{row}(strPlace); % note the actual response
                curNewUpdateRow = curNewUpdateRow + 1; % write a new row in newUpdate next time
            end
            if (length(allTrialData.Response{row}) < 4) % they didn't respond to all four letters, so there was also a timeout
                newUpdate(curNewUpdateRow, :) = allTrialData(row, :); % one extra row for this single non-letter
                newUpdate.RespTime(curNewUpdateRow) = 150000 - newUpdate.RespTime(curNewUpdateRow-1); % 15 secs, or 150,000 deci-ms, after the start of responding
                tempMemBack(curNewUpdateRow, 1) = 5 - (length(allTrialData.Response{row}) + 1); % they timed out remembering # length + 1
                tempRespMat(curNewUpdateRow, 1) = 'X'; % X will be our equivalent of RobotFactory's NO_ACTION (just to keep it a char column)
                tempCorrMat(curNewUpdateRow, 1) = 0; % timeouts are incorrect in this test
                curNewUpdateRow = curNewUpdateRow + 1; % write a new row in newUpdate next time
            end
        end
    end
    newUpdate.ThisResp = tempRespMat; % make this a new col in the newUpdate table
    newUpdate.Correct = tempCorrMat; % make this a new col in the newUpdate table
    newUpdate.MemBack = tempMemBack; % make this a new col in the newUpdate table
    newUpdate.RespTime = newUpdate.RespTime / 10000; % turn this from deci-milliseconds into seconds, to be consistent with RobotFactory
    
    % NOTE: WE SHOULD ADD A NEW COL REPRESENTING MISHA'S EDIT DISTANCE CORRECTNESS AS WELL!

    
    if (strcmpi(ignoreNoResponse, 'both') == 1) % we're ignoring all cases where the subject didn't respond (NOTE: just for compatibility with other 1A3 functions)
        newUpdate(newUpdate.ThisResp == 'X',:) = []; % delete all trials where the subject didn't respond (note this works because it's a char column)
        fprintf('getCleanUpdateTrials_PP_1A3: excluding all trials where the subject did not respond.\n');
    elseif (strcmpi(ignoreNoResponse, 'correct') == 1) % we're ignoring only cases where the subject was correct not to respond... NONE!
        fprintf('ALERT getCleanUpdateTrials_PP_1A3: excluding cases where was correct to not respond, but there are no such cases in Pre/Post tests!\n');
    elseif (strcmpi(ignoreNoResponse, 'incorrect') == 1) % we're ignoring only cases where the subject should have responded but didn't
        newUpdate(newUpdate.ThisResp == 'X',:) = []; % delete all trials where the subject didn't respond
        fprintf('getCleanUpdateTrials_PP_1A3: excluding cases where the subject should have responded but did not (i.e., all timeout cases).\n');
    else
        fprintf('getCleanUpdateTrials_PP_1A3: including all NoResponse trials.\n');
    end
    
    
end
