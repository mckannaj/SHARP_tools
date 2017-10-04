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
% of subjects for 1B.
%
% If the "printTable" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the SSRTtable.
%
function [SSRTtable] = getSSRTthirds_RF_1B(goTrials, inhTrials, excludeSubjs, printTable)
    allSubjects = unique(goTrials.Subject);
    thirdsMat = [allSubjects(1), 2,3,4,5]; % this will be overwritten anyway, so just counting columns
    thirdsMatRow = 1; % the row of thirdsMat that we're on
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
% just for testing        fprintf('getSSRTthirds_RF_1B: analyzing subj %d.\n', subj);

        thirdsMat(thirdsMatRow, :) = [subj, 2,3,4,5]; % this will be overwritten anyway, so just counting columns
        
        subjGoTable = goTrials(goTrials.Subject == subj, :); % just get this subject's rows
        subjInhTable = inhTrials(inhTrials.Subject == subj, :); % just get this subject's rows
        
        firstThirdGo = subjGoTable(1:floor(height(subjGoTable)/3),:);
        firstThirdInh = subjInhTable(1:floor(height(subjInhTable)/3),:);
        firstThirdGo = sortrows(firstThirdGo, 'RespTime'); % put them in order by response time
        firstThirdInhErrs = height(firstThirdInh(firstThirdInh.Correct == false, 1)); % count all the error rows in a single column
        inhErrRate = firstThirdInhErrs / (height(firstThirdInh)); % errors / total inhibits
        pickThisGoTrial = floor(inhErrRate * height(firstThirdGo)); % now that they're sorted, this is the number of the threshold RT
        if (pickThisGoTrial == 0)
            pickThisGoTrial = 1;
            fprintf('getSSRTthirds_RF_1B: subj %d made no errors on first third of Inh trials; guessing the lowest possible RT value.\n', subj);
        end
        if (pickThisGoTrial >= height(firstThirdGo))
            pickThisGoTrial = height(firstThirdGo);
            fprintf('getSSRTthirds_RF_1B: subj %d made all errors on first third of Inh trials; guessing the highest possible RT value.\n', subj);
        end
        thresholdRT = firstThirdGo.RespTime(pickThisGoTrial); % this and everything before it are quicker than the SSRT+SSD
        
        SSDest = mean(firstThirdInh.InhDelayUsed); % should probably track this until it becomes stable rather than just taking the avg...
        SSRTfirstThird = thresholdRT - SSDest;
        
        lastThirdGo = subjGoTable(floor((height(subjGoTable)/3)*2):end,:);
        lastThirdInh = subjInhTable(floor((height(subjInhTable)/3)*2):end,:);
        lastThirdGo = sortrows(lastThirdGo, 'RespTime'); % put them in order by response time
        lastThirdInhErrs = height(lastThirdInh(lastThirdInh.Correct == false, 1)); % count all the error rows in a single column
        inhErrRate = lastThirdInhErrs / (height(lastThirdInh)); % errors / total inhibits
%        inhErrRate = inhErrRate + .1; % assume there should be ~10% more errors, since there's a hidden 20% "fast" Inhibit trials going into this number
        pickThisGoTrial = floor(inhErrRate * height(lastThirdGo)); % now that they're sorted, this is the number of the threshold RT
        if (pickThisGoTrial == 0)
            pickThisGoTrial = 1;
            fprintf('getSSRTthirds_RF_1B: subj %d made no errors on last third of Inh trials; guessing the lowest possible RT value.\n', subj);
        end
        if (pickThisGoTrial >= height(lastThirdGo))
            pickThisGoTrial = height(lastThirdGo);
            fprintf('getSSRTthirds_RF_1B: subj %d made all errors on last third of Inh trials; guessing the highest possible RT value.\n', subj);
        end
        thresholdRT = lastThirdGo.RespTime(pickThisGoTrial); % this and everything before it are quicker than the SSRT+SSD
        SSDest = mean(lastThirdInh.InhDelayUsed); % should probably track this until it becomes stable rather than just taking the avg...
        SSRTlastThird = thresholdRT - SSDest;
        
        totalGo = subjGoTable;
        totalInh = subjInhTable;
        totalGo = sortrows(totalGo, 'RespTime'); % put them in order by response time
        totalInhErrs = height(totalInh(totalInh.Correct == false, 1)); % count all the error rows in a single column
        inhErrRate = totalInhErrs / (height(totalInh)); % errors / total inhibits
        pickThisGoTrial = floor(inhErrRate * height(totalGo)); % now that they're sorted, this is the number of the threshold RT
        if (pickThisGoTrial == 0)
            pickThisGoTrial = 1;
            fprintf('getSSRTthirds_RF_1B: subj %d made no errors at all during Inh trials; guessing the lowest possible RT value.\n', subj);
        end
        if (pickThisGoTrial >= height(totalGo))
            pickThisGoTrial = height(totalGo);
            fprintf('getSSRTthirds_RF_1B: subj %d made all errors during Inh trials; guessing the highest possible RT value.\n', subj);
        end
        thresholdRT = totalGo.RespTime(pickThisGoTrial); % this and everything before it are quicker than the SSRT+SSD
        SSDest = mean(totalInh.InhDelayUsed); % should probably track this until it becomes stable rather than just taking the avg...
        SSRTtotal = thresholdRT - SSDest;
                
        SSRTdelta = SSRTlastThird - SSRTfirstThird;
        
        thirdsMat(thirdsMatRow, 1) = subj; % redundant, but shows what the first col is
        thirdsMat(thirdsMatRow, 2) = SSRTfirstThird;
        thirdsMat(thirdsMatRow, 3) = SSRTlastThird;
        thirdsMat(thirdsMatRow, 4) = SSRTdelta;
        thirdsMat(thirdsMatRow, 5) = SSRTtotal;

        thirdsMatRow = thirdsMatRow + 1; % get ready to write the next row
    end
    
    SSRTtable = array2table(thirdsMat, 'VariableNames', {'Subject','FirstThirdSSRT','LastThirdSSRT','DeltaSSRT','TotalSSRT'});
    
    if (excludeSubjs == true)
        SSRTtable = excludeSubjects_RF_1B(false, false, SSRTtable);
    end
    
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getSSRTthirds_RF_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(SSRTtable, fileName);
    end

end


