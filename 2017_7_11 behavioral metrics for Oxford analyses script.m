% Zephy McKanna
% Script to provide behavioral metrics for Jamie and Sumientra
% 7/11/17 (and after)



% get a last-shift-of-a-given-cluster to first-shift-of-that-cluster per-day measure for Jamie 
[zRFSum_1B, ~, ~] = formTables_RF_1A3('1b-final-Parsed.rf-sum.xlsx', '', '', true);
delMe = zRFSum_1B(zRFSum_1B.ActualN < 4, :); % only set up to deal with N1-3 right now... (could fix this later)
% we're trying to make a matrix that is:
    % Cols: Cluster+Nval
    % Rows: SubjNum+Day+FirstEncounter, SubjNum+Day+LastEncounter
subjFirstLastClustersAccuracy = table( -1,-1,{'None'},-1,-1,-1,-1,-1,-1,...
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,...
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,...
    'VariableNames', {'Subj','RFtrainingDay','FirstOrLast',...
    'S','I','S_Logic','I_Logic','S_I','S_I_Logic',...
    'U_N1','U_N2','U_N3',...
    'U_Logic_N1','U_Logic_N2','U_Logic_N3',...
    'U_I_N1','U_I_N2','U_I_N3',...
    'U_I_Logic_N1','U_I_Logic_N2','U_I_Logic_N3',...
    'U_S_N1','U_S_N2','U_S_N3',...
    'U_S_Logic_N1','U_S_Logic_N2','U_S_Logic_N3',...
    'L4aV1_N1','L4aV1_N2','L4aV1_N3',...
    'L4aV2_N1','L4aV2_N2','L4aV2_N3',...
    'L4bV1_N1','L4bV1_N2','L4bV1_N3',...
    'L4bV2_N1','L4bV2_N2','L4bV2_N3'} );
curInsertingRow = 1; % this will go up by 2s, as we do one row for first and one for last
clustersCountInsertingRow = 1; % don't need a first and last for this one
subjs = unique(delMe.Subject);
for i = 1:length(subjs)
    subj = subjs(i);
    fprintf('Inserting subject %d.\n', subj); % staying alive feedback
    subjShifts = sortrows(delMe(delMe.Subject == subj,:),{'Date'});
    subjDays = unique(subjShifts.Date);
    for d = 1:length(subjDays)
        day = subjDays(d);
        subjShiftsToday = sortrows(subjShifts(subjShifts.Date == day,:),'ShiftNum','ascend');
        curDayFirst = table( subj,subjShiftsToday.RfTNumber(1),{'First'},...
            -1,-1,-1,-1,-1,-1,... % assume all -1s; change the ones we actually have before we insert
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,...
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,...
            'VariableNames', {'Subj','RFtrainingDay','FirstOrLast',...
            'S','I','S_Logic','I_Logic','S_I','S_I_Logic',...
            'U_N1','U_N2','U_N3',...
            'U_Logic_N1','U_Logic_N2','U_Logic_N3',...
            'U_I_N1','U_I_N2','U_I_N3',...
            'U_I_Logic_N1','U_I_Logic_N2','U_I_Logic_N3',...
            'U_S_N1','U_S_N2','U_S_N3',...
            'U_S_Logic_N1','U_S_Logic_N2','U_S_Logic_N3',...
            'L4aV1_N1','L4aV1_N2','L4aV1_N3',...
            'L4aV2_N1','L4aV2_N2','L4aV2_N3',...
            'L4bV1_N1','L4bV1_N2','L4bV1_N3',...
            'L4bV2_N1','L4bV2_N2','L4bV2_N3'} );
        curDayLast = table( subj,subjShiftsToday.RfTNumber(1),{'Last'},...
            -1,-1,-1,-1,-1,-1,... % assume all -1s; change the ones we actually have before we insert
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,...
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,...
            'VariableNames', {'Subj','RFtrainingDay','FirstOrLast',...
            'S','I','S_Logic','I_Logic','S_I','S_I_Logic',...
            'U_N1','U_N2','U_N3',...
            'U_Logic_N1','U_Logic_N2','U_Logic_N3',...
            'U_I_N1','U_I_N2','U_I_N3',...
            'U_I_Logic_N1','U_I_Logic_N2','U_I_Logic_N3',...
            'U_S_N1','U_S_N2','U_S_N3',...
            'U_S_Logic_N1','U_S_Logic_N2','U_S_Logic_N3',...
            'L4aV1_N1','L4aV1_N2','L4aV1_N3',...
            'L4aV2_N1','L4aV2_N2','L4aV2_N3',...
            'L4bV1_N1','L4bV1_N2','L4bV1_N3',...
            'L4bV2_N1','L4bV2_N2','L4bV2_N3'} );
        subjFirstLastClustersNumber(curInsertingRow,:) = curDayFirst; % just set this to the -1s and then deal with it directly
        subjFirstLastClustersNumber(curInsertingRow+1,:) = curDayLast; % just set this to the -1s and then deal with it directly
        subjFirstLastClustersCount(clustersCountInsertingRow,:) = table( ...
            subj,subjShiftsToday.RfTNumber(1),... % don't need a first/last for the count
            0,0,0,0,0,0,... % for a count, zeros make more sense than -1 or NaN
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,...
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,...
            'VariableNames', {'Subj','RFtrainingDay',...
            'S','I','S_Logic','I_Logic','S_I','S_I_Logic',...
            'U_N1','U_N2','U_N3',...
            'U_Logic_N1','U_Logic_N2','U_Logic_N3',...
            'U_I_N1','U_I_N2','U_I_N3',...
            'U_I_Logic_N1','U_I_Logic_N2','U_I_Logic_N3',...
            'U_S_N1','U_S_N2','U_S_N3',...
            'U_S_Logic_N1','U_S_Logic_N2','U_S_Logic_N3',...
            'L4aV1_N1','L4aV1_N2','L4aV1_N3',...
            'L4aV2_N1','L4aV2_N2','L4aV2_N3',...
            'L4bV1_N1','L4bV1_N2','L4bV1_N3',...
            'L4bV2_N1','L4bV2_N2','L4bV2_N3'} );

        listOfClustersSeen = [{''}];
        for j = 1:height(subjShiftsToday)
            clusterVar = getVarNameFromCluster(subjShiftsToday.Cluster(j), subjShiftsToday.ActualN(j), false);
            if (~ismember(clusterVar,listOfClustersSeen)) % if we haven't seen this cluster before (today)
                listOfClustersSeen = [listOfClustersSeen;clusterVar]; % add it to what we've seen
                curDayFirst(1,clusterVar) = {subjShiftsToday.Accuracy(j)}; % add its value to the "first" row
                subjFirstLastClustersNumber(curInsertingRow,clusterVar) = {j};
            end
            curDayLast(1,clusterVar) = {subjShiftsToday.Accuracy(j)}; % regardless, add its value to the "last" row (overwrite any previous)
            subjFirstLastClustersNumber(curInsertingRow+1,clusterVar) = {j};
            subjFirstLastClustersCount(clustersCountInsertingRow,clusterVar) = ... % grab all the instances of this cluster
                {height(subjShiftsToday(strcmpi(subjShiftsToday.Cluster, subjShiftsToday.Cluster(j)),:))};
        end

        subjFirstLastClustersAccuracy(curInsertingRow,:) = curDayFirst;
        subjFirstLastClustersAccuracy(curInsertingRow+1,:) = curDayLast;
        curInsertingRow = curInsertingRow + 2;
        clustersCountInsertingRow = clustersCountInsertingRow + 1;
    end
