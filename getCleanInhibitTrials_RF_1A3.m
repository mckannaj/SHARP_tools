% Zephy McKanna
% 11/14/14
%
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% It returns two tables, cleaned in way specified by the other input
% flags (see below). The first matrix contains Inhibit trials during
% Inhibit shifts. The second matrix contains non-inhibit (i.e., "Go"
% trials) during Inhibit shifts.
%
% If the "onlyCorrectGo" flag is set, only correct trials are included in
% the GoTrials table.
%
% The "dualTask" flag is just a sanity check; this function is only used to
% return switch trials in single task shifts. If it's set to "true", this
% function will error out. ZNOTE: could just gracefully call the other
% function....
%
% If the "ignoreNoResponseAnyway" flag is set to 'all', then Inhibit trials
% in which the participant would have been correct to not respond even if
% there hadn't been an Inhibit cue will be removed from the inhibitTrials
% table. If it's set to 'correct', then the ones where they shouldn't have
% responded anyway but DID (i.e., got it wrong despite two cues) are left
% in.
%
% If the "ignoreNoResponse" flag is set to "GoWrong", then trials which
% the participant got wrong by not responding (i.e., they should have
% responded because it was a Go trial) are removed from the goTrials table.
% If it's set to "GoCorrect", non-Inhibit trials which the participant got
% correct by not responding are removed. If it's set to "GoBoth" then all
% non-Inhibit trials in which the participant did not respond are removed.
%    
% If the "ignore3PlusSDs" flag is set to "Go", then trials which are more
% than 3 standard deviations away from the mean in terms of response time
% are removed from the goTrials table. Note that mean and SD are calculated
% after any removals based on the other flags.
%
function [goTrials, inhibitTrials] = getCleanInhibitTrials_RF_1A3(onlyCorrectGo, ignoreNoResponse, ignoreNoResponseAnyway, ignore3PlusSDs, dualTasks, allTrialData)
    if (nargin ~= nargin('getCleanInhibitTrials_RF_1A3'))
        error('zError: getCleanInhibitTrials_RF_1A3 expects %d inputs, but received %d. Please update any calling code.\n', nargin('getCleanInhibitTrials_RF_1A3'), nargin);
    end
    if (dualTasks == true)
        error('getCleanInhibitTrials_RF_1A3: This function is only intended to return trials in single tasks. Use getCleanInhibitTrials_dualTasks_RF_1A3() for dual tasks.');
    else
        allTrialData = allTrialData(strcmpi(allTrialData.Cluster,'I'),:); % start with just the inihibt-shift trials
    end
    inhibitTrials = allTrialData(strcmpi(allTrialData.NextState,'INHIBIT'),:); % all "INHIBIT" trials are actual inhibit trials
    goTrials = allTrialData(strcmpi(allTrialData.NextState,'INHIBIT') == 0,:); % all non-INHIBIT trials are "Go" trials
    
    if (onlyCorrectGo == true) % delete Go trials where they didn't respond correctly
        goTrials(goTrials.Correct == false,:) = [];
        fprintf('getCleanInhibitTrials_RF_1A3: excluding all incorrect Go trials.\n');
    end
    
    if (strcmpi(ignoreNoResponseAnyway, 'all') == 1) % delete inhibit trials where they wouldn't have responded anyway
        inhibitTrials(strcmpi(inhibitTrials.PreInhExpResp,'NO_ACTION'),:) = [];
        fprintf('getCleanInhibitTrials_RF_1A3: excluding all Inhibit trials where the participant wouldnt have responded regardless.\n');
    elseif (strcmpi(ignoreNoResponseAnyway, 'correct') == 1) % delete only inhibit trials where they wouldn't have responded anyway that they got correct
        inhibitTrials(strcmpi(inhibitTrials.PreInhExpResp,'NO_ACTION') & inhibitTrials.Correct == true,:) = [];
        fprintf('getCleanInhibitTrials_RF_1A3: excluding correct Inhibit trials where the participant wouldnt have responded regardless.\n');        
    end
    
    if (strcmpi(ignoreNoResponse, 'GoBoth') == 1) % we're ignoring all cases where the subject didn't respond during a "Go" trial
        goTrials(strcmpi(goTrials.GivenResp,'NO_ACTION'),:) = []; % delete all Go trials where the subject didn't respond
        fprintf('getCleanInhibitTrials_RF_1A3: excluding all Go trials where the subject did not respond.\n');
    elseif (strcmpi(ignoreNoResponse, 'GoCorrect') == 1) % we're ignoring only Go trials where the subject was correct not to respond
        goTrials(strcmpi(goTrials.GivenResp,'NO_ACTION') & goTrials.Correct == true,:) = []; % delete them
        fprintf('getCleanInhibitTrials_RF_1A3: excluding Go trials where was correct to not respond.\n');
    elseif (strcmpi(ignoreNoResponse, 'GoWrong') == 1) % we're ignoring only Go trials where the subject should have responded but didn't
        goTrials(strcmpi(goTrials.GivenResp,'NO_ACTION') & goTrials.Correct == false,:) = []; % delete them
        fprintf('getCleanInhibitTrials_RF_1A3: excluding Go trials where the subject should have responded but did not.\n');
    else
        fprintf('getCleanInhibitTrials_RF_1A3: including all NoResponse Go trials.\n');
    end
    
    
    if (strcmpi(ignore3PlusSDs, 'Go') == 1) % we're ignoring Go trials where the reaction time was more than 3 standard deviations from the mean
        avgGoTime = mean(goTrials.RespTime);
        sdGoTime = std(goTrials.RespTime);
        goTrials(goTrials.RespTime > (avgGoTime + (3 * sdGoTime)),:) = []; % delete ones more than 3 SDs over the mean
        goTrials(goTrials.RespTime < (avgGoTime - (3 * sdGoTime)),:) = []; % delete ones more than 3 SDs below the mean
        
        fprintf('getCleanInhibitTrials_RF_1A3: excluding all Go trials where response time was more than 3SDs from the mean.\n');
    end


end
