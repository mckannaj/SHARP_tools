

% quickest way to get all the data (except subjs who didn't finish)
zRF_1B = runFunctionWithRFblocks_1Output_1B('excludeSubjects_RF_1B','true, true, false, XXXXX');



% Count the number of trials in various conditions, for Misha 

% get a count of the number of trials that each subject encountered
delMe = [0 0];
delMe2 = unique(justFinished_1B.Subject);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % subj
    delMe(delMe3,:) = [delMe4 height(justFinished_1B(justFinished_1B.Subject == delMe4, 1:3))];
end
writetable(array2table(delMe), getFileNameForThisOS('subj-trialCount_1B.csv', 'IntResults'));

% get a count of the number of trials of each different N value
delMe = [0 0 0];
delMe2 = unique(justFinished_1B.NbackDifficulty);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % N value
    delMe5 = justFinished_1B(justFinished_1B.NbackDifficulty == delMe4, 'Subject'); % trials (with just a single column)
    delMe(delMe3,:) = [delMe4 length(unique(delMe5.Subject)) height(delMe5)];
end
writetable(array2table(delMe), getFileNameForThisOS('subj-trialCount_1B.csv', 'IntResults')); % note that this is reusing the filename

% get a count of the number of trials of each different switch flags value
delMe = [0 0 0];
delMe2 = unique(justFinished_1B.SwitchFlag);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % N value
    delMe5 = justFinished_1B(justFinished_1B.SwitchFlag == delMe4, 'Subject'); % trials (with just a single column)
    delMe(delMe3,:) = [delMe4 length(unique(delMe5.Subject)) height(delMe5)];
end
writetable(array2table(delMe), getFileNameForThisOS('subj-trialCount_1B.csv', 'IntResults')); % note that this is reusing the filename

% get a count of the number of trials of each different number of EFs
delMe = [0 0 0];
delMe2 = unique(justFinished_1B.numOfEFsInThisTrial);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % N value
    delMe5 = justFinished_1B(justFinished_1B.numOfEFsInThisTrial == delMe4, 'Subject'); % trials (with just a single column)
    delMe(delMe3,:) = [delMe4 length(unique(delMe5.Subject)) height(delMe5)];
end
writetable(array2table(delMe), getFileNameForThisOS('subj-trialCount_1B.csv', 'IntResults')); % note that this is reusing the filename

% get a count of the number of trials of logic or no logic
delMe = [0 0 0];
delMe2 = unique(justFinished_1B.anyLogicFlag);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % N value
    delMe5 = justFinished_1B(justFinished_1B.anyLogicFlag == delMe4, 'Subject'); % trials (with just a single column)
    delMe(delMe3,:) = [delMe4 length(unique(delMe5.Subject)) height(delMe5)];
end
writetable(array2table(delMe), getFileNameForThisOS('subj-trialCount_1B.csv', 'IntResults')); % note that this is reusing the filename

% get a count of the number of trials of each different switch hands value
delMe = [0 0 0];
delMe2 = unique(justFinished_1B.SwitchHandsFlag);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % N value
    delMe5 = justFinished_1B(justFinished_1B.SwitchHandsFlag == delMe4, 'Subject'); % trials (with just a single column)
    delMe(delMe3,:) = [delMe4 length(unique(delMe5.Subject)) height(delMe5)];
end
writetable(array2table(delMe), getFileNameForThisOS('subj-trialCount_1B.csv', 'IntResults')); % note that this is reusing the filename

% get a count of the number of trials of each different timeout value
delMe = [0 0 0 0.0];
delMe2 = unique(justFinished_1B.StimShowTime);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % N value
    delMe5 = justFinished_1B(justFinished_1B.StimShowTime == delMe4, :); % trials 
    delMe(delMe3,:) = [delMe4 length(unique(delMe5.Subject)) height(delMe5) mean(delMe5.RespTime)];
end
writetable(array2table(delMe), getFileNameForThisOS('subj-trialCount_1B.csv', 'IntResults')); % note that this is reusing the filename



% merge the iso_estimates (and logits) to the regular SUM file
zRFSum_1B.init_ISOest = zeros(height(zRFSum_1B),1);
zRFSum_1B.logit_init_ISOest = zeros(height(zRFSum_1B),1);
zRFSum_1B.end_ISOest = zeros(height(zRFSum_1B),1);
zRFSum_1B.logit_end_ISOest = zeros(height(zRFSum_1B),1);
delMe2 = unique(zRFSum_1B.Subject);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % subj
    fprintf('Merging subject %d.\n', delMe4);
    delMe5 = zRFSum_1B(zRFSum_1B.Subject == delMe4, :); % subjTrials: SUM
    delMe6 = zIsoShiftEstimates_1B(zIsoShiftEstimates_1B.Subject == delMe4, :); % subjTrials: ISO
    if (height(delMe5) ~= height(delMe6))
        fprintf('Weird mismatch in iso and sum files; subj = %d has %d shifts in SUM and %d shifts in ISO. ESTIMATES FOR THIS SUBJECT MAY BE OFF!\n', delMe4, height(delMe5), height(delMe6));
    end
    if (length(unique(delMe5.ShiftNum)) < length(unique(delMe6.ShiftNum)))
        delMe7 = unique(delMe5.ShiftNum);
    else % hopefully they have the same number; worst case, ISO has fewer
        delMe7 = unique(delMe6.ShiftNum);
    end
    for delMe8 = 1:length(delMe7)
        delMe9 = delMe7(delMe8); % shiftNum
        zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.ShiftNum == delMe9), :).init_ISOest = ...
            zIsoShiftEstimates_1B((zIsoShiftEstimates_1B.Subject == delMe4) & (zIsoShiftEstimates_1B.ShiftNum == delMe9), :).init_ISOest;
        zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.ShiftNum == delMe9), :).logit_init_ISOest = ...
            zIsoShiftEstimates_1B((zIsoShiftEstimates_1B.Subject == delMe4) & (zIsoShiftEstimates_1B.ShiftNum == delMe9), :).logit_init_ISOest;
        zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.ShiftNum == delMe9), :).end_ISOest = ...
            zIsoShiftEstimates_1B((zIsoShiftEstimates_1B.Subject == delMe4) & (zIsoShiftEstimates_1B.ShiftNum == delMe9), :).end_ISOest;        
        zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.ShiftNum == delMe9), :).logit_end_ISOest = ...
            zIsoShiftEstimates_1B((zIsoShiftEstimates_1B.Subject == delMe4) & (zIsoShiftEstimates_1B.ShiftNum == delMe9), :).logit_end_ISOest;        
    end
end





% merge the kernel_regressed logit estimates to the regular SUM file
zRFSum_1B.init_KernelLogit = zeros(height(zRFSum_1B),1);
zRFSum_1B.end_KernelLogit = zeros(height(zRFSum_1B),1);
zRFSum_1B.end_KernelLogit_AllPositive = zeros(height(zRFSum_1B),1);
delMe2 = unique(zRFSum_1B.Subject);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % subj
    fprintf('Merging subject %d.\n', delMe4);
    delMe5 = zRFSum_1B(zRFSum_1B.Subject == delMe4, :); % subjTrials: SUM
    delMe6 = zKernelShiftEstimates_1B(zKernelShiftEstimates_1B.Subject == delMe4, :); % subjTrials: ISO
    if (height(delMe5) ~= height(delMe6))
        fprintf('Weird mismatch in iso and sum files; subj = %d has %d shifts in SUM and %d shifts in ISO. ESTIMATES FOR THIS SUBJECT MAY BE OFF!\n', delMe4, height(delMe5), height(delMe6));
    end
    if (length(unique(delMe5.ShiftNum)) < length(unique(delMe6.ShiftNum)))
        delMe7 = unique(delMe5.ShiftNum);
    else % hopefully they have the same number; worst case, ISO has fewer
        delMe7 = unique(delMe6.ShiftNum);
    end
    for delMe8 = 1:length(delMe7)
        delMe9 = delMe7(delMe8); % shiftNum
        zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.ShiftNum == delMe9), :).init_KernelLogit = ...
            zKernelShiftEstimates_1B((zKernelShiftEstimates_1B.Subject == delMe4) & (zKernelShiftEstimates_1B.ShiftNum == delMe9), :).init_KernelLogit;
        zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.ShiftNum == delMe9), :).end_KernelLogit = ...
            zKernelShiftEstimates_1B((zKernelShiftEstimates_1B.Subject == delMe4) & (zKernelShiftEstimates_1B.ShiftNum == delMe9), :).end_KernelLogit;
        zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.ShiftNum == delMe9), :).end_KernelLogit_AllPositive = ...
            zKernelShiftEstimates_1B((zKernelShiftEstimates_1B.Subject == delMe4) & (zKernelShiftEstimates_1B.ShiftNum == delMe9), :).end_KernelLogit_AllPositive;        
    end
end






% If you want to remove all JumpBack = NaN rows from the SUM file: 
delMe = zRFSum_1B;
delMe(any(cellfun(@(x) numel(x)==1 & isnumeric(x) && isnan(x),delMe.JumpBack),2),:) = [];
delMe.JumpBack % look to prove it to yourself





% run Overall_Ability GLM on the ECE Swing server
delMe = zRF_1B(zRF_1B.StimShowTime < 5,:);
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_1B = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,8],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
printGLMcoeffs(RF_EFmodel_1B, true);





% Get the average accuracy for each participant, for U/I/S alone, before and after completing the cluster (using jump-backs for after)  
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe = delMe(strcmpi(delMe.Cluster, 'U'), :);
delMe = delMe(strcmpi(delMe.Cluster, 'I'), :);
delMe = delMe(strcmpi(delMe.Cluster, 'S'), :);
delMe.beforeOrAfterComplete = zeros(height(delMe),1); % start with everything being "before"
delMe2 = unique(delMe.Subject); % all subjs
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % subj
%    fprintf('Adding Before Or After to subject %d.\n', delMe4);
    delMe5 = delMe(delMe.Subject == delMe4, :); % subjShifts
    delMe6 = 0; % indicator as to whether we're before or after the completion of this shift
    for delMe7 = 1:height(delMe5)
        if (isnan(delMe5.ClusterComplete{delMe7}) == 0) % this cluster was completed at this shift
            delMe8 = delMe5.ShiftNum(delMe7); % shiftNum at which this cluster was completed
            delMe((delMe.Subject == delMe4) & (delMe.ShiftNum == delMe8),:).beforeOrAfterComplete = 1; % mark this shift as the completed one
            delMe((delMe.Subject == delMe4) & (delMe.ShiftNum > delMe8),:).beforeOrAfterComplete = ...
                ones(height(delMe5(delMe5.ShiftNum > delMe8,:)),1) + 1; % mark all following shifts as after completion
            break; % no need to check the remaining shifts; can only complete once
        end
    end
end
% now that delMe has the shift info plus "beforeOrAfterComplete" info, build a day-by-day matrix of pre and post completion averages 
delMe(isnan(delMe.Accuracy),:) = [];
mean(delMe(delMe.beforeOrAfterComplete == 0,:).Accuracy)
mean(delMe(delMe.beforeOrAfterComplete == 1,:).Accuracy)
mean(delMe(delMe.beforeOrAfterComplete == 2,:).Accuracy)

% Get the day from the ShiftNum (note: should probably use the date instead...) 
delMe.TrainingDay = zeros(height(delMe),1);
delMe((delMe.ShiftNum >= 1) & (delMe.ShiftNum <= 20), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 1) & (delMe.ShiftNum <= 20), :)),1) + 1; % day 1
delMe((delMe.ShiftNum >= 21) & (delMe.ShiftNum <= 40), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 21) & (delMe.ShiftNum <= 40), :)),1) + 2; % day 2
delMe((delMe.ShiftNum >= 41) & (delMe.ShiftNum <= 60), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 41) & (delMe.ShiftNum <= 60), :)),1) + 3; % day 3
delMe((delMe.ShiftNum >= 61) & (delMe.ShiftNum <= 80), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 61) & (delMe.ShiftNum <= 80), :)),1) + 4; % day 4
delMe((delMe.ShiftNum >= 81) & (delMe.ShiftNum <= 100), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 81) & (delMe.ShiftNum <= 100), :)),1) + 5; % day 5
delMe((delMe.ShiftNum >= 101) & (delMe.ShiftNum <= 120), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 101) & (delMe.ShiftNum <= 120), :)),1) + 6; % day 6
delMe((delMe.ShiftNum >= 121) & (delMe.ShiftNum <= 140), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 121) & (delMe.ShiftNum <= 140), :)),1) + 7; % day 7
delMe((delMe.ShiftNum >= 141) & (delMe.ShiftNum <= 160), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 141) & (delMe.ShiftNum <= 160), :)),1) + 8; % day 8
delMe((delMe.ShiftNum >= 161) & (delMe.ShiftNum <= 180), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 161) & (delMe.ShiftNum <= 180), :)),1) + 9; % day 9
delMe((delMe.ShiftNum >= 181) & (delMe.ShiftNum <= 200), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 181) & (delMe.ShiftNum <= 200), :)),1) + 10; % day 10
delMe((delMe.ShiftNum >= 201) & (delMe.ShiftNum <= 220), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 201) & (delMe.ShiftNum <= 220), :)),1) + 11; % day 11
delMe((delMe.ShiftNum >= 221) & (delMe.ShiftNum <= 240), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 221) & (delMe.ShiftNum <= 240), :)),1) + 12; % day 12
delMe((delMe.ShiftNum >= 241) & (delMe.ShiftNum <= 260), :).TrainingDay = zeros(height(delMe((delMe.ShiftNum >= 241) & (delMe.ShiftNum <= 260), :)),1) + 13; % day 13

delMe2 = [];
for delMe7 = 1:13
    delMe3 = delMe((delMe.TrainingDay == delMe7) & (delMe.beforeOrAfterComplete == 0), :);
    delMe4 = delMe((delMe.TrainingDay == delMe7) & (delMe.beforeOrAfterComplete == 1), :);
    delMe5 = delMe((delMe.TrainingDay == delMe7) & (delMe.beforeOrAfterComplete == 2), :);
    delMe2 = [delMe2; delMe7 length(unique(delMe3.Subject)) mean(delMe3.Accuracy) ...
        length(unique(delMe4.Subject)) mean(delMe4.Accuracy) length(unique(delMe5.Subject)) mean(delMe5.Accuracy)];
end
delMe2


% check and see if there are any negatives in any of the average transitions
delMe4 = AVGshiftIsoTransitions_1B; % replace this with whatever transitions you want to look at
for delMe5 = 1:height(delMe4) % row
    for delMe6 = 1:width(delMe4) % col
        if (~isnan(AVGshiftIsoTransitions_1B{delMe5, delMe6}))
            if (AVGshiftIsoTransitions_1B{delMe5, delMe6} < 0)
                fprintf('Found one at %d, %d.\n',delMe5, delMe6);
            end
        end
    end
end



% insert "training day" into the SUM file
zRFSum_1B.trainingDay = zeros(height(zRFSum_1B),1);
delMe2 = unique(zRFSum_1B.Subject);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % subj
    fprintf('Inserting training days for subject %d.\n', delMe4);
    delMe5 = zRFSum_1B(zRFSum_1B.Subject == delMe4, :); % subjTrials: SUM
    delMe6 = 0; % training day
    
    delMe7 = unique(delMe5.Date);
    for delMe8 = 1:length(delMe7)
        delMe6 = delMe6 + 1; % each unique date is its own training day, presumably
        delMe9 = delMe7(delMe8); % date
        zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.Date == delMe9), :).trainingDay = ...
            zeros(height(zRFSum_1B((zRFSum_1B.Subject == delMe4) & (zRFSum_1B.Date == delMe9), :)),1) + delMe6;
    end
    if (delMe6 > 11)
        fprintf('Subject %d had %d training days!(?).\n', delMe4, delMe6);
    end
end


% Create "days before completing U/S/I" and "shifts before completing U/S/I" matrices
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B);
delMe = unique(delMe.Subject); % we will build this up to the full matrix, but might as well start with subjects in col 1
delMe(:,2:7) = zeros(length(delMe(:,1)),6) - 1; % for the other 6 cols, insert -1s to indicate we haven't seen this yet
for delMe2 = 1:length(delMe(:,1))
    delMe3 = delMe(delMe2, 1); % subj
    delMe4 = [-1 -1 -1 -1 -1 -1]; % daysBeforeThisSubjPassed_U S I shiftsBeforeThisSubjPassed_U S I
    delMe5 = 0; % daysCount
    delMe6 = [0 0 0]; % UshiftsCount SshiftsCount IshiftsCount
    delMe7 = zRFSum_1B(zRFSum_1B.Subject == delMe3, :); % subjTrials from SUM file
    for delMe8 = 1:height(delMe7) % for each shift
        delMe9 = delMe7(delMe8, :); % shift
        if (strcmpi(delMe9.Cluster, 'U')) % this shift is a U
            if (isnan(delMe9.ClusterComplete{1}) == 0) % this shift completed U
                if (delMe4(1, 1) == -1) % we haven't seen a passed U before, so this must be the first one
                    delMe4(1, 1) = delMe9.trainingDay - 1; % record the days before we saw this
                end
                if (delMe4(1, 4) == -1) % we haven't seen a passed U before, so this must be the first one
                    delMe4(1, 4) = delMe6(1, 1); % record the U shifts seen before we saw this
                end
            end
            delMe6(1, 1) = delMe6(1, 1) + 1; % regardless, we saw another U shift, so count it
        elseif (strcmpi(delMe9.Cluster, 'S')) % this shift is a S
            if (isnan(delMe9.ClusterComplete{1}) == 0) % this shift completed S
                if (delMe4(1, 2) == -1) % we haven't seen a passed S before, so this must be the first one
                    delMe4(1, 2) = delMe9.trainingDay - 1; % record the days before we saw this
                end
                if (delMe4(1, 5) == -1) % we haven't seen a passed S before, so this must be the first one
                    delMe4(1, 5) = delMe6(1, 2); % record the S shifts seen before we saw this
                end
            end
            delMe6(1, 2) = delMe6(1, 2) + 1; % regardless, we saw another S shift, so count it
        elseif (strcmpi(delMe9.Cluster, 'I')) % this shift is a I
            if (isnan(delMe9.ClusterComplete{1}) == 0) % this shift completed I
                if (delMe4(1, 3) == -1) % we haven't seen a passed I before, so this must be the first one
                    delMe4(1, 3) = delMe9.trainingDay - 1; % record the days before we saw this
                end
                if (delMe4(1, 6) == -1) % we haven't seen a passed I before, so this must be the first one
                    delMe4(1, 6) = delMe6(1, 3); % record the I shifts seen before we saw this
                end
            end
            delMe6(1, 3) = delMe6(1, 3) + 1; % regardless, we saw another I shift, so count it
        end % end counting to U/I/S specifically
    end
    if ( (delMe4(1, 1) == -1) && (delMe4(1, 4) == -1) ) % never completed U
        fprintf('Subject %d never completed U.\n', delMe9.Subject);
        delMe4(1, 1) = max(delMe7.trainingDay); % so they saw all training days before passing it
        delMe4(1, 4) = delMe6(1, 1); % so all U shifts were seen before completing it
    end
    if ( (delMe4(1, 2) == -1) && (delMe4(1, 5) == -1) ) % never completed S
        fprintf('Subject %d never completed S.\n', delMe9.Subject);
        delMe4(1, 2) = max(delMe7.trainingDay); % so they saw all training days before passing it
        delMe4(1, 5) = delMe6(1, 2); % so all S shifts were seen before completing it
    end
    if ( (delMe4(1, 3) == -1) && (delMe4(1, 6) == -1) ) % never completed I
        fprintf('Subject %d never completed I.\n', delMe9.Subject);
        delMe4(1, 3) = max(delMe7.trainingDay); % so they saw all training days before passing it
        delMe4(1, 6) = delMe6(1, 3); % so all I shifts were seen before completing it
    end
    if (delMe4(1, 1) == -1) % never completed U 
        fprintf('Somehow subject %d completed U after some shifts but not after some days...???\n', delMe9.Subject);
    end
    if (delMe4(1, 2) == -1) % never completed S
        fprintf('Somehow subject %d completed U after some shifts but not after some days...???\n', delMe9.Subject);
    end
    if (delMe4(1, 3) == -1) % never completed I
        fprintf('Somehow subject %d completed U after some shifts but not after some days...???\n', delMe9.Subject);
    end
    if (delMe4(1, 4) == -1) % never completed U 
        fprintf('Somehow subject %d completed U after some days but not after some shifts...???\n', delMe9.Subject);
    end
    if (delMe4(1, 5) == -1) % never completed S
        fprintf('Somehow subject %d completed U after some days but not after some shifts...???\n', delMe9.Subject);
    end
    if (delMe4(1, 6) == -1) % never completed I
        fprintf('Somehow subject %d completed U after some days but not after some shifts...???\n', delMe9.Subject);
    end

    delMe(delMe(:,1) == delMe9.Subject, 2:7) = delMe4(1, 1:6);
    
    fprintf('Subject %d: Days: U=%d, S=%d, I=%d; Shifts: U=%d, S=%d, I=%d.\n', delMe(delMe(:,1) == delMe9.Subject, 1), ...
        delMe(delMe(:,1) == delMe9.Subject, 2), delMe(delMe(:,1) == delMe9.Subject, 3), delMe(delMe(:,1) == delMe9.Subject, 4), ...
        delMe(delMe(:,1) == delMe9.Subject, 5), delMe(delMe(:,1) == delMe9.Subject, 6), delMe(delMe(:,1) == delMe9.Subject, 6));
end
zCompletedUISafter_1B = array2table(delMe,'VariableNames',{'Subject','daysB4Passed_U','daysB4Passed_S','daysB4Passed_I','UshiftsB4Passed_U','SshiftsB4Passed_S','IshiftsB4Passed_I'});


histogram(zCompletedUISafter_1B.daysB4Passed_U)
title('Distribution of time before passing U')
ylabel('Count of subjects')
xlabel('Days before passing the U cluster')
set(findall(gca,'type','text'),'FontSize',16)
set(findall(gca,'type','axes'),'FontSize',14)

histogram(zCompletedUISafter_1B.daysB4Passed_S)
title('Distribution of time before passing S')
ylabel('Count of subjects')
xlabel('Days before passing the S cluster')
set(findall(gca,'type','text'),'FontSize',16)
set(findall(gca,'type','axes'),'FontSize',14)

histogram(zCompletedUISafter_1B.daysB4Passed_I)
title('Distribution of time before passing I')
ylabel('Count of subjects')
xlabel('Days before passing the I cluster')
set(findall(gca,'type','text'),'FontSize',16)
set(findall(gca,'type','axes'),'FontSize',14)

histogram(zCompletedUISafter_1B.UshiftsB4Passed_U)
title('Distribution of time before passing U')
ylabel('Count of subjects')
xlabel('Update shifts before passing the U cluster')
set(findall(gca,'type','text'),'FontSize',16)
set(findall(gca,'type','axes'),'FontSize',14)

histogram(zCompletedUISafter_1B.SshiftsB4Passed_S)
title('Distribution of time before passing S')
ylabel('Count of subjects')
xlabel('Shift shifts before passing the S cluster')
set(findall(gca,'type','text'),'FontSize',16)
set(findall(gca,'type','axes'),'FontSize',14)

histogram(zCompletedUISafter_1B.IshiftsB4Passed_I)
title('Distribution of time before passing I')
ylabel('Count of subjects')
xlabel('Inhibit shifts before passing the I cluster')
set(findall(gca,'type','text'),'FontSize',16)
set(findall(gca,'type','axes'),'FontSize',14)


% now see if the GLM (overall) Ability correlates to any of these
[delMe, delMe2] = removeNonMatchingSubjects(zOverallAbility_GLM_1B.Subject, zOverallAbility_GLM_1B, zCompletedUISafter_1B.Subject, zCompletedUISafter_1B, true, false); 
zScatter(delMe.Ability, delMe2.daysB4Passed_U, 'Comparing EFs to Ability', 'GLM-estimated overall Ability', 'Days before passing U cluster', true, '', '', '', false, '', '')
zScatter(delMe.Ability, delMe2.daysB4Passed_S, 'Comparing EFs to Ability', 'GLM-estimated overall Ability', 'Days before passing S cluster', true, '', '', '', false, '', '')
zScatter(delMe.Ability, delMe2.daysB4Passed_I, 'Comparing EFs to Ability', 'GLM-estimated overall Ability', 'Days before passing I cluster', true, '', '', '', false, '', '')
zScatter(delMe.Ability, delMe2.UshiftsB4Passed_U, 'Comparing EFs to Ability', 'GLM-estimated overall Ability', 'Update shifts before passing U cluster', true, '', '', '', false, '', '')
zScatter(delMe.Ability, delMe2.SshiftsB4Passed_S, 'Comparing EFs to Ability', 'GLM-estimated overall Ability', 'Switch shifts before passing S cluster', true, '', '', '', false, '', '')
zScatter(delMe.Ability, delMe2.IshiftsB4Passed_I, 'Comparing EFs to Ability', 'GLM-estimated overall Ability', 'Inhibit shifts before passing I cluster', true, '', '', '', false, '', '')



% now see if the pretest EFs correlate to any of these

% Pretest Switch
delMe3 = addPPswitchCols(zPPswitch_1B, false);
[delMe2] = getSwitchCostRT_PP_1B(excludeSubjects_RF_1B(true, true, false, delMe3), false, false); 
delMe4 = table2array([delMe2(isnan(delMe2.Pre_SC),'Subject')]) % find any subjects that don't have a pre SwitchCost somehow
delMe5 = table2array([delMe2(isnan(delMe2.Post_SC),'Subject')]) % find any subjects that don't have a post SwitchCost 
delMe6 = table2array([delMe2(isnan(delMe2.DeltaSC),'Subject')]) % find any subjects that don't have a delta SwitchCost 
delMe7 = delMe2; % these will be the pretest switchCost comparisons
delMe7(ismember(delMe7.Subject, delMe4), :) = []; % remove the non-preSC people
delMe8 = delMe2; % these will be the posttest switchCost comparisons
delMe8(ismember(delMe8.Subject, delMe5), :) = []; % remove the non-postSC people
delMe9 = delMe2; % these will be the delta switchCost comparisons
delMe9(ismember(delMe9.Subject, delMe6), :) = []; % remove the non-deltaSC people
[delMe, delMe7] = removeNonMatchingSubjects(zCompletedUISafter_1B.Subject, zCompletedUISafter_1B, delMe7.Subject, delMe7, true, false); 
zScatter(delMe.daysB4Passed_S, delMe7.Pre_SC, 'Comparing DaysBeforePassing to Pretest SwitchCost', 'Days before passing S cluster', 'Pretest Switch Cost (ReactionTime)', true, '', '', '', false, '', '')
zScatter(delMe.SshiftsB4Passed_S, delMe7.Pre_SC, 'Comparing ShiftsBeforePassing to Pretest SwitchCost', 'Switch shifts before passing S cluster', 'Pretest Switch Cost (ReactionTime)', true, '', '', '', false, '', '')
[delMe, delMe8] = removeNonMatchingSubjects(zCompletedUISafter_1B.Subject, zCompletedUISafter_1B, delMe8.Subject, delMe8, true, false); 
zScatter(delMe.daysB4Passed_S, delMe8.Post_SC, 'Comparing DaysBeforePassing to Posttest SwitchCost', 'Days before passing S cluster', 'Posttest Switch Cost (ReactionTime)', true, '', '', '', false, '', '')
zScatter(delMe.SshiftsB4Passed_S, delMe8.Post_SC, 'Comparing ShiftsBeforePassing to Posttest SwitchCost', 'Switch shifts before passing S cluster', 'Posttest Switch Cost (ReactionTime)', true, '', '', '', false, '', '')
[delMe, delMe9] = removeNonMatchingSubjects(zCompletedUISafter_1B.Subject, zCompletedUISafter_1B, delMe9.Subject, delMe9, true, false); 
zScatter(delMe.daysB4Passed_S, delMe9.DeltaSC, 'Comparing DaysBeforePassing to Delta EF SwitchCost', 'Days before passing S cluster', 'Delta (post-pre) Switch Cost (ReactionTime)', true, '', '', '', false, '', '')
zScatter(delMe.SshiftsB4Passed_S, delMe9.DeltaSC, 'Comparing ShiftsBeforePassing to Delta EF SwitchCost', 'Switch shifts before passing S cluster', 'Delta (post-pre) Switch Cost (ReactionTime)', true, '', '', '', false, '', '')

