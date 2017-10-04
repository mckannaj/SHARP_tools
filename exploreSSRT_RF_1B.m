% Zephy McKanna
% exploreSSRT_RF_1B
% 8_24_15
%
% This function attempts to explore and explain what participants to
% exclude from SSRT calculations due to unusual performance in RF.
%
% This is a modification of exploreSSRT_1B() that only deals with
% RobotFactory, intended to help us exclude certain subjects for unusual /
% noncompliant RF performance when using formalizedFishing().
% 
function [RF_FailedCatchTable, RF_FailedGoTable] = exploreSSRT_RF_1B(SSRT_RF_table)
% find people who failed a lot of Catch trials in RFinhibit 
    % mean(SSRT_RF_firstShifts_table.CorrectCatchPct) % ~.79
    % catchCutoff = mean(SSRT_RF_firstShifts_table.CorrectCatchPct) - (2 * std(SSRT_RF_firstShifts_table.CorrectCatchPct)); % = ~.4
    catchCutoff = .5; % since formalizedFishing() may use small/unusual numbers of trials, just assume the cutoff from the larger group is appropriate
    RF_FailedCatchTable = SSRT_RF_table(SSRT_RF_table.CorrectCatchPct < catchCutoff,:);
    % scatter(SSRT_RF_firstShifts_table.Subject, SSRT_RF_firstShifts_table.CorrectCatchPct)

% find people who failed a lot of Go trials in RFinhibit 
    % mean(SSRT_RF_firstShifts_table.CorrectGoPct) % ~.90
    % goCutoff = mean(SSRT_RF_firstShifts_table.CorrectGoPct) - (2 * std(SSRT_RF_firstShifts_table.CorrectGoPct)); % = ~.76
    goCutoff = .75; % since formalizedFishing() may use small/unusual numbers of trials, just use the cutoff from the larger group
    RF_FailedGoTable = SSRT_RF_table(SSRT_RF_table.CorrectGoPct < goCutoff,:);
    % scatter(SSRT_RF_firstShifts_table.Subject, SSRT_RF_firstShifts_table.CorrectGoPct)

end