end
for i = 1:height(subjFirstLastClustersAccuracy) % now change the -1s to NaNs, to be clear what people saw and what they didn't
    for j = 4:width(subjFirstLastClustersAccuracy) % first three will never be -1 (and one is a words column that will break on ==)
        if (subjFirstLastClustersAccuracy{i,j} == -1)
            subjFirstLastClustersAccuracy{i,j} = NaN;
        end
        if (subjFirstLastClustersNumber{i,j} == -1) % this table should have identically placed -1s, but might as well check...
            subjFirstLastClustersNumber{i,j} = NaN;
        end
    end
end
writetable(subjFirstLastClustersAccuracy, getFileNameForThisOS('2017_8_8-FirstLastPerDay-Accuracy.csv', 'IntResults'));
save(getFileNameForThisOS('2017_8_8-FirstLastPerDay-Accuracy.mat', 'IntResults'), 'subjFirstLastClustersAccuracy');
writetable(subjFirstLastClustersNumber, getFileNameForThisOS('2017_8_8-FirstLastPerDay-ShiftNum.csv', 'IntResults'));
save(getFileNameForThisOS('2017_8_8-FirstLastPerDay-ShiftNum.mat', 'IntResults'), 'subjFirstLastClustersNumber');
writetable(subjFirstLastClustersCount, getFileNameForThisOS('2017_8_9-CountOfClustersPerDay.csv', 'IntResults'));
save(getFileNameForThisOS('2017_8_9-CountOfClustersPerDay.mat', 'IntResults'), 'subjFirstLastClustersCount');
clear delMe subjFirstLastClustersAccuracy subjFirstLastClustersNumber 
clear curInsertingRow subjs i subj subjShifts subjDays d day subjShiftsToday
clear curDayFirst curDayLast listOfClustersSeen j clusterVar 
clear subjFirstLastClustersCount clustersCountInsertingRow









% get a per-day 1B GLM Ability estimate for Jamie
abilityPerDay = table( -999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,...
    'VariableNames', {'Subj','T1','T2','T3','T4','T5','T6','T7','T8',...
    'T9','T10','T11','T12'} );