% Pretest Update
includedPPupdate = excludeSubjects_RF_1B(true, true, false, zPPupdate_1B_singleTrials);
delMe2 = table(0,0.0,0.0,0.0,0.0,0.0,0.0,'VariableNames', {'Subject','Pre_Let_CorrectPct','Pre_Arr_CorrectPct','Post_Let_CorrectPct','Post_Arr_CorrectPct','delta_Let_CorrectPct','delta_Arr_CorrectPct'});
delMe5 = unique(includedPPupdate.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedPPupdate((includedPPupdate.Subject == delMe5(delMe4)) & (strcmpi(includedPPupdate.Period,'0-PreTest')), :); % subjTrials_Pre
    delMe7 = includedPPupdate((includedPPupdate.Subject == delMe5(delMe4)) & (strcmpi(includedPPupdate.Period,'4-PostTest')), :); % subjTrials_Post
    delMe8 = height(delMe6(strcmpi(delMe6.LetScore, 'correct'), :)) / height(delMe6); % Pre_Let_CorrectPct
    delMe9 = height(delMe7(strcmpi(delMe7.LetScore, 'correct'), :)) / height(delMe7); % Post_Let_CorrectPct
    delMe10 = height(delMe6(strcmpi(delMe6.ArrScore, 'correct'), :)) / height(delMe6); % Pre_Arr_CorrectPct
    delMe11 = height(delMe7(strcmpi(delMe7.ArrScore, 'correct'), :)) / height(delMe7); % Post_Arr_CorrectPct
    
    delMe2(delMe4,:) = {delMe5(delMe4) delMe8 delMe10 delMe9 delMe11 (delMe9 - delMe8) (delMe11 - delMe10)};
end

[delMe, delMe2] = removeNonMatchingSubjects(zCompletedUISafter_1B.Subject, zCompletedUISafter_1B, delMe2.Subject, delMe2, true, false);
zScatter(delMe.daysB4Passed_U, delMe2.Pre_Arr_CorrectPct, 'Comparing DaysBeforePassing to Pretest Update Accuracy', 'Days before passing U cluster', 'Pretest arrow rotation accuracy', true, '', '', '', false, '', '')
zScatter(delMe.UshiftsB4Passed_U, delMe2.Pre_Arr_CorrectPct, 'Comparing ShiftsBeforePassing to Pretest Update Accuracy', 'Update shifts before passing U cluster', 'Pretest arrow rotation accuracy', true, '', '', '', false, '', '')
zScatter(delMe.UshiftsB4Passed_U, delMe2.Pre_Let_CorrectPct, 'Comparing ShiftsBeforePassing to Pretest Update Accuracy', 'Update shifts before passing U cluster', 'Pretest letter rotation accuracy', true, '', '', '', false, '', '')

zScatter(delMe.UshiftsB4Passed_U, delMe2.Post_Arr_CorrectPct, 'Comparing ShiftsBeforePassing to Pretest Update Accuracy', 'Update shifts before passing U cluster', 'Posttest arrow rotation accuracy', true, '', '', '', false, '', '')
zScatter(delMe.UshiftsB4Passed_U, delMe2.Post_Let_CorrectPct, 'Comparing ShiftsBeforePassing to Pretest Update Accuracy', 'Update shifts before passing U cluster', 'Posttest letter rotation accuracy', true, '', '', '', false, '', '')

zScatter(delMe.UshiftsB4Passed_U, delMe2.delta_Arr_CorrectPct, 'Comparing ShiftsBeforePassing to Pretest Update Accuracy', 'Update shifts before passing U cluster', 'delta (post-pre) arrow rotation accuracy', true, '', '', '', false, '', '')
zScatter(delMe.UshiftsB4Passed_U, delMe2.delta_Let_CorrectPct, 'Comparing ShiftsBeforePassing to Pretest Update Accuracy', 'Update shifts before passing U cluster', 'delta (post-pre) letter rotation accuracy', true, '', '', '', false, '', '')


% RF early SwitchCost
[delMe] = getSwitchCostRT_RF_1B(excludeSubjects_RF_1B(true, true, false, first_N_RFshifts), 'single', false, true, false);

delMe4 = table2array([delMe(isnan(delMe.SwCost),'Subject')]) % find any subjects that don't have a SwitchCost somehow
delMe2 = delMe; % this will be the SCs
delMe2(ismember(delMe2.Subject, delMe4), :) = []; % remove the non-SC people

[delMe, delMe2] = removeNonMatchingSubjects(zCompletedUISafter_1B.Subject, zCompletedUISafter_1B, delMe2.Subject, delMe2, true, false); 
zScatter(delMe.daysB4Passed_S, delMe2.SwCost, 'Comparing DaysBeforePassing to Switch Cost from first two days of RF Switch trials', 'Days before passing S cluster', 'RF Switch Cost (RT; first 2 days)', true, '', '', '', false, '', '')
zScatter(delMe.SshiftsB4Passed_S, delMe2.SwCost, 'Comparing ShiftsBeforePassing to Switch Cost from first two days of RF Switch trials', 'Switch shifts before passing S cluster', 'RF Switch Cost (RT; first 2 days)', true, '', '', '', false, '', '')



% RF early Update Accuracy
[delMe] = getSwitchCostRT_RF_1B(excludeSubjects_RF_1B(true, true, false, first_N_RFshifts), 'single', false, true, false);

delMe4 = table2array([delMe(isnan(delMe.SwCost),'Subject')]) % find any subjects that don't have a SwitchCost somehow
delMe2 = delMe; % this will be the SCs
delMe2(ismember(delMe2.Subject, delMe4), :) = []; % remove the non-SC people

[delMe, delMe2] = removeNonMatchingSubjects(zCompletedUISafter_1B.Subject, zCompletedUISafter_1B, delMe2.Subject, delMe2, true, false); 
zScatter(delMe.daysB4Passed_S, delMe2.SwCost, 'Comparing DaysBeforePassing to Switch Cost from first two days of RF Switch trials', 'Days before passing S cluster', 'RF Switch Cost (RT; first 2 days)', true, '', '', '', false, '', '')
zScatter(delMe.SshiftsB4Passed_S, delMe2.SwCost, 'Comparing ShiftsBeforePassing to Switch Cost from first two days of RF Switch trials', 'Switch shifts before passing S cluster', 'RF Switch Cost (RT; first 2 days)', true, '', '', '', false, '', '')



% now see if Ability or anything else correlates with LSAT score differences pre/post in MITRE
[zLSATscores, ~, ~] = formTables_RF_1A3('2015_11_30 MITRE LSAT scores.xlsx', '2015_11_13 GLM overall Ability coeffs.xlsx', '2015_11_13 GLM overall Ability coeffs.xlsx', false);
delMe4 = zLSATscores;
delMe3 = zeros(height(delMe4),1); % note to delete this row in delMe
for delMe2 = 1:height(delMe4)
    if (iscellstr(delMe4(delMe2,:).lsatScore)) % pretest score is 'NaN', somehow
        delMe3(delMe2, 1) = 1;
    elseif (isnan(delMe4(delMe2,:).lsatScore)) % pretest score is 'NaN', somehow (NOTE: IF THIS IS A CELL ARRAY, WILL NEED {1}!!)
        delMe3(delMe2, 1) = 1;
    elseif (iscellstr(delMe4(delMe2,:).t2_lsatScore)) % posttest score is 'NaN' (guess they didn't take the posttest?)
        delMe3(delMe2, 1) = 1;
    elseif (isnan(delMe4(delMe2,:).t2_lsatScore{1})) % posttest score is 'NaN' (guess they didn't take the posttest?)
        delMe3(delMe2, 1) = 1;
    end
end
delMe4(delMe3(:,1) == 1, :) = []; % delete any rows from delMe that delMe3 marked as trash
delMe4.t2_lsatScore = cell2mat(delMe4.t2_lsatScore); % turn t2_lsatScore into a numeric array
delMe4.LSATdelta = delMe4.t2_lsatScore - delMe4.lsatScore;

[delMe2, delMe] = removeNonMatchingSubjects(zCompletedUISafter_1B.Subject, zCompletedUISafter_1B, delMe4.par_HON, delMe4, true, false);
zScatter(delMe2.daysB4Passed_U, delMe.LSATdelta, 'Comparing DaysBeforePassing to LSAT delta', 'Days before passing U cluster', 'MITRE LSAT delta', true, '', '', '', false, '', '')
zScatter(delMe2.UshiftsB4Passed_U, delMe.LSATdelta, 'Comparing ShiftsBeforePassing to LSAT delta', 'Update shifts before passing U cluster', 'MITRE LSAT delta', true, '', '', '', false, '', '')

zScatter(delMe2.daysB4Passed_S, delMe.LSATdelta, 'Comparing DaysBeforePassing to LSAT delta', 'Days before passing S cluster', 'MITRE LSAT delta', true, '', '', '', false, '', '')
zScatter(delMe2.SshiftsB4Passed_S, delMe.LSATdelta, 'Comparing ShiftsBeforePassing to LSAT delta', 'Switch shifts before passing S cluster', 'MITRE LSAT delta', true, '', '', '', false, '', '')

zScatter(delMe2.daysB4Passed_I, delMe.LSATdelta, 'Comparing DaysBeforePassing to LSAT delta', 'Days before passing I cluster', 'MITRE LSAT delta', true, '', '', '', false, '', '')
zScatter(delMe2.IshiftsB4Passed_I, delMe.LSATdelta, 'Comparing ShiftsBeforePassing to LSAT delta', 'Inhibit shifts before passing I cluster', 'MITRE LSAT delta', true, '', '', '', false, '', '')

[delMe2, delMe] = removeNonMatchingSubjects(zOverallAbility_GLM_1B.Subject, zOverallAbility_GLM_1B, delMe.par_HON, delMe, true, false);
zScatter(delMe2.Ability, delMe.lsatScore, 'Comparing overall GLM-estimated Ability to LSAT pretest', 'GLM-estimated overall Ability', 'MITRE LSAT pretest score', true, '', '', '', false, '', '')
zScatter(delMe2.Ability, delMe.t2_lsatScore, 'Comparing overall GLM-estimated Ability to LSAT posttest', 'GLM-estimated overall Ability', 'MITRE LSAT posttest score', true, '', '', '', false, '', '')
zScatter(delMe2.Ability, delMe.LSATdelta, 'Comparing overall GLM-estimated Ability to LSAT delta', 'GLM-estimated overall Ability', 'MITRE LSAT delta', true, '', '', '', false, '', '')





% get clustersCompleted for each day
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % get only participants that have finished
getClustersCompleted_perTimespan_1B(delMe, true, 1, 1, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 2, 2, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 3, 3, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 4, 4, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 5, 5, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 6, 6, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 7, 7, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 8, 8, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 9, 9, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 10, 10, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 11, 11, true, false);
getClustersCompleted_perTimespan_1B(delMe, true, 12, 12, true, false);

% now get the number of sessions that each subject completed
delMe = [];
delMe2 = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % get only participants that have finished
delMe2 = unique(delMe2.Subject);
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % subj
    delMe5 = zRFSum_1B(zRFSum_1B.Subject == delMe4, :); % subjTrials from SUM file
    delMe = [delMe; delMe4, max(delMe5.RfT)]; % add the subj and the number of sessions he/she saw
    fprintf('Inserted %d days for Subject %d.\n', max(delMe5.RfT), delMe4);
end
delMe2 = table(delMe(:,1),delMe(:,2), 'VariableNames',{'Subject', 'RfT'});
writetable(delMe2, getFileNameForThisOS('sessionsCompleted_justfinishedSubjs.csv', 'IntResults'));





% create the logit of the init_ISOest and end_ISOest
delMe = zIsoShiftEstimates_1B.init_ISOest;
delMe2 = 1 - zIsoShiftEstimates_1B.init_ISOest;
delMe4 = [];
for delMe3 = 1:length(delMe)
    if (delMe(delMe3) == 1) % this will make the logit infinite
        fprintf('Using a proxy of .98 for init_est number %d, since it is 1.\n', delMe3);
        delMe4(delMe3,1) = log(.98 / (1-.98)); % assuming ~50 trials: 1/50
    elseif (delMe(delMe3) == 0) % this will make the logit -infinite
        fprintf('Using a proxy of .02 for init_est number %d, since it is 0.\n', delMe3);
        delMe4(delMe3,1) = log(.02 / (1-.02)); % assuming ~50 trials: 1/50
    else
        delMe4(delMe3,1) = log(delMe(delMe3) / delMe2(delMe3));
    end
end
zIsoShiftEstimates_1B.logit_init_ISOest = delMe4;
delMe = zIsoShiftEstimates_1B.end_ISOest;
delMe2 = 1 - zIsoShiftEstimates_1B.end_ISOest;
delMe4 = [];
for delMe3 = 1:length(delMe)
    if (delMe(delMe3) == 1) % this will make the logit infinite
        fprintf('Using a proxy of .98 for end_est number %d, since it is 1.\n', delMe3);
        delMe4(delMe3,1) = log(.98 / (1-.98)); % assuming ~50 trials: 1/50
    elseif (delMe(delMe3) == 0) % this will make the logit -infinite
        fprintf('Using a proxy of .02 for end_est number %d, since it is 0.\n', delMe3);
        delMe4(delMe3,1) = log(.02 / (1-.02)); % assuming ~50 trials: 1/50
    else
        delMe4(delMe3,1) = log(delMe(delMe3) / delMe2(delMe3));
    end
end
zIsoShiftEstimates_1B.logit_end_ISOest = delMe4;



% get (and print out) information about the ISO estimates on a per-cluster basis, including init_est, end_est, and transitions 
[delMe] = getISOclusterInfoMatrix_1B(zIsoShiftEstimates_1B, false);
writetable(delMe, getFileNameForThisOS('2015_12_5 IsoClusterInfoMatrix.csv', 'IntResults'))
[delMe, delMe2, delMe3] = getISOclusterTransitionMatrix_1B(zIsoShiftEstimates_1B, false, true);
writetable(delMe, getFileNameForThisOS('2015_12_5 IsoClusterTransitions_DIFF.csv', 'IntResults'))
writetable(delMe2, getFileNameForThisOS('2015_12_5 IsoClusterTransitions_COUNT.csv', 'IntResults'))
writetable(delMe3, getFileNameForThisOS('2015_12_5 IsoClusterTransitions_AVG.csv', 'IntResults'))


% get (and print out) information about the ISO estimates on a per-cluster basis, including init_est, end_est, and transitions 
[delMe] = getKernelclusterInfoMatrix_1B(zKernelShiftEstimates_1B, false);
writetable(delMe, getFileNameForThisOS('2015_12_9 KernelClusterInfoMatrix.csv', 'IntResults'))
[delMe, delMe2, delMe3] = getKernelclusterTransitionMatrix_1B(zKernelShiftEstimates_1B, false, true);
writetable(delMe, getFileNameForThisOS('2015_12_9 KernelClusterTransitions_DIFF.csv', 'IntResults'))
writetable(delMe2, getFileNameForThisOS('2015_12_9 KernelClusterTransitions_COUNT.csv', 'IntResults'))
writetable(delMe3, getFileNameForThisOS('2015_12_9 KernelClusterTransitions_AVG.csv', 'IntResults'))


% remove all the trial and sum data from shifts that have no value for "Attempted" in the SUM file 
% (this indicates that some error occurred before the shift was completed) 
delMe = zRFSum_1B(isnan(zRFSum_1B.Attempted), :);
unique(delMe.Subject) % just to see if they're the ones we expect
for delMe2 = 1:height(delMe)
    delMe3 = delMe(delMe2, :); % the shift in question
    fprintf('Removing data for Subject %d, shift %d.\n', delMe3.Subject, delMe3.ShiftNum);
    zRF_1B((zRF_1B.Subject == delMe3.Subject) & (zRF_1B.ShiftNum == delMe3.ShiftNum), :) = []; % delete any trials for this weird shift
    zRFSum_1B((zRFSum_1B.Subject == delMe3.Subject) & (zRFSum_1B.ShiftNum == delMe3.ShiftNum), :) = []; % delete any sum data for this weird shift
end



% useful for cleaning the SUM data file
zRFSum_1B = insertFirstTimeClusterFlagsIntoSum_1B(zRFSum_1B, false);
zRFSum_1B_NoDupClustersComplete = removeDuplicateClustersCompleted_1B(zRFSum_1B, false); % remove the "completion" of extra jump-back clusters




% for each subject, for each day, count the clusters they completed upon first encounter 
findNANsFunction = @(x) all(isnan(x(:)));
delMe9 = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe2 = unique(delMe9.Subject);
delMe = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % for each subj (row) and each day (col) (plus an extra col for the subj# and another for the sessions completed)
for delMe3 = 1:length(delMe2) % row
    delMe4 = delMe2(delMe3); % subj
    fprintf('Counting initial clusters completed for subject %d.\n', delMe4);
    delMe(delMe3, 1) = delMe4; % record the subj #
    delMe(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
 
    delMe5 = delMe9((delMe9.Subject == delMe4) & (delMe9.firstTimeSeeingClusterToday == 1), :); % shifts for this subject where they saw the given cluster for the first time this day
    for delMe6 = 1:max(delMe5.RfT) % go through each training day this subject saw
        delMe7 = delMe5(delMe5.RfT == delMe6, :); % shifts for this training day
        delMe8 = delMe7.ClusterComplete;
        delMe8(cellfun(findNANsFunction, delMe8)) = []; % delete all the "NaN"s, leaving just the clusters complete
        delMe(delMe3, 2 + delMe6) = length(unique(delMe8)); % record the unique clusters completed for this day
    end
    if (max(delMe5.RfT) < max(delMe9.RfT)) % this subject completed fewer sessions than the maximum of any subject
        for delMe6 = (max(delMe5.RfT)+1):(max(delMe9.RfT))
            delMe(delMe3, 2 + delMe6) = nan;
        end
    end
end
delMe2 = array2table(delMe, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe2, getFileNameForThisOS('2015_12_7 clustersCompleted_OnFirstEncounterEachDay_JustFinishedSubjs.csv', 'IntResults'));

% for each subject, for each day, count the clusters they completed upon 2nd+ encounter 
findNANsFunction = @(x) all(isnan(x(:)));
delMe9 = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe2 = unique(delMe9.Subject);
delMe = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % for each subj (row) and each day (col) (plus an extra col for the subj# and another for the sessions completed)
for delMe3 = 1:length(delMe2) % row
    delMe4 = delMe2(delMe3); % subj
    fprintf('Counting non-initial clusters completed for subject %d.\n', delMe4);
    delMe(delMe3, 1) = delMe4; % record the subj #
    delMe(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
 
    delMe5 = delMe9((delMe9.Subject == delMe4) & (delMe9.firstTimeSeeingClusterToday == 0), :); % shifts for this subject where they saw the given cluster for the 2nd+ time this day
    for delMe6 = 1:max(delMe5.RfT) % go through each training day this subject saw
        delMe7 = delMe5(delMe5.RfT == delMe6, :); % shifts for this training day
        delMe8 = delMe7.ClusterComplete;
        delMe8(cellfun(findNANsFunction, delMe8)) = []; % delete all the "NaN"s, leaving just the clusters complete
        delMe(delMe3, 2 + delMe6) = length(unique(delMe8)); % record the unique clusters completed for this day
    end
    if (max(delMe5.RfT) < max(delMe9.RfT)) % this subject completed fewer sessions than the maximum of any subject
        for delMe6 = (max(delMe5.RfT)+1):(max(delMe9.RfT))
            delMe(delMe3, 2 + delMe6) = nan;
        end
    end
end
delMe2 = array2table(delMe, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe2, getFileNameForThisOS('2015_12_7 clustersCompleted_OnLaterEncountersEachDay_JustFinishedSubjs.csv', 'IntResults'));

% for each subject, for each day, count the clusters they completed within the first 3 shifts of the day 
findNANsFunction = @(x) all(isnan(x(:)));
delMe9 = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe2 = unique(delMe9.Subject);
delMe = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % for each subj (row) and each day (col) (plus an extra col for the subj# and another for the sessions completed)
for delMe3 = 1:length(delMe2) % row
    delMe4 = delMe2(delMe3); % subj
    fprintf('Counting clusters completed in first three shifts for subject %d.\n', delMe4);
    delMe(delMe3, 1) = delMe4; % record the subj #
    delMe(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
 
    delMe5 = delMe9(delMe9.Subject == delMe4, :); % this subject's shifts
    for delMe6 = 1:max(delMe5.RfT) % go through each training day this subject saw
        delMe7 = delMe5(delMe5.RfT == delMe6, :); % shifts for this training day
        delMe7 = delMe7((delMe7.ShiftNum >= min(delMe7.ShiftNum)) ...
            & (delMe7.ShiftNum <= (min(delMe7.ShiftNum)+2)), :); % first three shifts for this day
        delMe8 = delMe7.ClusterComplete;
        delMe8(cellfun(findNANsFunction, delMe8)) = []; % delete all the "NaN"s, leaving just the clusters complete
        delMe(delMe3, 2 + delMe6) = length(unique(delMe8)); % record the [count of] unique clusters completed for this day
    end
    if (max(delMe5.RfT) < max(delMe9.RfT)) % this subject completed fewer sessions than the maximum of any subject
        for delMe6 = (max(delMe5.RfT)+1):(max(delMe9.RfT))
            delMe(delMe3, 2 + delMe6) = nan;
        end
    end
end
delMe2 = array2table(delMe, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe2, getFileNameForThisOS('2015_12_7 clustersCompleted_OnFirst3ShiftsEachDay_JustFinishedSubjs.csv', 'IntResults'));

% for each subject, for each day, count the clusters they completed within the first 3 shifts of the day 
findNANsFunction = @(x) all(isnan(x(:)));
delMe9 = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe2 = unique(delMe9.Subject);
delMe = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % for each subj (row) and each day (col) (plus an extra col for the subj# and another for the sessions completed)
for delMe3 = 1:length(delMe2) % row
    delMe4 = delMe2(delMe3); % subj
    fprintf('Counting clusters completed in shifts after the first three for subject %d.\n', delMe4);
    delMe(delMe3, 1) = delMe4; % record the subj #
    delMe(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
 
    delMe5 = delMe9(delMe9.Subject == delMe4, :); % this subject's shifts
    for delMe6 = 1:max(delMe5.RfT) % go through each training day this subject saw
        delMe7 = delMe5(delMe5.RfT == delMe6, :); % shifts for this training day
        delMe7 = delMe7((delMe7.ShiftNum >= (min(delMe7.ShiftNum) + 4)) ...
            & (delMe7.ShiftNum <= (max(delMe7.ShiftNum))), :); % after the first three shifts for this day
        delMe8 = delMe7.ClusterComplete;
        delMe8(cellfun(findNANsFunction, delMe8)) = []; % delete all the "NaN"s, leaving just the clusters complete
        delMe(delMe3, 2 + delMe6) = length(unique(delMe8)); % record the [count of] unique clusters completed for this day
    end
    if (max(delMe5.RfT) < max(delMe9.RfT)) % this subject completed fewer sessions than the maximum of any subject
        for delMe6 = (max(delMe5.RfT)+1):(max(delMe9.RfT))
            delMe(delMe3, 2 + delMe6) = nan;
        end
    end
end
delMe2 = array2table(delMe, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe2, getFileNameForThisOS('2015_12_7 clustersCompleted_AfterFirst3ShiftsEachDay_JustFinishedSubjs.csv', 'IntResults'));

% for each subject, for each day, count the non-Inhibit shifts they completed within the first 3 shifts of the day 
findNANsFunction = @(x) all(isnan(x(:)));
delMe9 = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe9(strcmpi(delMe9.Cluster, 'I'),:) = []; % delete Inhibit clusters
delMe9(strcmpi(delMe9.Cluster, 'I/Logic'),:) = []; % delete Inhibit/Logic clusters
delMe9.EFandLogicCount = ones(height(delMe9), 1); % create a variable that's 1 for U, I, S; 2 for U/Logic, U/I, ..., etc.
delMe9(strcmpi(delMe9.Cluster, 'U/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/Logic'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'S/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'S/Logic'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'U/S'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/S'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'U/I'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/I'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'S/I'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'S/I'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'U/S/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/S/Logic'),:)), 1) + 2; % threes
delMe9(strcmpi(delMe9.Cluster, 'U/I/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/I/Logic'),:)), 1) + 2; % threes
delMe9(strcmpi(delMe9.Cluster, 'S/I/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'S/I/Logic'),:)), 1) + 2; % threes
delMe9(strcmpi(delMe9.Cluster, 'L4aV1'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'L4aV1'),:)), 1) + 3; % fours
delMe9(strcmpi(delMe9.Cluster, 'L4aV2'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'L4aV2'),:)), 1) + 3; % fours
delMe9(strcmpi(delMe9.Cluster, 'L4bV1'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'L4bV1'),:)), 1) + 3; % fours
delMe9(strcmpi(delMe9.Cluster, 'L4bV2'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'L4bV2'),:)), 1) + 3; % fours
delMe2 = unique(delMe9.Subject);
delMe = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % for each subj (row) and each day (col) (plus an extra col for the subj# and another for the sessions completed)
delMe8 = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % same thing, but normalized (since we don't know how many non-Inhibit shifts they saw in a given day)
delMe10 = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % normalized and weighted for complexity level in the "passed" shifts
for delMe3 = 1:length(delMe2) % row
    delMe4 = delMe2(delMe3); % subj
    fprintf('Counting shifts over 80 accuracy in first three non-Inhibit shifts for subject %d.\n', delMe4);
    delMe(delMe3, 1) = delMe4; % record the subj #
    delMe8(delMe3, 1) = delMe4; % record the subj #
    delMe10(delMe3, 1) = delMe4; % record the subj #
    delMe(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
    delMe8(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
    delMe10(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
 
    delMe5 = delMe9(delMe9.Subject == delMe4, :); % this subject's shifts
    for delMe6 = 1:max(delMe5.RfT) % go through each training day this subject saw
        delMe7 = delMe5(delMe5.RfT == delMe6, :); % shifts for this training day
        delMe7 = delMe7((delMe7.ShiftNum >= min(delMe7.ShiftNum)) ...
            & (delMe7.ShiftNum <= (min(delMe7.ShiftNum)+2)), :); % first three shifts for this day
        delMe(delMe3, 2 + delMe6) = height(delMe7(delMe7.Accuracy > 80, :)); % record the [count of] shifts of Accuracy > 80 for this day
        delMe8(delMe3, 2 + delMe6) = height(delMe7(delMe7.Accuracy > 80, :)) / height(delMe7); % same thing, but normalized for the number of shifts
        delMe10(delMe3, 2 + delMe6) = sum(delMe7(delMe7.Accuracy > 80, :).EFandLogicCount) / height(delMe7); % normalized and weighted for complexity level
    end
    if (max(delMe5.RfT) < max(delMe9.RfT)) % this subject completed fewer sessions than the maximum of any subject
        for delMe6 = (max(delMe5.RfT)+1):(max(delMe9.RfT))
            delMe(delMe3, 2 + delMe6) = nan;
            delMe8(delMe3, 2 + delMe6) = nan;
            delMe10(delMe3, 2 + delMe6) = nan;
        end
    end
end
delMe2 = array2table(delMe, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe2, getFileNameForThisOS('2015_12_7 NonInhibitShifts_Over80accuracy_inFirst3ShiftsEachDay_count.csv', 'IntResults'));
delMe3 = array2table(delMe8, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe3, getFileNameForThisOS('2015_12_7 NonInhibitShifts_Over80accuracy_inFirst3ShiftsEachDay_normalized.csv', 'IntResults'));
delMe4 = array2table(delMe10, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe4, getFileNameForThisOS('2015_12_7 NonInhibitShifts_Over80accuracy_inFirst3ShiftsEachDay_weighted.csv', 'IntResults'));


% for each subject, for each day, count the non-Inhibit shifts they completed after the first 3 shifts of the day 
findNANsFunction = @(x) all(isnan(x(:)));
delMe9 = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe9(strcmpi(delMe9.Cluster, 'I'),:) = []; % delete Inhibit clusters
delMe9(strcmpi(delMe9.Cluster, 'I/Logic'),:) = []; % delete Inhibit/Logic clusters
delMe9.EFandLogicCount = ones(height(delMe9), 1); % create a variable that's 1 for U, I, S; 2 for U/Logic, U/I, ..., etc.
delMe9(strcmpi(delMe9.Cluster, 'U/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/Logic'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'S/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'S/Logic'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'U/S'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/S'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'U/I'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/I'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'S/I'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'S/I'),:)), 1) + 1; % twos
delMe9(strcmpi(delMe9.Cluster, 'U/S/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/S/Logic'),:)), 1) + 2; % threes
delMe9(strcmpi(delMe9.Cluster, 'U/I/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'U/I/Logic'),:)), 1) + 2; % threes
delMe9(strcmpi(delMe9.Cluster, 'S/I/Logic'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'S/I/Logic'),:)), 1) + 2; % threes
delMe9(strcmpi(delMe9.Cluster, 'L4aV1'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'L4aV1'),:)), 1) + 3; % fours
delMe9(strcmpi(delMe9.Cluster, 'L4aV2'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'L4aV2'),:)), 1) + 3; % fours
delMe9(strcmpi(delMe9.Cluster, 'L4bV1'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'L4bV1'),:)), 1) + 3; % fours
delMe9(strcmpi(delMe9.Cluster, 'L4bV2'),:).EFandLogicCount = ones(height(delMe9(strcmpi(delMe9.Cluster, 'L4bV2'),:)), 1) + 3; % fours
delMe2 = unique(delMe9.Subject);
delMe = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % for each subj (row) and each day (col) (plus an extra col for the subj# and another for the sessions completed)
delMe8 = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % same thing, but normalized (since we don't know how many non-Inhibit shifts they saw in a given day)
delMe10 = zeros(length(delMe2),(max(delMe9.RfT) + 2)); % normalized and weighted for complexity level in the "passed" shifts
for delMe3 = 1:length(delMe2) % row
    delMe4 = delMe2(delMe3); % subj
    fprintf('Counting shifts over 80 accuracy after the first three non-Inhibit shifts for subject %d.\n', delMe4);
    delMe(delMe3, 1) = delMe4; % record the subj #
    delMe8(delMe3, 1) = delMe4; % record the subj #
    delMe10(delMe3, 1) = delMe4; % record the subj #
    delMe(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
    delMe8(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
    delMe10(delMe3, 2) = max(delMe9(delMe9.Subject == delMe4, :).RfT); % record the # of days the subject trained
 
    delMe5 = delMe9(delMe9.Subject == delMe4, :); % this subject's shifts
    for delMe6 = 1:max(delMe5.RfT) % go through each training day this subject saw
        delMe7 = delMe5(delMe5.RfT == delMe6, :); % shifts for this training day
        delMe7 = delMe7((delMe7.ShiftNum >= (min(delMe7.ShiftNum) + 4)) ...
            & (delMe7.ShiftNum <= (max(delMe7.ShiftNum))), :); % after the first three shifts for this day
        delMe(delMe3, 2 + delMe6) = height(delMe7(delMe7.Accuracy > 80, :)); % record the [count of] shifts of Accuracy > 80 for this day
        delMe8(delMe3, 2 + delMe6) = height(delMe7(delMe7.Accuracy > 80, :)) / height(delMe7); % same thing, but normalized for the number of shifts
        delMe10(delMe3, 2 + delMe6) = sum(delMe7(delMe7.Accuracy > 80, :).EFandLogicCount) / height(delMe7); % normalized and weighted for complexity level
    end
    if (max(delMe5.RfT) < max(delMe9.RfT)) % this subject completed fewer sessions than the maximum of any subject
        for delMe6 = (max(delMe5.RfT)+1):(max(delMe9.RfT))
            delMe(delMe3, 2 + delMe6) = nan;
            delMe8(delMe3, 2 + delMe6) = nan;
            delMe10(delMe3, 2 + delMe6) = nan;
        end
    end
end
delMe2 = array2table(delMe, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe2, getFileNameForThisOS('2015_12_7 NonInhibitShifts_Over80accuracy_afterFirst3ShiftsEachDay_count.csv', 'IntResults'));
delMe3 = array2table(delMe8, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe3, getFileNameForThisOS('2015_12_7 NonInhibitShifts_Over80accuracy_afterFirst3ShiftsEachDay_normalized.csv', 'IntResults'));
delMe4 = array2table(delMe10, 'VariableNames', {'Subject','TrainingDays','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
writetable(delMe4, getFileNameForThisOS('2015_12_7 NonInhibitShifts_Over80accuracy_afterFirst3ShiftsEachDay_weighted.csv', 'IntResults'));




% make a simulation to test the kernel function estimates with the assumption that there is no true decrease in ability 
%   (adapted from Misha's isorANAL.m)
Nrep = 1000;     % Number of shifts
Nseq = 50;      % number of trials in a shift
p = 0.5;        % (unchanging) prob of correct
rnd = rand(Nrep * Nseq,1); % random responses
rsp = double(rnd <= p);
pseudoRFtrialData = array2table(rsp,'VariableNames',{'Correct'});
pseudoRFtrialData.Subject = ones(height(pseudoRFtrialData),1) + 800; % unused subj # = 801
pseudoRFtrialData.Subject = ones(height(pseudoRFtrialData),1) + 800; % unused subj # = 801
delMe = {''};
delMe(1:height(pseudoRFtrialData),1) = {'none'};
pseudoRFtrialData.Cluster = delMe;
delMe = transpose(1:Nseq);
delMe2 = repmat(delMe, Nrep, 1);
pseudoRFtrialData.TrialCount = delMe2;
delMe = (1:Nseq);
delMe2 = repmat(delMe, Nrep, 1);
pseudoRFtrialData.ShiftNum = delMe2(:);
delMe = zeros(Nseq, 1);
delMe(1,1) = 1; % mark the first trial of the shifts
delMe2 = repmat(delMe, Nrep, 1);
pseudoRFtrialData.StartOfShifts = delMe2;

[logitProbCorrect, probCorrect, ~, ~, ~, ~] = getKernelValsPerShift_1A3(pseudoRFtrialData, pseudoRFtrialData.StartOfShifts, 'AllTrials', 10, '', false);

Y1 = zeros(Nrep,1); % start estimates
Y2 = Y1; % end estimates
for sn = 1:Nrep
    startRow = (Nseq * (sn-1)) + 1; % 1, Nseq + 1, etc.
    endRow = startRow + (Nseq - 1); % Nseq, Nseq + Nseq, etc
    [interceptAndslope] = regress(logitProbCorrect(startRow:endRow), [ones(Nseq,1), transpose(0:(Nseq - 1))]); % starting the X=0 ensures we get an intercept
    Y1(sn, 1) = interceptAndslope(1); % start estimate = intercept
%    if (interceptAndslope(2) > 0) % positive slope
        Y2(sn, 1) = interceptAndslope(1) + (Nseq * interceptAndslope(2)); % end estimate
%    else
%        Y2(sn, 1) = interceptAndslope(1); % assume no learning but no loss either = intercept
%    end
end

figure
histogram(Y1,30)
hold on
histogram(Y2,30)
hold off
title(sprintf('Distribution of Starting and End Points p = %6.3f, Nrep = %d',p,Nrep));
legend('Start','End')
figure
histogram(Y2-Y1,30);
title(sprintf('Distribution of Slopes p = %6.3f, Nrep = %d',p,Nrep));

clear p;
clear Nrep;
clear Nseq;
clear rnd;
clear rsp;
clear logitProbCorrect;
clear probCorrect;
clear pseudoRFtrialData;
clear startRow;
clear interceptAndslope;
clear Y1;
clear Y2;






% get the (logit of the) initial and end kernel estimates for each shift in the trial data (to run on SWING server) 
zKernelShiftEstimates_1B = getKernelRegressedPerf_Shifts_1B(zRF_1B, false, true);







% find out the correlation between Pre/post Switch (from Todd/Franziska) and RF Switch (both GLM_Ability and SwitchCost) 
[~, zPP_EF_FromMasterFile, ~] = formTables_RF_1A3('', '1b-final-Complete_EF_data_Ready_for_analysis.xlsx', '', true);
zPreSwitch_Master_Included = zPP_EF_FromMasterFile(zPP_EF_FromMasterFile.TS_Exclude_Pre == 0, :); % remove excluded
[~,~,switchDataForRF_GLM] = getCleanSwitchTrials_RF_1B(true, true, 'both', 'S', ...
    excludeSubjects_RF_1B(false, true, false, first_N_RFshifts), false);
switchCostRF = getSwitchCostRT_RF_1B(excludeSubjects_RF_1B(false, true, false, first_N_RFshifts), 'single', false, true, false);
[delMe, switchDataForRF_GLM] = removeNonMatchingSubjects(zPreSwitch_Master_Included.Subject, ...
    zPreSwitch_Master_Included, switchDataForRF_GLM.Subject, switchDataForRF_GLM, false, true); 
[x_RFSw, y_RFSw] = getDataForSwitchGLM(switchDataForRF_GLM, '', false, 'TrialCount', 'all', 'single', false); % now calculate the model
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount - Cluster - TrialDur + RT','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})
RFcoeffs = RFSwModel.Coefficients.Estimate(:,1);
RFcoeffs(1,1) = 0; % the first subject is the reference from which the others are estimated; overwrite the Intercept as this subject's coefficient
RFcoeffs = RFcoeffs(1:(length(RFcoeffs)-3)); % remove the three coeffs for SwRep_2, RT, and TotalTrialCount

% if you want to look at error SwitchCost:     zScatter(zPreSwitch_Master_Included.TS_ErrorSC_Pre, RFcoeffs, 'Switch Ability (GLM) from first two days of RF Switch trials compared to Pretest Switch Cost', 'Pretest Switch Cost (Errors)', 'RF Switch Ability (GLM, first 2 days)', true, '', '', '', false, '', '');
zScatter(delMe.TS_RTSC_Pre, RFcoeffs, ...
    'Switch Ability (GLM) from first two days of RF Switch trials compared to Pretest Switch Cost', ...
    'Pretest Switch Cost (ReactionTime)', 'RF Switch Ability (GLM, first 2 days)', true, '', '', '', false, '', '');

[delMe, delMe2] = removeNonMatchingSubjects(zPreSwitch_Master_Included.Subject, zPreSwitch_Master_Included, switchCostRF.Subject, switchCostRF, true, true);
zScatter(delMe.TS_RTSC_Pre, delMe2.SwCost, ...
    'Switch Cost from first two days of RF Switch trials compared to Pretest Switch Cost', ...
    'Pretest Switch Cost (ReactionTime)', 'RF Switch Cost (first 2 days)', true, '', '', '', false, '', '');

clear RFcoeffs;
clear first_10_RFshifts;
clear zPreSwitch_Master_Included;
clear switchDataRF;
clear RFSwModel;
clear x_RFSw;
clear y_RFSw;



% find out the correlation between Pre/post SSRT (from Todd/Franziska) and RF SSRT 
[~, zPP_EF_FromMasterFile, ~] = formTables_RF_1A3('', '1b-final-Complete_EF_data_Ready_for_analysis.xlsx', '', true);
zPP_SSRT_Master_Included = zPP_EF_FromMasterFile(zPP_EF_FromMasterFile.SST_Exclude_Pre == 0, :); % remove excluded from Pre SSRT
[SSRT_RF_firstShifts_table] = getSSRT_RF_1B(excludeSubjects_RF_1B(false, true, false, first_N_RFshifts), 'single', false, true, false);  
[delMe, delMe2] = removeNonMatchingSubjects(SSRT_RF_firstShifts_table.Subject, SSRT_RF_firstShifts_table, ...
    zPP_SSRT_Master_Included.Subject, zPP_SSRT_Master_Included, true, false);
zScatter(delMe.SSRT_est, delMe2.SST_SSRT_Pre, ...
    'SSRT from first two days of RF Inhibit trials compared to Pretest Inhibit', ...
    'Pretest SSRT', 'RF first-two-days SSRT', true, '', '', 14, false, '', '')

clear zPP_SSRT_Master_Included;
clear SSRT_RF_firstShifts_table;




ZEPHY: SOMETHING WEIRD IS GOING ON HERE WITH READING IN THIS COMPLETE_EF FILE (LOOK AT PreIgnEvts, PostIgnEvts, RST_ArrowsAcc_Pre, etc.)
% find out the correlation between Pre/post Rotation (from Todd/Franziska) and RF Update (both GLM_Ability and Accuracy) 
[~, zPP_EF_FromMasterFile, ~] = formTables_RF_1A3('', '1b-final-Complete_EF_data_Ready_for_analysis.xlsx', '', true);
zPP_Rotation_Master_Included = zPP_EF_FromMasterFile(zPP_EF_FromMasterFile.RST_Exclude_Pre == 0, :); % remove excluded from Pre SSRT
delMe2 = excludeSubjects_RF_1B(false, true, false, first_N_RFshifts);
delMe3 = delMe2(strcmpi(delMe2.Cluster, 'u'),:);
delMe = table(0,0.0,0.0,'VariableNames', {'Subject','NonNBack_CorrectPct','NBack_CorrectPct'});
delMe5 = unique(delMe3.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = delMe3(delMe3.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe7 = delMe6(delMe6.NbackFlag ~= 1, :); % delMe7 = Non N-back trials
    delMe8 = height(delMe7(delMe7.Correct == true,:)) / height(delMe7);
    delMe9 = delMe6(delMe6.NbackFlag == 1, :); % delMe9 = N-back trials
    delMe10 = height(delMe9(delMe9.Correct == true,:)) / height(delMe9);
    delMe(delMe4,:) = {delMe5(delMe4) delMe8 delMe10};
end

[delMe, delMe2] = removeNonMatchingSubjects(delMe.Subject, delMe, zPP_Rotation_Master_Included.Subject, zPP_Rotation_Master_Included, true, false);

zScatter(delMe.NBack_CorrectPct, delMe2.RST_ArrowsAcc_Pre, 'Update Accuracy from first two days of RF N-back trials\ncompared to Pretest Arrow trials', 'RF first-two-days N-back accuracy', 'Pretest arrow rotation accuracy', true, '', '', 14, false, '', '')
zScatter(delMe.NBack_CorrectPct, delMe2.RST_ArrowsCorr_Pre, 'Update Accuracy from first two days of RF N-back trials\ncompared to Pretest Arrow trials', 'RF first-two-days N-back accuracy', 'Pretest arrow rotation accuracy', true, '', '', 14, false, '', '')
zScatter(delMe.NBack_CorrectPct, delMe2.RST_AbsArrCorr_Pre, 'Update Accuracy from first two days of RF N-back trials\ncompared to Pretest Arrow trials', 'RF first-two-days N-back accuracy', 'Pretest arrow rotation accuracy', true, '', '', 14, false, '', '')




% 1B: Compare Update Accuracy in Pretest (arrows) and first two days of RF (N-back) 

% z: only do this line if you haven't already defined singleTrials; takes a few minutes           zPPupdate_1B_singleTrials = singleArrowPerTrial_PP_1B(zPPupdate_1B, false); % make the usual PPupdate into one-arrow-per-line
includedPPupdate = excludeSubjects_RF_1B(true, true, false, zPPupdate_1B_singleTrials);
delMe2 = table(0,0.0,0.0,'VariableNames', {'Subject','Let_CorrectPct','Arr_CorrectPct'});
delMe5 = unique(includedPPupdate.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedPPupdate(includedPPupdate.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe8 = height(delMe6(strcmpi(delMe6.LetScore, 'correct'), :)) / height(delMe6);
    delMe10 = height(delMe6(strcmpi(delMe6.ArrScore, 'correct'), :)) / height(delMe6);
    
    delMe2(delMe4,:) = {delMe5(delMe4) delMe8 delMe10};
end

[delMe, delMe2] = removeNonMatchingSubjects(delMe.Subject, delMe, delMe2.Subject, delMe2, true, false);

zScatter(delMe.NBack_CorrectPct, delMe2.Arr_CorrectPct, 'Update Accuracy from first two days of RF N-back trials\ncompared to Pretest Arrow trials', 'RF first-two-days N-back accuracy', 'Pretest arrow rotation accuracy', true, '', '', 14, true, '', '')


% get the order in which most people see the L4 shifts (on SWING server)
[delMe, delMe2] = unique(zRF_1B(strcmpi(zRF_1B.Cluster,'L4aV1'),:).Shift,'first')

    

% timing comparison for equalizeKernelRegressedTrials_1B 1 and 2
delMe2 = zKernelRegressAll_firstNshifts(zKernelRegressAll_firstNshifts.Subject < 10, :);
delMe3 = zRFSum_1B(zRFSum_1B.Subject < 10, :);
tic
delMe = equalizeKernelRegressedTrials_1B(delMe2, delMe3, false, true);
toc

tic
delMe = equalizeKernelRegressedTrials2_1B(delMe2, delMe3, false, true);
toc
    



% get the interpolated kernel-smoothed logits for each cluster on the SWING server 
delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'U'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'U'),:); 
equalKernel_cluster_U = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'S'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'S'),:); 
equalKernel_cluster_S = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'I'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'I'),:); 
equalKernel_cluster_I = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'I/Logic'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'I/Logic'),:); 
equalKernel_cluster_I_logic = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'U/Logic'),:);
delMe = [delMe; zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'U/Logic(xOR)'),:)];
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'U/Logic'),:); 
delMe2 = [delMe2; zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'U/Logic(xOR)'),:)]; 
equalKernel_cluster_U_logic = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'S/Logic'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'S/Logic'),:); 
equalKernel_cluster_S_logic = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'S/I'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'S/I'),:); 
equalKernel_cluster_S_I = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'U/I'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'U/I'),:); 
equalKernel_cluster_U_I = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'U/S'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'U/S'),:); 
equalKernel_cluster_U_S = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'U/S/Logic'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'U/S/Logic'),:); 
equalKernel_cluster_U_S_logic = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'U/I/Logic'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'U/I/Logic'),:); 
equalKernel_cluster_U_I_logic = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'S/I/Logic'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'S/I/Logic'),:); 
equalKernel_cluster_S_I_logic = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'L4aV1'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'L4aV1'),:); 
equalKernel_cluster_L4aV1 = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'L4aV2'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'L4aV2'),:); 
equalKernel_cluster_L4aV2 = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'L4bV1'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'L4bV1'),:); 
equalKernel_cluster_L4bV1 = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);

