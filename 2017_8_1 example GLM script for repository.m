% Example script for Raminder - explore behavioral data for BI repository
% Zephy, 8/1/17

% get a per-day 1B GLM Ability estimate for Jamie
abilityPerDay = table( -999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,...
    'VariableNames', {'Subj','T1','T2','T3','T4','T5','T6','T7','T8',...
    'T9','T10','T11','T12'} );

for trialDataDay = 1:12 % there are 12 training days in the 1B data (should be only 11, but 1 subject has a 12th...)
    fprintf('Performing GLM for Training day %d.\n', trialDataDay); % staying alive feedback
    trialData = getPerDayTrialData_1B(trialDataDay);
    trialsIncluded = excludeSubjects_RF_1B(true, true, false, trialData); % get just RF subjects who Finished
    clear trialData % for speed (dunno if it makes much difference, should test)
    subjs = unique(trialsIncluded.Subject);
    if (trialDataDay == 1) % prealloc the table, assuming we'll have the same number of subjects (or less) for all subsequent days
        abilityPerDay = repmat(abilityPerDay,length(subjs),1);
        abilityPerDay.Subj = subjs(1:end); 
    end
    glmData = trialsIncluded(trialsIncluded.StimShowTime < 5,:); % remove "didn't understand instructions" outliers
    glmY = glmData.Correct;
    glmX = [glmData.Subject glmData.NbackDifficulty glmData.SwitchFlag glmData.InhibitDifficulty glmData.numOfEFsInThisTrial glmData.TotalTrialCount glmData.RespTime];
% removing the intercept at Misha's suggestion...     RF_Abilitymodel_1B = fitglm(glmX,glmY,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'});
    RF_Abilitymodel_1B = fitglm(glmX,glmY,'logit(Correct) ~ Subj + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'},'Intercept','false');
% don't actually need the subject numbers this time...    glmSubjs = glmLabelsToNumbers(RF_Abilitymodel_1B.CoefficientNames(2:(end-11))); 

    % on different days, we have different subject numbers (and different N value numbers), so have to go through each 
    for i = 1:length(RF_Abilitymodel_1B.CoefficientNames)
        curName = RF_Abilitymodel_1B.CoefficientNames{i};
        if (~isempty(strfind(curName,'Subj_'))) % this row refers to a subject ability estimate
            subjNum = str2double(curName(strfind(curName,'_')+1:end));
            coeff = RF_Abilitymodel_1B.Coefficients.Estimate(i);
            abilityPerDay(abilityPerDay.Subj == subjNum, strcat('T', sprintf('%d',trialDataDay))) = {coeff};
        end
    end
    abilityPerDay(abilityPerDay.Subj == min(glmX(:,1)), strcat('T', sprintf('%d',trialDataDay))) = {0}; % reference subject
end
for i = 1:height(abilityPerDay) % now change the -999s to NaNs
    for j = 1:width(abilityPerDay)
        if (abilityPerDay{i,j} == -999)
            abilityPerDay{i,j} = NaN;
        end
    end
end
clear trialDataDay trialsIncluded subjs glmData glmY glmX 
% printGLMcoeffs(RF_Abilitymodel_1B, true); % if we want to view any given one, stop and print these out (e.g., for example email to Roi)
clear RF_Abilitymodel_1B i curName subjNum coeff

writetable(abilityPerDay, getFileNameForThisOS('2017_7_26-abilityPerDay_1B.csv', 'IntResults'));
save(getFileNameForThisOS('2017_7_26-abilityPerDay_1B.mat', 'IntResults'), 'abilityPerDay');
clear abilityPerDay




% now create a similar table that actually tells how many shifts they saw each "day" - since many are more than 20... 
shiftCountPerDay = table( -999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,...
    'VariableNames', {'Subj','T1','T2','T3','T4','T5','T6','T7','T8',...
    'T9','T10','T11','T12'} );
for trialDataDay = 1:12 % there are 12 training days in the 1B data (should be only 11, but 1 subject has a 12th...)
    fprintf('Counting shifts for Training day %d.\n', trialDataDay); % staying alive feedback
    trialData = getPerDayTrialData_1B(trialDataDay);
    trialsIncluded = excludeSubjects_RF_1B(true, true, false, trialData); % get just RF subjects who Finished
    clear trialData % for speed (dunno if it makes much difference, should test)
    subjs = unique(trialsIncluded.Subject);
    if (trialDataDay == 1) % prealloc the table
        shiftCountPerDay = repmat(shiftCountPerDay,length(subjs),1);
        shiftCountPerDay.Subj = subjs(1:end); % unnecessary subscript?
    end
    for i = 1:length(subjs)
        subjNum = subjs(i);
        subjTrials = trialsIncluded(trialsIncluded.Subject == subjNum,:);
        shiftCountPerDay(shiftCountPerDay.Subj == subjNum, strcat('T', sprintf('%d',trialDataDay))) = {length(unique(subjTrials.ShiftNum))};
    end
end
for i = 1:height(shiftCountPerDay) % now change the -999s to NaNs
    for j = 1:width(shiftCountPerDay)
        if (shiftCountPerDay{i,j} == -999)
            shiftCountPerDay{i,j} = NaN;
        end
    end
end
writetable(shiftCountPerDay, getFileNameForThisOS('2017_7_26-shiftCountPerDay_1B.csv', 'IntResults'));
save(getFileNameForThisOS('2017_7_26-shiftCountPerDay_1B.mat', 'IntResults'), 'shiftCountPerDay');
clear trialDataDay trialsIncluded subjs i subjNum subjTrials
clear shiftCountPerDay