for trialDataDay = 1:12 % there are 12 training days in the 1B data (should be only 11, but 1 subject has a 12th...)
    fprintf('Performing GLM for Training day %d.\n', trialDataDay); % staying alive feedback
    trialData = getPerDayTrialData_1B(trialDataDay);
    trialsIncluded = trialData(strcmpi(trialData.Status,'Finished'),:);
    trialsIncluded = [trialsIncluded; trialData(strcmpi(trialData.Status,'Finished*'),:)];
    clear trialData % for speed (dunno if it makes much difference, should test)
    subjs = unique(trialsIncluded.Subject);
    if (trialDataDay == 1) % prealloc the table, assuming we'll have the same number of subjects (or less) for all subsequent days
        abilityPerDay = repmat(abilityPerDay,length(subjs),1);
        abilityPerDay.Subj = subjs(1:end); 
    end
    glmData = trialsIncluded(trialsIncluded.StimShowTime < 5,:); % remove "didn't understand instructions" outliers
    glmY = glmData.Correct;
% original    glmX = [glmData.Subject glmData.NbackDifficulty glmData.SwitchFlag glmData.InhibitDifficulty glmData.numOfEFsInThisTrial glmData.TotalTrialCount glmData.RespTime];
% original, with intercept     RF_Abilitymodel_1B = fitglm(glmX,glmY,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'});
% original    RF_Abilitymodel_1B = fitglm(glmX,glmY,'logit(Correct) ~ Subj + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'},'Intercept','false');
% for the original    eval([sprintf('RF_Abilitymodel_1B_%d',i),'= RF_Abilitymodel_1B;']); % save the GLM in case we want to examine it later
    glmX = [glmData.Subject glmData.NbackDifficulty glmData.SwitchFlag glmData.InhibitDifficulty glmData.numOfEFsInThisTrial glmData.RespTime glmData.ShiftNum];
    RF_Abilitymodel_1B = fitglm(glmX,glmY,'logit(Correct) ~ Subj + Ndiff + SwRep + InhDiff + EFcount + RT + ShiftNum','distr','binomial','CategoricalVars',[1,2,3,5,7],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','RT','ShiftNum','Correct'},'Intercept','false');
    eval([sprintf('RF_Abilitymodel_xtraFactors_1B_%d',trialDataDay),'= RF_Abilitymodel_1B;']); % save the GLM for each day


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

%    length(RF_Abilitymodel_1B.Coefficients.Estimate(2:(end-11))) % 298 subjects involved on T1-11
%    if (trialDataDay < 12) % 12th day has fewer subjects
%        tmpTable = table(RF_Abilitymodel_1B.Coefficients.Estimate(2:299)); % first one is intercept; last several are Ndiff, SwRep, etc. - but Ndiff number changes, so can't just say (end-11)
%        abilityPerDay(:,strcat('T',sprintf('%d',trialDataDay))) = tmpTable; % put them into the right column
%    end
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

writetable(abilityPerDay, getFileNameForThisOS('2017_8_26-abilityPerDay_1B.csv', 'IntResults'));
save(getFileNameForThisOS('2017_8_26-abilityPerDay_1B.mat', 'IntResults'), 'abilityPerDay');


figure
hold on
for i = 1:height(abilityPerDay)
    plot(1:12,abilityPerDay{i,2:13})
end
xlabel('Training Day')
ylabel('Average GLM-estimated daily Ability')
hold off

clear abilityPerDay






% let's see if we can get a rolling window across three days (all done on SWING) 
for firstDayOfThree = 1:9 % this window will be this day and the following two
    fprintf('Performing GLM for days %d to %d.\n', firstDayOfThree, firstDayOfThree+2); % staying alive feedback
    trialData1 = getPerDayTrialData_1B(firstDayOfThree);
    trialData2 = getPerDayTrialData_1B(firstDayOfThree + 1);
    trialData3 = getPerDayTrialData_1B(firstDayOfThree + 2);
    trialsIncluded = excludeSubjects_RF_1B(true, true, false, [trialData1;trialData2;trialData3]);
    
    clear trialData1 trialData2 trialData3 % for speed (dunno if it makes much difference, should test)
    % now add a column that will indicate the subj+day factor for GLM
    trialsIncluded.SubjDayCode = zeros(height(trialsIncluded),1);
    trialsIncluded.SubjDayCode = (trialsIncluded.Subject * 1000) + trialsIncluded.RfTNumber;
    
    glmData = trialsIncluded(trialsIncluded.StimShowTime < 5,:); % remove "didn't understand instructions" outliers
    glmData = removeUncommonShifts_1B(glmData,10,-1,false); % remove any shifts that weren't seen by at least 10 different subjects on this day
%zNote: should consider taking a subset of "good" subjects for difficulty estimation purposes
    glmY = glmData.Correct;
% old, before we used removeUncomonShifts_1B    glmX = [glmData.SubjDayCode glmData.NbackDifficulty glmData.SwitchFlag glmData.InhibitDifficulty glmData.numOfEFsInThisTrial glmData.RespTime glmData.ShiftNum];
    glmX = [glmData.SubjDayCode glmData.ShiftID glmData.RespTime glmData.ShiftNum];
    clear trialsIncluded glmData % for speed
% old, before we used removeUncomonShifts_1B    RF_Abilitymodel_1B_threedays = fitglm(glmX,glmY,'logit(Correct) ~ SubjDay + Ndiff + SwRep + InhDiff + EFcount + RT + ShiftNum','distr','binomial','CategoricalVars',[1,2,3,5,7],'VarNames',{'SubjDay','Ndiff','SwRep','InhDiff','EFcount','RT','ShiftNum','Correct'},'Intercept','false');
    RF_Abilitymodel_1B_threedays = fitglm(glmX,glmY,'logit(Correct) ~ SubjDay + ShiftID + RT + ShiftNum','distr','binomial','CategoricalVars',[1,2,4],'VarNames',{'SubjDay','ShiftID','RT','ShiftNum','Correct'},'Intercept','false');
    eval([sprintf('RF_Abilitymodel_T%d_T%d',firstDayOfThree, firstDayOfThree+2),'= RF_Abilitymodel_1B_threedays;']); % save the GLM for each period
end
% now save them as tables so we can write them to a file
for firstDayOfThree = 1:9 % now save them (also on SWING; have to SCP them over to the laptop afterward)
    eval([sprintf('delMe = RF_Abilitymodel_T%d_T%d',firstDayOfThree, firstDayOfThree+2),';']); % set delMe to each GLM
    delMe2 = table(transpose(delMe.CoefficientNames), delMe.Coefficients.Estimate, ...
        delMe.Coefficients.SE, delMe.Coefficients.tStat, ...
        delMe.Coefficients.pValue, 'VariableNames', {'Coeff','Estimate','SE','tStat','pValue'});
    eval([sprintf('glmTable%d',firstDayOfThree),' = delMe2;']);
% old, before we used removeUncomonShifts_1B    eval(['writetable(delMe2, getFileNameForThisOS(','''',sprintf('2017_9_1-GLM_T%d_T%d',firstDayOfThree, firstDayOfThree+2),'.csv','''',', ','''','IntResults','''','));']);
    eval(['writetable(delMe2, getFileNameForThisOS(','''',sprintf('2017_9_3-GLM_T%d_T%d',firstDayOfThree, firstDayOfThree+2),'.csv','''',', ','''','IntResults','''','));']);
% old, before we used removeUncomonShifts_1B    eval(['save(getFileNameForThisOS(','''',sprintf('2017_9_1-GLM_T%d_T%d',firstDayOfThree, firstDayOfThree+2),'.mat','''',', ','''','IntResults','''','), ','''',sprintf('glmTable%d',firstDayOfThree),'''',');']);
    eval(['save(getFileNameForThisOS(','''',sprintf('2017_9_3-GLM_T%d_T%d',firstDayOfThree, firstDayOfThree+2),'.mat','''',', ','''','IntResults','''','), ','''',sprintf('glmTable%d',firstDayOfThree),'''',');']);
end


% now, back on the laptop, let's put all the glmTables into one (NOTE: have to load the e.g. "2017_9_3-GLM_T1_T3.mat" files first!) 
delMe3 = table(ones(9,1),transpose([1:9]),zeros(9,1),'VariableNames',{'Subj','Day','CoeffEst'}); % subj1 is the reference for the 9 GLMs (coeff est = 0)
insertRow = height(delMe3) + 1; % start on the next row after these
for firstDayOfThree = 1:9 % go through each three-day GLM
    fprintf('Adding data from GLM %d.\n', firstDayOfThree); % staying alive feedback
    eval([sprintf('delMe2 = glmTable%d',firstDayOfThree),';']); % set delMe2 to each GLM table
%    eval([sprintf('delMe = RF_Abilitymodel_T%d_T%d',firstDayOfThree, firstDayOfThree+2),';']); % set delMe to each GLM
%    delMe2 = table(transpose(delMe.CoefficientNames), delMe.Coefficients.Estimate, ...
%        delMe.Coefficients.SE, delMe.Coefficients.tStat, ...
%        delMe.Coefficients.pValue, 'VariableNames', {'Coeff','Estimate','SE','tStat','pValue'});
    for i = 1:length(delMe2.Coeff)
        curName = delMe2.Coeff{i};
        if (~isempty(strfind(curName,'SubjDay_'))) % this row refers to a subject ability estimate
            subjDayNum = str2double(curName(strfind(curName,'_')+1:end));
            subj = floor(subjDayNum / 1000);
            day = mod(subjDayNum, 1000);
            delMe3(insertRow,:) = table(subj,day,delMe2.Estimate(i),'VariableNames',{'Subj','Day','CoeffEst'});
            insertRow = insertRow + 1;
        end
    end
end
% let's make delMe3 a little prettier, for sharing with M&M
subjs = unique(delMe3.Subj);
AbilityCoeffEst_3dayWindow = table(subjs,NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),NaN(length(subjs),1),...
    NaN(length(subjs),1),NaN(length(subjs),1),'VariableNames',{'Subj',...
    'T1_1','T2_1','T2_2','T3_1','T3_2','T3_3','T4_1','T4_2','T4_3',...
    'T5_1','T5_2','T5_3','T6_1','T6_2','T6_3','T7_1','T7_2','T7_3',...
    'T8_1','T8_2','T8_3','T9_1','T9_2','T9_3','T10_1','T10_2','T11_1'});