delMe = zKernelTrialEstimates_1B(strcmpi(zKernelTrialEstimates_1B.Cluster, 'L4bV2'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'L4bV2'),:); 
equalKernel_cluster_L4bV2 = equalizeKernelRegressedTrials2_1B(delMe, delMe2, false, true);



delMe = []; % this will become the subject + the estimates
delMe2 = equalKernel_cluster_U;
delMe3 = unique(delMe2.Subject);
for delMe4 = 1:length(delMe3)
    delMe5 = delMe2(delMe2.Subject == delMe3(delMe4), :); % subject trials
    
    delMe6 = unique(delMe5.ShiftNum);

    delMe9 = []; % this will become the average estimates
    for delMe7 = 1:length(delMe6)
        delMe8 = delMe5(delMe5.ShiftNum == delMe6(delMe7), :).adjusted_kernelLogitEst; % estimates for just this shift
        if (isempty(delMe9)) % first time through
            delMe9 = delMe8;
        else
            delMe9 = delMe9 + delMe8; % sum the estimates for every shift in this cluster
        end
    end
    delMe9 = delMe9 / length(delMe6); % divide by the number of shifts = average estimates
    delMe(delMe4,:) = [delMe3(delMe4), transpose(delMe9)]; % subj, average estimates
end
avgKernel_cluster_U = delMe;
length(avgKernel_cluster_U)

save(getFileNameForThisOS('equalizedKernelEsts_Clusters.mat', 'ParsedData'),'equalKernel_cluster_I'...
,'equalKernel_cluster_I_logic','equalKernel_cluster_L4aV1','equalKernel_cluster_L4aV2','equalKernel_cluster_L4bV1'...
,'equalKernel_cluster_L4bV2','equalKernel_cluster_S','equalKernel_cluster_S_I','equalKernel_cluster_S_I_logic'...
,'equalKernel_cluster_S_logic','equalKernel_cluster_U','equalKernel_cluster_U_I','equalKernel_cluster_U_I_logic'...
,'equalKernel_cluster_U_S_logic','equalKernel_cluster_U_S','equalKernel_cluster_U_logic');

save(getFileNameForThisOS('avgKernelClusters.mat', 'ParsedData'),'avgKernel_cluster_I'...
,'avgKernel_cluster_I_logic','avgKernel_cluster_L4aV1','avgKernel_cluster_L4aV2','avgKernel_cluster_L4bV1'...
,'avgKernel_cluster_L4bV2','avgKernel_cluster_S','avgKernel_cluster_S_I','avgKernel_cluster_S_I_logic'...
,'avgKernel_cluster_S_logic','avgKernel_cluster_U','avgKernel_cluster_U_I','avgKernel_cluster_U_I_logic'...
,'avgKernel_cluster_U_S_logic','avgKernel_cluster_U_S','avgKernel_cluster_U_logic');

clear equalKernel_cluster_I;
clear equalKernel_cluster_I_logic;
clear equalKernel_cluster_L4aV1;
clear equalKernel_cluster_L4aV2;
clear equalKernel_cluster_L4bV1;
clear equalKernel_cluster_L4bV2;
clear equalKernel_cluster_S;
clear equalKernel_cluster_S_I;
clear equalKernel_cluster_S_I_logic;
clear equalKernel_cluster_S_logic;
clear equalKernel_cluster_U;
clear equalKernel_cluster_U_I;
clear equalKernel_cluster_U_I_logic;
clear equalKernel_cluster_U_S_logic;
clear equalKernel_cluster_U_S;
clear equalKernel_cluster_U_logic;

clear avgKernel_cluster_I;
clear avgKernel_cluster_I_logic;
clear avgKernel_cluster_L4aV1;
clear avgKernel_cluster_L4aV2;
clear avgKernel_cluster_L4bV1;
clear avgKernel_cluster_L4bV2;
clear avgKernel_cluster_S;
clear avgKernel_cluster_S_I;
clear avgKernel_cluster_S_I_logic;
clear avgKernel_cluster_S_logic;
clear avgKernel_cluster_U;
clear avgKernel_cluster_U_I;
clear avgKernel_cluster_U_I_logic;
clear avgKernel_cluster_U_S_logic;
clear avgKernel_cluster_U_S;
clear avgKernel_cluster_U_logic;


save(getFileNameForThisOS('zKernelTrialEstimates_1B.mat', 'ParsedData'),'zKernelTrialEstimates_1B');

save(getFileNameForThisOS('zIsoShiftEstimates_1B.mat', 'ParsedData'),'zIsoShiftEstimates_1B');
save(getFileNameForThisOS('zKernelShiftEstimates_1B.mat', 'ParsedData'),'zKernelShiftEstimates_1B');


% quick n dirty way of just getting the non-excluded subjects
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % now delMe has sum data for all included subjects
[delMe2, avgKernel_cluster_U] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_U(:,1), avgKernel_cluster_U, false, false); 
[delMe2, avgKernel_cluster_I] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_I(:,1), avgKernel_cluster_I, false, false); 
[delMe2, avgKernel_cluster_S] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_S(:,1), avgKernel_cluster_S, false, false); 
[delMe2, avgKernel_cluster_U_logic] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_U_logic(:,1), avgKernel_cluster_U_logic, false, false); 
[delMe2, avgKernel_cluster_I_logic] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_I_logic(:,1), avgKernel_cluster_I_logic, false, false); 
[delMe2, avgKernel_cluster_S_logic] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_S_logic(:,1), avgKernel_cluster_S_logic, false, false); 
[delMe2, avgKernel_cluster_U_S] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_U_S(:,1), avgKernel_cluster_U_S, false, false); 
[delMe2, avgKernel_cluster_U_I] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_U_I(:,1), avgKernel_cluster_U_I, false, false); 
[delMe2, avgKernel_cluster_S_I] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_S_I(:,1), avgKernel_cluster_S_I, false, false); 
[delMe2, avgKernel_cluster_U_S_logic] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_U_S_logic(:,1), avgKernel_cluster_U_S_logic, false, false); 
[delMe2, avgKernel_cluster_U_I_logic] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_U_I_logic(:,1), avgKernel_cluster_U_I_logic, false, false); 
[delMe2, avgKernel_cluster_S_I_logic] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_S_I_logic(:,1), avgKernel_cluster_S_I_logic, false, false); 
[delMe2, avgKernel_cluster_L4aV1] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_L4aV1(:,1), avgKernel_cluster_L4aV1, false, false); 
[delMe2, avgKernel_cluster_L4aV2] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_L4aV2(:,1), avgKernel_cluster_L4aV2, false, false); 
[delMe2, avgKernel_cluster_L4bV1] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_L4bV1(:,1), avgKernel_cluster_L4bV1, false, false); 
[delMe2, avgKernel_cluster_L4bV2] = removeNonMatchingSubjects(delMe.Subject, delMe, avgKernel_cluster_L4bV2(:,1), avgKernel_cluster_L4bV2, false, false); 




% estimate learning curves

delMe = []; % this will be the summed estimates
delMe6 = zEqualizedKernelLogits_firstNshifts(zEqualizedKernelLogits_firstNshifts.Subject == 1,:);
delMe2 = delMe6(strcmpi(delMe6.Cluster, 'U/S'),:);
delMe3 = unique(delMe2.ShiftNum);

for delMe4 = 1:length(delMe3)
    delMe5 = delMe2(delMe2.ShiftNum == delMe3(delMe4), :).adjusted_kernelLogitEst; % estimates for just this shift
    if (isempty(delMe)) % first time through
        delMe = delMe5;
    else
        delMe = delMe + delMe5; % sum the estimates for every shift in this cluster
    end
end
delMe7 = delMe / length(delMe3); % divide by the number of shifts = average estimates

zScatter(transpose(1:length(delMe7)), delMe7, 'Average kernel-smoothed logit of cluster performance', 'Normalized trial', 'Logit of average of all performance on this cluster', false, '', '', 14, false, '', '')







% help Misha to iterate through
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe5 = unique(delMe(strcmpi(delMe.Condition, 'RF tDCS'), :).Subject); % tDCS = red
delMe6 = unique(delMe(strcmpi(delMe.Condition, 'RF tRNS'), :).Subject); % tRNS = blue
delMe7 = unique(delMe(strcmpi(delMe.Condition, 'RF tDCS Sham'), :).Subject);
delMe7 = [delMe7; unique(delMe(strcmpi(delMe.Condition, 'RF tRNS Sham'), :).Subject)]; % both shams = green

delMe = {'avgKernel_cluster_I'...
,'avgKernel_cluster_I_logic','avgKernel_cluster_L4aV1','avgKernel_cluster_L4aV2','avgKernel_cluster_L4bV1'...
,'avgKernel_cluster_L4bV2','avgKernel_cluster_S','avgKernel_cluster_S_I','avgKernel_cluster_S_I_logic'...
,'avgKernel_cluster_S_logic','avgKernel_cluster_U','avgKernel_cluster_U_I','avgKernel_cluster_U_I_logic'...
,'avgKernel_cluster_U_S_logic','avgKernel_cluster_U_S','avgKernel_cluster_U_logic'};

delMe2 = eval(delMe{2});
for delMe3 = 1:length(delMe2)
    hold on;
    delMe4 = delMe2(delMe3, 2:end);
    if (ismember(delMe2(delMe3, 1),delMe5)) % tDCS = red
        plot(1:length(delMe4),delMe4,'Color',[0.9,0.3,0.3]);
    elseif (ismember(delMe2(delMe3, 1),delMe6)) % tRNS = blue
        plot(1:length(delMe4),delMe4,'Color',[0.3,0.9,0.3]);
    elseif (ismember(delMe2(delMe3, 1),delMe7)) % both shams = green
        plot(1:length(delMe4),delMe4,'Color',[0.3,0.3,0.9]);
    else
        fprintf('Who is this guy: %d ? No condition.\n', delMe2(delMe3, 1));
    end
    %zScatter(1:length(delMe4), delMe4, sprintf('Average kernel-smoothed logit of cluster performance for subject %d', delMe2(delMe3, 1)), 'Normalized trial', 'Logit of average of all performance on this cluster', false, '', '', 14, false, '', '');
    pause(.2);
end
hold off

% average across all subjects in one condition
for delMe4 = 1:length(delMe)
    delMe2 = eval(delMe{delMe4});
    
        delMe2 = avgKernel_cluster_L4bV2;

    figure
    hold on
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe5),2:end)); % tDCS = red
    plot(1:length(delMe3),delMe3,'Color',[0.9,0.3,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe6),2:end)); % tRNS = blue
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.9,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe7),2:end)); % sham = green
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.3,0.9]);
    hold off
end










% take Misha's cluster difficulty estimates and incorporate them into zKernelShiftEstimates_1B
    % Z NOTE: you must run '2015_12_18 misha_DifficultyPOv1113 script.m' to get Ds and ix before running this! 
zKernelShiftEstimates_1B.Cluster = strrep(zKernelShiftEstimates_1B.Cluster, 'U/Logic(xOR)', 'U/Logic'); % shift names don't also need to contain a short form of the cluster; remove
delMe = table(Snames(ix), Ds, 'VariableNames',{'ClusterName','Difficulty'}); % assume this is where Misha's difficulty results are
delMe.ClusterName = strrep(delMe.ClusterName, '+', '/'); % shift names don't also need to contain a short form of the cluster; remove
delMe.ClusterName = strrep(delMe.ClusterName, '4a/', ''); % shift names don't also need to contain a short form of the cluster; remove
delMe.ClusterName = strrep(delMe.ClusterName, '4b/', ''); % shift names don't also need to contain a short form of the cluster; remove

delMe7 = zKernelShiftEstimates_1B.Shift;
delMe7 = strrep(delMe7, ' ', '');
delMe7 = strrep(delMe7, '?', '');
delMe7 = strrep(delMe7, '_', '/');
delMe7 = strrep(delMe7, '-', '');
delMe7 = strrep(delMe7, '(S/I)', '');
delMe7 = strrep(delMe7, '(U/I)', '');
delMe7 = strrep(delMe7, '(U/S)', '');
delMe7 = strrep(delMe7, '4bT:1a', '');
delMe7 = strrep(delMe7, '4bT:1b', '');
delMe7 = strrep(delMe7, '4bT:1c', '');
delMe7 = strrep(delMe7, '4bT:2a', '');
delMe7 = strrep(delMe7, '4bT:2b', '');
delMe7 = strrep(delMe7, '4bT:2c', '');
delMe7 = strrep(delMe7, '4bT:3a', '');
delMe7 = strrep(delMe7, '4bT:3b', '');
delMe7 = strrep(delMe7, '4bT:3c', '');

zKernelShiftEstimates_1B.diffEst = zeros(height(zKernelShiftEstimates_1B), 1); % make a new col for the diff estimates
for delMe2 = 1:height(zKernelShiftEstimates_1B) % go through each shift
    % Z: SHOULD PROBABLY PUT SOME "SUBJ#" feedback here!
    delMe3 = zKernelShiftEstimates_1B.Cluster{delMe2}; % the cluster of this shift, if it's not L4
    delMe4 = delMe7{delMe2}; % the shiftName of this shift, modified to be compared against the L4 difficulty names
    if ( (strcmpi(delMe3, 'L4aV1') == 1) || ... % L4a
            (strcmpi(delMe3, 'L4aV2') == 1) || ...
            (strcmpi(delMe3, 'L4bV1') == 1) || ... %L4b
            (strcmpi(delMe3, 'L4bV2') == 1) )        
        delMe5 = delMe(strcmpi(delMe.ClusterName, delMe4),:).Difficulty; % it's level 4, so use the modified shift name
    else % it's not a Level4 shift; cluster name ought to just match
        delMe5 = delMe(strcmpi(delMe.ClusterName, delMe3),:).Difficulty;
    end
    zKernelShiftEstimates_1B(delMe2,:).diffEst = delMe5;
end







% now that we have the difficulty in zKernelShiftEstimates_1B, use that to see if there's a clear learning curve 

delMe3 = unique(zKernelShiftEstimates_1B.Subject);
for delMe4 = 1:length(delMe3)
    % first just plot the kernel estimates
    delMe5 = delMe3(delMe4); % subj
    delMe = zKernelShiftEstimates_1B(zKernelShiftEstimates_1B.Subject == delMe5, :);
    delMe2 = delMe.end_KernelLogit_AllPositive;
    delMe2 = delMe2 + delMe.diffEst;
    
    % remove everything from delMe2 that's negative, so we can take the log of it without involving imaginary numbers
    delMe(delMe2<0,:) = [];
    delMe2(delMe2<0) = [];    
    
    delMe6 = sprintf('Ability (performance + difficulty) per shift\n(Subject number %d)', delMe5);
%    zScatter(log(delMe.ShiftNum), log(delMe2), delMe6, 'Shift number', 'Ability estimate (end of shift)', false, '', '', '', false, '', '');
    zScatter(delMe.ShiftNum, delMe2, delMe6, 'Shift number', 'Ability estimate (end of shift)', false, '', '', '', false, '', '');
    hold on
    
    % then smoothe those estimates again, with another kernel, and plot that on top 
    delMe7 = delMe2; % just so we aren't re-using 2, in case we need it again
    delMe8 = max(delMe7) - min(delMe7); % find the total range
    delMe7 = delMe7 / delMe8; % now scale everything to between 0 and 1

    [~, delMe9] = getKernelProbEst(delMe7, 10, false); % now delMe9 is the kernel-smoothed values between 0 and 1
    delMe9 = delMe9 * delMe8; % return values to the original scale

%    plot(log(delMe.ShiftNum), log(delMe9), 'Color', 'red', 'LineWidth', 2)
    plot(delMe.ShiftNum, delMe9, 'Color', 'red', 'LineWidth', 2)
    
    % finally, fit the data with a power-law curve and plot that on top
    delMe10 = polyfit(log(delMe.ShiftNum),log(delMe2),1) % power law coefs
    delMe11 = polyval(delMe10*3.3, log(delMe.ShiftNum)); % poly-fitted y values
    
%    plot(log(delMe.ShiftNum), delMe11, 'Color', 'cyan', 'LineWidth', 2)
    plot(delMe.ShiftNum, delMe11, 'Color', 'cyan', 'LineWidth', 2)
    
    hold off

    pause(1);
end





% a couple of subjects that seem to have interesting learning curves: 
%   117
%   128
delMe5 = 128; % subj num
delMe = zKernelShiftEstimates_1B(zKernelShiftEstimates_1B.Subject == delMe5, :);
delMe2 = delMe.end_KernelLogit_AllPositive;
delMe2 = delMe2 + delMe.diffEst;
delMe6 = sprintf('Ability (performance + difficulty) per shift\n(Subject number %d)', delMe5);
zScatter(delMe.ShiftNum, delMe2, '', 'Block number', 'Ability estimate (end of each block)', false, '', '', 20, false, '', '');
% title(delMe6)

% first, normalize Ability scores to between 0 and 1
delMe3 = delMe2; % start with the Ability scores
% delMe6 = min(delMe3);
% if (delMe6 < 0)
%    delMe3 = delMe3 + (min(delMe3) * -1); % shift it up to make everything positive
% end
delMe4 = max(delMe3) - min(delMe3);
delMe3 = delMe3 / delMe4; % now everything is between 0 and 1

[~, delMe5] = getKernelProbEst(delMe3, 10, false); % now delMe5 is the kernel-smoothed values between 0 and 1
delMe5 = delMe5 * delMe4; % spread it out again
% if (delMe6 < 0)
%    delMe5 = delMe5 - delMe6; % shift it down again
% end

hold on
plot(delMe.ShiftNum, delMe5, 'Color', 'red', 'LineWidth', 2)
hold off

figure
zScatter(delMe.ShiftNum, delMe5, 'Kernel-smoothed Ability (performance + difficulty) per shift\n(Subject number 128)', 'Shift number', 'Kernel-smoothed Ability estimate (end of shift)', false, '', '', '', false, '', '');


u_shifts = delMe(strcmpi(delMe.Cluster, 'U'), :);
u_shifts_scores = u_shifts.end_KernelLogit_AllPositive;
u_shifts_scores = u_shifts_scores + u_shifts.diffEst;
s_shifts = delMe(strcmpi(delMe.Cluster, 'S'), :);
s_shifts_scores = s_shifts.end_KernelLogit_AllPositive;
s_shifts_scores = s_shifts_scores + s_shifts.diffEst;
i_shifts = delMe(strcmpi(delMe.Cluster, 'I'), :);
i_shifts_scores = i_shifts.end_KernelLogit_AllPositive;
i_shifts_scores = i_shifts_scores + i_shifts.diffEst;

figure
hold on;
delMe6 = sprintf('Ability (performance + difficulty) per shift\n(Subject number %d)', delMe5);
title(delMe6)
scatter(u_shifts.ShiftNum, u_shifts_scores, 'Color', 'red');
hold off

clear u_shifts s_shifts i_shifts;
clear u_shifts_scores s_shifts_scores i_shifts_scores;



% see a single shift (subj128, shift10)
delMe = zKernelRegressAll_firstNshifts(zKernelRegressAll_firstNshifts.Subject == 128,:);
delMe2 = delMe(delMe.ShiftNum == 10,:);

zScatter(delMe2.TrialNum, delMe2.kernelLogitEst, 'Ability (Logit of Kernel-smoothed estimate) per trial\n(Subject number 128, Shift number 10: Update)', 'Trial number', 'Logit of Kernel-smoothed estimate', false, '', '', '', false, '', '');

% now see the same shift with Prob, rather than LogitProb
figure
[~, delMe10] = getKernelRegressedPerf_Shifts_1B(first_N_RFshifts(first_N_RFshifts.Subject == 128,:), false, true);
delMe2 = delMe10(delMe10.ShiftNum == 10,:);

zScatter(delMe2.TrialNum, delMe2.kernelEst, '', 'Trial number', 'Kernel-smoothed probability estimate', false, '', '', 20, false, '', '');
title('Kernel-smoothed performance per trial\n(Subject number 128, Shift number 10: Update)');

% now kernel-smooth it again and look at it
[~, delMe3] = getKernelProbEst(delMe2.kernelEst, 10, false); 
hold on
plot(delMe2.TrialNum, delMe3, 'Color', 'red', 'LineWidth', 2)
hold off

figure
zScatter(delMe2.TrialNum, delMe3, '', 'Trial number', 'Kernel-smoothed probability estimate', false, '', '', '', false, '', '');
%title('Kernel-resmoothed performance per trial\n(Subject number 128, Shift number 10: Update)')



zPPmeasures = formTableFromXLS('1b-final-PRE-POST-MEASURES', true, true, true);
save(getFileNameForThisOS('2016_2_9-PrePostMeasures.mat', 'ParsedData'), 'zPPmeasures');




% z: Eventually, want to look at the end of each variable name (HOW???) for Pre/Post, and exclude on that basis
%       For now, just exclude anyone who is excluded from either Pre or Post 
delMe = formTableFromXLS('1b-final-PRE-POST-MEASURES_ALL', true, true, true);
% first, kill everything from subjs that were globally excluded
delMe(delMe.Exclusion == 0, :) = [];
% now exclude from the Switch task
delMe4 = delMe.Properties.VariableNames(:,strncmpi(delMe.Properties.VariableNames, 'TS_',3));
delMe5 = length(delMe4) - 2; % last two cols are Exclude_Pre and Exclude_Post
for delMe6 = 1:delMe5 % all the non-exclude cols
    delMe.(delMe4{delMe6})(delMe.(delMe4{end-1}) == 1) = NaN;
    delMe.(delMe4{delMe6})(delMe.(delMe4{end}) == 1) = NaN;
end
% delMe(1:10,delMe4) % just to check and make sure
% exclude from the Stop Signal task
delMe4 = delMe.Properties.VariableNames(:,strncmpi(delMe.Properties.VariableNames, 'SST_',4));
delMe5 = length(delMe4) - 2; % last two cols are Exclude_Pre and Exclude_Post
for delMe6 = 1:delMe5 % all the non-exclude cols
    delMe.(delMe4{delMe6})(delMe.(delMe4{end-1}) == 1) = NaN;
    delMe.(delMe4{delMe6})(delMe.(delMe4{end}) == 1) = NaN;
end
% delMe(1:10,delMe4) % just to check and make sure
% exclude from the Rotation Span task
delMe4 = delMe.Properties.VariableNames(:,strncmpi(delMe.Properties.VariableNames, 'RST_',4));
delMe5 = length(delMe4) - 2; % last two cols are Exclude_Pre and Exclude_Post
for delMe6 = 1:delMe5 % all the non-exclude cols
    delMe.(delMe4{delMe6})(delMe.(delMe4{end-1}) == 1) = NaN;
    delMe.(delMe4{delMe6})(delMe.(delMe4{end}) == 1) = NaN;
end
% delMe(1:10,delMe4) % just to check and make sure
%exclude from the EO
delMe4 = delMe.Properties.VariableNames(:,strncmpi(delMe.Properties.VariableNames, 'EO',2));
for delMe6 = 1:length(delMe4) % EO exclusion have different names: ExcludeEO and ExcludeEOPost
    delMe.(delMe4{delMe6})(delMe.ExcludeEO == 1) = NaN;
    delMe.(delMe4{delMe6})(delMe.ExcludeEOPost == 1) = NaN;
end
% delMe(1:10,delMe4) % just to check and make sure

zPPmeasures_All = delMe;
save(getFileNameForThisOS('2016_2_9-PrePostMeasures_ALL.mat', 'ParsedData'), 'zPPmeasures_All');


% ClustDiff - ordinal variable indicating the relative cluster difficulty


% create "difficulty" or "performance" measures per-shift for Yeganeh EEG analyses 
delMe = zRFSum_1B(zRFSum_1B.ShiftNum < 41,:); % just get the first 40 shifts (first two days)
delMe = zRFSum_1B; % or you can do all shifts
delMe.ClustDiff = zeros(height(delMe),1); % now mark the cluster difficulties, in order
delMe(strcmpi(delMe.Cluster,'I'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'I'),:)),1) + 1;
delMe(strcmpi(delMe.Cluster,'U'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'U'),:)),1) + 2;
delMe(strcmpi(delMe.Cluster,'S'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'S'),:)),1) + 3;
delMe(strcmpi(delMe.Cluster,'S/I'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'S/I'),:)),1) + 4;
delMe(strcmpi(delMe.Cluster,'U/I'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'U/I'),:)),1) + 5;
delMe(strcmpi(delMe.Cluster,'I/Logic'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'I/Logic'),:)),1) + 6;
delMe(strcmpi(delMe.Cluster,'U/I/Logic'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'U/I/Logic'),:)),1) + 7;
delMe(strcmpi(delMe.Cluster,'S/I/Logic'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'S/I/Logic'),:)),1) + 8;
delMe(strcmpi(delMe.Shift,'Typographic Trigonometry (U/I)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Typographic Trigonometry (U/I)'),:)),1) + 9;
delMe(strcmpi(delMe.Shift,'Biological Itemizing (U/S)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Biological Itemizing (U/S)'),:)),1) + 10;
delMe(strcmpi(delMe.Shift,'Reptile Plotting (U/S)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Reptile Plotting (U/S)'),:)),1) + 11;
delMe(strcmpi(delMe.Cluster,'U/S'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'U/S'),:)),1) + 12;
delMe(strcmpi(delMe.Shift,'Theoretical Aerodynamics (U/I)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Theoretical Aerodynamics (U/I)'),:)),1) + 13;
delMe(strcmpi(delMe.Cluster,'S/Logic'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'S/Logic'),:)),1) + 14;
delMe(strcmpi(delMe.Shift,'4b T:1a - rm Prrtzng'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:1a - rm Prrtzng'),:)),1) + 15;
delMe(strcmpi(delMe.Cluster,'U/Logic'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'U/Logic'),:)),1) + 16;
delMe(strcmpi(delMe.Cluster,'U/Logic(xOR)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'U/Logic(xOR)'),:)),1) + 16;
delMe(strcmpi(delMe.Shift,'Proportional Sympathizing (U/S)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Proportional Sympathizing (U/S)'),:)),1) + 17;
delMe(strcmpi(delMe.Shift,'4b T:2a - Meat-Bag Edition'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:2a - Meat-Bag Edition'),:)),1) + 18;
delMe(strcmpi(delMe.Shift,'Tetromino Groking (U/I)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Tetromino Groking (U/I)'),:)),1) + 19;
delMe(strcmpi(delMe.Shift,'4b T:1b - O_gan Failure?'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:1b - O_gan Failure?'),:)),1) + 20;
delMe(strcmpi(delMe.Cluster,'U/S/Logic'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Cluster,'U/S/Logic'),:)),1) + 21;
delMe(strcmpi(delMe.Shift,'Dimensional Jargonization (U/S)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Dimensional Jargonization (U/S)'),:)),1) + 22;
delMe(strcmpi(delMe.Shift,'Algorithmic Comprehension (S/I)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Algorithmic Comprehension (S/I)'),:)),1) + 23;
delMe(strcmpi(delMe.Shift,'Computational Vocalizations (S/I)'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'Computational Vocalizations (S/I)'),:)),1) + 24;
delMe(strcmpi(delMe.Shift,'4b T:1c - AAAAAAAA'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:1c - AAAAAAAA'),:)),1) + 25;
delMe(strcmpi(delMe.Shift,'4b T:3c - Penultimations'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:3c - Penultimations'),:)),1) + 26;
delMe(strcmpi(delMe.Shift,'4b T:2c - Extended training'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:2c - Extended training'),:)),1) + 27;
delMe(strcmpi(delMe.Shift,'4b T:2b - For exceptional testers'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:2b - For exceptional testers'),:)),1) + 28;
delMe(strcmpi(delMe.Shift,'4b T:3a - Specializations'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:3a - Specializations'),:)),1) + 29;
delMe(strcmpi(delMe.Shift,'4b T:3b - Extreme Categorizing'),:).ClustDiff = zeros(height(delMe(strcmpi(delMe.Shift,'4b T:3b - Extreme Categorizing'),:)),1) + 30;

delMe.ClustDiffPlusN = delMe.ClustDiff + (.33 * (delMe.ActualN - 1)); % make the ones with N > 1 just a little harder

delMe.ComplexityLevel = zeros(height(delMe),1); % mark the complexity levels as non-cells (basically just make 4b into 5)
delMe(strcmpi(delMe.Cluster,'I'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'I'),:)),1) + 1;
delMe(strcmpi(delMe.Cluster,'U'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'U'),:)),1) + 1;
delMe(strcmpi(delMe.Cluster,'S'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'S'),:)),1) + 1;
delMe(strcmpi(delMe.Cluster,'S/I'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'S/I'),:)),1) + 2;
delMe(strcmpi(delMe.Cluster,'U/I'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'U/I'),:)),1) + 2;
delMe(strcmpi(delMe.Cluster,'U/S'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'U/S'),:)),1) + 2;
delMe(strcmpi(delMe.Cluster,'S/Logic'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'S/Logic'),:)),1) + 2;
delMe(strcmpi(delMe.Cluster,'U/Logic'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'U/Logic'),:)),1) + 2;
delMe(strcmpi(delMe.Cluster,'I/Logic'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'I/Logic'),:)),1) + 2;
delMe(strcmpi(delMe.Cluster,'U/I/Logic'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'U/I/Logic'),:)),1) + 3;
delMe(strcmpi(delMe.Cluster,'S/I/Logic'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'S/I/Logic'),:)),1) + 3;
delMe(strcmpi(delMe.Cluster,'U/Logic(xOR)'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'U/Logic(xOR)'),:)),1) + 3;
delMe(strcmpi(delMe.Cluster,'U/S/Logic'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'U/S/Logic'),:)),1) + 3;
delMe(strcmpi(delMe.Cluster,'L4aV1'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'L4aV1'),:)),1) + 4;
delMe(strcmpi(delMe.Cluster,'L4aV2'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'L4aV2'),:)),1) + 4;
delMe(strcmpi(delMe.Cluster,'L4bV1'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'L4bV1'),:)),1) + 5;
delMe(strcmpi(delMe.Cluster,'L4bV2'),:).ComplexityLevel = zeros(height(delMe(strcmpi(delMe.Cluster,'L4bV2'),:)),1) + 5;

