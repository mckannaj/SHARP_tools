% Zephy McKanna
% 11/14/14
%
% This function takes the two cleaned matrices output from
% getCleanInhibitTrials_RF_1A3() - correct Go trials and all Inhibit trials
% - and uses them to calculate the SSRT for the first and last thirds of
% each subject.
%
% It outputs a table with four columns: subj, firstThirdSSRT,
% lastThirdSSRT, and deltaSSRT.
% deltaSSRT is simply the difference between the first and last thirds.
%
% If the "excludeSubjs" flag is set, we also exclude the decided-upon list
% of subjects for 1A-3.
%
function [SSRTtable] = getSSRTthirds2_RF_1A3(goTrials, inhTrials, excludeSubjs)
    allSubjects = unique(goTrials.Subject);
    thirdsMat = [allSubjects(1), 2,3,4]; % this will be overwritten anyway, so just counting columns
    thirdsMatRow = 1; % the row of thirdsMat that we're on
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        thirdsMat(thirdsMatRow, :) = [subj, 2,3,4]; % this will be overwritten anyway, so just counting columns
        
        subjGoTable = goTrials(goTrials.Subject == subj, :); % just get this subject's rows
        subjInhTable = inhTrials(inhTrials.Subject == subj, :); % just get this subject's rows
        
        firstThirdGo = subjGoTable(1:floor(height(subjGoTable)/3),:);
        firstThirdInh = subjInhTable(1:floor(height(subjInhTable)/3),:);
        firstThirdGo = sortrows(firstThirdGo, 'RespTime'); % put them in order by response time
        firstThirdInhErrs = height(firstThirdInh(firstThirdInh.Correct == false, 1)); % count all the error rows in a single column
        if (firstThirdInhErrs == 0) % they never made an error
            fprintf('getSSRTthirds_RF_1A3: subj %d made no errors on first third of Inh trials; putting in -9999 for values to indicate exclusion.\n', subj);
            SSRTfirstThird = -9999;
        elseif (firstThirdInhErrs >= height(firstThirdInh))
            fprintf('getSSRTthirds_RF_1A3: subj %d made all errors on first third of Inh trials; putting in -9999 for values to indicate exclusion.\n', subj);
            SSRTfirstThird = -9999;
        else % normal number of errors
            inhErrRate = firstThirdInhErrs / (height(firstThirdInh)); % errors / total inhibits
%        inhErrRate = inhErrRate + .2; % assume there should be ~20% more errors, since there's a hidden 20% "fast" Inhibit trials going into this number
            pickThisGoTrial = floor(inhErrRate * height(firstThirdGo)); % now that they're sorted, this is the number of the threshold RT
%        if (pickThisGoTrial == 0)
%            pickThisGoTrial = 1;
%            fprintf('getSSRTthirds_RF_1A3: subj %d made no errors on first third of Inh trials; guessing the lowest possible RT value.\n', subj);
%        end
%        if (pickThisGoTrial >= height(firstThirdGo))
%            pickThisGoTrial = height(firstThirdGo);
%            fprintf('getSSRTthirds_RF_1A3: subj %d made all errors on first third of Inh trials; guessing the highest possible RT value.\n', subj);
%        end
            thresholdRT = firstThirdGo.RespTime(pickThisGoTrial); % this and everything before it are quicker than the SSRT+SSD
        
            % NOTE: we should make a function to better estimate the SSD, based 
            % on the fact that it gets unfairly bumped up every time they get a 
            % quick Inhibit signal and every time they would've given
            % No_Response anyway!!!
            SSDest = mean(firstThirdInh.CurrentInhDelta); % should probably track this until it becomes stable rather than just taking the avg...
            SSRTfirstThird = thresholdRT - SSDest;
        end
        
        lastThirdGo = subjGoTable(floor((height(subjGoTable)/3)*2):end,:);
        lastThirdInh = subjInhTable(floor((height(subjInhTable)/3)*2):end,:);
        lastThirdGo = sortrows(lastThirdGo, 'RespTime'); % put them in order by response time
        lastThirdInhErrs = height(lastThirdInh(lastThirdInh.Correct == false, 1)); % count all the error rows in a single column
        if (lastThirdInhErrs == 0) % they never made an error
            fprintf('getSSRTthirds_RF_1A3: subj %d made no errors on last third of Inh trials; putting in -9999 for values to indicate exclusion.\n', subj);
            SSRTlastThird = -9999;
        elseif (lastThirdInhErrs >= height(lastThirdInh))
            fprintf('getSSRTthirds_RF_1A3: subj %d made all errors on last third of Inh trials; putting in -9999 for values to indicate exclusion.\n', subj);
            SSRTlastThird = -9999;
        else % normal number of errors
            inhErrRate = lastThirdInhErrs / (height(lastThirdInh)); % errors / total inhibits
%        inhErrRate = inhErrRate + .2; % assume there should be ~10% more errors, since there's a hidden 20% "fast" Inhibit trials going into this number
            pickThisGoTrial = floor(inhErrRate * height(lastThirdGo)); % now that they're sorted, this is the number of the threshold RT
%        if (pickThisGoTrial == 0)
%            pickThisGoTrial = 1;
%            fprintf('getSSRTthirds_RF_1A3: subj %d made no errors on last third of Inh trials; guessing the lowest possible RT value.\n', subj);
%        end
%        if (pickThisGoTrial >= height(firstThirdGo))
%            pickThisGoTrial = height(firstThirdGo);
%            fprintf('getSSRTthirds_RF_1A3: subj %d made all errors on last third of Inh trials; guessing the highest possible RT value.\n', subj);
%        end
            thresholdRT = lastThirdGo.RespTime(pickThisGoTrial); % this and everything before it are quicker than the SSRT+SSD
            SSDest = mean(lastThirdInh.CurrentInhDelta); % should probably track this until it becomes stable rather than just taking the avg...
            SSRTlastThird = thresholdRT - SSDest;
        end
%{        
        % TESTING
        if (subj == 2325)
            firstThirdGo.RespTime
            firstThirdInh.GivenResp
            firstThirdInh.CurrentInhDelta
            median(firstThirdInh.CurrentInhDelta)
            firstThirdInh.RespTime
            firstThirdInh.Problem
            firstThirdGo.RespTime(floor((firstThirdInhErrs / (height(firstThirdInh))) * height(firstThirdGo))) % threshold RT
        end
%}        
        SSRTdelta = SSRTlastThird - SSRTfirstThird;
        
        thirdsMat(thirdsMatRow, 1) = subj; % redundant, but shows what the first col is
        thirdsMat(thirdsMatRow, 2) = SSRTfirstThird;
        thirdsMat(thirdsMatRow, 3) = SSRTlastThird;
        thirdsMat(thirdsMatRow, 4) = SSRTdelta;

        thirdsMatRow = thirdsMatRow + 1; % get ready to write the next row
    end
    
    SSRTtable = array2table(thirdsMat, 'VariableNames', {'Subject','FirstThirdSSRT','LastThirdSSRT','DeltaSSRT'});
    
    if (excludeSubjs == true)
        SSRTtable = excludeSubjects_RF_1A3('both', SSRTtable);
    end
end