days = unique(delMe3.Day);
for i = 1:length(subjs)
    subj = subjs(i);
    for j = 1:length(days)
        day = days(j);
        subjDayRows = delMe3((delMe3.Subj == subj) & (delMe3.Day == day),:);
        if (~isempty(subjDayRows)) % we have some estimates
            for k = 1:height(subjDayRows)
                AbilityCoeffEst_3dayWindow{AbilityCoeffEst_3dayWindow.Subj == subj,sprintf('T%d_%d',day,k)} = subjDayRows.CoeffEst(k);
            end
        end
    end
end
%writetable(AbilityCoeffEst_3dayWindow, getFileNameForThisOS('2017_9_2-abilityCoeffs_3dayWindow_1B.csv', 'IntResults'));
%save(getFileNameForThisOS('2017_9_2-abilityCoeffs_3dayWindow_1B.mat', 'IntResults'), 'AbilityCoeffEst_3dayWindow');
writetable(AbilityCoeffEst_3dayWindow, getFileNameForThisOS('2017_9_3-abilityCoeffs_3dayWindow_1B.csv', 'IntResults'));
save(getFileNameForThisOS('2017_9_3-abilityCoeffs_3dayWindow_1B.mat', 'IntResults'), 'AbilityCoeffEst_3dayWindow');