%zPerShiftData_forYeganeh = delMe;
%save(getFileNameForThisOS('2016_3_3_zPerShiftData_forYeganeh.mat', 'IntResults'),'zPerShiftData_forYeganeh');
%clear zPerShiftData_forYeganeh;
zPerShiftData_forSumientra = delMe;
save(getFileNameForThisOS('2016_3_3_zPerShiftData_forSumientra.mat', 'IntResults'),'zPerShiftData_forSumientra');
clear zPerShiftData_forSumientra;

    
    
% take the output from getIsoRperf_Shifts_1B (trials) and figure out when each shift hits .8 (threshold) 
threshold = .8;
% go through the SUM file, find all the iso_trials for each shift, and add a value to the SUM file 
delMe = zRFSum_1B;
delMe.isoThresholdTrial = zeros(height(delMe),1) - 1; % start with all -1s
for sumFileRow = 1:height(zRFSum_1B)
    if (sumFileRow > 1)
        if (delMe.Subject(sumFileRow) ~= delMe.Subject(sumFileRow - 1))
            fprintf('working on Subject %d\n', delMe.Subject(sumFileRow));
        end
    end
    shiftInfoThisRow = zRFSum_1B(sumFileRow,:);
    isoTrialsThisShift = zIsoTrialEstimates_1B((zIsoTrialEstimates_1B.Subject == shiftInfoThisRow.Subject) & (zIsoTrialEstimates_1B.ShiftNum == shiftInfoThisRow.ShiftNum), :);
    isoTrialsAboveThreshold = isoTrialsThisShift(isoTrialsThisShift.isoEst > threshold, :);
    if (isempty(isoTrialsAboveThreshold)) % nothing got above threshold
        isoThresholdEst = isoTrialsThisShift(height(isoTrialsThisShift),:).isoEst; % take the final one, as it will be the closest to threshold
    else % grab the trial number of the first one to meet threshold
        isoThresholdEst = isoTrialsAboveThreshold(1,:).TrialNum;
    end
    delMe.isoThresholdTrial(sumFileRow) = isoThresholdEst;
end

clear threshold sumFileRow shiftInfoThisRow isoTrialsThisShift isoTrialsAboveThreshold isoThresholdEst
% delMe NOW EQUALS SUM FILE PLUS THRESHOLD VALUES



% visualize the iso_threshold values gotten from SWING server 

rSqTable = table(0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,'VariableNames',{'Subject','U','I','S','U_I','U_S','S_I','U_Logic','S_Logic','I_Logic','L4a','L4b'});
uniqueSubjs = unique(zIsoShiftThresholds_1B.Subject);
for iterator = 1:length(uniqueSubjs)
    subjNum = uniqueSubjs(iterator);
    subjThresholds = zIsoShiftThresholds_1B(zIsoShiftThresholds_1B.Subject == subjNum, :);
    subjThresholds = subjThresholds(subjThresholds.isoThresholdTrial > 1, :); % just the shifts where they actually got to threshold
    subjClustU = subjThresholds(strcmpi(subjThresholds.Cluster,'U'),:); 
    subjClustS = subjThresholds(strcmpi(subjThresholds.Cluster,'S'),:); 
    subjClustI = subjThresholds(strcmpi(subjThresholds.Cluster,'I'),:); 
    subjClustU_S = subjThresholds(strcmpi(subjThresholds.Cluster,'U/S'),:); 
    subjClustU_I = subjThresholds(strcmpi(subjThresholds.Cluster,'U/I'),:); 
    subjClustS_I = subjThresholds(strcmpi(subjThresholds.Cluster,'S/I'),:); 
    subjClustU_Logic = subjThresholds(strcmpi(subjThresholds.Cluster,'U/Logic'),:); 
    subjClustS_Logic = subjThresholds(strcmpi(subjThresholds.Cluster,'S/Logic'),:); 
    subjClustI_Logic = subjThresholds(strcmpi(subjThresholds.Cluster,'I/Logic'),:); 
    subjClustL4aV1 = subjThresholds(strcmpi(subjThresholds.Cluster,'L4aV1'),:); 
    subjClustL4bV1 = subjThresholds(strcmpi(subjThresholds.Cluster,'L4bV1'),:); 

    titleStr = sprintf('Threshold learning: Update (Subject %d)', subjNum); % title
    zScatter(subjClustU.ShiftNum, subjClustU.isoThresholdTrial, titleStr, 'ShiftNum', 'Trials to threshold', true, '', '', '', false, '', '');

    if (height(subjClustU) > 3)
        U_stats = regstats(subjClustU.ShiftNum, subjClustU.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (U_stats.beta(2) > 0) % slope is positive
            U_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        U_stats.rsquare = -3;
    end
    if (height(subjClustS) > 3)
        S_stats = regstats(subjClustS.ShiftNum, subjClustS.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (S_stats.beta(2) > 0) % slope is positive
            S_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        S_stats.rsquare = -3;
    end
    if (height(subjClustI) > 3)
        I_stats = regstats(subjClustI.ShiftNum, subjClustI.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (I_stats.beta(2) > 0) % slope is positive
            I_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        I_stats.rsquare = -3;
    end
    if (height(subjClustU_S) > 3)
        US_stats = regstats(subjClustU_S.ShiftNum, subjClustU_S.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (US_stats.beta(2) > 0) % slope is positive
            US_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        US_stats.rsquare = -3;
    end
    if (height(subjClustU_I) > 3)
        UI_stats = regstats(subjClustU_I.ShiftNum, subjClustU_I.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (UI_stats.beta(2) > 0) % slope is positive
            UI_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        UI_stats.rsquare = -3;
    end
    if (height(subjClustS_I) > 3)
        SI_stats = regstats(subjClustS_I.ShiftNum, subjClustS_I.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (SI_stats.beta(2) > 0) % slope is positive
            SI_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        SI_stats.rsquare = -3;
    end
    if (height(subjClustU_Logic) > 3)
        ULogic_stats = regstats(subjClustU_Logic.ShiftNum, subjClustU_Logic.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (ULogic_stats.beta(2) > 0) % slope is positive
            ULogic_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        ULogic_stats.rsquare = -3;
    end
    if (height(subjClustS_Logic) > 3)
        SLogic_stats = regstats(subjClustS_Logic.ShiftNum, subjClustS_Logic.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (SLogic_stats.beta(2) > 0) % slope is positive
            SLogic_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        SLogic_stats.rsquare = -3;
    end
    if (height(subjClustI_Logic) > 3)
        ILogic_stats = regstats(subjClustI_Logic.ShiftNum, subjClustI_Logic.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (ILogic_stats.beta(2) > 0) % slope is positive
            ILogic_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        ILogic_stats.rsquare = -3;
    end
    if (height(subjClustL4aV1) > 3)
        L4aV1_stats = regstats(subjClustL4aV1.ShiftNum, subjClustL4aV1.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (L4aV1_stats.beta(2) > 0) % slope is positive
            L4aV1_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        L4aV1_stats.rsquare = -3;
    end
    if (height(subjClustL4bV1) > 3)
       L4bV1_stats = regstats(subjClustL4bV1.ShiftNum, subjClustL4bV1.isoThresholdTrial,'linear',{'rsquare','beta'});
        if (L4bV1_stats.beta(2) > 0) % slope is positive
            L4bV1_stats.rsquare = -2; % ignore this one, we can't explain it
        end
    else
        L4bV1_stats.rsquare = -3;
    end
    
    rowTable = table(subjNum,U_stats.rsquare * -1,S_stats.rsquare  * -1,I_stats.rsquare  * -1,...
        US_stats.rsquare * -1,UI_stats.rsquare * -1,SI_stats.rsquare * -1,...
        ULogic_stats.rsquare * -1,SLogic_stats.rsquare * -1,ILogic_stats.rsquare * -1,...
        L4aV1_stats.rsquare * -1,L4bV1_stats.rsquare * -1,...
        'VariableNames',{'Subject','U','I','S','U_I','U_S','S_I','U_Logic','S_Logic','I_Logic','L4a','L4b'});

    rSqTable(iterator,:) = rowTable;
end

clear uniqueSubjs iterator subjNum subjThresholds
clear subjClustU subjClustS subjClustI subjClustU_S subjClustU_I subjClustS_I
clear subjClustU_Logic subjClustS_Logic subjClustI_Logic subjClustL4aV1 subjClustL4bV1
clear titleStr U_stats S_stats I_stats US_stats UI_stats SI_stats 
clear ULogic_stats SLogic_stats ILogic_stats L4aV1_stats L4bV1_stats 
clear rSqTable


rSqTable(rSqTable.U_S < -.1, :)
    
    delMe = 694; % subj
    delMe2 = zIsoShiftThresholds_1B(zIsoShiftThresholds_1B.Subject == delMe, :);
    delMe3 = delMe2(delMe2.isoThresholdTrial > 1, :); % just the shifts where they actually got to threshold
    delMe4 = delMe3(strcmpi(delMe3.Cluster,'U'),:); % cluster
    delMe4 = delMe4(strcmpi(delMe4.Shift,'Color Balancing (U)'),:); % shift

    titleStr = sprintf('Threshold learning: (Subject %d)', delMe); % title
    zScatter(delMe4.ShiftNum, delMe4.isoThresholdTrial, titleStr, 'ShiftNum', 'Trials to threshold', true, '', '', '', false, '', '');
    delMe5 = regstats(delMe4.ShiftNum, delMe4.isoThresholdTrial,'linear',{'rsquare','beta'});

    
    
    
% make a list of all shifts (+ Nvals, for Update-involved shifts), and then count the transitions between them  
shiftNameTable = []; % clear it; this will eventually be a table of names, plus Nvals
shiftNameList = unique(zRFSum_1B.Shift); % shift name list
updateShiftList = {}; % blank cell structure
shiftPlusNlist = {}; % blank cell structure
for delMe3 = 1:length(shiftNameList) % first, grab all the update shifts
    shiftName = shiftNameList{delMe3}; % particular shift name (non-cell)
    if ( (strcmpi(shiftName(end-4:end), '(U/S)') == 1) || ... % add to Update-shift list
            (strcmpi(shiftName(end-4:end), '(U/I)') == 1) || ...
            (strcmpi(shiftName(end-2:end), '(U)') == 1) || ...
            (strcmpi(shiftName, 'Algorithmic Comprehension (S/I)') == 1) || ... % this is a Lv4a
            (strcmpi(shiftName, 'Computational Vocalizations (S/I)') == 1) || ... % this is a Lv4a
            (strcmpi(shiftName, '4b T:1c - AAAAAAAA') == 1) || ... % this is a Lv4b
            (strcmpi(shiftName, '4b T:2a - Meat-Bag Edition') == 1) || ... % this is a Lv4b
            (strcmpi(shiftName, '4b T:3a - Specializations') == 1) ) % this is a Lv4b
        updateShiftList(length(updateShiftList)+1, 1) = shiftNameList(delMe3); % add this shift name (as a cell)
    else % not an update shift; might as well add it to the total shift list
        shiftPlusNlist(length(shiftPlusNlist)+1, 1) = getVarNameFromShift(shiftNameList(delMe3), 0, false); % add this shift name (as a cell)
    end
end
for delMe = 1:length(updateShiftList)
    updateShiftName = updateShiftList{delMe}; % particular update shift name (non-cell)
    shiftPlusNlist(length(shiftPlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 1, false);
    shiftPlusNlist(length(shiftPlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 2, false);
    shiftPlusNlist(length(shiftPlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 3, false);
end
clear shiftNameList shiftName updateShiftList updateShiftName % just interim variables
    
clear shiftPlusNlist shiftNameTable % the end variables

    




% see how many shifts were repeated in 1A-3 (Z: SHOULD PROBABLY DO THIS FOR 1B AT SOME POINT) 
delMe10 = table(0,0,{'shiftName'},'VariableNames',{'Subj','Count','Shift'});
delMe = excludeSubjects_RF_1A3('all', false, zRFSum_1A3);
delMe2 = unique(delMe.Subject);
delMe11 = 1; % iterator to show which line of delMe10 we're on
for delMe3 = 1:length(delMe2)
    delMe4 = delMe2(delMe3); % subj num
    delMe5 = delMe(delMe.Subject == delMe4, :); % subj shifts
    delMe6 = unique(delMe5.Shift);
    for delMe7 = 1:length(delMe6)
        delMe8 = delMe6(delMe7); % shift name
        delMe9 = delMe5(strcmpi(delMe5.Shift, delMe8), :);
        delMe12 = delMe10(delMe10.Subj == delMe4, :);
        if (isempty(delMe12))
            delMe10(delMe11,:) = table(delMe4,height(delMe9),delMe8,'VariableNames',{'Subj','Count','Shift'});
            delMe11 = delMe11 + 1;
        elseif (isempty(delMe12(strcmpi(delMe12.Shift,delMe8),:))) % we haven't done this one before
            delMe10(delMe11,:) = table(delMe4,height(delMe9),delMe8,'VariableNames',{'Subj','Count','Shift'});
            delMe11 = delMe11 + 1;
        end
    end
end
    
height(delMe)
delMe10
height(delMe10)
height(delMe10(delMe10.Count == 1,:))
max(delMe10.Count)
delMe10(delMe10.Count > 6,:)





% put the "ActualN" into zKernelShiftEstimates_1B, so that we can use getKernelShiftInfoMatrix_1B() on it 
% while we're at it, also put the "JumpBack" in, so we can exclude those from shift difficulty estimations 
%   zNOTE: takes several minutes!
zKernelShiftEstimates_1B.ActualN = zeros(height(zKernelShiftEstimates_1B), 1) - 1;
zKernelShiftEstimates_1B.JumpBack = zeros(height(zKernelShiftEstimates_1B), 1) - 1;
uniqueSubjsList = unique(zKernelShiftEstimates_1B.Subject); 
for i = 1:length(uniqueSubjsList)
    curSubj = uniqueSubjsList(i);
    fprintf('Working on subject %d\n', curSubj);
    subjRows = zKernelShiftEstimates_1B(zKernelShiftEstimates_1B.Subject == curSubj, :);
    uniqueShiftNums = unique(subjRows.ShiftNum);
    for j = 1:length(uniqueShiftNums)
        curShiftNum = uniqueShiftNums(j);
        sumShift = zRFSum_1B((zRFSum_1B.Subject == curSubj) & ...
            (zRFSum_1B.ShiftNum == curShiftNum), :);

        zKernelShiftEstimates_1B((zKernelShiftEstimates_1B.Subject == curSubj) & ...
            (zKernelShiftEstimates_1B.ShiftNum == curShiftNum), :).ActualN = ...
            sumShift.ActualN;
        
        thisIsNotAJumpBack = isnan(sumShift.JumpBack{1}); % jump-backs are either NaN or a cell string of the shift name
        if (thisIsNotAJumpBack(1) == 1) % not a jump-back
            zKernelShiftEstimates_1B((zKernelShiftEstimates_1B.Subject == curSubj) & ...
            (zKernelShiftEstimates_1B.ShiftNum == curShiftNum), :).JumpBack = 0;
        else % it is a jump-back shift
            zKernelShiftEstimates_1B((zKernelShiftEstimates_1B.Subject == curSubj) & ...
            (zKernelShiftEstimates_1B.ShiftNum == curShiftNum), :).JumpBack = 1;
        end
    end
end
clear uniqueSubjsList i curSubj subjRows uniqueShiftNums j curShiftNum;
clear sumShift thisIsNotAJumpBack;




% Create a partial ordering for Clusters
clusterNamesInOrder = {'U', 'S', 'I', ...
    'U_Logic', 'S_Logic', 'I_Logic', ...
    'U_S', 'U_I', 'S_I', ...
    'U_S_Logic', 'U_I_Logic', 'S_I_Logic', ...
    'L4aV1', 'L4aV2', 'L4bV1', 'L4bV2'};
clusterPO_1B = array2table(zeros(length(clusterNamesInOrder),length(clusterNamesInOrder)),...
        'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);
clusterPO_1B{'U','U_Logic'} = 1;
clusterPO_1B{'U','U_S'} = 1;
clusterPO_1B{'U','U_I'} = 1;
clusterPO_1B{'U','U_S_Logic'} = 1;
clusterPO_1B{'U','U_I_Logic'} = 1;
clusterPO_1B{'U','L4aV1'} = 1;
clusterPO_1B{'U','L4aV2'} = 1;
clusterPO_1B{'S','S_Logic'} = 1;
clusterPO_1B{'S','U_S'} = 1;
clusterPO_1B{'S','S_I'} = 1;
clusterPO_1B{'S','U_S_Logic'} = 1;
clusterPO_1B{'S','S_I_Logic'} = 1;
clusterPO_1B{'S','L4aV1'} = 1;
clusterPO_1B{'S','L4aV2'} = 1;
clusterPO_1B{'I','I_Logic'} = 1;
clusterPO_1B{'I','U_I'} = 1;
clusterPO_1B{'I','S_I'} = 1;
clusterPO_1B{'I','U_I_Logic'} = 1;
clusterPO_1B{'I','S_I_Logic'} = 1;
clusterPO_1B{'I','L4aV1'} = 1;
clusterPO_1B{'I','L4aV2'} = 1;
clusterPO_1B{'U_Logic','U_S_Logic'} = 1;
clusterPO_1B{'U_Logic','U_I_Logic'} = 1;
clusterPO_1B{'U_Logic','L4aV1'} = 1;
clusterPO_1B{'U_Logic','L4aV2'} = 1;
clusterPO_1B{'S_Logic','U_S_Logic'} = 1;
clusterPO_1B{'S_Logic','S_I_Logic'} = 1;
clusterPO_1B{'S_Logic','L4aV1'} = 1;
clusterPO_1B{'S_Logic','L4aV2'} = 1;
clusterPO_1B{'I_Logic','U_I_Logic'} = 1;
clusterPO_1B{'I_Logic','S_I_Logic'} = 1;
clusterPO_1B{'I_Logic','L4aV1'} = 1;
clusterPO_1B{'I_Logic','L4aV2'} = 1;
clusterPO_1B{'U_S','U_S_Logic'} = 1;
clusterPO_1B{'U_S','L4aV1'} = 1;
clusterPO_1B{'U_S','L4aV2'} = 1;
clusterPO_1B{'U_I','U_I_Logic'} = 1;
clusterPO_1B{'U_I','L4aV1'} = 1;
clusterPO_1B{'U_I','L4aV2'} = 1;
clusterPO_1B{'S_I','S_I_Logic'} = 1;
clusterPO_1B{'S_I','L4aV1'} = 1;
clusterPO_1B{'S_I','L4aV2'} = 1;
clusterPO_1B{'U_S_Logic','L4aV1'} = 1;
clusterPO_1B{'U_S_Logic','L4aV2'} = 1;
clusterPO_1B{'U_I_Logic','L4aV1'} = 1;
clusterPO_1B{'U_I_Logic','L4aV2'} = 1;
clusterPO_1B{'S_I_Logic','L4aV1'} = 1;
clusterPO_1B{'S_I_Logic','L4aV2'} = 1;
save(getFileNameForThisOS('2016_4_23_clusterPO_1B.mat', 'ParsedData'), 'clusterPO_1B')
clear clusterNamesInOrder


% Create a partial ordering for Shifts
    % first, get all the shift names (plus Nvals), in table-variable-friendly format 
    shiftNameList = unique(zRFSum_1B.Shift); % shift name list
    L4aShiftNameList = {}; % blank cell structure
    updateShiftNameList = {}; % blank cell structure
    varNamePlusNlist = {}; % blank cell structure
    for iterator = 1:length(shiftNameList) % first, grab all the update shifts
        shiftName = shiftNameList{iterator}; % particular shift name (non-cell)
        if ( (strcmpi(shiftName, '4a Update Switch V1 (U/S)') == 1) || ... % first break out the Lv4a shifts, might have N > 3
                (strcmpi(shiftName, '4a Update Switch V1 - 2 (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Biological Itemizing (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Reptile Plotting (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Algorithmic Comprehension (S/I)') == 1) || ...
                (strcmpi(shiftName, 'Typographic Trigonometry (U/I)') == 1) || ...
                (strcmpi(shiftName, 'Theoretical Aerodynamics (U/I)') == 1) || ...
                (strcmpi(shiftName, 'Mammalian Maneuvering (U/I)') == 1) || ...
                (strcmpi(shiftName, '4a Update Switch V2 (U/S)') == 1) || ...
                (strcmpi(shiftName, '4a Update Switch V2 - 2 (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Dimensional Jargonization (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Proportional Sympathizing (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Computational Vocalizations (S/I)') == 1) || ...
                (strcmpi(shiftName, 'Tetromino Groking (U/I)') == 1) || ...
                (strcmpi(shiftName, 'Word/Number Partitioning (U/S)') == 1) )
            L4aShiftNameList(length(L4aShiftNameList)+1, 1) = shiftNameList(iterator); % add to Update-shift list
        elseif ( (strcmpi(shiftName(end-4:end), '(U/S)') == 1) || ... % if this shift involves Update (in any form)
                (strcmpi(shiftName(end-4:end), '(U/I)') == 1) || ...
                (strcmpi(shiftName(end-2:end), '(U)') == 1) || ...
                (strcmpi(shiftName, 'Algorithmic Comprehension (S/I)') == 1) || ... % this is a Lv4a
                (strcmpi(shiftName, 'Computational Vocalizations (S/I)') == 1) || ... % this is a Lv4a
                (strcmpi(shiftName, '4b T:1c - AAAAAAAA') == 1) || ... % this is a Lv4b involving Update
                (strcmpi(shiftName, '4b T:2a - Meat-Bag Edition') == 1) || ... % this is a Lv4b involving Update
                (strcmpi(shiftName, '4b T:3a - Specializations') == 1) ) % this is a Lv4b involving Update
            updateShiftNameList(length(updateShiftNameList)+1, 1) = shiftNameList(iterator); % add to Update-shift list
        else % not an update shift; might as well add it to the total shift list
            varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift(shiftNameList(iterator), 0, false); % make this into a variable name
        end
    end
    for iterator = 1:length(L4aShiftNameList)
        L4ShiftName = L4aShiftNameList{iterator}; % particular update shift name (non-cell)
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({L4ShiftName}, 1, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({L4ShiftName}, 2, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({L4ShiftName}, 3, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({L4ShiftName}, 4, false); % Note: catch-all for N>3
    end
    for iterator = 1:length(updateShiftNameList)
        updateShiftName = updateShiftNameList{iterator}; % particular update shift name (non-cell)
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 1, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 2, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 3, false); % make this into a variable name
    end

    shiftNamesInOrder = transpose(varNamePlusNlist); % just because the "table" creation expects it in cols(?)
shiftPO_1B = array2table(zeros(length(shiftNamesInOrder),length(shiftNamesInOrder)),...
        'VariableNames', shiftNamesInOrder, 'RowNames', shiftNamesInOrder);

    % now go through each shift, figure out its cluster, and note its PO
for row = 1:height(shiftPO_1B)
    fprintf('Calculating PO for shift %d.\n', row);
    rowShiftVar = shiftPO_1B.Properties.RowNames{row};
    [rowShiftName, rowShiftN] = getShiftNameFromVar(rowShiftVar, false);
    rowShiftCluster = zRFSum_1B(strcmpi(zRFSum_1B.Shift, rowShiftName), :).Cluster{1};
    
    for col = 1:width(shiftPO_1B)
        colShiftVar = shiftPO_1B.Properties.VariableNames{col};
        [colShiftName, colShiftN] = getShiftNameFromVar(colShiftVar, false);
        colShiftCluster = zRFSum_1B(strcmpi(zRFSum_1B.Shift, colShiftName), :).Cluster{1};
        
        if (strcmpi(rowShiftCluster, colShiftCluster) == 1) % same cluster; look to N value
            if (rowShiftN < colShiftN)
                fprintf('Case 1 - setting row %d, col %d to 1.\n', row, col);
                shiftPO_1B{rowShiftVar,colShiftVar} = 1; % row is at least as easy as col
            end
        else
            clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, colShiftCluster);
            % Z NOTE: WE ARE CONSIDERING ABDUCTIVE REASONING AS ITS OWN FACTOR, SO NOTHING IS DEFINITIVELY HARDER THAN L4b TASKS!             
            % However: special cases: L4b are sometimes harder than other clusters, sometimes not
            if (strcmpi(colShiftName, '4b T:1a - rm Prrtzng') == 1) % cluster S/I
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'S/I');
            elseif (strcmpi(colShiftName, '4b T:1b - O_gan Failure?') == 1) % cluster S/I
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'S/I');
            elseif (strcmpi(colShiftName, '4b T:1c - AAAAAAAA') == 1) % cluster S/I
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'S/I');
            elseif (strcmpi(colShiftName, '4b T:2a - Meat-Bag Edition') == 1) % cluster U/I
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'U/I');
            elseif (strcmpi(colShiftName, '4b T:2b - For exceptional testers') == 1) % cluster U/I
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'U/I');
            elseif (strcmpi(colShiftName, '4b T:2c - Extended training') == 1) % cluster S/I
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'S/I');
            elseif (strcmpi(colShiftName, '4b T:3a - Specializations') == 1) % cluster U/Logic
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'U/Logic');
            elseif (strcmpi(colShiftName, '4b T:3b - Extreme Categorizing') == 1) % cluster S/Logic
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'S/Logic');
            elseif (strcmpi(colShiftName, '4b T:3c - Penultimations') == 1) % cluster I/Logic
                clusterPO = isCluster1AtLeastAsEasyAsCluster2(rowShiftCluster, 'I/Logic');
            end
            
            if (clusterPO == 1) % by cluster, row is at least as easy as col
                if (rowShiftN <= colShiftN) % N value won't interfere with cluster determination, or might help it
                    fprintf('Case 2 - setting row %d, col %d to 1.\n', row, col);
                    shiftPO_1B{rowShiftVar,colShiftVar} = 1; % row is at least as easy as col
                end
            end
        end
    end
end
save(getFileNameForThisOS('2016_4_23_shiftPO_1B.mat', 'ParsedData'), 'shiftPO_1B')

clear shiftNamesInOrder shiftNameList L4aShiftNameList updateShiftNameList 
clear varNamePlusNlist iterator updateShiftName L4ShiftName shiftName
clear row rowShiftVar rowShiftName rowShiftN rowShiftCluster clusterPO
clear col colShiftVar colShiftName colShiftN colShiftCluster





% find SSRT changes over the course of training
%delMe = excludeSubjects_RF_1B(false, true, false, zRF_1B); % change to first_N_RFshifts if not running on SWING
delMe = excludeSubjects_RF_1B(false, true, false, first_N_RFshifts); % 
inhAndCatchTrials = delMe(delMe.InhibitFlag == 1,:);
inhTrials = inhAndCatchTrials(inhAndCatchTrials.UsedShortDelay == 0, :);
inhSubjs = unique(inhTrials.Subject);
height(inhTrials) / length(inhSubjs) % avg non-catch Inhibit trials (from SWING): 694.96

inhCountTable = table(0,0,'VariableNames',{'Subject','InhTrialCount'}); 
for delMe2 = 1:length(inhSubjs) % 
    thisSubj = inhSubjs(delMe2); % this subject
    subjTrials = inhTrials(inhTrials.Subject == thisSubj, :); % subj trials
    inhCountTable(delMe2,:) = table(thisSubj,height(subjTrials),'VariableNames',{'Subject','InhTrialCount'});
end
inhCountTable(inhCountTable.InhTrialCount == min(inhCountTable.InhTrialCount), :) % (from SWING): Subj 432, 451 inhibit trials
inhCountTable(inhCountTable.InhTrialCount == max(inhCountTable.InhTrialCount), :) % (from SWING): Subj 431, 1081 inhibit trials

clear inhAndCatchTrials inhTrials inhSubjs
clear inhCountTable thisSubj subjTrials inhCountTable 




% find out how many shifts go along with the partial ordering prediction 
[delMe, delMe2] = getKernelShiftTransitionPOpercentages_1B(zKernelShiftEstimates_1B, shiftPO_1B, false, true);
inLineWithPO = 0;
notInLineWithPO = 0;
reallyNotInLineWithPO = 0;
transitionsWithPOtable = table({'fromThis'},{'toThis'},0,0,0,0.0,...
    'VariableNames',{'fromShift','toShift','timesSeen','expectedDirection','unexectedDirection','pctExpected'});
tableRow = 1;
for r = 1:height(delMe)
    for c = 1:width(delMe)
        inLineWithPOtable = 0;
        if (delMe2{r,c} > 5) % we saw a transition here more than 5 times (so we care about calculating it)
            if (delMe{r,c} > .5) % more than half of the transitions we saw here were in line with the PO
                inLineWithPO = inLineWithPO + 1;
                inLineWithPOtable = inLineWithPOtable + 1;
            else
                notInLineWithPO = notInLineWithPO + 1;
                if (delMe{r,c} < .1)
                    reallyNotInLineWithPO = reallyNotInLineWithPO + 1;
                end
            end
        end
        transitionsWithPOtable(tableRow,:) = table(delMe.Properties.RowNames(r), delMe.Properties.VariableNames(c),...
            delMe2{r,c}, inLineWithPOtable, delMe2{r,c} - inLineWithPOtable, inLineWithPOtable / delMe2{r,c}, ...
            'VariableNames',{'fromShift','toShift','timesSeen','expectedDirection','unexectedDirection','pctExpected'});
        tableRow = tableRow + 1;
    end
end
inLineWithPO
notInLineWithPO
reallyNotInLineWithPO
transitionsWithPOtable

clear r c inLineWithPO notInLineWithPO reallyNotInLineWithPO tableRow inLineWithPOtable
clear transitionsWithPOtable
        
        





% Get per-trial data for Yeganeh from SWING
%   (basically, start with everything and delete everything except):
%       Subject Condition Status Date RfT EegT ShiftNum Cluster Shift Level
%       StimTime Problem TrialTime all-the-SigmaS GivenResp Correct
%       StimShowTime RespTime NbackFlag NbackDifficulty ScenarioCode

delMe = zRF_1B;
delMe.Period = [];
delMe.Institution = [];
delMe.Gender = [];
delMe.Age = [];
delMe.AgeBin = [];
delMe.EduYears = [];
delMe.EduLevel = [];
delMe.Version = [];
delMe.LogFileId = [];
delMe.StimError = [];
delMe.Automaton = [];
delMe.N = [];
delMe.nBack = [];
delMe.nbackProb = [];
delMe.SwitchProb = [];
delMe.InhibitProb = [];
delMe.MatchProb = [];
delMe.NextState = [];
delMe.ExpResp = [];
delMe.PreInhSigmaP = [];
delMe.PreInhSigmaPRight = [];
delMe.PreInhNextState = [];
delMe.PreInhExpResp = [];
%delMe.GivenResp = [];
delMe.EstRespTime = [];
delMe.NextInhibitDelay = [];
delMe.InhDelayUsed = [];
delMe.DisplayedInhSignal = [];
delMe.UsedShortDelay = [];
delMe.UpdatedInhDelay = [];
delMe.ReportedRespTime = [];
delMe.TrialID = [];
delMe.TrialId = [];
delMe.TotalTrialCount = [];
delMe.AfterErrorFlag = [];
delMe.IncorrectFlag = [];
delMe.anyEFFlag = [];
delMe.nonEFFlag = [];
delMe.noEFFlag = [];
delMe.NonEFFlag = [];
delMe.RelationalFlag = [];
delMe.LogicIdFlag = [];
delMe.LogicXorFlag = [];
delMe.AnyLogic = [];
delMe.AnyLogicFlag = [];
delMe.anyLogicFlag = [];
delMe.SwitchHandsFlag = [];
delMe.numOfEFsInThisTrial = [];
delMe.numOfEFsInThisShift = [];
delMe.SwitchFlag = [];
delMe.InhibitFlag = [];
delMe.InhibitDifficulty = [];
delMe.ActualN = [];
delMe(1:3,:) % just to see what we've got
zRF_1B_colsForUpdateEEG = delMe;
save(getFileNameForThisOS('2016_4_21_zRF_1B_colsForUpdateEEG.mat', 'IntResults'), 'zRF_1B_colsForUpdateEEG')









% now figure out what rule a given subject was working with at each time point 
npat = 16; % this is the number of patterns... but what does that mean?
sn = 1051; % a random finished subject

for pn = 1:npat     %  all pattern numbers
    rtmp = sum(rsp(find(stim(ip2) == (pn-1)),sn));
    if rtmp == 0   catstr(pn) =   '0';   %Cat0 => 0
    elseif rtmp == 2 catstr(pn) = '1';   %Cat1 => 1
    else catstr(pn) = '-';
    end
end
[Bins,compx(sn),Nums,ott] = misha_minTruthtable(catstr);
 
    
% zNOTE: to set up the Pilot 3 data for analyses, see "2016_10_27 Pilot3 analyses script.m" 


% create some Tables from the 1B data for UIUC overview presentation
[z1Bexample_data, z1Bexample_sum, z1Bexample_all] = formTables_RF_1A3('1b-final-Parsed.rf-data.xlsx', '1b-final-Parsed.rf-sum.xlsx', '1b-final-Parsed.robotfactory.00.xlsx', true);
z1Bexample = putNewColsIntoDataTable_1B(z1Bexample_all); % also put the new, useful columns into the per-trial file





% add shiftID(plus Nval) to the 2016_12_7-1B_RF_logisticRegPerShift.csv matrix we made for Misha 
delMe = readtable(getFileNameForThisOS('2016_12_7-1B_RF_logisticRegPerShift.csv', 'IntResults'));
load('/Users/Shared/SHARP/ParsedData/RFSum_1B_final-2015_10_29.mat'); % creates zRFSum_1B

delMe.shiftIDplusN = zeros(height(delMe), 1);
delMe.nVal = zeros(height(delMe), 1);
thisSubj = 1;
for i = 1:height(delMe)
    if (delMe.Subject(i) ~= thisSubj)
        printf('working on subject %d./n',thisSubj);
        thisSubj = delMe.Subject(i);
    end
    subjShifts = zRFSum_1B(zRFSum_1B.Subject == delMe.Subject(i),:);
    thisShift = subjShifts(subjShifts.ShiftNum == delMe.CumShiftNum(i),:);
    delMe.nVal(i) = thisShift.ActualN;
end
for i = 1:height(delMe)
    delMe.shiftIDplusN(i) = getShiftIDfromShiftName(delMe.Shift{i},delMe.nVal(i),false);
end
writetable(delMe, getFileNameForThisOS('2017_1_5-1B_RF_logisticRegPerShift.csv', 'IntResults'),'WriteRowNames',false);
clear delMe i zRFSum_1B thisSubj subjShifts thisShift



% generate a matrix of shift (and cluster) names and difficulties for Misha  
% FIRST: run everything in "2016_4_22 DifficultyPOv1113 script.m"
%   This should give you variables like ix, dispNames, and Ds
delMe = table(ix, dispNames(ix), Ds, 'VariableNames', {'Index', 'Name','Difficulty'});
tableForMisha = table({'temp'}, 0,0, {'temp'}, 0,'VariableNames', ...
    {'ShiftName', 'ShiftID','ShiftDifficulty','Cluster','ClusterDifficulty'});
for i = 1:height(delMe)
    nVal = 0; % assume no n value
%    if (delMe.Subject(i) ~= thisSubj)
%        printf('working on subject %d./n',thisSubj);
%        thisSubj = delMe.Subject(i);
%    end
    dispName = delMe.Name{i};
    % if the name has an N value attached, remove it
    nIndex = findstr(dispName, '+N');
    if (~isempty(nIndex)) % there is an N value with this
        nVal = str2num(dispName(nIndex+2));
        dispName = dispName(1:(nIndex-1));
        shiftID = getShiftIDfromShiftName(dispName,nVal,false);
    else % no Nval; since Misha is using ActualN, shifts without an N-back component have N = 1
        shiftID = getShiftIDfromShiftName(dispName,1,false);
    end
    [shiftName,~] = getShiftNamefromShiftID(shiftID); % get the actual name, not the name-plus-N-val
    clusterGroup = zRFSum_1B(strcmpi(zRFSum_1B.Shift, shiftName),:);
    cluster = clusterGroup.Cluster(1); % all of these should be the same; just pick one
    if (strcmpi(cluster,'U/Logic(xOR)'))
        cluster = 'U/Logic';
    end
    tableForMisha(i,:) = table({shiftName}, shiftID, delMe.Difficulty(i), cluster, -999,...
        'VariableNames', {'ShiftName', 'ShiftID','ShiftDifficulty','Cluster','ClusterDifficulty'});
end
% now add cluster difficulty
% FIRST: run everything in "2016_4_22 misha_DifficultyPOv1113 script.m"
%   This should give you variables like ix, Snames, and Ds
delMe = table(ix, Snames(ix), Ds, 'VariableNames', {'Index', 'Name','Difficulty'});
delMe.usefulNames = delMe.Name; % create a column that we'll actually use to get the cluster difficulties
for i = 1:height(delMe)
    delMe.usefulNames(i) = strrep(delMe.usefulNames(i),'+','/');
    name = delMe.usefulNames{i};
    if (name(1) == '4') % if it's a Lv4 shift
        name = name(4:end); % just take the 'L4+' off
        [delMe.usefulNames{i},~] = getShiftNamefromShiftID(getShiftIDfromShiftName(name,0,false)); 
    end
end
% now put the two together
for i = 1:height(tableForMisha)
    if (strcmpi(tableForMisha.Cluster{i},'U/Logic(xOR)'))
        tableForMisha.Cluster{i} = 'U/Logic';
    end
    Lv4flag = 0; % assume it's not a Lv4 shift
    cluster = tableForMisha.Cluster{i};
    if (length(cluster) > 1)
        if (strcmpi(cluster(1:2),'L4')) % it's a Lv4 shift
            Lv4flag = 1;
        end
    end
    for j = 1:height(delMe)
        if (Lv4flag == 0)
            if (strcmpi(cluster, delMe.usefulNames{j}))
                tableForMisha.ClusterDifficulty(i) = delMe.Difficulty(j);
            end
        else % it is a Lv4 shift
            if (strcmpi(tableForMisha.ShiftName{i}, delMe.usefulNames{j}))
                tableForMisha.ClusterDifficulty(i) = delMe.Difficulty(j);
            end
        end
    end
end
writetable(tableForMisha, getFileNameForThisOS('2017_1_8-1B_RF_shiftAndClusterDifficulties.csv', 'IntResults'),'WriteRowNames',false);
clear i nVal dispName nIndex shiftID shiftName clusterGroup cluster
clear name Lv4flag j 



% find out why betas > 50 are so high
delMe = readtable(getFileNameForThisOS('2017_1_5-1B_RF_logisticRegPerShift.csv', 'IntResults'));
delMe2 = delMe(delMe.beta1 > 10)
%{
    Subject                   Shift                   TrainingDay    CumShiftNum    DailyShiftNum     beta0     b0pVal     beta1     b1pVal     IterationLimit    PerfectSeparation    shiftIDplusN    nVal
    _______    ___________________________________    ___________    ___________    _____________    _______    _______    ______    _______    ______________    _________________    ____________    ____

     15        'Green Synergizing (I)'                1                3             3               -87.744    0.99996    58.491    0.99985    0                 1                      301           1   
     30        'Lesson Planning (S)'                  2               22             2               -91.393    0.99998    60.926     0.9999    0                 1                     8001           1   
     37        'Stereoizing (I)'                      9              175            15               -87.546    0.99996    58.359    0.99984    0                 1                      601           1   
     40        'Cartography Catharsis (S/I)'          3               47             7               -88.806    0.99996    59.199    0.99987    0                 1                     9601           1   
     48        'Genderization (S)'                    1               17            17               -147.65    0.99994    59.057    0.99986    0                 1                     7901           1   
     94        'Braincase Downsizing (I)'             2               21             1               -86.976    0.99995    57.979    0.99983    0                 1                     2601           1   
    240        'Green Synergizing (I)'                1                3             3               -87.744    0.99996    58.491    0.99985    0                 1                      301           1   
    247        'Monocular Inspection (S)'             1                5             5               -151.37    0.99996    60.546     0.9999    0                 1                      801           1   
    275        'Braincase Downsizing (I)'             1               14            14               -146.59    0.99994    58.633    0.99985    0                 1                     2601           1   
    300        'Green Synergizing (I)'                1                3             3                -148.4    0.99995    59.358    0.99987    0                 1                      301           1   
    316        'Genderization (S)'                    1               14            14               -89.034    0.99997    59.351    0.99987    0                 1                     7901           1   
    337        'Braincase Downsizing (I)'             1               14            14               -86.794    0.99995    57.858    0.99983    0                 1                     2601           1   
    404        'Green Synergizing (I)'                1                3             3               -88.154    0.99996    58.765    0.99985    0                 1                      301           1   
    414        'Stereoizing (I)'                      9              175            15               -88.154    0.99996    58.765    0.99985    0                 1                      601           1   
    423        'Color Balancing (U)'                  1                1             1               -2346.2     0.9999     60.94     0.9999    0                 1                      102           2   
    423        'Duplicate Mitigation (U)'             1                4             4               -85.149    0.99994    56.761    0.99978    0                 1                      201           1   
    432        'Color Balancing (U)'                  1                1             1               -87.546    0.99996    58.359    0.99984    0                 1                      102           2   
    432        'Braincase Downsizing (I)'             3               49             9               -85.149    0.99994    56.761    0.99978    0                 1                     2601           1   
    448        'Braincase Downsizing (I)'             1               18            18               -86.976    0.99995    57.979    0.99983    0                 1                     2601           1   
    458        'Stereoizing (I)'                      9              175            15               -89.268    0.99997    59.508    0.99987    0                 1                      601           1   
    461        'Stereoizing (I)'                      9              175            15               -88.154    0.99996    58.765    0.99985    0                 1                      601           1   
    471        'Lesson Planning (S)'                  2               22             2                -148.4    0.99995    59.358    0.99987    0                 1                     8001           1   
    510        'Organism Culling (U)'                 3               60            20                   -85    0.99994    56.662    0.99978    0                 1                     7203           3   
    613        'Braincase Downsizing (I)'             1               14            14               -86.976    0.99995    57.979    0.99983    0                 1                     2601           1   
    624        'Monocular Inspection (S)'             1                5             5               -88.366    0.99996    58.906    0.99986    0                 1                      801           1   
    677        'Computational Vocalizations (S/I)'    7              140            20               -92.334    0.99998    61.556    0.99991    0                 1                    13601           1   
    691        'Head Removal (S/I)'                   3               45            11               -90.813    0.99997    60.539     0.9999    0                 1                     1801           1   
    711        'Computational Vocalizations (S/I)'    6              111            11               -368.17    0.99998    66.935    0.99997    0                 1                    13601           1   
    716        'Sensor Peripheralizing (S)'           7              122             2               -84.566    0.99993    56.373    0.99976    0                 1                     2801           1   
    719        'Emotional Imprinting (I)'             6              115            15               -148.79    0.99995    59.514    0.99987    0                 1                     7701           1   
    726        'Braincase Downsizing (I)'             1               14            14               -87.744    0.99996    58.491    0.99985    0                 1                     2601           1   
    726        'Dimensional Jargonization (U/S)'      9              169             9               -97.499    0.99999    65.023    0.99996    0                 1                    13401           1   
%}
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-0_49-2015_10_29.mat') % variable: zRF_1B_0_49, subj 1 shiftNum 1 to subj 48 shiftNum 220
highBetaTrials = zRF_1B_0_49((zRF_1B_0_49.Subject == 15) & (zRF_1B_0_49.ShiftNum == 3), :);
highBetaTrials = [highBetaTrials; zRF_1B_0_49((zRF_1B_0_49.Subject == 30) & (zRF_1B_0_49.ShiftNum == 22), :)];
highBetaTrials = [highBetaTrials; zRF_1B_0_49((zRF_1B_0_49.Subject == 37) & (zRF_1B_0_49.ShiftNum == 175), :)];
highBetaTrials = [highBetaTrials; zRF_1B_0_49((zRF_1B_0_49.Subject == 40) & (zRF_1B_0_49.ShiftNum == 47), :)];
highBetaTrials = [highBetaTrials; zRF_1B_0_49((zRF_1B_0_49.Subject == 48) & (zRF_1B_0_49.ShiftNum == 17), :)];
clear zRF_1B_0_49
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-50_99-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_50_99((zRF_1B_50_99.Subject == 94) & (zRF_1B_50_99.ShiftNum == 21), :)];
clear zRF_1B_50_99
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-200_249-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_200_249((zRF_1B_200_249.Subject == 240) & (zRF_1B_200_249.ShiftNum == 3), :)];
highBetaTrials = [highBetaTrials; zRF_1B_200_249((zRF_1B_200_249.Subject == 247) & (zRF_1B_200_249.ShiftNum == 5), :)];
clear zRF_1B_200_249
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-250_299-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_250_299((zRF_1B_250_299.Subject == 275) & (zRF_1B_250_299.ShiftNum == 14), :)];
clear zRF_1B_250_299
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-300_349-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_300_349((zRF_1B_300_349.Subject == 300) & (zRF_1B_300_349.ShiftNum == 3), :)];
highBetaTrials = [highBetaTrials; zRF_1B_300_349((zRF_1B_300_349.Subject == 316) & (zRF_1B_300_349.ShiftNum == 14), :)];
highBetaTrials = [highBetaTrials; zRF_1B_300_349((zRF_1B_300_349.Subject == 337) & (zRF_1B_300_349.ShiftNum == 14), :)];
clear zRF_1B_300_349
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-400_449-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_400_449((zRF_1B_400_449.Subject == 404) & (zRF_1B_400_449.ShiftNum == 3), :)];
highBetaTrials = [highBetaTrials; zRF_1B_400_449((zRF_1B_400_449.Subject == 414) & (zRF_1B_400_449.ShiftNum == 175), :)];
highBetaTrials = [highBetaTrials; zRF_1B_400_449((zRF_1B_400_449.Subject == 423) & (zRF_1B_400_449.ShiftNum == 1), :)];
highBetaTrials = [highBetaTrials; zRF_1B_400_449((zRF_1B_400_449.Subject == 423) & (zRF_1B_400_449.ShiftNum == 4), :)];
highBetaTrials = [highBetaTrials; zRF_1B_400_449((zRF_1B_400_449.Subject == 432) & (zRF_1B_400_449.ShiftNum == 1), :)];
highBetaTrials = [highBetaTrials; zRF_1B_400_449((zRF_1B_400_449.Subject == 432) & (zRF_1B_400_449.ShiftNum == 49), :)];
highBetaTrials = [highBetaTrials; zRF_1B_400_449((zRF_1B_400_449.Subject == 448) & (zRF_1B_400_449.ShiftNum == 18), :)];
clear zRF_1B_400_449
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-450_499-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_450_499((zRF_1B_450_499.Subject == 458) & (zRF_1B_450_499.ShiftNum == 175), :)];
highBetaTrials = [highBetaTrials; zRF_1B_450_499((zRF_1B_450_499.Subject == 461) & (zRF_1B_450_499.ShiftNum == 175), :)];
highBetaTrials = [highBetaTrials; zRF_1B_450_499((zRF_1B_450_499.Subject == 471) & (zRF_1B_450_499.ShiftNum == 22), :)];
clear zRF_1B_450_499
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-500_549-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_500_549((zRF_1B_500_549.Subject == 510) & (zRF_1B_500_549.ShiftNum == 60), :)];
clear zRF_1B_500_549
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-600_649-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_600_649((zRF_1B_600_649.Subject == 613) & (zRF_1B_600_649.ShiftNum == 14), :)];
highBetaTrials = [highBetaTrials; zRF_1B_600_649((zRF_1B_600_649.Subject == 624) & (zRF_1B_600_649.ShiftNum == 5), :)];
clear zRF_1B_600_649
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-650_699-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_650_699((zRF_1B_650_699.Subject == 677) & (zRF_1B_650_699.ShiftNum == 140), :)];
highBetaTrials = [highBetaTrials; zRF_1B_650_699((zRF_1B_650_699.Subject == 691) & (zRF_1B_650_699.ShiftNum == 45), :)];
clear zRF_1B_650_699
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-700_749-2015_10_29.mat')
highBetaTrials = [highBetaTrials; zRF_1B_700_749((zRF_1B_700_749.Subject == 711) & (zRF_1B_700_749.ShiftNum == 111), :)];
highBetaTrials = [highBetaTrials; zRF_1B_700_749((zRF_1B_700_749.Subject == 716) & (zRF_1B_700_749.ShiftNum == 122), :)];
highBetaTrials = [highBetaTrials; zRF_1B_700_749((zRF_1B_700_749.Subject == 719) & (zRF_1B_700_749.ShiftNum == 115), :)];
highBetaTrials = [highBetaTrials; zRF_1B_700_749((zRF_1B_700_749.Subject == 726) & (zRF_1B_700_749.ShiftNum == 14), :)];
highBetaTrials = [highBetaTrials; zRF_1B_700_749((zRF_1B_700_749.Subject == 726) & (zRF_1B_700_749.ShiftNum == 169), :)];
clear zRF_1B_700_749
writetable(highBetaTrials, getFileNameForThisOS('2017_1_10-1B_RF_highBeta1Trials.csv', 'IntResults'),'WriteRowNames',false);



