% Zephy McKanna
% excludeSubjects_RF_1B
% 4/16/15
%
% This function takes a table containing a "Subject" column, and removes
% data from the following subjects (agreed to be excluded from 1B):
% 
% If the justRF flag is set to true, then we will also exclude all subjects
% that were not in [one of] the RobotFactory training group[s]. We do this
% by checking a "Condition" column, and expecting the first two characters
% to be 'RF' in that column if this person actually played RobotFactory
% (examples: 'RF tDCS', 'RF tDCS sham', 'RF tRNS', 'RF tRNS sham').
%   zNOTE: AT SOME POINT, WE SHOULD PROBABLY JUST SEARCH FOR 'RF' THROUGHOUT THE STRING...! 
%
% It returns the original table, less the rows of those subjects.
%
function [tableWithoutExcludedSubjects] = excludeSubjects_RF_1B(justRF, onlyFinished, noChancePerformance, fullData)
    tableWithoutExcludedSubjects = fullData;
    
    % always remove subjects that we agreed should be globally excluded (11/22/15) 
    delMe = [101 ;110 ;115 ;119 ;208 ;230 ;242 ;251 ;267 ;299 ;302 ;319 ;331 ;332 ;343 ;421 ;426 ;451 ;74 ;80];
    tableWithoutExcludedSubjects(ismember(tableWithoutExcludedSubjects.Subject, delMe),:) = [];

% ZEPHY: presumably, do this eventually...?
%    tableWithoutExcludedSubjects(strncmpi(tableWithoutExcludedSubjects.Status, 'Dropped'), :) = []; % remove dropped subjs regardless

    if (justRF == true)
        fprintf('excludeSubjects_RF_1B: only returning subjects with RF in the Condition.\n');
        tableWithoutExcludedSubjects = tableWithoutExcludedSubjects(strncmpi(tableWithoutExcludedSubjects.Condition, 'RF', 2), :);
    end
    
    if (onlyFinished == true) % note that this includes "Finished" and "Finished*"; not sure what the second one is...
        fprintf('excludeSubjects_RF_1B: only returning subjects with Finished in the Status.\n');
        tableWithoutExcludedSubjects = tableWithoutExcludedSubjects(strncmpi(tableWithoutExcludedSubjects.Status, 'Finished', 8), :);
    end
    
    % check for exclusions based on chance performance on PP or RF single-EF 
    if (strcmpi(noChancePerformance, 'inhibit')) % remove subjects who were noncompliant on inhibit
        fprintf('excludeSubjects_RF_1B: excluding chance performers in Inhibit.\n');
        delMe = [12; 157; 174; 220; 242; 419; 669; 134; 152; 270; 496; 607; 673; 775; 10; 90; 554; 587; 663; 338; 771; 41; 199; 435; 562; 707; 737];
        tableWithoutExcludedSubjects(ismember(tableWithoutExcludedSubjects.Subject, delMe),:) = [];
    elseif (strcmpi(noChancePerformance, 'update')) % remove subjects who were noncompliant on update
        fprintf('excludeSubjects_RF_1B: excluding chance performers in Update.\n');
        delMe2 = [496; 572; 644; 669; 771; 199];
        tableWithoutExcludedSubjects(ismember(tableWithoutExcludedSubjects.Subject, delMe2),:) = [];
    elseif (strcmpi(noChancePerformance, 'switch')) % remove subjects who were noncompliant on switch
        fprintf('excludeSubjects_RF_1B: excluding chance performers in Switch.\n');
        delMe3 = [10; 41; 69; 81; 254; 275; 419; 450; 474; 532; 679; 685; 50; 137; 195; 199; 208; 291; 312; 345; 476; 496; 499; 526; 562; 572; 586; 634; 644; 669; 673; 701; 707; 781; 40; 88; 241; 270; 404; 412; 435; 663; 718; 737; 744; 749; 771];
        tableWithoutExcludedSubjects(ismember(tableWithoutExcludedSubjects.Subject, delMe3),:) = [];
    elseif (strcmpi(noChancePerformance, 'all')) % remove all subjects that have any noncompliant / chance performance sections
        fprintf('excludeSubjects_RF_1B: excluding all chance performers.\n');
        delMe = [12; 157; 174; 220; 242; 419; 669; 134; 152; 270; 496; 607; 673; 775; 10; 90; 554; 587; 663; 338; 771; 41; 199; 435; 562; 707; 737];
        tableWithoutExcludedSubjects(ismember(tableWithoutExcludedSubjects.Subject, delMe),:) = [];
        delMe2 = [496; 572; 644; 669; 771; 199];
        tableWithoutExcludedSubjects(ismember(tableWithoutExcludedSubjects.Subject, delMe2),:) = [];
        delMe3 = [10; 41; 69; 81; 254; 275; 419; 450; 474; 532; 679; 685; 50; 137; 195; 199; 208; 291; 312; 345; 476; 496; 499; 526; 562; 572; 586; 634; 644; 669; 673; 701; 707; 781; 40; 88; 241; 270; 404; 412; 435; 663; 718; 737; 744; 749; 771];
        tableWithoutExcludedSubjects(ismember(tableWithoutExcludedSubjects.Subject, delMe3),:) = [];
    end
     
    % regardless, we're excluding the ones who dropped out... (none so far?) 

end