subjs = unique(delMe3.Subj);
delMe4 = table(subjs,zeros(length(subjs),1),...
    zeros(length(subjs),1),zeros(length(subjs),1),zeros(length(subjs),1),...
    zeros(length(subjs),1),zeros(length(subjs),1),zeros(length(subjs),1),...
    zeros(length(subjs),1),zeros(length(subjs),1),zeros(length(subjs),1),...
    zeros(length(subjs),1),'VariableNames',{'Subj','T1','T2','T3','T4',...
    'T5','T6','T7','T8','T9','T10','T11'});
days = unique(delMe3.Day);
for i = 1:length(subjs)
    subj = subjs(i);
    fprintf('Interpolating estimates for subj %d.\n', subj); % staying alive feedback (kind of annoying, should make a Verbose flag)
    for j = 1:length(days)
        day = days(j);
        subjDayRows = delMe3((delMe3.Subj == subj) & (delMe3.Day == day),:);
        if (isempty(subjDayRows)) % we don't have an estimate for this subj on this day
            delMe4{delMe4.Subj == subj,sprintf('T%d',day)} = NaN;
        else % we have some estimates
            delMe4{delMe4.Subj == subj,sprintf('T%d',day)} = mean(subjDayRows.CoeffEst);
        end
    end
end
abilityPerDay = delMe4;
%writetable(abilityPerDay, getFileNameForThisOS('2017_9_1-abilityPerDay_3dayWindow_1B.csv', 'IntResults'));
%save(getFileNameForThisOS('2017_9_1-abilityPerDay_3dayWindow_1B.mat', 'IntResults'), 'abilityPerDay');
writetable(abilityPerDay, getFileNameForThisOS('2017_9_3-abilityPerDay_3dayWindow_1B.csv', 'IntResults'));
save(getFileNameForThisOS('2017_9_3-abilityPerDay_3dayWindow_1B.mat', 'IntResults'), 'abilityPerDay');

figure
hold on
for i = 1:height(abilityPerDay)
    plot(1:11,abilityPerDay{i,2:12})
end
xlabel('Training Day')
ylabel('Average GLM-estimated daily Ability (interpolated from 3-day moving window)')
hold off

clear abilityPerDay




% now create a similar table that actually tells how many shifts they saw each "day" - since many are more than 20... 
shiftCountPerDay = table( -999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,...
    'VariableNames', {'Subj','T1','T2','T3','T4','T5','T6','T7','T8',...
    'T9','T10','T11','T12'} );
for trialDataDay = 1:12 % there are 12 training days in the 1B data (should be only 11, but 1 subject has a 12th...)
    fprintf('Counting shifts for Training day %d.\n', trialDataDay); % staying alive feedback
    trialData = getPerDayTrialData_1B(trialDataDay);
    trialsIncluded = trialData(strcmpi(trialData.Status,'Finished'),:);
    trialsIncluded = [trialsIncluded; trialData(strcmpi(trialData.Status,'Finished*'),:)];
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



% now do the same for 2B data (NOTE: this assumes we have all "finished" trial data with extra cols in delMe3) 
abilityPerDay_2B = table( -999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,...
    'VariableNames', {'Subj','T1','T2','T3','T4','T5','T6','T7','T8',...
    'T9','T10','T11','T12'} );
shiftCountPerDay_2B = table( -999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,-999,...
    'VariableNames', {'Subj','T1','T2','T3','T4','T5','T6','T7','T8',...
    'T9','T10','T11','T12'} );