% figure out what learning curve shapes we don't have well characterized yet
% make a new matrix, that marks:
%   high beta1s (we know the shape of this curve is 000, jump to 1111)
%   very lot pVals for beta1 (the logistic regression is the correct model for these)
%   beta1s at or below (or maybe a tiny bit above) zero (assuming these are non-learning)
% The rest are not yet well characterized.
delMe = readtable(getFileNameForThisOS('2017_1_5-1B_RF_logisticRegPerShift.csv', 'IntResults'));
delMe.highBeta1 = zeros(height(delMe), 1);
delMe.logisticP01 = zeros(height(delMe), 1);
delMe.logisticP05 = zeros(height(delMe), 1);
delMe.nonLearning = zeros(height(delMe), 1);
delMe.lowLearning = zeros(height(delMe), 1);
delMe.notWellCharacterized = zeros(height(delMe), 1);
for i = 1:height(delMe)
    if (delMe.beta1(i) > 5) % 32 of these
        delMe.highBeta1(i) = 1;
    end
    if (delMe.b1pVal(i) < .05) % 6087 of these
        delMe.logisticP05(i) = 1;
    end
    if (delMe.b1pVal(i) < .01) % 1619 of these
        delMe.logisticP01(i) = 1;
    end
    if (delMe.beta1(i) < .0001) % somewhat arbitrary, but close to 0 (27100)
        delMe.nonLearning(i) = 1;
    end
    if (delMe.beta1(i) < .01) % turns out there are a lot of these between .01 and .0001 (10269)
        delMe.lowLearning(i) = 1;
    end
    
    if ( (delMe.highBeta1(i) == 0) && ... 
            (delMe.logisticP05(i) == 0) && ...
            (delMe.logisticP01(i) == 0) && ...
            (delMe.nonLearning(i) == 0) && ...
            (delMe.lowLearning(i) == 0) )
        delMe.notWellCharacterized(i) = 1; % 17795
    end
        
end



    

% Create a full description of each shift (all differentiating parameters) 
shiftTable = table({'None'}, 0, 0, {'None'}, 'VariableNames', {'ShiftName', 'nVal','ShiftID','Cluster'});
shiftTableRow = 1;
for i = 1:13 % there are 13 sets of 50-subject trials data
    trialData = get50subjsTrialData_1B(i);
    subjs = unique(trialData.Subject);
    for j = 1:length(subjs)
        fprintf('Working on subject %d.\n', subjs(j));
        subjTrials = trialData(trialData.Subject == subjs(j), :);
        shifts = unique(subjTrials.ShiftNum);
        for k = 1:length(shifts)
            shiftTrials = subjTrials(subjTrials.ShiftNum == shifts(k),:);
            shiftTrialRow = shiftTrials(1,:);
            shiftID = getShiftIDfromShiftName(shiftTrialRow.Shift{1}, shiftTrialRow.ActualN, false);
            shiftTable(shiftTableRow,:) = table(shiftTrialRow.Shift, ...
                shiftTrialRow.ActualN, shiftID, shiftTrialRow.Cluster, ...
                'VariableNames', {'ShiftName', 'nVal','ShiftID','Cluster'});
            shiftTableRow = shiftTableRow + 1;
        end
    end
end
% now clear out any non-unique rows
delMe = unique(shiftTable);
delMe(strcmpi(delMe.Cluster, 'U/Logic(xOR)'),'Cluster') = ...
    {'U/Logic';'U/Logic';'U/Logic';'U/Logic';'U/Logic';'U/Logic'}; % there are six of these rows (I'm sure there's a better / more global way to do this...)
writetable(delMe, getFileNameForThisOS('2017_1_18-1B_RF_ShiftPlusIDList.csv', 'IntResults'),'WriteRowNames',false);

clear i j k shiftTableRow trialData subjs subjTrials 
clear shifts shiftTrials shiftTrialRow shiftID
clear shiftTable
    

% create a version of the P2 data that doesn't have anyone who started on CodeVersion 1 or any doubled tasks for Maciej 
load('/Users/Shared/SHARP/IntResults/2016_11_1-zP2_CLT_forMisha.mat')
delMe = zP2_CLT_forMisha;
delMe.TrainingDayNumber = zeros(height(delMe),1);
for i = 1:height(delMe)
    if (i > 1)
        if (delMe.Subject(i) ~= delMe.Subject(i - 1))
            fprintf('Inserting TrainingDayNumber for Subject %d\n', delMe.Subject(i));
        end
    end
    if (strcmpi(delMe.TrainingDay(i),'Training 1'))
        delMe.TrainingDayNumber(i) = 1;
    elseif (strcmpi(delMe.TrainingDay(i),'Training 2'))
        delMe.TrainingDayNumber(i) = 2;
    elseif (strcmpi(delMe.TrainingDay(i),'Training 3'))
        delMe.TrainingDayNumber(i) = 3;
    elseif (strcmpi(delMe.TrainingDay(i),'Training 4'))
        delMe.TrainingDayNumber(i) = 4;
    elseif (strcmpi(delMe.TrainingDay(i),'Training 5'))
        delMe.TrainingDayNumber(i) = 5;
    end
end
subjs = unique(delMe.Subject);
for i = 1:length(subjs)
    fprintf('Working on subject %d.\n', subjs(i));
    subj = subjs(i);
    subjTrials = delMe(delMe.Subject == subj, :);
    if (subjTrials.CodeVersion(1) == 1) % they start out on CodeVersion1
        delMe(delMe.Subject == subj, :) = []; % delete these trials
        tasks = unique(subjTrials.TaskNumber);
        for j = 1:length(tasks)
            task = tasks(j);
            taskTrials = subjTrials(subjTrials.TaskNumber == task,:);
            if (length(unique(taskTrials.TrainingDayNumber)) > 1) % this task happened on multiple days
                deleteThisDay = min(taskTrials.TrainingDayNumber);
                delMe((delMe.Subject == subj) & (delMe.TaskNumber == task) ...
                    & (delMe.TrainingDayNumber == deleteThisDay), :) = []; % delete these trials
            end
        end
    end
end

clear i subjs subj subjTrials task tasks j taskTrials deleteThisDay
clear zP2_CLT_forMisha



% get all the shift IDs for shifts in 1B
[shiftList_1B, ~, ~] = formTables_RF_1A3('1b-final-ShiftNames.xlsx', '', '', false);
for i=1:height(shiftList_1B)
    shiftList_1B.ShiftID(i) = getShiftIDfromShiftName(shiftList_1B.Shift{i}, 0, false);
end
writetable(shiftList_1B, getFileNameForThisOS('2017_2_27-1B_ShiftNamesAndIDs.csv', 'IntResults'),'WriteRowNames',false);
clear shiftList_1B i



% add shiftIDs to all the 1B per-trial data
curSubj = 0;
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-0_49-2015_10_29.mat') % variable: zRF_1B_0_49, subj 1 shiftNum 1 to subj 48 shiftNum 220
zRF_1B_0_49.ShiftID = zeros(height(zRF_1B_0_49),1);
for i = 1:height(zRF_1B_0_49)
    if (curSubj ~= zRF_1B_0_49.Subject(i))
        curSubj = zRF_1B_0_49.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_0_49.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_0_49.Shift{i}, zRF_1B_0_49.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-0_49-2015_10_29.mat', 'ParsedData'), 'zRF_1B_0_49');
clear zRF_1B_0_49 

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-50_99-2015_10_29.mat')
zRF_1B_50_99.ShiftID = zeros(height(zRF_1B_50_99),1);
for i = 1:height(zRF_1B_50_99)
    if (curSubj ~= zRF_1B_50_99.Subject(i))
        curSubj = zRF_1B_50_99.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_50_99.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_50_99.Shift{i}, zRF_1B_50_99.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-50_99-2015_10_29.mat', 'ParsedData'), 'zRF_1B_50_99');
clear zRF_1B_50_99

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-100_149-2015_10_29.mat') 
zRF_1B_100_149.ShiftID = zeros(height(zRF_1B_100_149),1);
for i = 1:height(zRF_1B_100_149)
    if (curSubj ~= zRF_1B_100_149.Subject(i))
        curSubj = zRF_1B_100_149.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_100_149.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_100_149.Shift{i}, zRF_1B_100_149.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-100_149-2015_10_29.mat', 'ParsedData'), 'zRF_1B_100_149');
clear zRF_1B_100_149 
%{ 
% 150-199 doesn't really exist
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-150_199-2015_10_29.mat')
zRF_1B_150_199.ShiftID = zeros(height(zRF_1B_150_199),1);
for i = 1:height(zRF_1B_150_199)
    if (curSubj ~= zRF_1B_150_199.Subject(i))
        curSubj = zRF_1B_150_199.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_150_199.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_150_199.Shift{i}, zRF_1B_150_199.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-150_199-2015_10_29.mat', 'ParsedData'), 'zRF_1B_150_199');
clear zRF_1B_150_199
%}

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-200_249-2015_10_29.mat') 
zRF_1B_200_249.ShiftID = zeros(height(zRF_1B_200_249),1);
for i = 1:height(zRF_1B_200_249)
    if (curSubj ~= zRF_1B_200_249.Subject(i))
        curSubj = zRF_1B_200_249.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_200_249.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_200_249.Shift{i}, zRF_1B_200_249.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-200_249-2015_10_29.mat', 'ParsedData'), 'zRF_1B_200_249');
clear zRF_1B_200_249 

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-250_299-2015_10_29.mat')
zRF_1B_250_299.ShiftID = zeros(height(zRF_1B_250_299),1);
for i = 1:height(zRF_1B_250_299)
    if (curSubj ~= zRF_1B_250_299.Subject(i))
        curSubj = zRF_1B_250_299.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_250_299.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_250_299.Shift{i}, zRF_1B_250_299.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-250_299-2015_10_29.mat', 'ParsedData'), 'zRF_1B_250_299');
clear zRF_1B_250_299

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-300_349-2015_10_29.mat') 
zRF_1B_300_349.ShiftID = zeros(height(zRF_1B_300_349),1);
for i = 1:height(zRF_1B_300_349)
    if (curSubj ~= zRF_1B_300_349.Subject(i))
        curSubj = zRF_1B_300_349.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_300_349.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_300_349.Shift{i}, zRF_1B_300_349.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-300_349-2015_10_29.mat', 'ParsedData'), 'zRF_1B_300_349');
clear zRF_1B_300_349 

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-350_399-2015_10_29.mat')
zRF_1B_350_399.ShiftID = zeros(height(zRF_1B_350_399),1);
for i = 1:height(zRF_1B_350_399)
    if (curSubj ~= zRF_1B_350_399.Subject(i))
        curSubj = zRF_1B_350_399.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_350_399.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_350_399.Shift{i}, zRF_1B_350_399.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-350_399-2015_10_29.mat', 'ParsedData'), 'zRF_1B_350_399');
clear zRF_1B_350_399


load('/Users/Shared/SHARP/ParsedData/RFAll_1B-400_449-2015_10_29.mat') 
zRF_1B_400_449.ShiftID = zeros(height(zRF_1B_400_449),1);
for i = 1:height(zRF_1B_400_449)
    if (curSubj ~= zRF_1B_400_449.Subject(i))
        curSubj = zRF_1B_400_449.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_400_449.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_400_449.Shift{i}, zRF_1B_400_449.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-400_449-2015_10_29.mat', 'ParsedData'), 'zRF_1B_400_449');
clear zRF_1B_400_449 

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-450_499-2015_10_29.mat')
zRF_1B_450_499.ShiftID = zeros(height(zRF_1B_450_499),1);
for i = 1:height(zRF_1B_450_499)
    if (curSubj ~= zRF_1B_450_499.Subject(i))
        curSubj = zRF_1B_450_499.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_450_499.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_450_499.Shift{i}, zRF_1B_450_499.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-450_499-2015_10_29.mat', 'ParsedData'), 'zRF_1B_450_499');
clear zRF_1B_450_499

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-500_549-2015_10_29.mat') 
zRF_1B_500_549.ShiftID = zeros(height(zRF_1B_500_549),1);
for i = 1:height(zRF_1B_500_549)
    if (curSubj ~= zRF_1B_500_549.Subject(i))
        curSubj = zRF_1B_500_549.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_500_549.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_500_549.Shift{i}, zRF_1B_500_549.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-500_549-2015_10_29.mat', 'ParsedData'), 'zRF_1B_500_549');
clear zRF_1B_500_549 

% 550-599 doesn't exist

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-600_649-2015_10_29.mat') 
zRF_1B_600_649.ShiftID = zeros(height(zRF_1B_600_649),1);
for i = 1:height(zRF_1B_600_649)
    if (curSubj ~= zRF_1B_600_649.Subject(i))
        curSubj = zRF_1B_600_649.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_600_649.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_600_649.Shift{i}, zRF_1B_600_649.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-600_649-2015_10_29.mat', 'ParsedData'), 'zRF_1B_600_649');
clear zRF_1B_600_649 

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-650_699-2015_10_29.mat')
zRF_1B_650_699.ShiftID = zeros(height(zRF_1B_650_699),1);
for i = 1:height(zRF_1B_650_699)
    if (curSubj ~= zRF_1B_650_699.Subject(i))
        curSubj = zRF_1B_650_699.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_650_699.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_650_699.Shift{i}, zRF_1B_650_699.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-650_699-2015_10_29.mat', 'ParsedData'), 'zRF_1B_650_699');
clear zRF_1B_650_699

load('/Users/Shared/SHARP/ParsedData/RFAll_1B-700_749-2015_10_29.mat') 
zRF_1B_700_749.ShiftID = zeros(height(zRF_1B_700_749),1);
for i = 1:height(zRF_1B_700_749)
    if (curSubj ~= zRF_1B_700_749.Subject(i))
        curSubj = zRF_1B_700_749.Subject(i);
        fprintf('Working on subject %d.\n', curSubj);
    end
    zRF_1B_700_749.ShiftID(i) = getShiftIDfromShiftName(zRF_1B_700_749.Shift{i}, zRF_1B_700_749.ActualN(i), false);
end
save(getFileNameForThisOS('RFAll_1B-700_749-2015_10_29.mat', 'ParsedData'), 'zRF_1B_700_749');
clear zRF_1B_700_749 





% now grab just the 5 (edit: now 8) columns that Maciej needs for PCA
colsForPCA = [];
for i = 1:13 % there are 13 sets of 50-subject trials data
    fprintf('Working on the %dth set of data (out of 13).\n', i);
    trialData = get50subjsTrialData_1B(i);
    tmpColsForPCA = trialData(:,'Subject');
    tmpColsForPCA.ShiftID = trialData.ShiftID;
    tmpColsForPCA.ExpResp = trialData.ExpResp;
    tmpColsForPCA.GivenResp = trialData.GivenResp;
    tmpColsForPCA.Correct = trialData.Correct;
    tmpColsForPCA.ShiftNum = trialData.ShiftNum;
    tmpColsForPCA.trialNum = trialData.Problem;
    tmpColsForPCA.StimTime = trialData.StimTime;
    colsForPCA = [colsForPCA; tmpColsForPCA];
end % note that writing this out in csv form takes over half an hour!c
writetable(colsForPCA, getFileNameForThisOS('2017_7_31-1B_RF_eightColsForMaciej.csv', 'IntResults'),'WriteRowNames',false);
% now count the number of doubled shiftIDs, just for our info
shiftIDs = unique(colsForPCA.ShiftID);
stringIDs = cellstr(num2str(shiftIDs));
stringIDs = strrep(stringIDs,' ','');
stringIDs = strcat('j',stringIDs);
subjs = unique(colsForPCA.Subject);
stringSubjs = cellstr(num2str(subjs));
stringSubjs = strrep(stringSubjs,' ','');
stringSubjs = strcat('i',stringSubjs);
shiftIDcounts = zeros(length(subjs),length(shiftIDs));
shiftIDcounts = array2table(shiftIDcounts);
shiftIDcounts.Properties.VariableNames = stringIDs;
shiftIDcounts.Properties.RowNames = stringSubjs;
%shiftIDcounts = zeros(length(subjs)+1,length(shiftIDs)+1);
%shiftIDcounts(1,2:end) = shiftIDs;
%shiftIDcounts(2:end,1) = subjs;
for i = 1:length(subjs)
    subj = subjs(i);
    fprintf('Working on subject %d.\n', subj);
    subjString = strcat('i',(cellstr(num2str(subj))));
    subjTrials = colsForPCA(colsForPCA.Subject == subj,:);
    subjShifts = unique(subjTrials.ShiftNum);
    for j = 1:length(subjShifts)
        subjShiftTrials = subjTrials(subjTrials.ShiftNum == subjShifts(j),:);
        shiftString = strcat('j',(cellstr(num2str(subjShiftTrials.ShiftID(1))))); % first grab the referenced shiftNum, then make it a string, then put a j in front
        shiftIDcounts{subjString,shiftString} = shiftIDcounts{subjString,shiftString} + 1;
    end
end
onlySawOnce = 0;
sawTwiceOrMore = 0;
for i = 1:height(shiftIDcounts) % go through all the subjects
    fprintf('Working on row %d.\n', i);
    for j = 1:width(shiftIDcounts) % and all the shifts
        if (shiftIDcounts{i,j} == 1)
            onlySawOnce = onlySawOnce + 1;
        elseif (shiftIDcounts{i,j} > 1)
            sawTwiceOrMore = sawTwiceOrMore + 1;
        end
    end
end
onlySawOnce
sawTwiceOrMore
writetable(shiftIDcounts, getFileNameForThisOS('2017_3_30-1B_RF_SubjShiftCount.csv', 'IntResults'),'WriteRowNames',true);

% Misha needs all the duplicate shifts removed, so let's be nice and do that for him
firstShiftsForPCA = colsForPCA((colsForPCA.Subject == 1) & (colsForPCA.ShiftNum == 1),:); % assume we'll start with subj 1, shift 1
subjs = unique(colsForPCA.Subject);
for i = 1:length(subjs) 
    subj = subjs(i);
    fprintf('Working on subject %d.\n', subj);
    if (i > 1) % not the first subject
        firstShiftsForPCA = [firstShiftsForPCA; ...
            colsForPCA((colsForPCA.Subject == subj) & (colsForPCA.ShiftNum == 1),:)]; % first shift overall must be a first encounter
    end
    firstShiftID = colsForPCA((colsForPCA.Subject == subj) & (colsForPCA.ShiftNum == 1),:).ShiftID(1);
    subjTrials = colsForPCA(colsForPCA.Subject == subj,:);
    subjShiftNums = unique(subjTrials.ShiftNum);
    subjShiftIDs = unique(subjTrials.ShiftID);
    subjShiftSeen = table(subjShiftIDs,zeros(length(subjShiftIDs),1),'VariableNames',{'ShiftID','SeenThisBefore'});
    subjShiftSeen(subjShiftSeen.ShiftID == firstShiftID,:).SeenThisBefore = 1; % but we did already put the first shift in, so mark it
    for j = 1:length(subjShiftNums)
        subjShiftTrials = subjTrials(subjTrials.ShiftNum == subjShiftNums(j),:);
        seenThisShift = subjShiftSeen(subjShiftSeen.ShiftID == subjShiftTrials.ShiftID(1),:).SeenThisBefore;
        if (seenThisShift == 0) % we've never seen this shift before; add it to the growing table
            firstShiftsForPCA = [firstShiftsForPCA; subjShiftTrials]; % add it to the list
            subjShiftSeen(subjShiftSeen.ShiftID == subjShiftTrials.ShiftID(1),:).SeenThisBefore = 1; % note it as seen, now
        end % if we've seen it before, just ignore it
    end
end
save(getFileNameForThisOS('2017_5_12-colsForPCA-Misha.mat', 'IntResults'), 'firstShiftsForPCA');

clear trialData tmpColsForPCA i shiftIDs stringIDs subjs stringSubjs shiftIDcounts
clear subj subjString subjTrials subjShifts j subjShiftTrials shiftString
clear firstShiftID subjShiftNums subjShiftIDs subjShiftSeen seenThisShift
clear colsForPCA shiftIDcounts onlySawOnce sawTwiceOrMore firstShiftsForPCA % once we're done with them






% read in the feature map, clean it up for usability, and save it for later 
[~,~,delMe] = xlsread('/Users/z_home/Desktop/SHARP/ETC/2017_2_5 RF stimuli feature map - 1B.xlsx'); 
delSize = size(delMe);
delHeight = delSize(1);
delWidth = delSize(2);
for i = 1:delHeight
    if isnan(delMe{i,1})
        delMe(i:end,:) = []; % if it has no Shift_name, it's not a real row; delete it
        break;
    end
end
for i = 1:delWidth
    if isnan(delMe{1,i})
        delMe(:,i:end) = []; % if it has no title row, it's not a real col; delete it
        break;
    end
end
delMe(1,1:end) = strrep(delMe(1,1:end), ' ', '_'); % remove all spaces from the first row; table variable names can't have spaces
delMe(1,1:end) = strrep(delMe(1,1:end), ':', ''); % same with :
delMe(1,1:end) = strrep(delMe(1,1:end), '3dShape', 'Shape3d'); % can't start with a number either
feat_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
% first remove all the totally-NaN cols
deleteTheseCols = {'nothing yet'};
deleteTheseColsRow = 1;
for c = 17:width(feat_1B) % ANOTHER HACK! (I happen to know the first 17 are ok, and also contain some non-number cols)
    nanCount = sum(isnan(table2array(feat_1B(:,c))));
    if (nanCount == height(feat_1B)) % this col is 100% NaNs; remove it
        deleteTheseCols(deleteTheseColsRow,:) = feat_1B(:,c).Properties.VariableNames(1); % note the names of these cols, to delete
        deleteTheseColsRow = deleteTheseColsRow + 1;
    end
end
for i = 1:length(deleteTheseCols)
    feat_1B(:,deleteTheseCols(i)) = []; % delete the marked cols
end
% now change all the NaNs to 0s (note that this will take a minute, but not too long) 
for i = 1:height(feat_1B) 
    for c = 1:width(feat_1B)
        if (iscell(feat_1B{i,c}) == 0) % if it's not a cell, it's either a number or a NaN
            if (isnan(feat_1B{i,c})) % if it's a NaN...
                feat_1B{i,c} = 0; % make it a zero
            end
        end
    end
end
save(getFileNameForThisOS('2017_3_10-FeatureMap_AllShifts_1B.mat', 'IntResults'), 'feat_1B');
writetable(feat_1B, getFileNameForThisOS('2017_3_10-FeatureMap_AllShifts_1B.csv', 'IntResults'),'WriteRowNames',false);
clear delSize delHeight delWidth delMe i c deleteTheseCols deleteTheseColsRow nanCount




% now load in the PCA loadings Maciej gave us
[~,~,delMe] = xlsread(getFileNameForThisOS('2017_2_28-y25loadings3SD.xlsx', 'IntResults')); 
delMe(:,1) = []; % not sure what this first column is meant to be; remove it
PCAload_3SD_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names

% and now make a new matrix that associates the PCs with features
PCfeat_1B = table(0,0,'VariableNames', {'PCnum', 'nVal'}); % add the two features of these shifts that the feature map doesn't have
for i = 1:width(feat_1B) % then add all the ones that the feature map does have to the table
    PCfeat_1B(1,i+2) = feat_1B(1,i);
    PCfeat_1B.Properties.VariableNames{i+2} = feat_1B.Properties.VariableNames{i};
end
addingRowNum = 1;
for col = 2:width(PCAload_3SD_1B) % go through all the PCs
    pc = col-1; % first col is "shift", then it's PCs
    for row = 1:height(PCAload_3SD_1B)
        if (strcmpi(PCAload_3SD_1B{row,col},'NA') == 0) % this cell isn't just 'NA'
            if (addingRowNum > 1)
                PCfeat_1B(addingRowNum,:) = PCfeat_1B(addingRowNum-1,:); % just create a dummy space into which we can save values
            end
            n = mod(PCAload_3SD_1B{row,1},100); % get the n value
            shift = PCAload_3SD_1B{row,1} - n; % get the shift ID
            features = feat_1B(feat_1B.ShiftID == shift, :);
%            addThisRow = table(pc,n,features{1,14:end},'VariableNames', ['PCnum', 'nVal',features.Properties.VariableNames(14:end)])
            PCfeat_1B.PCnum(addingRowNum) = pc;
            PCfeat_1B.nVal(addingRowNum) = n;
            PCfeat_1B(addingRowNum,3:end) = feat_1B(feat_1B.ShiftID == shift, :);
            addingRowNum = addingRowNum + 1;
        end
    end
end
writetable(PCfeat_1B, getFileNameForThisOS('2017_3_10-PCAloads_3SDs_features_1B.csv', 'IntResults'),'WriteRowNames',false);
clear i addingRowNum col row pc n shift features addThisRow
 
% and now summarize those features in a new matrix: sums
PCfeat_1B_sums = PCfeat_1B(1,:);
uniquePCs = unique(PCfeat_1B.PCnum);
for i = 1:length(uniquePCs)
    pc = uniquePCs(i);
    pcRows = PCfeat_1B(PCfeat_1B.PCnum == pc, :);
    if (i > 1) 
        PCfeat_1B_sums(i,:) = PCfeat_1B_sums(i-1,:); % just create a dummy space into which we can save values
    end
    for c = 1:width(PCfeat_1B)
        if (strcmpi(PCfeat_1B.Properties.VariableNames{c},'PCnum'))
            PCfeat_1B_sums{pc,c} = pcRows{1,c};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'nVal'))
            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Shift_name'))
            PCfeat_1B_sums{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'ShiftID'))
            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Scenario'))
            PCfeat_1B_sums{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'ScenarioCode'))
            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Cluster'))
            PCfeat_1B_sums{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'NonEF'))
            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'TimeoutCorrect'))
            PCfeat_1B_sums{pc,c} = -1;
        else
            PCfeat_1B_sums{pc,c} = sum(pcRows{:,c});
        end
    end
end
width(PCfeat_1B_sums) % 193 cols
PCfeat_1B_sums_noZeros = PCfeat_1B_sums; % now create one that doesn't have any sum=0 cols
PCfeat_1B_sums_noZeros.nVal = [];
PCfeat_1B_sums_noZeros.Shift_name = [];
PCfeat_1B_sums_noZeros.ShiftID = [];
PCfeat_1B_sums_noZeros.Scenario = [];
PCfeat_1B_sums_noZeros.ScenarioCode = [];
PCfeat_1B_sums_noZeros.Cluster = [];
PCfeat_1B_sums_noZeros.NonEF = [];
PCfeat_1B_sums_noZeros.TimeoutCorrect = [];
for i=width(PCfeat_1B_sums_noZeros):-1:1
    if (sum(PCfeat_1B_sums_noZeros{:,i}) == 0)
        PCfeat_1B_sums_noZeros(:,i) = [];
    end
end
width(PCfeat_1B_sums_noZeros) % 87 cols
writetable(PCfeat_1B_sums_noZeros, getFileNameForThisOS('2017_3_10-PCfeat_1B_sums_noZeros.csv', 'IntResults'),'WriteRowNames',false);

% and now summarize those features in a new matrix: weights (based on loadings) 
PCfeat_1B_weights = PCfeat_1B(1,:);
uniquePCs = unique(PCfeat_1B.PCnum);
for i = 1:length(uniquePCs)
    pc = uniquePCs(i);
    pcRows = PCfeat_1B(PCfeat_1B.PCnum == pc, :);
    pcShiftWeights = zeros(1, height(pcRows));
    for j = 1:height(pcRows)
        weightShiftID = pcRows.ShiftID(j) + pcRows.nVal(j);
        weightCell = PCAload_3SD_1B{PCAload_3SD_1B.Shift == weightShiftID, i+1}; % i+1 because PC1 is col 2 in PCAload_3SD_1B
        pcShiftWeights(1,j) = weightCell{1};
    end
    if (i > 1) 
        PCfeat_1B_weights(i,:) = PCfeat_1B_weights(i-1,:); % just create a dummy space into which we can save values
    end
    for c = 1:width(PCfeat_1B)
        if (strcmpi(PCfeat_1B.Properties.VariableNames{c},'PCnum'))
            PCfeat_1B_weights{pc,c} = pcRows{1,c};
% weight might be interesting for nVal?       elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'nVal'))
%            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Shift_name'))
            PCfeat_1B_weights{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'ShiftID'))
            PCfeat_1B_weights{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Scenario'))
            PCfeat_1B_weights{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'ScenarioCode'))
            PCfeat_1B_weights{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Cluster'))
            PCfeat_1B_weights{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'NonEF'))
            PCfeat_1B_weights{pc,c} = -1;
% weight might be interesting for timeoutCorrect?       elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'TimeoutCorrect'))
%            PCfeat_1B_sums{pc,c} = -1;
        else
            PCfeat_1B_weights{pc,c} = pcShiftWeights * pcRows{:,c};
        end
    end
end
width(PCfeat_1B_weights) % 193 cols

PCfeat_1B_weights_noZeros = PCfeat_1B_weights; % now create one that doesn't have any sum=0 cols
%PCfeat_1B_weights_noZeros.nVal = [];
PCfeat_1B_weights_noZeros.Shift_name = [];
PCfeat_1B_weights_noZeros.ShiftID = [];
PCfeat_1B_weights_noZeros.Scenario = [];
PCfeat_1B_weights_noZeros.ScenarioCode = [];
PCfeat_1B_weights_noZeros.Cluster = [];
PCfeat_1B_weights_noZeros.NonEF = [];
%PCfeat_1B_sums_noZeros.TimeoutCorrect = [];
for i=width(PCfeat_1B_weights_noZeros):-1:1
    if (sum(PCfeat_1B_weights_noZeros{:,i}) == 0)
        PCfeat_1B_weights_noZeros(:,i) = [];
    end
end
width(PCfeat_1B_weights_noZeros) % 89 cols

writetable(PCfeat_1B_weights_noZeros, getFileNameForThisOS('2017_3_10-PCfeat_1B_weights_noZeros.csv', 'IntResults'),'WriteRowNames',false);





% create some sets of "emblematic" shifts for Maciej
delMe = unique(zRFSum_1B.Shift);
delMe2 = table({'Test'},{'Cluster'},0,'VariableNames', {'Shift', 'Cluster', 'ShiftID'}); 
for i = 1:length(delMe)
    shiftName = delMe(i);
    shiftExample = zRFSum_1B(strcmpi(zRFSum_1B.Shift, shiftName), :);
    cluster = shiftExample.Cluster(1);
    firstLetter = cluster{1};
    firstLetter = firstLetter(1);
    if (strcmpi(firstLetter, 'U')) % it's an update-related cluster; set N = 2
        delMe2(i,:) = table(shiftName,cluster,...
            getShiftIDfromShiftName(delMe{i}, 2, false),...
            'VariableNames', {'Shift', 'Cluster', 'ShiftID'}); 
    elseif (strcmpi(cluster, 'L4aV1')) % it's a LV4a cluster; set N = 2
        delMe2(i,:) = table(shiftName,cluster,...
            getShiftIDfromShiftName(delMe{i}, 2, false),...
            'VariableNames', {'Shift', 'Cluster', 'ShiftID'}); 
    elseif (strcmpi(cluster, 'L4aV2')) % it's a LV4a cluster; set N = 2
        delMe2(i,:) = table(shiftName,cluster,...
            getShiftIDfromShiftName(delMe{i}, 2, false),...
            'VariableNames', {'Shift', 'Cluster', 'ShiftID'}); 
    else
        delMe2(i,:) = table(shiftName,cluster,...
            getShiftIDfromShiftName(delMe{i}, 1, false),...
            'VariableNames', {'Shift', 'Cluster', 'ShiftID'}); 
    end        
end
clear i

writetable(delMe2, getFileNameForThisOS('2017_4_19-shiftNamesAndIDs_1B.csv', 'IntResults'),'WriteRowNames',false);



        

% get just the U, I, and S shifts for Maciej (with shiftIDs)
%   then also label them as "good" or "bad" examples of the EFs
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'U'),:);
delMe = [delMe; zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'I'),:)];
delMe = [delMe; zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 's'),:)];
delMe.ShiftID = zeros(height(delMe),1);
for i = 1:height(delMe)
    delMe.ShiftID(i) = getShiftIDfromShiftName(delMe.Shift{i}, delMe.ActualN(i), false);
end

delMe2 = unique(delMe.ShiftID);
delMe2(isnan(delMe2),:) = []; % apparently there is an ActualN that is NaN... might want to look into this?
delMe3 = table({'Test'},0,'VariableNames',{'Shift','ShiftID'});
for i = 1:length(delMe2)
    [shiftName,~] = getShiftNamefromShiftID(delMe2(i));
    delMe3(i,:) = table({shiftName},delMe2(i),'VariableNames',{'Shift','ShiftID'});
end
writetable(delMe3, getFileNameForThisOS('U_I_S shifts and IDs - 1B.csv', 'IntResults'));
clear i shiftName delMe delMe2 delMe3



% describe the clustering which Maciej has identified within RF
Cluster1 = [901 12803 5803 9702 3603 5801 1303 1301 401 8202 1103 4702 5602 1402 12903 2801 7202 6101 11403 2201 8801 1503 12701 2502 12602 1202 4601 4701 4602 13603 11603 12702 13703 10203 9703 3803 9401 11402 1201 5901 201 6201 13402 7303 9301 1203 5603 12603 5703 8203 1502 5702];
Cluster2 = [1401 8201 13503 2302 4703 3903 12904 1101 1501 6301 11602 10103 10403 7203 6001 2301 5601 8803 12806 1403 9501 11401 2202 2901 9002 7302 10803 13004 10801 7201 101 12605 5802 103 8903 203 2501 8701 10802 13403 12804 12703 13003];
Cluster3 = [13007 2102 12705 3001 2303 2103 2001 2701 2101 3303 2403 2503 4901 2402 5701 6403 8901 8703 6303 7501 9802 9803 9003 2002 4603 8902 10303 8802 8702 6402 6302 7403 13704 13604 13504 13404 13008 13006 13005 12907 12906 12905 12805 12706 12704 12608 12607 12606 12604 12003 11702 11703 6401 9201 7301 9001 3402 3403 2003 2203 2401];
Cluster4 = [601 7701 7801 3002 1701 1302 13501 13701 3201 13401 7901 8001 9601 301 801 2601];
Cluster5 = [8101 1601 12801 12802 12901 3003 9503 3703 12601 9101 13001 202 1001 102 13502 13702 4801 12902 1102 13002 701 3302 8401 5401 5501 9502 1901 8501 11201];

clusterTable = table(0,0,{'Test'},0,'VariableNames',{'Cluster','ShiftID','Shift','ActualN'});
insertThisRow = 1;
for i = 1:5 % cluster number
    clusterNum = sprintf('%d',i);
    curCluster = eval(strcat('Cluster',clusterNum));
    for j = 1:length(curCluster)
        shiftID = curCluster(j);
        [shiftName, shiftN] = getShiftNamefromShiftID(shiftID);
        clusterTable(insertThisRow,:) = table(str2num(clusterNum), shiftID, {shiftName}, shiftN,'VariableNames',{'Cluster','ShiftID','Shift','ActualN'});
        insertThisRow = insertThisRow + 1;
    end
end
writetable(clusterTable, getFileNameForThisOS('2016_4_24 clustering evaluation.csv', 'IntResults'));

clear Cluster1 Cluster2 Cluster3 Cluster4 Cluster5
clear insertThisRow i clusterNum curCluster j shiftID shiftID shiftName shiftN


% add to feature map: binary cols to indicate scenario, high TimeoutCorrect, and EF counts 
load(getFileNameForThisOS('2017_3_10-FeatureMap_AllShifts_1B.mat', 'IntResults')); % load feat_1B
feat_1B.Scenario1 = zeros(height(feat_1B),1);
feat_1B.Scenario2 = zeros(height(feat_1B),1);
feat_1B.Scenario3 = zeros(height(feat_1B),1);
feat_1B.Scenario4 = zeros(height(feat_1B),1);
feat_1B.Scenario5 = zeros(height(feat_1B),1);
feat_1B.HighTimeoutCorrect = zeros(height(feat_1B),1);
%feat_1B.Lv4 = zeros(height(feat_1B),1);
feat_1B.JustOneEF = zeros(height(feat_1B),1);
feat_1B.JustTwoEFs = zeros(height(feat_1B),1);
feat_1B.JustThreeEFs = zeros(height(feat_1B),1); % only Lv4 at this point
for i=1:height(feat_1B)
    if (feat_1B.ScenarioCode(i) == 1)
        feat_1B.Scenario1(i) = 1;
    elseif (feat_1B.ScenarioCode(i) == 2)
        feat_1B.Scenario2(i) = 1;
    elseif (feat_1B.ScenarioCode(i) == 3)
        feat_1B.Scenario3(i) = 1;
    elseif (feat_1B.ScenarioCode(i) == 4)
        feat_1B.Scenario4(i) = 1;
    elseif (feat_1B.ScenarioCode(i) == 5)
        feat_1B.Scenario5(i) = 1;
    end
    if (feat_1B.TimeoutCorrect(i) >= 0.5)
        feat_1B.HighTimeoutCorrect(i) = 1;
    end
    if ( (strcmpi(feat_1B.Cluster(i), 'U') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'S') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'I') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'U/Logic') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'S/Logic') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'I/Logic') == 1) )
        feat_1B.JustOneEF(i) = 1;
    end
    if ( (strcmpi(feat_1B.Cluster(i), 'U/S') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'U/S/Logic') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'U/I') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'U/I/Logic') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'S/I') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'S/I/Logic') == 1) )
        feat_1B.JustTwoEFs(i) = 1;
    end
    if ( (strcmpi(feat_1B.Cluster(i), 'L4aV1') == 1) || ...
            (strcmpi(feat_1B.Cluster(i), 'L4aV2') == 1) )
        feat_1B.JustThreeEFs(i) = 1;
    end

end
save(getFileNameForThisOS('2017_3_10-FeatureMap_AllShifts_1B.mat', 'IntResults'), 'feat_1B');


load(getFileNameForThisOS('2017_3_10-FeatureMap_AllShifts_1B.mat', 'IntResults')); % load feat_1B

% change 0s in feature map to -1s (useful for weighting / heat maps)
%   Note: takes about 60sec
featMapWithNeg1s = feat_1B;
for i=width(featMapWithNeg1s):-1:1 % go backward, since we might delete some columns and we don't want to screw up the index
    if (~iscell(featMapWithNeg1s{1,i})) % if there's one cell in the col, it's a non-numeric col; don't mess with it for now
        if (isequal(unique(featMapWithNeg1s{:,i}), [0])) % if we've never seen this at all, it's not useful for weighting categories; remove it
            featMapWithNeg1s(:,i) = [];
        elseif ( isequal(unique(featMapWithNeg1s{:,i}), [0;1]) || ... % this is binary; make the 0s into -1s
                isequal(unique(featMapWithNeg1s{:,i}), [1;0]) )
            for j = 1:height(featMapWithNeg1s)
                if (featMapWithNeg1s{j,i} == 0)
                    featMapWithNeg1s{j,i} = -1;
                end
            end
        end
    end