for trialDataDay = 1:11 % there are 11 training days in the 2B data so far
    fprintf('Performing GLM for Training day %d.\n', trialDataDay); % staying alive feedback
%    trialData = getPerDayTrialData_1B(trialDataDay);
%    trialsIncluded = trialData(strcmpi(trialData.Status,'Finished'),:);
%    trialsIncluded = [trialsIncluded; trialData(strcmpi(trialData.Status,'Finished*'),:)];
%    clear trialData % for speed (dunno if it makes much difference, should test)
    trialsIncluded = delMe3(delMe3.RfTNumber == trialDataDay,:);
    subjs = unique(trialsIncluded.Subject);
    if (trialDataDay == 1) % prealloc the table, assuming we'll have the same number of subjects (or less) for all subsequent days
        abilityPerDay_2B = repmat(abilityPerDay_2B,length(subjs),1);
        abilityPerDay_2B.Subj = subjs(1:end); 
        shiftCountPerDay_2B = repmat(shiftCountPerDay_2B,length(subjs),1);
        shiftCountPerDay_2B.Subj = subjs(1:end); % unnecessary subscript?
    end
    for i = 1:length(subjs)
        subjNum = subjs(i);
        subjTrials = trialsIncluded(trialsIncluded.Subject == subjNum,:);
        shiftCountPerDay_2B(shiftCountPerDay_2B.Subj == subjNum, strcat('T', sprintf('%d',trialDataDay))) = {length(unique(subjTrials.CumShiftNum))};
    end
    glmData = trialsIncluded(trialsIncluded.StimShowTime < 5,:); % remove "didn't understand instructions" outliers
    glmY = glmData.Correct;
    glmX = [glmData.Subject glmData.NbackDifficulty glmData.SwitchFlag glmData.InhibitDifficulty glmData.numOfEFsInThisTrial glmData.TotalTrialCount glmData.RespTime];
% removing the intercept at Misha's suggestion...     RF_Abilitymodel_1B = fitglm(glmX,glmY,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'});
    RF_Abilitymodel_2B = fitglm(glmX,glmY,'logit(Correct) ~ Subj + Ndiff + SwRep + InhDiff + EFcount + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,5],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','TrialCount','RT','Correct'},'Intercept','false');

    % on different days, we have different subject numbers (and different N value numbers), so have to go through each 
    for i = 1:length(RF_Abilitymodel_2B.CoefficientNames)
        curName = RF_Abilitymodel_2B.CoefficientNames{i};
        if (~isempty(strfind(curName,'Subj_'))) % this row refers to a subject ability estimate
            subjNum = str2double(curName(strfind(curName,'_')+1:end));
            coeff = RF_Abilitymodel_2B.Coefficients.Estimate(i);
            abilityPerDay_2B(abilityPerDay_2B.Subj == subjNum, strcat('T', sprintf('%d',trialDataDay))) = {coeff};
        end
    end
    abilityPerDay_2B(abilityPerDay_2B.Subj == min(glmX(:,1)), strcat('T', sprintf('%d',trialDataDay))) = {0}; % reference subject
end
for i = 1:height(abilityPerDay_2B) % now change the -999s to NaNs
    for j = 1:width(abilityPerDay_2B)
        if (abilityPerDay_2B{i,j} == -999)
            abilityPerDay_2B{i,j} = NaN;
        end
        if (shiftCountPerDay_2B{i,j} == -999) % this table has the same size as the other one...
            shiftCountPerDay_2B{i,j} = NaN;
        end
    end
end
clear trialDataDay trialsIncluded subjs glmData glmY glmX 
clear RF_Abilitymodel_2B i curName subjTrials subjNum coeff

writetable(shiftCountPerDay_2B, getFileNameForThisOS('2017_7_26-shiftCountPerDay_2B.csv', 'IntResults'));
save(getFileNameForThisOS('2017_7_26-shiftCountPerDay_2B.mat', 'IntResults'), 'shiftCountPerDay_2B');
writetable(abilityPerDay_2B, getFileNameForThisOS('2017_7_26-abilityPerDay_2B.csv', 'IntResults'));
save(getFileNameForThisOS('2017_7_26-abilityPerDay_2B.mat', 'IntResults'), 'abilityPerDay_2B');
clear abilityPerDay_2B shiftCountPerDay_2B