end
save(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults'), 'featMapWithNeg1s');

% create a table that includes the category, the Nval, and the features 
catFeatures = table(0,0,'VariableNames',{'Category','ActualN'});
insertThisCol = width(catFeatures) + 1;
for i=1:width(featMapWithNeg1s) 
    catFeatures(1,insertThisCol) = featMapWithNeg1s(1,i);
    catFeatures.Properties.VariableNames(insertThisCol) = featMapWithNeg1s.Properties.VariableNames(i);
    insertThisCol = insertThisCol + 1;
end
% now populate that table with the features for each observed shift
for i=1:height(clusterTable)
    catFeatures(i,:) = catFeatures(1,:); % create a placeholder for the next row without having to specify all the variables
    catFeatures.Category(i) = clusterTable.Cluster(i);
    catFeatures.ShiftID(i) = clusterTable.ShiftID(i);
    catFeatures.ActualN(i) = mod(catFeatures.ShiftID(i), 100);
    featShift = featMapWithNeg1s(featMapWithNeg1s.ShiftID == (catFeatures.ShiftID(i) - catFeatures.ActualN(i)), :); % feature map doesn't have N values in shiftIDs
    catFeatures.Shift_name(i) = featShift.Shift_name;
    catFeatures(i,5:end) = featShift(1,3:end);
end
clear featMapWithNeg1s insertThisCol featShift i

% now weight the features by the category
catWeights = table();
%catWeights(1,1:end) = catFeatures(1,1:end);
%catWeights.Properties.VariableNames(1:end) = catFeatures.Properties.VariableNames(1:end);
for i=1:width(catFeatures) % set up the columns
    catWeights(1,i) = catFeatures(1,i);
    catWeights.Properties.VariableNames(i) = catFeatures.Properties.VariableNames(i);
end
% Note: these cols don't make sense in a weight matrix: Cluster, Shift_name, ShiftID, Scenario, ScenarioCode 
categories = unique(catFeatures.Category);
catWeights.Properties.VariableNames(2) = {'AvgUpdateN'}; % change from ActualN to average N for update shifts
catWeights.Properties.VariableNames(17) = {'AvgNonEF'}; 
catWeights.Properties.VariableNames(18) = {'AvgTimeoutCorrect'}; 
for i=1:length(categories)
    cat = categories(i);
    catShifts = catFeatures(catFeatures.Category == cat, :);
    catWeights(i,:) = catWeights(1,:); % set up the weights with some default values
    % now weight them properly
    catWeights.Category(i) = cat;
    updateShifts = catShifts(catShifts.U == 1, :);
    catWeights.AvgUpdateN(i) = mean(updateShifts.ActualN);
    catWeights.Shift_name(i) = {'N/A'}; % remove this later
    catWeights.ShiftID(i) = -999; % remove this later
    catWeights.Scenario(i) = {'N/A'}; % remove this later
    for j=6:13 % columns U, I, S, xOR, ID, Relational, HypTest, NotTrueInhibit
        catWeights{i,j} = sum(catShifts{:,j});
    end
    catWeights.ScenarioCode(i) = -999; % remove this later
    catWeights.Cluster(i) = {'N/A'}; % remove this later
    catWeights.Logic(i) = sum(catShifts.Logic);
    catWeights.AvgNonEF(i) = mean(catShifts.NonEF);
    catWeights.AvgTimeoutCorrect(i) = mean(catShifts.TimeoutCorrect);
    catWeights.TotalCorrResp(i) = -999; % remove this later
    catWeights.GuessProb(i) = -999; % remove this later
    for j=20:width(catWeights) % remaining cols are all 1/-1
        catWeights{i,j} = sum(catShifts{:,j});
    end
end
catWeights.Shift_name = []; % remove the cols that don't make sense in the weighting aggregation
catWeights.ShiftID = []; 
catWeights.Scenario = []; 
catWeights.Cluster = []; 
catWeights.ScenarioCode = []; 
catWeights.TotalCorrResp = []; 
catWeights.GuessProb = []; 
writetable(catWeights, getFileNameForThisOS('2017_5_10-categoryWeightedFeatures.csv', 'IntResults')); % use this for a heat map
clear i j cat catShifts updateShifts categories

% now put the CatWeights back into the range of -1 to 1
Cluster1 = [901 12803 5803 9702 3603 5801 1303 1301 401 8202 1103 4702 5602 1402 12903 2801 7202 6101 11403 2201 8801 1503 12701 2502 12602 1202 4601 4701 4602 13603 11603 12702 13703 10203 9703 3803 9401 11402 1201 5901 201 6201 13402 7303 9301 1203 5603 12603 5703 8203 1502 5702];
Cluster2 = [1401 8201 13503 2302 4703 3903 12904 1101 1501 6301 11602 10103 10403 7203 6001 2301 5601 8803 12806 1403 9501 11401 2202 2901 9002 7302 10803 13004 10801 7201 101 12605 5802 103 8903 203 2501 8701 10802 13403 12804 12703 13003];
Cluster3 = [13007 2102 12705 3001 2303 2103 2001 2701 2101 3303 2403 2503 4901 2402 5701 6403 8901 8703 6303 7501 9802 9803 9003 2002 4603 8902 10303 8802 8702 6402 6302 7403 13704 13604 13504 13404 13008 13006 13005 12907 12906 12905 12805 12706 12704 12608 12607 12606 12604 12003 11702 11703 6401 9201 7301 9001 3402 3403 2003 2203 2401];
Cluster4 = [601 7701 7801 3002 1701 1302 13501 13701 3201 13401 7901 8001 9601 301 801 2601];
Cluster5 = [8101 1601 12801 12802 12901 3003 9503 3703 12601 9101 13001 202 1001 102 13502 13702 4801 12902 1102 13002 701 3302 8401 5401 5501 9502 1901 8501 11201];
catWeightPcts = catWeights;
for i = 1:height(catWeights)
    curCat = eval(sprintf('Cluster%d',i));
    for j = 1:width(catWeights)
        catWeightPcts{i,j} = catWeightPcts{i,j} / length(curCat);
    end
end
catWeightPcts.Category = catWeights.Category; % several things were already correct, however; put those back
catWeightPcts.AvgUpdateN = catWeights.AvgUpdateN;
catWeightPcts.AvgNonEF = catWeights.AvgNonEF;
catWeightPcts.AvgTimeoutCorrect = catWeights.AvgTimeoutCorrect;
writetable(catWeightPcts, getFileNameForThisOS('2017_5_8-categoryWeightedFeatures_percentages.csv', 'IntResults')); % use this for a heat map

clear Cluster1 Cluster2 Cluster3 Cluster4 Cluster5

clear clusterTable catFeatures catWeights % when we're done analyzing them...

%{
These were the Inhibit shifts that were fixed (no longer single-stim):
shiftIDs (in order): [1300 5700 2600 9100 11000 3000 9500 11400 3200 9600 11500]
32: Odditizing U/I  (C1: 1301, 1303; C4: 1302) (not in PCs 1-10)
34: Limb Reparations U/I   (C1: 5702, 5703; C3: 5701) (not in PCs 1-10)
66: Braincase Downsizing I/Logic (C4: 2601) (not in PCs 1-10)
67: ATC Prioritizing I/Logic (C5: 9101) (PC1)
68: Flipper Exception I/Logic (no cluster) (PC9)
78: Digit Arrangement U/I/Logic (C3: 3001; C4: 3002; C5: 3003) (PC1, 10)
79: PI Memorization U/I/Logic  (C2: 9501; C5: 9502, 9503) (not in PCs 1-10)
80: Language Crunching U/I/Logic  (C1: 11402, 11403; C2: 11401) (not in PCs 1-10)
82: Ocular Orientation S/I/Logic  (C4: 3201) (PC1, 9)
83: Cartography Catharsis S/I/Logic (C4: 9601) (PC1, 4, 5, 9, 10)
84: Generational Gapping S/I/Logic (no cluster) (not in PCs 1-10) NEVER SEEN IN 1B!!!! 
%}


% add shiftIDs to the 1B per-shift data
zRFSum_1B.shiftID = zeros(height(zRFSum_1B),1);
for i=1:height(zRFSum_1B)
    zRFSum_1B.shiftID(i) = getShiftIDfromShiftName(zRFSum_1B.Shift{i}, zRFSum_1B.ActualN(i), false);
end

% read in the threshold data from Maciej and see how many are before or after the end of the shift
delMe = readtable(getFileNameForThisOS('2017_5_10 - fromMaciej - thre_subject_shift.csv', 'IntResults'));
delMe.totalTrials = zeros(height(delMe),1);
delMe.beforeTheStart = zeros(height(delMe),1);
delMe.afterTheEnd = zeros(height(delMe),1);
prevSubj = delMe.subject(1);
for i = 1:height(delMe)
    curSubj = delMe.subject(i);
    if (curSubj ~= prevSubj) % new subject; give staying alive feedback
        prevSubj = curSubj;
        fprintf('Handling subject %d.\n', curSubj);
    end
    subjShifts = zRFSum_1B(zRFSum_1B.Subject == curSubj,:);
    firstSubjShift = subjShifts(subjShifts.shiftID == delMe.shift(i), :);
    delMe.totalTrials(i) = firstSubjShift.Attempted(1);
    if (delMe.thre(i) > delMe.totalTrials(i))
        delMe.afterTheEnd(i) = 1;
    elseif (delMe.thre(i) < 1)
        delMe.beforeTheStart(i) = 1;
    end
        
end
delMe(1:10,:) % just to see 

clear i subjShifts firstSubjShift prevSubj curSubj

subjsThresholdPerf = table(0,0,0,0,'VariableNames',{'Subject','perfectShifts','learnedShifts','unlearnedShifts'});
subjs = unique(delMe.subject); 
for i = 1:length(subjs)
    subj = subjs(i);
    subjShifts = delMe(delMe.subject == subj, :);
    subjsThresholdPerf(i,:) = table(subj, ...
        sum(subjShifts.beforeTheStart) / height(subjShifts), ...
        1 - ((sum(subjShifts.beforeTheStart) + sum(subjShifts.afterTheEnd)) / height(subjShifts)), ...
        sum(subjShifts.afterTheEnd) / height(subjShifts), ...
        'VariableNames',{'Subject','perfectShifts','learnedShifts','unlearnedShifts'});
end
writetable(subjsThresholdPerf, getFileNameForThisOS('2017_5_10-SubjectsPerformanceOnThreshold.csv', 'IntResults'));
shiftsThresholdPerf = table(0,0,0,0,'VariableNames',{'ShiftID','perfectSubjs','learningSubjs','unlearningSubjs'});
shifts = unique(delMe.shift); 
for i = 1:length(shifts)
    shift = shifts(i);
    shiftSubjs = delMe(delMe.shift == shift, :);
    shiftsThresholdPerf(i,:) = table(shift, ...
        sum(shiftSubjs.beforeTheStart) / height(shiftSubjs), ...
        1 - ((sum(shiftSubjs.beforeTheStart) + sum(shiftSubjs.afterTheEnd)) / height(shiftSubjs)), ...
        sum(shiftSubjs.afterTheEnd) / height(shiftSubjs), ...
        'VariableNames',{'ShiftID','perfectSubjs','learningSubjs','unlearningSubjs'});
end
writetable(shiftsThresholdPerf, getFileNameForThisOS('2017_5_10-ShiftsPerformanceOnThreshold.csv', 'IntResults'));
clear i subjs subj shifts shift subjShifts shiftSubjs




% now do the same feature categorization for the PCA loadings Maciej gave us
[~,~,delMe] = xlsread(getFileNameForThisOS('2017_5_10 pca_thresholds_loadings_3SD_selected.xlsx', 'IntResults')); 
delMe(:,1) = []; % not sure what this first column is meant to be; remove it
PCAload_3SD_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
categoryTable = table(0,0,{'Test'},0,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
addingRowNum = 1;
for col = 2:width(PCAload_3SD_1B) % go through all the PCs (first col is shift numbers)
    for row = 1:height(PCAload_3SD_1B)
        if (strcmpi(PCAload_3SD_1B{row,col},'NA') == 0) % this cell isn't just 'NA'
            shiftID = PCAload_3SD_1B{row,1}; % first col is the shift ID
            [shiftName, shiftN] = getShiftNamefromShiftID(shiftID);
            categoryTable(addingRowNum,:) = table(col-1, shiftID, {shiftName}, ...
                shiftN,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
            addingRowNum = addingRowNum + 1;
        end
    end
end
% create a table that includes the category, the Nval, and the features 
load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
catFeatures = table(0,0,'VariableNames',{'Category','ActualN'});
insertThisCol = width(catFeatures) + 1;
for i=1:width(featMapWithNeg1s) 
    catFeatures(1,insertThisCol) = featMapWithNeg1s(1,i);
    catFeatures.Properties.VariableNames(insertThisCol) = featMapWithNeg1s.Properties.VariableNames(i);
    insertThisCol = insertThisCol + 1;
end
% now populate that table with the features for each observed shift
for i=1:height(categoryTable)
    catFeatures(i,:) = catFeatures(1,:); % create a placeholder for the next row without having to specify all the variables
    catFeatures.Category(i) = categoryTable.Category(i);
    catFeatures.ShiftID(i) = categoryTable.ShiftID(i);
    catFeatures.ActualN(i) = mod(catFeatures.ShiftID(i), 100);
    featShift = featMapWithNeg1s(featMapWithNeg1s.ShiftID == (catFeatures.ShiftID(i) - catFeatures.ActualN(i)), :); % feature map doesn't have N values in shiftIDs
    catFeatures.Shift_name(i) = featShift.Shift_name;
    catFeatures(i,5:end) = featShift(1,3:end);
end
clear featMapWithNeg1s insertThisCol featShift i

catWeightPcts = catWeights; % divide these by the number of shifts that went into them to put them in the range of -1 to 1
for j = 1:width(catWeights)
    catWeightPcts{1,j} = catWeightPcts{1,j} / 1; % this is hacky; put it in a function and pass along these params or calculate them
    catWeightPcts{2,j} = catWeightPcts{2,j} / 2; 
    catWeightPcts{3,j} = catWeightPcts{3,j} / 6; 
    catWeightPcts{4,j} = catWeightPcts{4,j} / 4; 
    catWeightPcts{5,j} = catWeightPcts{5,j} / 7; 
    catWeightPcts{6,j} = catWeightPcts{6,j} / 5; 
    catWeightPcts{7,j} = catWeightPcts{7,j} / 4; 
    catWeightPcts{8,j} = catWeightPcts{8,j} / 5; 
    catWeightPcts{9,j} = catWeightPcts{9,j} / 2; 
    catWeightPcts{10,j} = catWeightPcts{10,j} / 4; 
end
catWeightPcts.Category = catWeights.Category; % several things were already correct, however; put those back
catWeightPcts.AvgUpdateN = catWeights.AvgUpdateN;
catWeightPcts.AvgNonEF = catWeights.AvgNonEF;
catWeightPcts.AvgTimeoutCorrect = catWeights.AvgTimeoutCorrect;
writetable(catWeightPcts, getFileNameForThisOS('2017_5_10-PCAweightedFeatures_percentages.csv', 'IntResults')); % use this for a heat map




%{ 
ignore all this, just to make a point
delMe = readtable(getFileNameForThisOS('2017_5_13-MishaPsychoFits.csv', 'IntResults'));
scatter(1:height(delMe),delMe.y25)
title(sprintf('Y25s'));
xlabel('Row number (meaningless)')
ylabel('Y25 value')

scatter(1:height(delMe),delMe.thresh)
title(sprintf('Threshold (limits: 1 and 300)'));
xlabel('Row number (meaningless)')
ylabel('Trials until we meet 80% threshold')

scatter(1:height(delMe),delMe.gamma)
title(sprintf('Threshold (limits: 1 and 300)'));
xlabel('Row number (meaningless)')
ylabel('Gamma')

delMe2 = delMe(delMe.gamma > .95,:);
figure
scatter(1:height(delMe2),delMe2.lambda)
title(sprintf('gamma > .95'));
xlabel('Row number (meaningless)')
ylabel('Lambda')
%}


% now do the same feature categorization for the Y25 PCA loadings (really need to get that function working) 
[~,~,delMe] = xlsread(getFileNameForThisOS('2015_5_13 Maciej_pca_y25_loadings_3SD.xlsx', 'IntResults')); 
delMe(:,1) = []; % not sure what this first column is meant to be; remove it
PCAload_3SD_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
categoryTable = table(0,0,{'Test'},0,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
addingRowNum = 1;
for col = 2:width(PCAload_3SD_1B) % go through all the PCs (first col is shift numbers)
    for row = 1:height(PCAload_3SD_1B)
        if (strcmpi(PCAload_3SD_1B{row,col},'NA') == 0) % this cell isn't just 'NA'
            shiftID = PCAload_3SD_1B{row,1}; % first col is the shift ID
            [shiftName, shiftN] = getShiftNamefromShiftID(shiftID);
            categoryTable(addingRowNum,:) = table(col-1, shiftID, {shiftName}, ...
                shiftN,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
            addingRowNum = addingRowNum + 1;
        end
    end
end
% create a table that includes the category, the Nval, and the features 
load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
catFeatures = table(0,0,'VariableNames',{'Category','ActualN'});
insertThisCol = width(catFeatures) + 1;
for i=1:width(featMapWithNeg1s) 
    catFeatures(1,insertThisCol) = featMapWithNeg1s(1,i);
    catFeatures.Properties.VariableNames(insertThisCol) = featMapWithNeg1s.Properties.VariableNames(i);
    insertThisCol = insertThisCol + 1;
end
% now populate that table with the features for each observed shift
for i=1:height(categoryTable)
    catFeatures(i,:) = catFeatures(1,:); % create a placeholder for the next row without having to specify all the variables
    catFeatures.Category(i) = categoryTable.Category(i);
    catFeatures.ShiftID(i) = categoryTable.ShiftID(i);
    catFeatures.ActualN(i) = mod(catFeatures.ShiftID(i), 100);
    featShift = featMapWithNeg1s(featMapWithNeg1s.ShiftID == (catFeatures.ShiftID(i) - catFeatures.ActualN(i)), :); % feature map doesn't have N values in shiftIDs
    catFeatures.Shift_name(i) = featShift.Shift_name;
    catFeatures(i,5:end) = featShift(1,3:end);
end
clear featMapWithNeg1s insertThisCol featShift i
% now weight the features by the category
catWeights = table();
for i=1:width(catFeatures) % set up the columns
    catWeights(1,i) = catFeatures(1,i);
    catWeights.Properties.VariableNames(i) = catFeatures.Properties.VariableNames(i);
end
% Note: these cols don't make sense in a weight matrix: Cluster, Shift_name, ShiftID, Scenario, ScenarioCode 
categories = unique(catFeatures.Category);
catWeights.Properties.VariableNames(2) = {'AvgUpdateN'}; % change from ActualN to average N for update shifts
catWeights.Properties.VariableNames(17) = {'AvgNonEF'}; 
catWeights.Properties.VariableNames(18) = {'AvgTimeoutCorrect'}; 
for i=1:length(categories)
    cat = categories(i);
    catShifts = catFeatures(catFeatures.Category == cat, :);
    catWeights(i,:) = catWeights(1,:); % set up the weights with some default values
    % now weight them properly
    catWeights.Category(i) = cat;
    updateShifts = catShifts(catShifts.U == 1, :);
    catWeights.AvgUpdateN(i) = mean(updateShifts.ActualN);
    catWeights.Shift_name(i) = {'N/A'}; % remove this later
    catWeights.ShiftID(i) = -999; % remove this later
    catWeights.Scenario(i) = {'N/A'}; % remove this later
    for j=6:13 % columns U, I, S, xOR, ID, Relational, HypTest, NotTrueInhibit
        catWeights{i,j} = sum(catShifts{:,j});
    end
    catWeights.ScenarioCode(i) = -999; % remove this later
    catWeights.Cluster(i) = {'N/A'}; % remove this later
    catWeights.Logic(i) = sum(catShifts.Logic);
    catWeights.AvgNonEF(i) = mean(catShifts.NonEF);
    catWeights.AvgTimeoutCorrect(i) = mean(catShifts.TimeoutCorrect);
    catWeights.TotalCorrResp(i) = -999; % remove this later
    catWeights.GuessProb(i) = -999; % remove this later
    for j=20:width(catWeights) % remaining cols are all 1/-1
        catWeights{i,j} = sum(catShifts{:,j});
    end
end
catWeights.Shift_name = []; % remove the cols that don't make sense in the weighting aggregation
catWeights.ShiftID = []; 
catWeights.Scenario = []; 
catWeights.Cluster = []; 
catWeights.ScenarioCode = []; 
catWeights.TotalCorrResp = []; 
catWeights.GuessProb = []; 
clear i j cat catShifts updateShifts categories
catWeightPcts = catWeights; % divide these by the number of shifts that went into them to put them in the range of -1 to 1
for j = 1:width(catWeights)
    catWeightPcts{1,j} = catWeightPcts{1,j} / 4; % this is hacky; put it in a function and pass along these params or calculate them
    catWeightPcts{2,j} = catWeightPcts{2,j} / 4; 
    catWeightPcts{3,j} = catWeightPcts{3,j} / 5; 
    catWeightPcts{4,j} = catWeightPcts{4,j} / 2; 
    catWeightPcts{5,j} = catWeightPcts{5,j} / 4; 
    catWeightPcts{6,j} = catWeightPcts{6,j} / 6; 
    catWeightPcts{7,j} = catWeightPcts{7,j} / 3; 
    catWeightPcts{8,j} = catWeightPcts{8,j} / 4; 
    catWeightPcts{9,j} = catWeightPcts{9,j} / 5; 
    catWeightPcts{10,j} = catWeightPcts{10,j} / 6; 
end
catWeightPcts.Category = catWeights.Category; % several things were already correct, however; put those back
catWeightPcts.AvgUpdateN = catWeights.AvgUpdateN;
catWeightPcts.AvgNonEF = catWeights.AvgNonEF;
catWeightPcts.AvgTimeoutCorrect = catWeights.AvgTimeoutCorrect;
writetable(catWeightPcts, getFileNameForThisOS('2017_5_15-Y25_PCAweightedFeatures_percentages.csv', 'IntResults')); % use this for a heat map

% now do the same feature categorization for the threshold PCA loadings (really need to get that function working) 
[~,~,delMe] = xlsread(getFileNameForThisOS('2017_5_15-Maciej_pca_thresholds_loadings_3SD.xlsx', 'IntResults')); 
delMe(:,1) = []; % not sure what this first column is meant to be; remove it
PCAload_3SD_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
categoryTable = table(0,0,{'Test'},0,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
addingRowNum = 1;
for col = 2:width(PCAload_3SD_1B) % go through all the PCs (first col is shift numbers)
    for row = 1:height(PCAload_3SD_1B)
        if (strcmpi(PCAload_3SD_1B{row,col},'NA') == 0) % this cell isn't just 'NA'
            shiftID = PCAload_3SD_1B{row,1}; % first col is the shift ID
            [shiftName, shiftN] = getShiftNamefromShiftID(shiftID);
            categoryTable(addingRowNum,:) = table(col-1, shiftID, {shiftName}, ...
                shiftN,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
            addingRowNum = addingRowNum + 1;
        end
    end
end
% create a table that includes the category, the Nval, and the features 
load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
catFeatures = table(0,0,'VariableNames',{'Category','ActualN'});
insertThisCol = width(catFeatures) + 1;
for i=1:width(featMapWithNeg1s) 
    catFeatures(1,insertThisCol) = featMapWithNeg1s(1,i);
    catFeatures.Properties.VariableNames(insertThisCol) = featMapWithNeg1s.Properties.VariableNames(i);
    insertThisCol = insertThisCol + 1;
end
% now populate that table with the features for each observed shift
for i=1:height(categoryTable)
    catFeatures(i,:) = catFeatures(1,:); % create a placeholder for the next row without having to specify all the variables
    catFeatures.Category(i) = categoryTable.Category(i);
    catFeatures.ShiftID(i) = categoryTable.ShiftID(i);
    catFeatures.ActualN(i) = mod(catFeatures.ShiftID(i), 100);
    featShift = featMapWithNeg1s(featMapWithNeg1s.ShiftID == (catFeatures.ShiftID(i) - catFeatures.ActualN(i)), :); % feature map doesn't have N values in shiftIDs
    catFeatures.Shift_name(i) = featShift.Shift_name;
    catFeatures(i,5:end) = featShift(1,3:end);
end
clear featMapWithNeg1s insertThisCol featShift i
% now weight the features by the category
catWeights = table();
for i=1:width(catFeatures) % set up the columns
    catWeights(1,i) = catFeatures(1,i);
    catWeights.Properties.VariableNames(i) = catFeatures.Properties.VariableNames(i);
end
% Note: these cols don't make sense in a weight matrix: Cluster, Shift_name, ShiftID, Scenario, ScenarioCode 
categories = unique(catFeatures.Category);
catWeights.Properties.VariableNames(2) = {'AvgUpdateN'}; % change from ActualN to average N for update shifts
catWeights.Properties.VariableNames(17) = {'AvgNonEF'}; 
catWeights.Properties.VariableNames(18) = {'AvgTimeoutCorrect'}; 
for i=1:length(categories)
    cat = categories(i);
    catShifts = catFeatures(catFeatures.Category == cat, :);
    catWeights(i,:) = catWeights(1,:); % set up the weights with some default values
    % now weight them properly
    catWeights.Category(i) = cat;
    updateShifts = catShifts(catShifts.U == 1, :);
    catWeights.AvgUpdateN(i) = mean(updateShifts.ActualN);
    catWeights.Shift_name(i) = {'N/A'}; % remove this later
    catWeights.ShiftID(i) = -999; % remove this later
    catWeights.Scenario(i) = {'N/A'}; % remove this later
    for j=6:13 % columns U, I, S, xOR, ID, Relational, HypTest, NotTrueInhibit
        catWeights{i,j} = sum(catShifts{:,j});
    end
    catWeights.ScenarioCode(i) = -999; % remove this later
    catWeights.Cluster(i) = {'N/A'}; % remove this later
    catWeights.Logic(i) = sum(catShifts.Logic);
    catWeights.AvgNonEF(i) = mean(catShifts.NonEF);
    catWeights.AvgTimeoutCorrect(i) = mean(catShifts.TimeoutCorrect);
    catWeights.TotalCorrResp(i) = -999; % remove this later
    catWeights.GuessProb(i) = -999; % remove this later
    for j=20:width(catWeights) % remaining cols are all 1/-1
        catWeights{i,j} = sum(catShifts{:,j});
    end
end
catWeights.Shift_name = []; % remove the cols that don't make sense in the weighting aggregation
catWeights.ShiftID = []; 
catWeights.Scenario = []; 
catWeights.Cluster = []; 
catWeights.ScenarioCode = []; 
catWeights.TotalCorrResp = []; 
catWeights.GuessProb = []; 
clear i j cat catShifts updateShifts categories
catWeightPcts = catWeights; % divide these by the number of shifts that went into them to put them in the range of -1 to 1
for j = 1:width(catWeights)
    catWeightPcts{1,j} = catWeightPcts{1,j} / 3; % this is hacky; put it in a function and pass along these params or calculate them
    catWeightPcts{2,j} = catWeightPcts{2,j} / 4; 
    catWeightPcts{3,j} = catWeightPcts{3,j} / 7; 
    catWeightPcts{4,j} = catWeightPcts{4,j} / 5; 
    catWeightPcts{5,j} = catWeightPcts{5,j} / 4; 
    catWeightPcts{6,j} = catWeightPcts{6,j} / 3; 
    catWeightPcts{7,j} = catWeightPcts{7,j} / 8; 
    catWeightPcts{8,j} = catWeightPcts{8,j} / 3; 
    catWeightPcts{9,j} = catWeightPcts{9,j} / 7; 
    catWeightPcts{10,j} = catWeightPcts{10,j} / 4; 
end
catWeightPcts.Category = catWeights.Category; % several things were already correct, however; put those back
catWeightPcts.AvgUpdateN = catWeights.AvgUpdateN;
catWeightPcts.AvgNonEF = catWeights.AvgNonEF;
catWeightPcts.AvgTimeoutCorrect = catWeights.AvgTimeoutCorrect;
writetable(catWeightPcts, getFileNameForThisOS('2017_5_15-threshold_PCAweightedFeatures_percentages.csv', 'IntResults')); % use this for a heat map

% now do the same feature categorization for the Y25 clustering (really need to get that function working) 
[~,~,delMe] = xlsread(getFileNameForThisOS('2017_5_15-Maciej_clusters4y25.xlsx', 'IntResults')); 
PCAload_3SD_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
categoryTable = table(0,0,{'Test'},0,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
addingRowNum = 1;
for row = 1:height(PCAload_3SD_1B)
    shiftID = PCAload_3SD_1B{row,1}; % first col is the shift ID
    [shiftName, shiftN] = getShiftNamefromShiftID(shiftID);
    categoryTable(addingRowNum,:) = table(PCAload_3SD_1B{row,2}, shiftID, {shiftName}, ...
        shiftN,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
    addingRowNum = addingRowNum + 1;
end
% create a table that includes the category, the Nval, and the features 
load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
catFeatures = table(0,0,'VariableNames',{'Category','ActualN'});
insertThisCol = width(catFeatures) + 1;
for i=1:width(featMapWithNeg1s) 
    catFeatures(1,insertThisCol) = featMapWithNeg1s(1,i);
    catFeatures.Properties.VariableNames(insertThisCol) = featMapWithNeg1s.Properties.VariableNames(i);
    insertThisCol = insertThisCol + 1;
end
% now populate that table with the features for each observed shift
for i=1:height(categoryTable)
    catFeatures(i,:) = catFeatures(1,:); % create a placeholder for the next row without having to specify all the variables
    catFeatures.Category(i) = categoryTable.Category(i);
    catFeatures.ShiftID(i) = categoryTable.ShiftID(i);
    catFeatures.ActualN(i) = mod(catFeatures.ShiftID(i), 100);
    featShift = featMapWithNeg1s(featMapWithNeg1s.ShiftID == (catFeatures.ShiftID(i) - catFeatures.ActualN(i)), :); % feature map doesn't have N values in shiftIDs
    catFeatures.Shift_name(i) = featShift.Shift_name;
    catFeatures(i,5:end) = featShift(1,3:end);
end
clear featMapWithNeg1s insertThisCol featShift i
% now weight the features by the category
catWeights = table();
for i=1:width(catFeatures) % set up the columns
    catWeights(1,i) = catFeatures(1,i);
    catWeights.Properties.VariableNames(i) = catFeatures.Properties.VariableNames(i);
end
% Note: these cols don't make sense in a weight matrix: Cluster, Shift_name, ShiftID, Scenario, ScenarioCode 
categories = unique(catFeatures.Category);
catWeights.Properties.VariableNames(2) = {'AvgUpdateN'}; % change from ActualN to average N for update shifts
catWeights.Properties.VariableNames(17) = {'AvgNonEF'}; 
catWeights.Properties.VariableNames(18) = {'AvgTimeoutCorrect'}; 
for i=1:length(categories)
    cat = categories(i);
    catShifts = catFeatures(catFeatures.Category == cat, :);
    catWeights(i,:) = catWeights(1,:); % set up the weights with some default values
    % now weight them properly
    catWeights.Category(i) = cat;
    updateShifts = catShifts(catShifts.U == 1, :);
    catWeights.AvgUpdateN(i) = mean(updateShifts.ActualN);
    catWeights.Shift_name(i) = {'N/A'}; % remove this later
    catWeights.ShiftID(i) = -999; % remove this later
    catWeights.Scenario(i) = {'N/A'}; % remove this later
    for j=6:13 % columns U, I, S, xOR, ID, Relational, HypTest, NotTrueInhibit
        catWeights{i,j} = sum(catShifts{:,j});
    end
    catWeights.ScenarioCode(i) = -999; % remove this later
    catWeights.Cluster(i) = {'N/A'}; % remove this later
    catWeights.Logic(i) = sum(catShifts.Logic);
    catWeights.AvgNonEF(i) = mean(catShifts.NonEF);
    catWeights.AvgTimeoutCorrect(i) = mean(catShifts.TimeoutCorrect);
    catWeights.TotalCorrResp(i) = -999; % remove this later
    catWeights.GuessProb(i) = -999; % remove this later
    for j=20:width(catWeights) % remaining cols are all 1/-1
        catWeights{i,j} = sum(catShifts{:,j});
    end
end
catWeights.Shift_name = []; % remove the cols that don't make sense in the weighting aggregation
catWeights.ShiftID = []; 
catWeights.Scenario = []; 
catWeights.Cluster = []; 
catWeights.ScenarioCode = []; 
catWeights.TotalCorrResp = []; 
catWeights.GuessProb = []; 
clear i j cat catShifts updateShifts categories
catWeightPcts = catWeights; % divide these by the number of shifts that went into them to put them in the range of -1 to 1
for j = 1:width(catWeights)
    catWeightPcts{1,j} = catWeightPcts{1,j} / height(categoryTable(categoryTable.Category == 1, :)); % this is hacky; put it in a function and pass along these params or calculate them
    catWeightPcts{2,j} = catWeightPcts{2,j} / height(categoryTable(categoryTable.Category == 2, :)); 
    catWeightPcts{3,j} = catWeightPcts{3,j} / height(categoryTable(categoryTable.Category == 3, :)); 
    catWeightPcts{4,j} = catWeightPcts{4,j} / height(categoryTable(categoryTable.Category == 4, :)); 
end
catWeightPcts.Category = catWeights.Category; % several things were already correct, however; put those back
catWeightPcts.AvgUpdateN = catWeights.AvgUpdateN;
catWeightPcts.AvgNonEF = catWeights.AvgNonEF;
catWeightPcts.AvgTimeoutCorrect = catWeights.AvgTimeoutCorrect;
writetable(catWeightPcts, getFileNameForThisOS('2017_5_15-Y25_clustering_weightedFeatures_percentages.csv', 'IntResults')); % use this for a heat map

% now do the same feature categorization for the threshold clustering (really need to get that function working) 
[~,~,delMe] = xlsread(getFileNameForThisOS('2017_5_15-Maciej_clusters4_thre.xlsx', 'IntResults')); 
PCAload_3SD_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
categoryTable = table(0,0,{'Test'},0,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
addingRowNum = 1;
for row = 1:height(PCAload_3SD_1B)
    shiftID = PCAload_3SD_1B{row,1}; % first col is the shift ID
    [shiftName, shiftN] = getShiftNamefromShiftID(shiftID);
    categoryTable(addingRowNum,:) = table(PCAload_3SD_1B{row,2}, shiftID, {shiftName}, ...
        shiftN,'VariableNames',{'Category','ShiftID','Shift','ActualN'});
    addingRowNum = addingRowNum + 1;
end
% create a table that includes the category, the Nval, and the features 
load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
catFeatures = table(0,0,'VariableNames',{'Category','ActualN'});
insertThisCol = width(catFeatures) + 1;
for i=1:width(featMapWithNeg1s) 
    catFeatures(1,insertThisCol) = featMapWithNeg1s(1,i);
    catFeatures.Properties.VariableNames(insertThisCol) = featMapWithNeg1s.Properties.VariableNames(i);
    insertThisCol = insertThisCol + 1;
end
% now populate that table with the features for each observed shift
for i=1:height(categoryTable)
    catFeatures(i,:) = catFeatures(1,:); % create a placeholder for the next row without having to specify all the variables
    catFeatures.Category(i) = categoryTable.Category(i);
    catFeatures.ShiftID(i) = categoryTable.ShiftID(i);
    catFeatures.ActualN(i) = mod(catFeatures.ShiftID(i), 100);
    featShift = featMapWithNeg1s(featMapWithNeg1s.ShiftID == (catFeatures.ShiftID(i) - catFeatures.ActualN(i)), :); % feature map doesn't have N values in shiftIDs
    catFeatures.Shift_name(i) = featShift.Shift_name;
    catFeatures(i,5:end) = featShift(1,3:end);
end
clear featMapWithNeg1s insertThisCol featShift i
% now weight the features by the category
catWeights = table();
for i=1:width(catFeatures) % set up the columns
    catWeights(1,i) = catFeatures(1,i);
    catWeights.Properties.VariableNames(i) = catFeatures.Properties.VariableNames(i);
end
% Note: these cols don't make sense in a weight matrix: Cluster, Shift_name, ShiftID, Scenario, ScenarioCode 
categories = unique(catFeatures.Category);
catWeights.Properties.VariableNames(2) = {'AvgUpdateN'}; % change from ActualN to average N for update shifts
catWeights.Properties.VariableNames(17) = {'AvgNonEF'}; 
catWeights.Properties.VariableNames(18) = {'AvgTimeoutCorrect'}; 
for i=1:length(categories)
    cat = categories(i);
    catShifts = catFeatures(catFeatures.Category == cat, :);
    catWeights(i,:) = catWeights(1,:); % set up the weights with some default values
    % now weight them properly
    catWeights.Category(i) = cat;
    updateShifts = catShifts(catShifts.U == 1, :);
    catWeights.AvgUpdateN(i) = mean(updateShifts.ActualN);
    catWeights.Shift_name(i) = {'N/A'}; % remove this later
    catWeights.ShiftID(i) = -999; % remove this later
    catWeights.Scenario(i) = {'N/A'}; % remove this later
    for j=6:13 % columns U, I, S, xOR, ID, Relational, HypTest, NotTrueInhibit
        catWeights{i,j} = sum(catShifts{:,j});
    end
    catWeights.ScenarioCode(i) = -999; % remove this later
    catWeights.Cluster(i) = {'N/A'}; % remove this later
    catWeights.Logic(i) = sum(catShifts.Logic);
    catWeights.AvgNonEF(i) = mean(catShifts.NonEF);
    catWeights.AvgTimeoutCorrect(i) = mean(catShifts.TimeoutCorrect);
    catWeights.TotalCorrResp(i) = -999; % remove this later
    catWeights.GuessProb(i) = -999; % remove this later
    for j=20:width(catWeights) % remaining cols are all 1/-1
        catWeights{i,j} = sum(catShifts{:,j});
    end
end
catWeights.Shift_name = []; % remove the cols that don't make sense in the weighting aggregation
catWeights.ShiftID = []; 
catWeights.Scenario = []; 
catWeights.Cluster = []; 
catWeights.ScenarioCode = []; 
catWeights.TotalCorrResp = []; 
catWeights.GuessProb = []; 
clear i j cat catShifts updateShifts categories
catWeightPcts = catWeights; % divide these by the number of shifts that went into them to put them in the range of -1 to 1
for j = 1:width(catWeights)
    catWeightPcts{1,j} = catWeightPcts{1,j} / height(categoryTable(categoryTable.Category == 1, :)); % this is hacky; put it in a function and pass along these params or calculate them
    catWeightPcts{2,j} = catWeightPcts{2,j} / height(categoryTable(categoryTable.Category == 2, :)); 
    catWeightPcts{3,j} = catWeightPcts{3,j} / height(categoryTable(categoryTable.Category == 3, :)); 
    catWeightPcts{4,j} = catWeightPcts{4,j} / height(categoryTable(categoryTable.Category == 4, :)); 
end
catWeightPcts.Category = catWeights.Category; % several things were already correct, however; put those back
catWeightPcts.AvgUpdateN = catWeights.AvgUpdateN;
catWeightPcts.AvgNonEF = catWeights.AvgNonEF;
catWeightPcts.AvgTimeoutCorrect = catWeights.AvgTimeoutCorrect;
writetable(catWeightPcts, getFileNameForThisOS('2017_5_15-thresh_clustering_weightedFeatures_percentages.csv', 'IntResults')); % use this for a heat map





[zHarvMRI_1B, ~, ~] = formTables_RF_1A3('1b-final-harvard_MRI_subjs.xlsx', '', '', true);
%[zEFdata_1B, ~, ~] = formTables_RF_1A3('1b-final-Complete_EF_data_Ready_for_analysis.xlsx', '', '', true);
[zEFdata_1B] = readtable(getFileNameForThisOS('1b-final-Complete_EF_data_Ready_for_analysis.csv', 'ParsedData'));
[zACsilo_SUM_1B, zACvisSearch_SUM_1B, zACthumb_SUM_1B] = formTables_RF_1A3('1b-final-Parsed-AC.silo-sum.xlsx', '1b-final-Parsed-AC.visualsearch-sum.xlsx', '1b-final-Parsed-AC.thumbprint-sum.xlsx', true);
delMe = [101 ;110 ;115 ;119 ;208 ;230 ;242 ;251 ;267 ;299 ;302 ;319 ;331 ;332 ;343 ;421 ;426 ;451 ;74 ;80]; % globally excluded from 1B
zHarvMRI_1B.Training = repmat({'Unknown'}, height(zHarvMRI_1B), 1);
zHarvMRI_1B.Status = repmat({'Unknown'}, height(zHarvMRI_1B), 1);
zHarvMRI_1B.GloballyExcluded = zeros(height(zHarvMRI_1B),1);
subjs = unique(zHarvMRI_1B.Subject);
for i = 1:length(subjs)
    subj = subjs(i);
    if (ismember(subj, unique(zRFSum_1B.Subject)))
        zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).Training = {'RF'};
        zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).Status = ...
            zRFSum_1B(zRFSum_1B.Subject == subj,:).Status(1);
    elseif (ismember(subj, unique(zACsilo_SUM_1B.Subject)))
        zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).Training = {'AC'};
        zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).Status = ...
            zACsilo_SUM_1B(zACsilo_SUM_1B.Subject == subj,:).Status(1);    
    else
        zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).Training = {'PresumablyNone'};
        zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).Status = ...
            zEFdata_1B(zEFdata_1B.Subject == subj,:).Status(1);        
    end
    if (ismember(subj, delMe))
        zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).GloballyExcluded = 1;
    end
end
% let's see how many subjects we actually have to work with...
delMe = zHarvMRI_1B(zHarvMRI_1B.GloballyExcluded == 0, :); % assume no global exclusions
delMe2 = delMe(strcmpi(delMe.Status,'Finished'),:);
delMe2 = [delMe2; delMe(strcmpi(delMe.Status,'Finished*'),:)]; % Finished or Finished* is ok...
delMe3 = delMe2(strcmpi(delMe2.Training,'rf'),:);
height(delMe3) % 55
delMe4 = delMe2(strcmpi(delMe2.Training,'ac'),:);
height(delMe4) % 20

% now add any EF stuff that might be useful, including:
    % TS_RTSC_Pre	TS_RTSC_Post TS_Exclude_Pre	TS_Exclude_Pre_Rationale	TS_Exclude_Post	TS_Exclude_Post_Rationale
    % SST_SSRT_Pre	SST_SSRT_Post	SST_Exclude_Pre	SST_Exclude_Pre_Rationale	SST_Exclude_Post	SST_Exclude_Post_Rationale
    % RST_ArrowsAcc_Pre	RST_ArrowsAcc_Post RST_Exclude_Pre	RST_Exclude_Pre_Rationale	RST_Exclude_Post	RST_Exclude_Post_Rationale
zHarvMRI_1B.TS_RTSC_Pre = repmat(NaN, height(zHarvMRI_1B), 1);
zHarvMRI_1B.TS_RTSC_Post = repmat(NaN, height(zHarvMRI_1B), 1);
zHarvMRI_1B.TS_Exclude_Pre = zeros(height(zHarvMRI_1B),1);
zHarvMRI_1B.TS_Exclude_Pre_Rationale = repmat({'none'}, height(zHarvMRI_1B), 1);
zHarvMRI_1B.TS_Exclude_Post = zeros(height(zHarvMRI_1B),1);
zHarvMRI_1B.TS_Exclude_Post_Rationale = repmat({'none'}, height(zHarvMRI_1B), 1);
zHarvMRI_1B.SST_SSRT_Pre = repmat(NaN, height(zHarvMRI_1B), 1);
zHarvMRI_1B.SST_SSRT_Post = repmat(NaN, height(zHarvMRI_1B), 1);
zHarvMRI_1B.SST_Exclude_Pre = zeros(height(zHarvMRI_1B),1);
zHarvMRI_1B.SST_Exclude_Pre_Rationale = repmat({'none'}, height(zHarvMRI_1B), 1);
zHarvMRI_1B.SST_Exclude_Post = zeros(height(zHarvMRI_1B),1);
zHarvMRI_1B.SST_Exclude_Post_Rationale = repmat({'none'}, height(zHarvMRI_1B), 1);
zHarvMRI_1B.RST_ArrowsAcc_Pre = repmat(NaN, height(zHarvMRI_1B), 1);
zHarvMRI_1B.RST_ArrowsAcc_Post = repmat(NaN, height(zHarvMRI_1B), 1);
zHarvMRI_1B.RST_Exclude_Pre = zeros(height(zHarvMRI_1B),1);
zHarvMRI_1B.RST_Exclude_Pre_Rationale = repmat({'none'}, height(zHarvMRI_1B), 1);
zHarvMRI_1B.RST_Exclude_Post = zeros(height(zHarvMRI_1B),1);
zHarvMRI_1B.RST_Exclude_Post_Rationale = repmat({'none'}, height(zHarvMRI_1B), 1);
for i = 1:length(subjs)
    subj = subjs(i);
    EFrow = zEFdata_1B(zEFdata_1B.Subject == subj, :);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).TS_RTSC_Pre = EFrow.TS_RTSC_Pre(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).TS_RTSC_Post = EFrow.TS_RTSC_Post(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).TS_Exclude_Pre = EFrow.TS_Exclude_Pre(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).TS_Exclude_Pre_Rationale = EFrow.TS_Exclude_Pre_Rationale(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).TS_Exclude_Post = EFrow.TS_Exclude_Post(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).TS_Exclude_Post_Rationale = EFrow.TS_Exclude_Post_Rationale(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).SST_SSRT_Pre = EFrow.SST_SSRT_Pre(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).SST_SSRT_Post = EFrow.SST_SSRT_Post(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).SST_Exclude_Pre = EFrow.SST_Exclude_Pre(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).SST_Exclude_Pre_Rationale = EFrow.SST_Exclude_Pre_Rationale(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).SST_Exclude_Post = EFrow.SST_Exclude_Post(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).SST_Exclude_Post_Rationale = EFrow.SST_Exclude_Post_Rationale(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).RST_ArrowsAcc_Pre = EFrow.RST_ArrowsAcc_Pre(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).RST_ArrowsAcc_Post = EFrow.RST_ArrowsAcc_Post(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).RST_Exclude_Pre = EFrow.RST_Exclude_Pre(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).RST_Exclude_Pre_Rationale = EFrow.RST_Exclude_Pre_Rationale(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).RST_Exclude_Post = EFrow.RST_Exclude_Post(1);
    zHarvMRI_1B(zHarvMRI_1B.Subject == subj,:).RST_Exclude_Post_Rationale = EFrow.RST_Exclude_Post_Rationale(1);
end
% and how many do we have now, of each EF?
delMe = zHarvMRI_1B(zHarvMRI_1B.GloballyExcluded == 0, :); % assume no global exclusions
delMe2 = delMe(strcmpi(delMe.Status,'Finished'),:);
delMe2 = [delMe2; delMe(strcmpi(delMe.Status,'Finished*'),:)]; % Finished or Finished* is ok...
delMe3 = delMe2(delMe2.TS_Exclude_Pre == 0,:);
delMe4 = delMe3(delMe3.TS_Exclude_Post == 0,:);
height(delMe4) % 54
delMe3 = delMe2(delMe2.SST_Exclude_Pre == 0,:);
delMe4 = delMe3(delMe3.SST_Exclude_Post == 0,:);
height(delMe4) % 53
delMe3 = delMe2(delMe2.RST_Exclude_Pre == 0,:);
delMe4 = delMe3(delMe3.RST_Exclude_Post == 0,:);
height(delMe4) % 59
writetable(zHarvMRI_1B, getFileNameForThisOS('1b-final-harvard_MRI_subjs_EFs.csv', 'IntResults'));







% run GLM using feature difficulty (along with Ability, RT, and cluster difficulty)
load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
for trialDataNum = 1:13 % there are 13 sets of 50-subject trials data
    % first, add the feature data we care about to the per-trial data
    trialData = get50subjsTrialData_1B(trialDataNum);

    % already has it trialData.Cluster = zeros(height(trialData),1);
    % already has it trialData.ScenarioCode = zeros(height(trialData),1);
    trialData.Colors = zeros(height(trialData),1);
    trialData.Numbers = zeros(height(trialData),1);
    trialData.Letters = zeros(height(trialData),1);
    trialData.Words = zeros(height(trialData),1);
    trialData.Pictures = zeros(height(trialData),1);
    trialData.Spatial = zeros(height(trialData),1);
    trialData.Shape = zeros(height(trialData),1);
    trialData.ExactMatch = zeros(height(trialData),1);
    trialData.Peripheral = zeros(height(trialData),1);

    for i = 1:height(featMapWithNeg1s) % go through each shift
        if (mod(i,20) == 0)
            fprintf('Trial Dataset %d; Shift number %d.\n', trialDataNum, i); % staying alive feedback
        end
        shift = featMapWithNeg1s(i,:).Shift_name;
        if (featMapWithNeg1s(i,:).Colors == 1)
            trialData(strcmpi(trialData.Shift,shift),:).Colors = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
        if (featMapWithNeg1s(i,:).Numbers == 1)
            trialData(strcmpi(trialData.Shift,shift),:).Numbers = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
        if (featMapWithNeg1s(i,:).Letters == 1)
            trialData(strcmpi(trialData.Shift,shift),:).Letters = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
        if (featMapWithNeg1s(i,:).Words == 1)
            trialData(strcmpi(trialData.Shift,shift),:).Words = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
        if (featMapWithNeg1s(i,:).Pictures == 1)
            trialData(strcmpi(trialData.Shift,shift),:).Pictures = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
        if (featMapWithNeg1s(i,:).Spatial == 1)
            trialData(strcmpi(trialData.Shift,shift),:).Spatial = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
        if (featMapWithNeg1s(i,:).Shape == 1)
            trialData(strcmpi(trialData.Shift,shift),:).Shape = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
        if (featMapWithNeg1s(i,:).ExactMatch == 1)
            trialData(strcmpi(trialData.Shift,shift),:).ExactMatch = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
        if (featMapWithNeg1s(i,:).Peripheral == 1)
            trialData(strcmpi(trialData.Shift,shift),:).Peripheral = ...
                ones(height(trialData(strcmpi(trialData.Shift,shift),:)),1);
        end
    end

    % also have to insert a ClusterNum, so we can put it all in one matrix 
    trialData.ClusterNum = zeros(height(trialData),1);
    trialData(strcmpi(trialData.Cluster,'U'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'U'),:)),1) + 0);
    trialData(strcmpi(trialData.Cluster,'S'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'S'),:)),1) + 1);
    trialData(strcmpi(trialData.Cluster,'I'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'I'),:)),1) + 2);
    trialData(strcmpi(trialData.Cluster,'U/Logic'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'U/Logic'),:)),1) + 4);
    trialData(strcmpi(trialData.Cluster,'U/Logic(xOR)'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'U/Logic(xOR)'),:)),1) + 4); % how do we still have these hanging around???
    trialData(strcmpi(trialData.Cluster,'S/Logic'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'S/Logic'),:)),1) + 5);
    trialData(strcmpi(trialData.Cluster,'I/Logic'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'I/Logic'),:)),1) + 6);
    trialData(strcmpi(trialData.Cluster,'U/I'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'U/I'),:)),1) + 7);
    trialData(strcmpi(trialData.Cluster,'S/I'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'S/I'),:)),1) + 8);
    trialData(strcmpi(trialData.Cluster,'U/S'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'U/S'),:)),1) + 9);
    trialData(strcmpi(trialData.Cluster,'U/I/Logic'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'U/I/Logic'),:)),1) + 10);
    trialData(strcmpi(trialData.Cluster,'S/I/Logic'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'S/I/Logic'),:)),1) + 11);
    trialData(strcmpi(trialData.Cluster,'U/S/Logic'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'U/S/Logic'),:)),1) + 12);
    % Make all the Lv4a the same (13)
    trialData(strcmpi(trialData.Cluster,'L4aV1'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'L4aV1'),:)),1) + 13);
    trialData(strcmpi(trialData.Cluster,'L4aV2'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'L4aV2'),:)),1) + 13);
    % Make all the Lv4b the same (14)
    trialData(strcmpi(trialData.Cluster,'L4bV1'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'L4bV1'),:)),1) + 14);
    trialData(strcmpi(trialData.Cluster,'L4bV2'),:).ClusterNum = ...
        (zeros(height(trialData(strcmpi(trialData.Cluster,'L4bV2'),:)),1) + 14);

    delMe = trialData(trialData.StimShowTime < 5,:); % ignore really long shifts; they'll be weird data
    delMe2 = delMe.Correct;
    delMe3 = [delMe.Subject delMe.ClusterNum delMe.ScenarioCode delMe.Colors delMe.Numbers delMe.Letters delMe.Words delMe.Pictures delMe.Spatial delMe.Shape delMe.ExactMatch delMe.Peripheral delMe.TotalTrialCount delMe.RespTime];
    % the old glm, for reference   delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
    RF_FeatModel_1B = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Clust + Scenario + Colors + Numbers + Letters + Words + Pictures + Spatial + Shape + ExactMatch + Peripheral + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,4,5,6,7,8,9,10,11,12],'VarNames',{'Subj','Clust','Scenario','Colors','Numbers','Letters','Words','Pictures','Spatial','Shape','ExactMatch','Peripheral','TrialCount','RT','Correct'})
    printGLMcoeffs(RF_FeatModel_1B, sprintf('featGLMcoeffs_%d.csv',trialDataNum));