% make the per-day Ability comparable across days
   % get T_reults from /Users/Shared/SHARP/Tools/2015_12_18 misha_DifficultyPOv1113 script.m
        % NOTE: we're using the T_results from the end (line 181) of that file
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Cluster,'U/Logic(xOR)'),:); % get rid of these, first thing
zRFSum_1B(strcmpi(zRFSum_1B.Cluster,'U/Logic(xOR)'),:).Cluster = repmat({'U/Logic'},height(delMe),1);
% now make all the Clusters the same as in zRFSum
T_results.Cluster = repmat({'unknown'},height(T_results),1);
T_results('1-U','Cluster') = {{'U'}};
T_results('2-S','Cluster') = {{'S'}};
T_results('3-I','Cluster') = {{'I'}};
T_results('4-U+Logic','Cluster') = {{'U/Logic'}};
T_results('5-S+Logic','Cluster') = {{'S/Logic'}};
T_results('6-I+Logic','Cluster') = {{'I/Logic'}};
T_results('7-U+S','Cluster') = {{'U/S'}};
T_results('8-U+I','Cluster') = {{'U/I'}};
T_results('9-S+I','Cluster') = {{'S/I'}};
T_results('10-U+S+Logic','Cluster') = {{'U/S/Logic'}};
T_results('11-U+I+Logic','Cluster') = {{'U/I/Logic'}};
T_results('12-S+I+Logic','Cluster') = {{'S/I/Logic'}};
T_results(13:21,'Cluster') = {{'4a'}}; % all the 4as; note in zRFSum, these are split into Lv1 and Lv2
T_results(22:30,'Cluster') = {{'4b'}}; % all the 4bs; note in zRFSum, these are split into Lv1 and Lv2
% now grab the Shift names for the ones where it matters
T_results.Shift = repmat({'doesntMatter'},height(T_results),1);
T_results('13-4a+AlgorithmicComprehension','Shift') = {{'Algorithmic Comprehension (S/I)'}};
T_results('14-4a+BiologicalItemizing','Shift') = {{'Biological Itemizing (U/S)'}};
T_results('15-4a+ReptilePlotting','Shift') = {{'Reptile Plotting (U/S)'}};
T_results('16-4a+TheoreticalAerodynamics','Shift') = {{'Theoretical Aerodynamics (U/I)'}};
T_results('17-4a+TypographicTrigonometry','Shift') = {{'Typographic Trigonometry (U/I)'}};
T_results('18-4a+ComputationalVocalizations','Shift') = {{'Computational Vocalizations (S/I)'}};
T_results('19-4a+DimensionalJargonization','Shift') = {{'Dimensional Jargonization (U/S)'}};
T_results('20-4a+ProportionalSympathizing','Shift') = {{'Proportional Sympathizing (U/S)'}};
T_results('21-4a+TetrominoGroking','Shift') = {{'Tetromino Groking (U/I)'}};
T_results('22-4b+AAAAAAAA','Shift') = {{'4b T:1c - AAAAAAAA'}};
T_results('23-4b+MeatBagEdition','Shift') = {{'4b T:2a - Meat-Bag Edition'}};
T_results('24-4b+Penultimations','Shift') = {{'4b T:3c - Penultimations'}};
T_results('25-4b+Specializations','Shift') = {{'4b T:3a - Specializations'}};
T_results('26-4b+rmPrrtzng','Shift') = {{'4b T:1a - rm Prrtzng'}};
T_results('27-4b+Extendedtraining','Shift') = {{'4b T:2c - Extended training'}};
T_results('28-4b+ExtremeCategorizing','Shift') = {{'4b T:3b - Extreme Categorizing'}};
T_results('29-4b+Forexceptionaltesters','Shift') = {{'4b T:2b - For exceptional testers'}};
T_results('30-4b+O+ganFailure','Shift') = {{'4b T:1b - O_gan Failure?'}};
% now add a Difficulty number to each row of the Sum file
zRFSum_1B.DifficultyForGLM = zeros(height(zRFSum_1B),1);
for i = 1:height(zRFSum_1B)
    if (ismember(zRFSum_1B.Shift(i),T_results.Shift)) % if we have the shift, then it's a Lv4; use the shift difficulty
        zRFSum_1B.DifficultyForGLM(i) = T_results(strcmpi(zRFSum_1B.Shift(i),T_results.Shift),:).D;
    elseif (ismember(zRFSum_1B.Cluster(i),T_results.Cluster)) % we don't recognize the shift, so it must be a cluster (...?)
        zRFSum_1B.DifficultyForGLM(i) = T_results(strcmpi(zRFSum_1B.Cluster(i),T_results.Cluster),:).D;
    else
        zRFSum_1B.Shift(i)
        zRFSum_1B.Cluster(i)
        fprintf('Unknown shift/cluster! What is this (above)???\n');
    end
end

avgClusterDiff_Subj_Day = table(0,0,0,0,0,0,0,0,0,0,0,0,0,'VariableNames',...
    {'Subj','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
subjs = unique(zRFSum_1B.Subject);
for i = 1:length(subjs)
    subj = subjs(i);
    avgClusterDiff_Subj_Day(i,:) = table(subj,0,0,0,0,0,0,0,0,0,0,0,0,'VariableNames',...
        {'Subj','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'});
    subjShifts = zRFSum_1B(zRFSum_1B.Subject == subj, :);
    subjDays = unique(subjShifts.RfTNumber);
    for j = 1:length(subjDays)
        day = subjDays(j);
        dayShifts = subjShifts(subjShifts.RfTNumber == day,:);
        avgClusterDiffToday = mean(dayShifts.DifficultyForGLM);
        avgClusterDiff_Subj_Day(i,sprintf('T%d',day)) = {avgClusterDiffToday};
    end
end
clear subjs i subj subjShifts subjDays j day dayShifts avgClusterDiffToday
avgClusterDiff_Subj_Day % just to see
save(getFileNameForThisOS('2017_8_8-avgClusterDiff_Subj_Day_1B.mat', 'IntResults'), 'avgClusterDiff_Subj_Day');

load(getFileNameForThisOS('2017_7_26-abilityPerDay_1B.mat', 'IntResults')); % load abilityPerDay
load(getFileNameForThisOS('2017_8_8-avgClusterDiff_Subj_Day_1B.mat', 'IntResults')); % load avgClusterDiff_Subj_Day
abilityPlusDiff_PerDay_1B = abilityPerDay; % start off with just the Ability
subjs = unique(abilityPerDay.Subj);
for i = 1:length(subjs)
    subj = subjs(i);
    for day = 1:12 % 11 if abilityPerDay only has 11 days (as in 9/1 version)
        if ( ~isnan(abilityPlusDiff_PerDay_1B{abilityPlusDiff_PerDay_1B.Subj == subj,...
                sprintf('T%d',day)}) ) % if we actually have an Ability for this day
            abilityPlusDiff_PerDay_1B{abilityPlusDiff_PerDay_1B.Subj == subj,...
                sprintf('T%d',day)} = abilityPlusDiff_PerDay_1B{abilityPlusDiff_PerDay_1B.Subj == subj,...
                sprintf('T%d',day)} + avgClusterDiff_Subj_Day{avgClusterDiff_Subj_Day.Subj == subj,...
                sprintf('T%d',day)};
        end
    end
end
abilityPlusDiff_PerDay_1B % just to see
save(getFileNameForThisOS('2017_8_8-abilityPlusDiff_PerDay_1B.mat', 'IntResults'), 'abilityPlusDiff_PerDay_1B');
writetable(abilityPlusDiff_PerDay_1B, getFileNameForThisOS('2017_8_8-abilityPlusDiff_PerDay_1B.csv', 'IntResults'));
%save(getFileNameForThisOS('2017_9_1-abilityPlusDiff_3dayWindow_1B.mat', 'IntResults'), 'abilityPlusDiff_PerDay_1B');
%writetable(abilityPlusDiff_PerDay_1B, getFileNameForThisOS('2017_9_1-abilityPlusDiff_3dayWindow_1B.csv', 'IntResults'));

figure
hold on
for i = 1:height(abilityPlusDiff_PerDay_1B)
    plot(1:12,abilityPlusDiff_PerDay_1B{i,2:13}) % 1:11 and 2:12, if using the 9/1 three-day-window version
end
xlabel('Training Day')
ylabel('Average GLM-estimated daily Ability + average daily difficulty')
hold off

figure
hold on
delMe = avgClusterDiff_Subj_Day;
for i=1:height(delMe)
    for j=1:width(delMe)
        if (delMe{i,j} == 0)
            delMe{i,j} = NaN;
        end
    end
end
for i = 1:height(delMe)
    plot(1:12,delMe{i,2:13})
end
xlabel('Training Day')
ylabel('Average daily difficulty')
hold off

figure
boxplot(zRFSum_1B.DifficultyForGLM, zRFSum_1B.Subject)
xlabel('Subject')
ylabel('Difficulty per shift (box plot)')
delMe = zRFSum_1B(zRFSum_1B.Subject < 30,:);
figure
boxplot(delMe.DifficultyForGLM, delMe.Subject)
xlabel('Subject')
ylabel('Difficulty per shift')


load(getFileNameForThisOS('2017_8_26-abilityPerDay_1B.mat', 'IntResults')); % load abilityPerDay (uses ShiftNum_factor instead of TrialNum_coeff)
load(getFileNameForThisOS('2017_8_8-avgClusterDiff_Subj_Day_1B.mat', 'IntResults')); % load avgClusterDiff_Subj_Day
abilityPlusDiff_xtraFactor_1B = abilityPerDay; % start off with just the Ability
subjs = unique(abilityPerDay.Subj);
for i = 1:length(subjs)
    subj = subjs(i);
    for day = 1:12
        if ( ~isnan(abilityPlusDiff_xtraFactor_1B{abilityPlusDiff_xtraFactor_1B.Subj == subj,...
                sprintf('T%d',day)}) ) % if we actually have an Ability for this day
            abilityPlusDiff_xtraFactor_1B{abilityPlusDiff_xtraFactor_1B.Subj == subj,...
                sprintf('T%d',day)} = abilityPlusDiff_xtraFactor_1B{abilityPlusDiff_xtraFactor_1B.Subj == subj,...
                sprintf('T%d',day)} + avgClusterDiff_Subj_Day{avgClusterDiff_Subj_Day.Subj == subj,...
                sprintf('T%d',day)};
        end
    end
end

figure
hold on
for i = 1:height(abilityPlusDiff_xtraFactor_1B)
    plot(1:12,abilityPlusDiff_xtraFactor_1B{i,2:13})
end
xlabel('Training Day')
ylabel('Average GLM-estimated daily Ability + average daily difficulty')
hold off