end

clear trialDataNum trialData i shift featMapWithNeg1s RF_FeatModel_1B


% now let's try to do the same thing with all subjects at once
%    (might crash the computer? save everything and find out)
load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
for trialDataNum = 1:13 % there are 13 sets of 50-subject trials data
    % first, we care about a very limited number of columns; remove all others 
    delMe = get50subjsTrialData_1B(trialDataNum);
    fprintf('Incorporating subject group %d.\n', trialDataNum); % staying alive feedback
    tmp = delMe(:,'Subject');
    tmp.Shift = delMe.Shift; % need this to get the features
    tmp.Cluster = delMe.Cluster; % need this to calculate the ClusterNum
    tmp.ScenarioCode = delMe.ScenarioCode;
    tmp.TotalTrialCount = delMe.TotalTrialCount;
    tmp.RespTime = delMe.RespTime;
    tmp.StimShowTime = delMe.StimShowTime; % need this to ignore weird long shifts
    tmp.Correct = delMe.Correct;
    
    if (trialDataNum == 1)
        trialData = tmp;
    else
        trialData = [trialData; tmp];
    end
end
clear delMe tmp % to free every last scrap of available memory
% now just run everything from line 3901-3998
%       NOTE: the above still crashes your mac. Run it on SWING instead.




% insert the 'RfTNumber' in the SUM file into the per-trial data
%   NOTE: this has to be done on SWING; it takes more than a day
load('/Users/Shared/SHARP/ParsedData/RFAll_1B_2015_10_29.mat') % NOTE: takes an hour!

zRF_1B = [];
for trialDataNum = 1:13 % there are 13 sets of 50-subject trials data
    % first, we care about a very limited number of columns; remove all others 
    delMe2 = get50subjsTrialData_1B(trialDataNum);
%delMe2 = zRF_1B_0_49;

    delMe2.RfTNumber = zeros(height(delMe2),1);
    delMe2.EegTNumber = zeros(height(delMe2),1);
    subjs = unique(delMe2.Subject);
    for i = 1:length(subjs)
        subj = subjs(i);
        fprintf('Inserting RfTdays for subject %d.\n', subj); % staying alive feedback
        subjShifts = zRFSum_1B(zRFSum_1B.Subject == subj,:);
        shifts = unique(subjShifts.ShiftNum);
        RfTday = 0; % reset just to make sure we don't get any leftover from last cycle
        EegTday = 0; % reset just to make sure we don't get any leftover from last cycle
        for j = 1:length(shifts)
            shift = shifts(j);
            RfTday = subjShifts(subjShifts.ShiftNum == shift,:).RfTNumber; % should just be a single number...?
            EegTday = subjShifts(subjShifts.ShiftNum == shift,:).EegTNumber;
            delMe2( (delMe2.Subject == subj) & (delMe2.ShiftNum == shift), :).RfTNumber = repmat(RfTday,height(delMe2( (delMe2.Subject == subj) & (delMe2.ShiftNum == shift), :)),1);
            delMe2( (delMe2.Subject == subj) & (delMe2.ShiftNum == shift), :).EegTNumber = repmat(EegTday,height(delMe2( (delMe2.Subject == subj) & (delMe2.ShiftNum == shift), :)),1);
        end
    end

    zRF_1B = [zRF_1B; delMe2];
end
clear trialDataNum delMe2 subjs i subj subjShifts shifts RfTday EegTday j shift
% might need this extra flag
save(getFileNameForThisOS('RFAll_1B_2015_10_29_WITH-RFtrainingDay.mat', 'ParsedData'), 'zRF_1B','-v7.3');

% save per-day files so we can have a quicker way to deal with them
zRF_1B_T1 = zRF_1B(zRF_1B.RfTNumber == 1, :);
save(getFileNameForThisOS('RFAll_1B-T1-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T1');
clear zRF_1B_T1

zRF_1B_T2 = zRF_1B(zRF_1B.RfTNumber == 2, :);
save(getFileNameForThisOS('RFAll_1B-T2-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T2');
clear zRF_1B_T2

zRF_1B_T3 = zRF_1B(zRF_1B.RfTNumber == 3, :);
save(getFileNameForThisOS('RFAll_1B-T3-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T3');
clear zRF_1B_T3

zRF_1B_T4 = zRF_1B(zRF_1B.RfTNumber == 4, :);
save(getFileNameForThisOS('RFAll_1B-T4-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T4');
clear zRF_1B_T4

zRF_1B_T5 = zRF_1B(zRF_1B.RfTNumber == 5, :);
save(getFileNameForThisOS('RFAll_1B-T5-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T5');
clear zRF_1B_T5

zRF_1B_T6 = zRF_1B(zRF_1B.RfTNumber == 6, :);
save(getFileNameForThisOS('RFAll_1B-T6-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T6');
clear zRF_1B_T6

zRF_1B_T7 = zRF_1B(zRF_1B.RfTNumber == 7, :);
save(getFileNameForThisOS('RFAll_1B-T7-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T7');
clear zRF_1B_T7

zRF_1B_T8 = zRF_1B(zRF_1B.RfTNumber == 8, :);
save(getFileNameForThisOS('RFAll_1B-T8-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T8');
clear zRF_1B_T8

zRF_1B_T9 = zRF_1B(zRF_1B.RfTNumber == 9, :);
save(getFileNameForThisOS('RFAll_1B-T9-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T9');
clear zRF_1B_T9

zRF_1B_T10 = zRF_1B(zRF_1B.RfTNumber == 10, :);
save(getFileNameForThisOS('RFAll_1B-T10-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T10');
clear zRF_1B_T10

zRF_1B_T11 = zRF_1B(zRF_1B.RfTNumber == 11, :);
save(getFileNameForThisOS('RFAll_1B-T11-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T11');
clear zRF_1B_T11

zRF_1B_T12 = zRF_1B(zRF_1B.RfTNumber == 12, :);
save(getFileNameForThisOS('RFAll_1B-T12-2015_10_29.mat', 'ParsedData'), 'zRF_1B_T12');
clear zRF_1B_T12

% see exactly how many people have a T12
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-T12-2015_10_29.mat')
length(unique(zRF_1B_T12.Subject)) % 1
clear zRF_1B_T12




% Now insert the 'RfTNumber' into 2B data
%   NOTE: we already have a 'Visit' which is basically the same, but not numeric 
% first, laboriously load the 500k-rows parsed data, then:
delMe2 = zRFAll_2B(strcmpi(zRFAll_2B.Status,'finished'),:); % we only care about finished people at this point; might as well make it quicker
delMe2 = [delMe2; zRFAll_2B(strcmpi(zRFAll_2B.Status,'finished*'),:)]; % don't know if these exist, but...
delMe2.RfTNumber = zeros(height(delMe2),1);
for i=1:height(delMe2)
    delMe2.RfTNumber(i) = str2num(delMe2.Visit{i}(9:10)); % Visit is always a string like 'training01' or 'training11', so the last two are the RfTNumber
end





% find a clear/notable difference in performance based on features, for site visit 
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'u'),:);
load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
delMe.Upd_ColorParts = zeros(height(delMe),1);
delMe.Upd_ShapeParts = zeros(height(delMe),1);
delMe.Upd_Symbols = zeros(height(delMe),1);
delMe.Upd_NumMatch = zeros(height(delMe),1);
delMe.Upd_Pics_Snake = zeros(height(delMe),1);
delMe.Upd_Pics_Animal = zeros(height(delMe),1);
for i = 1:height(delMe)
    shift = delMe.Shift(i);
    if (featMapWithNeg1s(strcmpi(featMapWithNeg1s.Shift_name,shift),:).Upd_ColorParts(1) == 1)
        delMe.Upd_ColorParts(i) = 1;
    end
    if (featMapWithNeg1s(strcmpi(featMapWithNeg1s.Shift_name,shift),:).Upd_ShapeParts(1) == 1)
        delMe.Upd_ShapeParts(i) = 1;
    end
    if (featMapWithNeg1s(strcmpi(featMapWithNeg1s.Shift_name,shift),:).Upd_Symbols(1) == 1)
        delMe.Upd_Symbols(i) = 1;
    end
    if (featMapWithNeg1s(strcmpi(featMapWithNeg1s.Shift_name,shift),:).Upd_NumMatch(1) == 1)
        delMe.Upd_NumMatch(i) = 1;
    end
    if (featMapWithNeg1s(strcmpi(featMapWithNeg1s.Shift_name,shift),:).Upd_Pics_Snake(1) == 1)
        delMe.Upd_Pics_Snake(i) = 1;
    end
    if (featMapWithNeg1s(strcmpi(featMapWithNeg1s.Shift_name,shift),:).Upd_Pics_Animal(1) == 1)
        delMe.Upd_Pics_Animal(i) = 1;
    end
end
delMe2 = delMe(delMe.Upd_ColorParts == 1,:);
delMe3 = delMe(delMe.Upd_ShapeParts == 1,:);
delMe4 = delMe(delMe.Upd_Symbols == 1,:);
delMe5 = delMe(delMe.Upd_NumMatch == 1,:);
delMe6 = delMe(delMe.Upd_Pics_Snake == 1,:);
delMe7 = delMe(delMe.Upd_Pics_Animal == 1,:);
[~,pVal] = ttest2(delMe2.Accuracy, delMe3.Accuracy)
[~,pVal] = ttest2(delMe2.Accuracy, delMe4.Accuracy)
[~,pVal] = ttest2(delMe2.Accuracy, delMe5.Accuracy)
[~,pVal] = ttest2(delMe2.Accuracy, delMe6.Accuracy)
[~,pVal] = ttest2(delMe2.Accuracy, delMe7.Accuracy)

[counts, bins] = hist(delMe2.Accuracy);
[counts2, bins2] = hist(delMe3.Accuracy);
plot(bins,counts)
hold on
plot(bins2,counts2)
legend({'ColorParts','ShapeParts'})
xlabel('Accuracy (correct/possible)')
ylabel(sprintf('Number of shifts observed\nwith the given accuracy'))
set(findall(gca,'type','text'),'FontSize',24)
set(findall(gca,'type','axes'),'FontSize',24)
hold off

figure
[counts3, bins3] = hist(delMe5.Accuracy);
plot(bins,counts)
hold on
plot(bins3,counts3)
legend({'ColorParts','Numbers'})
xlabel('Accuracy (correct/possible)')
ylabel(sprintf('Number of shifts observed\nwith the given accuracy'))
set(findall(gca,'type','text'),'FontSize',24)
set(findall(gca,'type','axes'),'FontSize',24)
hold off






% first, recreate zRF_1B in the fastest way possible (ugh)
load ../ParsedData/RFAll_1B-0_49-2015_10_29.mat
load ../ParsedData/RFAll_1B-50_99-2015_10_29.mat
load ../ParsedData/RFAll_1B-100_149-2015_10_29.mat
load ../ParsedData/RFAll_1B-150_199-2015_10_29.mat
load ../ParsedData/RFAll_1B-200_249-2015_10_29.mat
load ../ParsedData/RFAll_1B-250_299-2015_10_29.mat
load ../ParsedData/RFAll_1B-300_349-2015_10_29.mat
load ../ParsedData/RFAll_1B-350_399-2015_10_29.mat
load ../ParsedData/RFAll_1B-400_449-2015_10_29.mat
load ../ParsedData/RFAll_1B-450_499-2015_10_29.mat
load ../ParsedData/RFAll_1B-500_549-2015_10_29.mat
load ../ParsedData/RFAll_1B-550_599-2015_10_29.mat
load ../ParsedData/RFAll_1B-600_649-2015_10_29.mat
load ../ParsedData/RFAll_1B-650_699-2015_10_29.mat
load ../ParsedData/RFAll_1B-700_749-2015_10_29.mat
load ../ParsedData/RFAll_1B-750_799-2015_10_29.mat
zRF_1B = [zRF_1B_0_49; zRF_1B_50_99];
zRF_1B = [zRF_1B; zRF_1B_100_149]; % second half of this one doesn't really exist
zRF_1B = [zRF_1B; zRF_1B_200_249; zRF_1B_250_299];
zRF_1B = [zRF_1B; zRF_1B_300_349; zRF_1B_350_399];
zRF_1B = [zRF_1B; zRF_1B_400_449; zRF_1B_450_499];
zRF_1B = [zRF_1B; zRF_1B_500_549]; % second half of this one doesn't really exist
zRF_1B = [zRF_1B; zRF_1B_600_649; zRF_1B_650_699];
zRF_1B = [zRF_1B; zRF_1B_700_749]; % second half of this one doesn't really exist
clear zRF_1B_0_49 zRF_1B_50_99 % clear these out for speed
clear zRF_1B_100_149 zRF_1B_150_199
clear zRF_1B_200_249 zRF_1B_250_299
clear zRF_1B_300_349 zRF_1B_350_399
clear zRF_1B_400_449 zRF_1B_450_499
clear zRF_1B_500_549 zRF_1B_550_599
clear zRF_1B_600_649 zRF_1B_650_699
clear zRF_1B_700_749 zRF_1B_750_799
% now add a column that will indicate the subj+day factor for GLM
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B);
clear zRF_1B % for speed
delMe.SubjDayCode = zeros(height(delMe),1);
delMe.SubjDayCode = (delMe.Subject * 1000) + delMe.RfTNumber;
% now run the GLM (I assume this will take a LOOOOOOOONG time to run)
    glmData = delMe(delMe.StimShowTime < 5,:); % remove "didn't understand instructions" outliers
    glmY = glmData.Correct;
    glmX = [glmData.SubjDayCode glmData.NbackDifficulty glmData.SwitchFlag glmData.InhibitDifficulty glmData.numOfEFsInThisTrial glmData.TotalTrialCount glmData.RespTime];
clear delMe glmData % for speed
% removing the intercept at Misha's suggestion...     RF_Abilitymodel_1B = fitglm(glmX,glmY,'logit(Correct) ~ 1 + SubjDay + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'SubjDay','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'});
    RF_Abilitymodel_1B_subjDay = fitglm(glmX,glmY,'logit(Correct) ~ SubjDay + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'SubjDay','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'},'Intercept','false');

% now we have to extract the SubjDay coeffs and get them into a matrix
RF_Abilitymodel_1B_subjDay % just to see (make sure the "sanity check" coeffs make sense)




% go through each day and get a RF_Abilitymodel_1B for each, so we can investigate the variability of the coeffs and factors 
allXvals = []; % list of variable data, for variance graphs
for trialDataDay = 1:11
    fprintf('Doing GLM for day %d.\n', trialDataDay); % staying alive feedback
    trialData = getPerDayTrialData_1B(trialDataDay);
    trialsIncluded = trialData(strcmpi(trialData.Status,'Finished'),:);
    trialsIncluded = [trialsIncluded; trialData(strcmpi(trialData.Status,'Finished*'),:)];
    clear trialData % for speed (dunno if it makes much difference, should test)
    glmData = trialsIncluded(trialsIncluded.StimShowTime < 5,:); % remove "didn't understand instructions" outliers
    glmY = glmData.Correct;
    glmX = [glmData.Subject glmData.NbackDifficulty glmData.SwitchFlag glmData.InhibitDifficulty glmData.numOfEFsInThisTrial glmData.TotalTrialCount glmData.RespTime];
    delMe = fitglm(glmX,glmY,'logit(Correct) ~ Subj + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'},'Intercept','false');
    eval([sprintf('RF_Abilitymodel_1B_%d',trialDataDay),'= delMe;'])
    xSize = size(glmX);
    dayNumberCol = zeros(xSize(1),1)+trialDataDay;
    if (trialDataDay == 1)
        allXvals = [dayNumberCol glmX];
    else
        addToAllX = [dayNumberCol glmX];
        allXvals = [allXvals; addToAllX];
    end
end

InhCoeffVariance = [];
TrialsCoeffVariance = [];
RTcoeffVariance = [];
UfactorVariance = [];
SwfactorVariance = [];
EFfactorVariance = [];
avgFactorEstimatePerDay = table(0,0,0,0,'VariableNames',{'TrainingDay','Ufactor','SWfactor','EFfactor'});
for i = 1:11 % days
    % first, get the variance for the continuous variables
    eval(['curDayModel = ',sprintf('RF_Abilitymodel_1B_%d',i),';'])
    varsForThisDay = allXvals(allXvals(:,1) == i, :);
    InhVar = var(varsForThisDay(:,5));
    InhCoeff = curDayModel.Coefficients.Estimate('InhDiff');
%    eval(['InhCoeff = ',sprintf('RF_Abilitymodel_1B_%d.Coefficients.Estimate(',trialDataDay),'''InhDiff'');'])
    %testing RF_Abilitymodel_1B_1.Coefficients.Estimate('InhDiff')
    InhCoeffVariance(i,1) = (InhCoeff*InhCoeff) * InhVar; % variance = coeff^2 * variance of the variable

    TrialsVar = var(varsForThisDay(:,7));
    TrialsCoeff = curDayModel.Coefficients.Estimate('TrialCount');
%    eval(['TrialsCoeff = ',sprintf('RF_Abilitymodel_1B_%d.Coefficients.Estimate(',trialDataDay),'''TrialCount'');'])
    TrialsCoeffVariance(i,1) = (TrialsCoeff*TrialsCoeff) * TrialsVar; % variance = coeff^2 * variance of the variable
    
    RTvar = var(varsForThisDay(:,8));
    RTcoeff = curDayModel.Coefficients.Estimate('RT');
%    eval(['RTcoeff = ',sprintf('RF_Abilitymodel_1B_%d.Coefficients.Estimate(',trialDataDay),'''RT'');'])
    RTcoeffVariance(i,1) = (RTcoeff*RTcoeff) * RTvar; % variance = coeff^2 * variance of the variable
    
    % now get the variance for the factors... = sum[ (factor_n ? estFactor_n)^2 * proportion_n ]
    %       estFactor_n = sum [factor_n * proportion_n]
    Ufactors = []; 
    Swfactors = []; 
    EFfactors = []; 
    for m = 1:length(curDayModel.CoefficientNames)
        curName = curDayModel.CoefficientNames{m};
        if (~isempty(strfind(curName,'Ndiff_'))) % this row refers to an N value factor
            Ufactors(end+1,1) = str2double(curName(strfind(curName,'_')+1:end)); % store the N value
            Ufactors(end,2) = curDayModel.Coefficients.Estimate(m); % store the factor
%            abilityPerDay(abilityPerDay.Subj == subjNum, strcat('T', sprintf('%d',trialDataDay))) = {coeff};
        end
        if (~isempty(strfind(curName,'SwRep_')))
            Swfactors(end+1,1) = str2double(curName(strfind(curName,'_')+1:end));
            Swfactors(end,2) = curDayModel.Coefficients.Estimate(m);
        end
        if (~isempty(strfind(curName,'EFcount_')))
            EFfactors(end+1,1) = str2double(curName(strfind(curName,'_')+1:end));
            EFfactors(end,2) = curDayModel.Coefficients.Estimate(m);
        end
    end
    facMatSize = size(Ufactors);
    Ufactors(:,3) = zeros(facMatSize(1),1)-999.99; % proportion_n
    Ufactors(:,4) = zeros(facMatSize(1),1)-999.99; % estFactor_n (=sum of all (factor * proportion))
    Ufactors(:,5) = zeros(facMatSize(1),1)-999.99; % ((factor_n ? estFactor_n)^2 * proportion_n)
    flagVals = unique(allXvals(:,3)); % in this case, N values
    for j = 1:length(flagVals)
        flagVal = flagVals(j);
        if (~ismember(flagVal,Ufactors(:,1))) % no factor for this - must be the reference value
            Ufactors(end+1,1) = flagVal; % store the N value
            Ufactors(end,2) = 0; % with no intercept, factor for the reference is zero
        end
        proportion = length(varsForThisDay(varsForThisDay(:,3)==flagVal,1)) / ...
            length(varsForThisDay(:,1)); % times we saw this value / all trials
        Ufactors(Ufactors(:,1)==flagVal,3) = proportion;
        Ufactors(Ufactors(:,1)==flagVal,4) = proportion * Ufactors(Ufactors(:,1)==flagVal,2); % sum of this is factorEstimate
    end
    Uestimate = sum(Ufactors(:,4));
    for k = 1:length(Ufactors(:,1))
        Ufactors(k,5) = (Ufactors(k,2) - Uestimate)^2 .* Ufactors(k,3); % ((factor_n ? estFactor_n)^2 * proportion_n)
    end
    UfactorVariance(i,1) = sum(Ufactors(:,5)); % sum all the individual contributions for the day

    facMatSize = size(Swfactors); % reusing facMatSize
    Swfactors(:,3) = zeros(facMatSize(1),1)-999.99; % proportion_n
    Swfactors(:,4) = zeros(facMatSize(1),1)-999.99; % estFactor_n (=factor * proportion)
    Swfactors(:,5) = zeros(facMatSize(1),1)-999.99; % ((factor_n ? estFactor_n)^2 * proportion_n)
    flagVals = unique(allXvals(:,4)); % in this case, switch flags
    for j = 1:length(flagVals)
        flagVal = flagVals(j);
        if (~ismember(flagVal,Swfactors(:,1))) % no factor for this - must be the reference value
            Swfactors(end+1,1) = flagVal; 
            Swfactors(end,2) = 0; % with no intercept, factor for the reference is zero
        end
        proportion = length(varsForThisDay(varsForThisDay(:,4)==flagVal,1)) / ...
            length(varsForThisDay(:,1)); % times we saw this value / all trials
        Swfactors(Swfactors(:,1)==flagVal,3) = proportion;
        Swfactors(Swfactors(:,1)==flagVal,4) = proportion * Swfactors(Swfactors(:,1)==flagVal,2); % sum of this is factorEstimate
    end
    SwEstimate = sum(Swfactors(:,4));
    for k = 1:length(Swfactors(:,1))
        Swfactors(k,5) = (Swfactors(k,2) - SwEstimate)^2 .* Swfactors(k,3); % ((factor_n ? estFactor_n)^2 * proportion_n)
    end
    SwfactorVariance(i,1) = sum(Swfactors(:,5)); % sum all the individual contributions for the day

    facMatSize = size(EFfactors); % reusing facMatSize
    EFfactors(:,3) = zeros(facMatSize(1),1)-999.99; % proportion_n
    EFfactors(:,4) = zeros(facMatSize(1),1)-999.99; % estFactor_n (=factor * proportion)
    EFfactors(:,5) = zeros(facMatSize(1),1)-999.99; % ((factor_n ? estFactor_n)^2 * proportion_n)
    flagVals = unique(allXvals(:,6)); % in this case, switch flags
    for j = 1:length(flagVals)
        flagVal = flagVals(j);
        if (~ismember(flagVal,EFfactors(:,1))) % no factor for this - must be the reference value
            EFfactors(end+1,1) = flagVal; 
            EFfactors(end,2) = 0; % with no intercept, factor for the reference is zero
        end
        proportion = length(varsForThisDay(varsForThisDay(:,6)==flagVal,1)) / ...
            length(varsForThisDay(:,1)); % times we saw this value / all trials
        EFfactors(EFfactors(:,1)==flagVal,3) = proportion;
        EFfactors(EFfactors(:,1)==flagVal,4) = proportion * EFfactors(EFfactors(:,1)==flagVal,2); % sum of this is factorEstimate
    end
    EFestimate = sum(EFfactors(:,4));
    for k = 1:length(EFfactors(:,1))
        EFfactors(k,5) = (EFfactors(k,2) - EFestimate)^2 .* EFfactors(k,3); % ((factor_n ? estFactor_n)^2 * proportion_n)
    end
    EFfactorVariance(i,1) = sum(EFfactors(:,5)); % sum all the individual contributions for the day
    avgFactorEstimatePerDay(i,:) = table(i,Uestimate,SwEstimate,EFestimate,...
        'VariableNames',{'TrainingDay','Ufactor','SWfactor','EFfactor'});
end
perDayGLM_variability = table(InhCoeffVariance, TrialsCoeffVariance, ...
    RTcoeffVariance, UfactorVariance, SwfactorVariance, ...
    EFfactorVariance,'VariableNames',{'InhCoeff','TrialsCoeff','RTCoeff',...
    'Ufactor','SWfactor','EFfactor'});
avgFactorEstimatePerDay.total = avgFactorEstimatePerDay.Ufactor + ...
    avgFactorEstimatePerDay.SWfactor + avgFactorEstimatePerDay.EFfactor;

clear trialDataDay trialsIncluded glmData glmY glmX xSize dayNumberCol addToAllX
clear i m j curDayModel varsForThisDay InhCoeff InhVar TrialsVar curName
clear TrialsCoeff RTvar RTcoeff Ufactors Swfactors EFfactors facMatSize
clear proportion flagVal flagVals Uestimate SwEstimate EFestimate
clear InhCoeffVariance TrialsCoeffVariance RTcoeffVariance 
clear UfactorVariance SwfactorVariance EFfactorVariance
clear allXvals perDayGLM_variability % when we're done with these


% now add the average of the factors to each ability per day
load(getFileNameForThisOS('2017_7_26-abilityPerDay_1B.mat', 'IntResults')); % load abilityPerDay
abilityPerDayPlusFactors = abilityPerDay;
for i = 1:height(abilityPerDayPlusFactors)
    for j = 2:width(abilityPerDayPlusFactors) % first col is just the subject number
        if (~isnan(abilityPerDayPlusFactors{i,j})) % there's an ability value here
            abilityPerDayPlusFactors{i,j} = abilityPerDayPlusFactors{i,j} + ...
                avgFactorEstimatePerDay.total(j-1); % training day = j-1
        end
    end
end
figure
hold on
for i = 1:height(abilityPerDayPlusFactors)
    plot(1:12,abilityPerDayPlusFactors{i,2:13})
end
xlabel('Training Day')
ylabel('Average GLM-estimated daily Ability + estimated factor difficulties')
hold off

