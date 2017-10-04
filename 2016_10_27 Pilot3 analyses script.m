% Zephy McKanna
% 10/27/16
% Script to help produce figures for iARPA site visit on 11/8/16
%

% Step 1: set up the data
% First, save the three RF .csv files from Dennis into the ParsedData
% folder, as .xlsx, with the "2a-P3-latest-" prefix.

[zRFP3_data, zRFP3_sum, ~] = formTables_RF_1A3('2a-P3-latest-rf-data.xlsx', '2a-P3-latest-rf-sum.xlsx', '', true);
% zNOTE: in the latest version of the parser, you have to put the headings into the later rf trial files manually 
[zRFP3_all1, zRFP3_all2, ~] = formTables_RF_1A3('2a-P3-latest-rf-trials.00.xlsx', '2a-P3-latest-rf-trials.01.xlsx', '', true);
zRFP3_all = [zRFP3_all1; zRFP3_all2];
clear zRFP3_all1 zRFP3_all2 % clear out large tables for speed
zRFP3 = putNewColsIntoDataTable_2A(zRFP3_all); % also put the new, useful columns into the per-trial file
clear zRFP3_all % don't need this large table anymore; just use zRFP3 instead

% put the visit SessionNum into the SUM file from the Visit
zRFP3_sum.SessionNum = zeros(height(zRFP3_sum),1) - 1; % -1 = error (sanity check)
for delMe = 1:height(zRFP3_sum); 
    visit = zRFP3_sum.Visit{delMe};
    switch visit
        case 'training1'
            zRFP3_sum.SessionNum(delMe) = 1;
        case 'training2'
            zRFP3_sum.SessionNum(delMe) = 2;
        case 'training3'
            zRFP3_sum.SessionNum(delMe) = 3;
        case 'training4'
            zRFP3_sum.SessionNum(delMe) = 4;
        case 'training5'
            zRFP3_sum.SessionNum(delMe) = 5;
        case 'training6'
            zRFP3_sum.SessionNum(delMe) = 6;
        case 'training7'
            zRFP3_sum.SessionNum(delMe) = 7;
        case 'training8'
            zRFP3_sum.SessionNum(delMe) = 8;
        otherwise
            warning('Unexpected visit: %s\n', visit);
    end
end
clear visit % no longer needed

% Change the "Training" into a version number (1B = 1, 2A = 2)
zRFP3_sum.RFversion = zeros(height(zRFP3_sum),1) - 1; % -1 = error (sanity check)
for delMe = 1:height(zRFP3_sum); 
    delMe2 = zRFP3_sum.Training{delMe}; % 'robot_factory' or 'robot_factory_1b'
    switch delMe2
        case 'robot_factory_1b'
            zRFP3_sum.RFversion(delMe) = 1;
        case 'robot_factory'
            zRFP3_sum.RFversion(delMe) = 2;
        otherwise
            warning('Unexpected RF version number: %s\n', delMe2);
    end
end
zRFP3_data.RFversion = zeros(height(zRFP3_data),1) - 1; % -1 = error (sanity check)
for delMe = 1:height(zRFP3_data); 
    delMe2 = zRFP3_data.Training{delMe}; % 'robot_factory' or 'robot_factory_1b'
    switch delMe2
        case 'robot_factory_1b'
            zRFP3_data.RFversion(delMe) = 1;
        case 'robot_factory'
            zRFP3_data.RFversion(delMe) = 2;
        otherwise
            warning('Unexpected RF version number: %s\n', delMe2);
    end
end
% zRFP3_all is done in putNewColsIntoDataTable_2A()

[zP3_CLT_sum, zP3_CLT_tasks, zP3_CLT_trials] = formTables_RF_1A3('2a-P3-latest-clt-sum.xlsx', '2a-P3-latest-clt-tasks.xlsx', '2a-P3-latest-clt-trials.xlsx', true);




% Step 2: Exclusion
delMe = zP3_CLT_sum(zP3_CLT_sum.IgnoredEvents>100,:) % tasks where people responded 100+ times inappropriately
writetable(delMe, getFileNameForThisOS('2016_11_15-Pilot3CatIgnoredEvents.csv', 'IntResults'),'WriteRowNames',false);
[zACP3_thumb_sum, zACP3_silo_sum, zACP3_visual_sum] = formTables_RF_1A3('/Pilot3-1114/ac-thumb-sum.xlsx', '/Pilot3-1114/ac-silo-sum.xlsx', '/Pilot3-1114/ac-visual-sum.xlsx', true);
delMe2 = zACP3_thumb_sum(zACP3_thumb_sum.IgnoredEvents>100,:) % tasks where people responded 100+ times inappropriately
delMe2.ACtype = zeros(height(delMe2),1) + 1; % type 1 = thumb
delMe2.Accuracy = []; % this prevents concatenation for some reason
delMe3 = zACP3_silo_sum(zACP3_silo_sum.IgnoredEvents>100,:) % tasks where people responded 100+ times inappropriately
delMe3.ACtype = zeros(height(delMe3),1) + 2; % type 2 = silo
delMe3.Accuracy = []; % this prevents concatenation for some reason
delMe4 = zACP3_visual_sum(zACP3_visual_sum.IgnoredEvents>100,:) % tasks where people responded 100+ times inappropriately
delMe4.ACtype = zeros(height(delMe4),1) + 3; % type 3 = visual
delMe4.Accuracy = []; % this prevents concatenation for some reason
delMe5 = [delMe2;delMe3;delMe4];
writetable(delMe5, getFileNameForThisOS('2016_11_15-Pilot3ACIgnoredEvents.csv', 'IntResults'),'WriteRowNames',false);

delMe6 = table(0,0,{'Categorization'},'VariableNames',{'Subject','TotalIgnoredEvents','From'});
nextRowToWrite = 1;
subjects = unique(delMe.Subject);
for row = 1:length(subjects)
    subj = subjects(row);
    subjRows = delMe(delMe.Subject == subj, :);
    delMe6(nextRowToWrite,:) = table(subj,sum(subjRows.IgnoredEvents),{'Categorization'},'VariableNames',{'Subject','TotalIgnoredEvents','From'});
    nextRowToWrite = nextRowToWrite + 1;
end
subjects = unique(delMe5.Subject);
for row = 1:length(subjects)
    subj = subjects(row);
    subjRows = delMe5(delMe5.Subject == subj, :);
    delMe6(nextRowToWrite,:) = table(subj,sum(subjRows.IgnoredEvents),{'AC'},'VariableNames',{'Subject','TotalIgnoredEvents','From'});
    nextRowToWrite = nextRowToWrite + 1;
end
writetable(delMe6, getFileNameForThisOS('2016_11_15-Pilot3TotalIgnoredEvents.csv', 'IntResults'),'WriteRowNames',false);

% now investigate RF subjs that didn't do well for noncompliance
[delMe, delMe2] = getClustersCompleted_perTimespan_2A(zRFP3_sum, true, 1, 8, true, true); % re-using delMe and delMe2!
delMe = [delMe; delMe2]; % we want both 2A and 1B participants
delMe(delMe.total > 4, :) = []; % only get subjects that completed 4 or fewer cluaters (limit the search time for noncompliant subjs)
delMe = delMe.Subject;
HalfPlusOneSD = 50 + std(zRFP3_sum.Accuracy,'omitnan');
rfPerfTable = table(0,0,0,0.0,'VariableNames',{'Subject','TotalShifts','ShiftsNearChancePerf','PercentNearChance'});
nextRowToWrite = 1; % reset
subjects = unique(delMe);
for row = 1:length(subjects)
    subj = subjects(row);
    subjRows = zRFP3_sum(zRFP3_sum.Subject == subj, :);
    subjRowsNearChance = subjRows(subjRows.Accuracy < HalfPlusOneSD, :);
    rfPerfTable(nextRowToWrite,:) = table(subj,height(subjRows),...
        height(subjRowsNearChance),( height(subjRowsNearChance) / height(subjRows) ), ...
        'VariableNames',{'Subject','TotalShifts','ShiftsNearChancePerf','PercentNearChance'});
    nextRowToWrite = nextRowToWrite + 1;
end
writetable(rfPerfTable, getFileNameForThisOS('2016_11_15-Pilot3RFnearChance.csv', 'IntResults'),'WriteRowNames',false);

% put all the exclusions together in "2016_11_6-TasksToExclude.xlsx" (and also on gDrive) 
% also, update excludeSubjects_RF_2AP3
clear zACP3_thumb_sum zACP3_silo_sum zACP3_visual_sum % no need to keep these
clear row subj subjects subjRows subjRowsNearChance HalfPlusOneSD rfPerfTable nextRowToWrite
clear delMe delMe2 delMe3 delMe4 delMe5 delMe6

% now create some variables without the excluded participants: 
%       excludeSubjects_RF_2AP3(justFinished, excludeNCRF, excludeNCAC, justRF, fullData)

% get a version of the tables that includes only people who have finished and who were (we believe) compliant 
zRFP3_data_included = excludeSubjects_RF_2AP3(true, true, true, true, zRFP3_data);
zRFP3_sum_included = excludeSubjects_RF_2AP3(true, true,  true, true, zRFP3_sum);
zRFP3_included = excludeSubjects_RF_2AP3(true, true,  true, true, zRFP3);






% Step 3: Clusters completed (for people who have Finished)
[delMe, delMe2] = getClustersCompleted_perTimespan_2A(zRFP3_sum_included, true, 1, 8, true, true) % prints it out also
% put the data into "2016_11_15-clustersCompleted_total_onlyFinished - withGraphs.xlsx" for analysis and graphs
% also use that file to compare Clusters Completed with GLM Ability (below) 



% Step 4: Overall Ability (GLM)
% first, label the categorization difficulty

delMe = zRFP3_included(zRFP3_included.StimShowTime < 4,:); % exclude unusual timeouts and categorization (may also try: < 10 for just categorization)
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,8],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
printGLMcoeffs(RF_EFmodel_2A, true);
% including the Categorization rule
delMe = zRFP3_included(zRFP3_included.StimShowTime < 4,:); % exclude unusual timeouts
delMe = [delMe; zRFP3_included(strcmpi(zRFP3_included.Cluster,'Cat'),:)]; % but include categorization
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime delMe.CatRule];
RF_EFmodel_2Acat = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT + CatRule','distr','binomial','CategoricalVars',[1,2,3,5,6,8,10],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','CatRule','Correct'})
printGLMcoeffs(RF_EFmodel_2Acat, true);
% just EF for just the 2A participants
delMe = zRFP3_included(zRFP3_included.StimShowTime < 4,:); % exclude unusual timeouts
delMe(strcmpi(delMe.Training,'robot_factory_1b'),:) = []; % exclude all the 1B participants
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime delMe.CatRule];
RF_EFmodel_2Acat = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT + CatRule','distr','binomial','CategoricalVars',[1,2,3,5,6,8,10],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','CatRule','Correct'})
printGLMcoeffs(RF_EFmodel_2Acat, true);
% including the Categorization rule but only for the 2A participants
delMe = zRFP3_included(zRFP3_included.StimShowTime < 4,:); % exclude unusual timeouts
delMe = [delMe; zRFP3_included(strcmpi(zRFP3_included.Cluster,'Cat'),:)]; % but include categorization
delMe(strcmpi(delMe.Training,'robot_factory_1b'),:) = []; % exclude all the 1B participants
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime delMe.CatRule];
RF_EFmodel_2Acat = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT + CatRule','distr','binomial','CategoricalVars',[1,2,3,5,6,8,10],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','CatRule','Correct'})
printGLMcoeffs(RF_EFmodel_2Acat, true);
% just categorization
delMe = zRFP3_included(strcmpi(zRFP3_included.Cluster,'Cat'),:); % just categorization
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime delMe.CatRule];
RF_EFmodel_2Acat = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + TrialCount + Timeout + RT + CatRule','distr','binomial','CategoricalVars',[1,3,5],'VarNames',{'Subj','TrialCount','Timeout','RT','CatRule','Correct'})
printGLMcoeffs(RF_EFmodel_2Acat, true);

% without Inhibit difficulty (doesn't really make sense anyway)
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,4,5,7],'VarNames',{'Subj','Ndiff','SwRep','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
% without TrialCount
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.StimShowTime delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + EFcount + anyLogic + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,4,5,6],'VarNames',{'Subj','Ndiff','SwRep','EFcount','anyLogic','Timeout','RT','Correct'})
% excluding anything unusually hard for people (Timeout > 3)
delMe = zRFP3_included(zRFP3_included.StimShowTime <= 3,:); 
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.StimShowTime delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + EFcount + anyLogic + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,4,5,6],'VarNames',{'Subj','Ndiff','SwRep','EFcount','anyLogic','Timeout','RT','Correct'})
% only Ndiff and RT
delMe = zRFP3_included(zRFP3_included.StimShowTime <= 3,:); 
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','Ndiff','RT','Correct'})
% only Switch and RT, divided by RF version
delMe = zRFP3_included((zRFP3_included.StimShowTime <= 3) & (zRFP3_included.RFversion == 1),:); 
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.SwitchFlag delMe.RespTime];
RF_EFmodel_1B = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + SwRep + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','Correct'})
delMe = zRFP3_included((zRFP3_included.StimShowTime <= 3) & (zRFP3_included.RFversion == 2),:); 
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.SwitchFlag delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + SwRep + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','Correct'})
% only Ndiff and RT, divided by RF version
delMe = zRFP3_included((zRFP3_included.StimShowTime <= 3) & (zRFP3_included.RFversion == 1),:); 
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.RespTime];
RF_EFmodel_1B = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','Ndiff','RT','Correct'})
delMe = zRFP3_included((zRFP3_included.StimShowTime <= 3) & (zRFP3_included.RFversion == 2),:); 
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','Ndiff','RT','Correct'})
% Divided by RF version, with everything
delMe = zRFP3_included((zRFP3_included.StimShowTime <= 9) & (zRFP3_included.RFversion == 1),:); % only exclude categorization
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_1B = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,8],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
delMe = zRFP3_included((zRFP3_included.StimShowTime <= 9) & (zRFP3_included.RFversion == 2),:); % only exclude categorization
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,8],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
% Divided by RF version, without Inhibit difficulty
delMe = zRFP3_included((zRFP3_included.StimShowTime <= 9) & (zRFP3_included.RFversion == 1),:); % only exclude categorization
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_1B = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,4,5,7],'VarNames',{'Subj','Ndiff','SwRep','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
delMe = zRFP3_included((zRFP3_included.StimShowTime <= 9) & (zRFP3_included.RFversion == 2),:); % only exclude categorization
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,4,5,7],'VarNames',{'Subj','Ndiff','SwRep','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})

% GLM only in the first two days, versus the last two days
subjs = unique(zRFP3_included.Subject);
zRFP3_twoFirstDays = [];
zRFP3_twoLastDays = [];
for row = 1:length(subjs)
    subj = subjs(row);
    subjRows = zRFP3_included(zRFP3_included.Subject == subj, :);
    subjRowsMin1 = subjRows(subjRows.SessionNum == min(subjRows.SessionNum), :); % grab the lowest
    subjRows(subjRows.SessionNum == min(subjRows.SessionNum), :) = []; % then delete the lowest
    subjRowsMin2 = subjRows(subjRows.SessionNum == min(subjRows.SessionNum), :); % grab the lowest again (second lowest now)
    zRFP3_twoFirstDays = [zRFP3_twoFirstDays;subjRowsMin1;subjRowsMin2];
    subjRowsMax1 = subjRows(subjRows.SessionNum == max(subjRows.SessionNum), :); % grab the highest
    subjRows(subjRows.SessionNum == max(subjRows.SessionNum), :) = []; % then delete the highest
    subjRowsMax2 = subjRows(subjRows.SessionNum == max(subjRows.SessionNum), :); % grab the highest again (second highest now)
    zRFP3_twoLastDays = [zRFP3_twoLastDays;subjRowsMax1;subjRowsMax2];
end
clear subjs subj subjRows subjRowsMin1 subjRowsMin2 subjRowsMax1 subjRowsMax2

delMe = zRFP3_twoFirstDays(zRFP3_twoFirstDays.StimShowTime < 4,:); % exclude categorization and weird timeouts
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_First2_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,8],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
printGLMcoeffs(RF_EFmodel_First2_2A, true);
delMe = zRFP3_twoLastDays(zRFP3_twoLastDays.StimShowTime < 4,:); % exclude categorization and weird timeouts
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_Last2_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,8],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
printGLMcoeffs(RF_EFmodel_Last2_2A, true);


% Some odd things in the Ability GLM, which is why I tried so many
% different configurations... Particularly SWITCH: 
%  Nvals basically make sense (more N, more negative)
%  Switch/repetition don't make sense: repetition (SwRep_2) always harder than Switch (SwRep_1)
%  InhDiff doesn't make sense: more difficult = easier (but what does InhDiff even mean) 
%  EFcount makes sense: 2 EFs is harder than 1 is harder than 0
%  Logic makes sense: any logic makes it harder
%  TrialCount makes sense: basically zero, but slightly positive
%  Timeout makes some sense within its limits: 2s is harder than 1s (but 3s is easier again, so...?)




% Step 5: categorization
% done above now... [zP3_CLT_sum, zP3_CLT_tasks, zP3_CLT_trials] = formTables_RF_1A3('2a-P3-latest-clt-sum.xlsx', '2a-P3-latest-clt-tasks.xlsx', '2a-P3-latest-clt-trials.xlsx', true);
zP3_CLT_sum_included = excludeSubjects_RF_2AP3(true, true, true, false, zP3_CLT_sum); % only the finished, non-excluded people
zP3_CLT_tasks_included = excludeSubjects_RF_2AP3(true, true, true, false, zP3_CLT_tasks); % only the finished, non-excluded people
zP3_CLT_trials_included = excludeSubjects_RF_2AP3(true, true, true, false, zP3_CLT_trials); % only the finished, non-excluded people
% delMe = zP3_CLT_tasks(strcmpi(zP3_CLT_tasks.Status, 'finished'),:); % only grab the finished people
delMe = zP3_CLT_tasks_included; % only grab the finished and included people
delMe2 = delMe(strcmpi(delMe.Visit, 'baseline'),:); % delMe2 (and even delMes) = the baseline data
delMe3 = delMe(strcmpi(delMe.Visit, 'followup'),:); % delMe3 (and odd delMes) = the followup data
[unique(delMe2.Subject) unique(delMe3.Subject)] % sanity check - this line will fail if there are different numbers of subjects
zP3_catTaskTable = table(0,{'popo'},0,0,0,'VariableNames',{'Subject','Training','BL_Success','FU_Success','Delta_Success'});
subjs = unique(delMe2.Subject);
for i = 1:length(unique(delMe2.Subject)) 
    subj = subjs(i);
    delMe4 = delMe2(delMe2.Subject == subj, :); % even = baseline
    delMe5 = delMe3(delMe3.Subject == subj, :); % odd = followup
    zP3_catTaskTable(i,:) = table(subj,delMe4.Training(1),...
        sum(delMe4.OutcomeInt),sum(delMe5.OutcomeInt),sum(delMe5.OutcomeInt) - sum(delMe4.OutcomeInt)...
        ,'VariableNames',{'Subject','Training','BL_Success','FU_Success','Delta_Success'});
end
zP3_catTaskTable
writetable(zP3_catTaskTable, getFileNameForThisOS('2016_11_15-Pilot3CategorizationDeltas_includedOnly.csv', 'IntResults'),'WriteRowNames',false);
clear i subjs subj delMe2 delMe3 delMe4 delMe5; % just temporary variables
zP3_catTaskTable_2A = zP3_catTaskTable(strcmpi(zP3_catTaskTable.Training, 'robot_factory'), :);
zP3_catTaskTable_1B = zP3_catTaskTable(strcmpi(zP3_catTaskTable.Training, 'robot_factory_1b'), :);
zP3_catTaskTable_AC = zP3_catTaskTable(strcmpi(zP3_catTaskTable.Training, 'sharp_training'), :);
mean(zP3_catTaskTable_2A.Delta_Success)
mean(zP3_catTaskTable_1B.Delta_Success)
mean(zP3_catTaskTable_AC.Delta_Success)
%[p,tbl,stats,terms] = anovan(___)
[delMe,delMe2,delMe3,delMe4] = anovan(zP3_catTaskTable.Delta_Success,{zP3_catTaskTable.Training})
clear zP3_catTaskTable_2A zP3_catTaskTable_1B zP3_catTaskTable_AC; % once we're done with them
% ANOVAn doesn't show any sig differences (p = .08), but graph in "2016_11_15-Pilot3CatDeltas_withGraph.xlsx" anyway 

% what if we ignore subjects in the 1500s? seems to be something different about that site 
delMe = zP3_catTaskTable;
delMe(delMe.Subject > 1499, :) = [];
delMe_2A = delMe(strcmpi(delMe.Training, 'robot_factory'), :);
delMe_1B = delMe(strcmpi(delMe.Training, 'robot_factory_1b'), :);
delMe_AC = delMe(strcmpi(delMe.Training, 'sharp_training'), :);
mean(delMe_2A.Delta_Success)
mean(delMe_1B.Delta_Success)
mean(delMe_AC.Delta_Success)
[delMe5,delMe2,delMe3,delMe4] = anovan(delMe.Delta_Success,{delMe.Training})
%[p,tbl,stats,terms] = anovan(___)
clear delMe_2A delMe_1B delMe_AC

% Step 5b: RF categorization
% find out how many of each type each participant did in RF
delMe = zRFP3_sum_included(strcmpi(zRFP3_sum_included.Cluster, 'Cat'),:); % grab Categorization trials
subjs = unique(delMe.Subject);
zP3_RF_CatCountTable = table(0,0,0,0,0,0,'VariableNames',{'Subject','ID','AND','OR','xOR','ShepV'});
for row = 1:length(subjs)
    subj = subjs(row);
    subjRows = delMe(delMe.Subject == subj, :);
    idRows = subjRows(strcmpi(subjRows.Automaton, 'Categorization Identity'),:);
    andRows = subjRows(strcmpi(subjRows.Automaton, 'Categorization AND'),:);
    orRows = subjRows(strcmpi(subjRows.Automaton, 'Categorization OR'),:);
    xorRows = subjRows(strcmpi(subjRows.Automaton, 'Categorization XOR'),:);
    svRows = subjRows(strcmpi(subjRows.Automaton, 'Categorization Shepard V'),:);
    zP3_RF_CatCountTable(row,:) = table(subj,height(idRows),height(andRows),...
        height(orRows),height(xorRows),height(svRows),...
        'VariableNames',{'Subject','ID','AND','OR','xOR','ShepV'});
end
zP3_RF_CatCountTable
writetable(zP3_RF_CatCountTable, getFileNameForThisOS('2016_11_15-RF_Categorization.csv', 'IntResults'),'WriteRowNames',false);

clear delMe subjs row subj idRows andRows orRows xorRows svRows
clear zP3_RF_CatCountTable

% 5c: Categorization involving success on the test stimuli, rather than meeting criterion in the tasks 
delMe = zP3_CLT_trials_included(zP3_CLT_trials_included.TestStim == 1, :); % only grab the test stimuli for finished and included people
delMe2 = delMe(strcmpi(delMe.Visit, 'baseline'),:); % delMe2 (and even delMes) = the baseline data
delMe3 = delMe(strcmpi(delMe.Visit, 'followup'),:); % delMe3 (and odd delMes) = the followup data
[unique(delMe2.Subject) unique(delMe3.Subject)] % sanity check - this line will fail if there are different numbers of subjects
zP3_catTrialTestTable = table(0,{'popo'},0,0,0,'VariableNames',{'Subject','Training','BL_Success','FU_Success','Delta_Success'});
subjs = unique(delMe2.Subject);
for i = 1:length(unique(delMe2.Subject)) 
    subj = subjs(i);
    delMe4 = delMe2(delMe2.Subject == subj, :); % even = baseline
    delMe5 = delMe3(delMe3.Subject == subj, :); % odd = followup
    zP3_catTrialTestTable(i,:) = table(subj,delMe4.Training(1),...
        sum(delMe4.OutcomeInt),sum(delMe5.OutcomeInt),sum(delMe5.OutcomeInt) - sum(delMe4.OutcomeInt)...
        ,'VariableNames',{'Subject','Training','BL_Success','FU_Success','Delta_Success'});
end
zP3_catTrialTestTable
writetable(zP3_catTrialTestTable, getFileNameForThisOS('2016_11_6-Pilot3CategorizationTestSets_includedOnly.csv', 'IntResults'),'WriteRowNames',false);
clear i subjs subj delMe2 delMe3 delMe4 delMe5; % just temporary variables




% Step 6: EFs (by thirds)
getSingleEFmeasures_RF_2A(zRFP3_included, false, true); % prints it out also
% creates a file called "getSingleEFmeasures_RF_2A-output.csv"
% took this, put graphs in it; new name: "2016_11_15 - SingleEFmeasures_RF-Pilot3 - withGraphs.xlsx"

% Now get the "totals" overall
[~, upd_N2Trials, ~, ~] = getCleanUpdateTrials_RF_1A3('both', false, zRFP3_included, false);
[updAccSum, updAccThirds] = getNewAccuracy_RF_1A3(upd_N2Trials, false);
delMe = table(updAccThirds.Subject, updAccThirds.TotalAcc,'VariableNames',{'Subject','TotalUpdateAcc'});
[sw_switchTrials, sw_nonSwitchTrials, ~] = getCleanSwitchTrials_RF_1B(true, true, 'both', 'S', zRFP3_included, false);
[thirdsRT_swSwitch] = getNewRT_RF_1A3(sw_switchTrials, false);
[thirdsRT_swRepetition] = getNewRT_RF_1A3(sw_nonSwitchTrials, false);
delMe.TotalSC_RT = thirdsRT_swSwitch.TotalCorrect - thirdsRT_swRepetition.TotalCorrect;
[inh_goTrials, inh_inhibitTrials] = getCleanInhibitTrials_RF_1A3(true, 'GoBoth', 'correct', true, false, zRFP3_included);
[SSRTtable] = getSSRTthirds_RF_1B(inh_goTrials, inh_inhibitTrials, false, false);
delMe.TotalSSRT = SSRTtable.TotalSSRT;
writetable(delMe, getFileNameForThisOS('2016_11_18-Pilot3TotalSingleEFs.csv', 'IntResults'),'WriteRowNames',false);


clear upd_N2Trials updAccSum updAccThirds 
clear sw_switchTrials sw_nonSwitchTrials thirdsRT_swSwitch thirdsRT_swRepetition 
clear inh_goTrials inh_inhibitTrials SSRTtable



% Step 7: comparing GLM Ability to BOMAT
% need some way to figure out baseline Gf (MITRE?)
[zRFP3_BOMAT, zRFP3_BOMAT_sum, ~] = formTables_RF_1A3('Pilot3-1114/bomat-trials.xlsx', 'Pilot3-1114/bomat-sum.xlsx', '', true);
delMe =  excludeSubjects_RF_2AP3(true, true, true, true, zRFP3_BOMAT); % only take the RF groups
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.Problem delMe.RT];
P3_BOMATmodel = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Problem + RT','distr','binomial','CategoricalVars',[1],'VarNames',{'Subj','Problem','RT','Correct'})
printGLMcoeffs(P3_BOMATmodel, true);

delMe3 = [delMe.Subject delMe.RT];
P3_BOMATmodel2 = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + RT','distr','binomial','CategoricalVars',[1],'VarNames',{'Subj','RT','Correct'})
printGLMcoeffs(P3_BOMATmodel2, true);

% try it without the subjects in the 1500 range (seems to be something different about that site)
delMe = zRFP3_BOMAT;
delMe(delMe.Subject > 1499, :) = [];
delMe(strcmpi(delMe.Training,'sharp_training'), :) = [];
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.RT];
P3_BOMATmodel3 = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + RT','distr','binomial','CategoricalVars',[1],'VarNames',{'Subj','RT','Correct'})
%P3_BOMATmodel3.CoefficientNames(2:35)
tempTable = array2table(glmLabelsToNumbers(transpose(P3_BOMATmodel3.CoefficientNames(2:35))), 'VariableNames', {'Subject'});
tempTable.BOMATcoeff = P3_BOMATmodel3.Coefficients.Estimate(2:35);

delMe5 = zRFP3(zRFP3.StimShowTime < 4,:); % exclude unusual timeouts
delMe5 = [delMe5; zRFP3(strcmpi(zRFP3.Cluster,'Cat'),:)]; % but include categorization
delMe5(delMe5.Subject > 1499, :) = [];
delMe5(strcmpi(delMe5.Training,'sharp_training'), :) = [];
delMe5 = delMe5(strcmpi(delMe5.Status,'FINISHED'), :);

delMe2 = delMe5.Correct;
delMe3 = [delMe5.Subject delMe5.NbackDifficulty delMe5.SwitchFlag delMe5.InhibitDifficulty delMe5.numOfEFsInThisTrial delMe5.anyLogicFlag delMe5.TotalTrialCount delMe5.StimShowTime delMe5.RespTime delMe5.CatRule];
RF_EFmodel_2A_no1500s = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT + CatRule','distr','binomial','CategoricalVars',[1,2,3,5,6,8,10],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','CatRule','Correct'})
RF_EFmodel_2A_no1500s.CoefficientNames(2:35)
tempTable.RFcoeff = RF_EFmodel_2A_no1500s.Coefficients.Estimate(2:35);
corrcoef(tempTable.BOMATcoeff, tempTable.RFcoeff) % r = .4658
r(1,2)*r(1,2) % r^2 = .21






% Step 8: MITRE data
% first, create the zRFP3_MITRE table
warning('off','MATLAB:nonIntegerTruncatedInConversionToChar'); % suppress this known and non-helpful warning for these functions    
[~,~,rawData] = xlsread(getFileNameForThisOS('Pilot3-1114/Pilot3-Mitre-scores.xlsx', 'ParsedData'), 'MERGED'); 
rawData(1,1:end) = strrep(rawData(1,1:end), '-', ''); % remove all hyphens from the first row; table variable names can't have hyphens, apparently
rawData(1,1:end) = strrep(rawData(1,1:end), '#', ''); % remove all # from the first row; table variable names can't have #, apparently
rawData(1,1:end) = strrep(rawData(1,1:end), '(', '_'); % remove all # from the first row; table variable names can't have (), apparently
rawData(1,1:end) = strrep(rawData(1,1:end), ')', ''); % remove all # from the first row; table variable names can't have (), apparently
rawData(1,1:end) = strrep(rawData(1,1:end), '/', ''); % remove all / from the first row; table variable names can't have hyphens, apparently
% now find out if there are any hidden single spaces (damn you, excel) 
cellSize = size(rawData);
cellWidth = cellSize(2);
for colNum = 1:cellWidth
    col = rawData(:,colNum);
    spacesToKill = find(strcmpi(' ',col));
    rawData(spacesToKill,colNum) = {NaN};
end
zRFP3_MITRE = cell2table(rawData(2:end, 1:end), 'VariableNames', rawData(1,1:end)); % use the first row as the table col (variable) names
warning('on','MATLAB:nonIntegerTruncatedInConversionToChar'); % turn the warning back on, in case it's helpful for other functions later
zRFP3_MITRE.Properties.VariableNames{'Number'} = 'Subject'; % just because so many scripts take the variable name "Subject"
clear rawData cellSize cellWidth colNum col spacesToKill
zRFP3_MITRE_included = excludeSubjects_RF_2AP3(true, false, zRFP3_MITRE); % only take the finished subjects


delMe = excludeSubjects_RF_2AP3(true, true, zRFP3_MITRE); % only take the finished RF subjects
writetable(delMe, getFileNameForThisOS('2016_11_7-Pilot3MITREfinishedRF.csv', 'IntResults'),'WriteRowNames',false);
[zRFP3_BOMAT_sum, ~, ~] = formTables_RF_1A3('Pilot3-1114/bomat-sum.xlsx', '', '', true);
delMe2 =  excludeSubjects_RF_2AP3(true, true, zRFP3_BOMAT_sum); % only take the finished RF subjects
writetable(delMe2, getFileNameForThisOS('2016_11_7-Pilot3BOMATfinishedRF.csv', 'IntResults'),'WriteRowNames',false);




% Step 9: check for site-specific differences
% Clusters completed
[delMe, delMe2] = getClustersCompleted_perTimespan_2A(zRFP3_sum_included, true, 1, 8, true, true);
delMe = [delMe;delMe2]; % put the 2a and 1b together again
delMe.site = zeros(height(delMe),1);
%subjs = unique(delMe.Subject)
for row = 1:height(delMe)
    delMe.site(row) = ( delMe.Subject(row) - (1000 + mod(delMe.Subject(row), 100)) ) / 100;
end    
[p,tbl] = anova1(delMe.total,delMe.site,'off') % .15 - no differences
[p,tbl] = anova1(delMe.totalPerEFshift,delMe.site,'off') % .1699 - no differences

clear row p tbl
    
% GLM Ability
delMe = zRFP3_included(zRFP3_included.StimShowTime < 4,:); % exclude categorization (may also try: < 10)
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,8],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
%RF_EFmodel_2A.CoefficientNames(2:65) % - just the subjects
tempTable = array2table(glmLabelsToNumbers(transpose(RF_EFmodel_2A.CoefficientNames(2:65))), 'VariableNames', {'Subject'});
tempTable.Coeff = RF_EFmodel_2A.Coefficients.Estimate(2:65);
for row = 1:height(tempTable)
    tempTable.site(row) = ( tempTable.Subject(row) - (1000 + mod(tempTable.Subject(row), 100)) ) / 100;
end    
[p,tbl] = anova1(tempTable.Coeff,tempTable.site,'off') % .1443 - no differences

clear tempTable row p tbl

% Categorization - meeting criterion
delMe = zP3_catTaskTable; % defined above, if not already present
delMe.site = zeros(height(delMe),1);
%subjs = unique(delMe.Subject)
for row = 1:height(delMe)
    delMe.site(row) = ( delMe.Subject(row) - (1000 + mod(delMe.Subject(row), 100)) ) / 100;
end    
[p,tbl] = anova1(delMe.BL_Success,delMe.site,'off') % .0378 - check back on this
delMe2 = delMe(delMe.site == 1,:);
delMe3 = delMe(delMe.site == 3,:);
delMe4 = delMe(delMe.site == 5,:);
mean(delMe2.BL_Success) % 4.56
mean(delMe3.BL_Success) % 4.71
mean(delMe4.BL_Success) % 3.52
[p,tbl] = anova1(delMe.FU_Success,delMe.site,'off') % .9 - NO DIFFERENCE??!?
mean(delMe2.FU_Success) % 5.6
mean(delMe3.FU_Success) % 5.48
mean(delMe4.FU_Success) % 5.43
[p,tbl] = anova1(delMe.Delta_Success,delMe.site,'off') % .08 - difference?
mean(delMe2.Delta_Success) % 1.06
mean(delMe3.Delta_Success) % 0.7679
mean(delMe4.Delta_Success) % 1.9 (!!!!)

clear row p tbl

% Categorization - test set


% EFs
delMe = getSingleEFmeasures_RF_2A(zRFP3_included, false, false); 
delMe.site = zeros(height(delMe),1);
%subjs = unique(delMe.Subject)
for row = 1:height(delMe)
    delMe.site(row) = ( delMe.Subject(row) - (1000 + mod(delMe.Subject(row), 100)) ) / 100;
end    
[p,tbl] = anova1(delMe.FirstThirdAccSwitchCost,delMe.site,'off') % .6 - no difference
[p,tbl] = anova1(delMe.LastThirdAccSwitchCost,delMe.site,'off') % .6 - no difference
[p,tbl] = anova1(delMe.DeltaAccSwitchCost,delMe.site,'off') % .5058 - no difference
[p,tbl] = anova1(delMe.FirstThirdRTswitchCost,delMe.site,'off') % .8 - no difference
[p,tbl] = anova1(delMe.LastThirdRTswitchCost,delMe.site,'off') % .249 - no difference
[p,tbl] = anova1(delMe.DeltaRTswitchCost,delMe.site,'off') % .465 - no difference
[p,tbl] = anova1(delMe.FirstThirdUpdAccN2,delMe.site,'off') % .14 - no difference
[p,tbl] = anova1(delMe.LastThirdUpdAccN2,delMe.site,'off') % .136 - no difference
[p,tbl] = anova1(delMe.DeltaUpdAccN2,delMe.site,'off') % .47 - no difference
[p,tbl] = anova1(delMe.FirstThirdSSRT,delMe.site,'off') % .58 - no difference
[p,tbl] = anova1(delMe.LastThirdSSRT,delMe.site,'off') % .5898 - no difference
[p,tbl] = anova1(delMe.DeltaSSRT,delMe.site,'off') % .72 - no difference
delMe2 = delMe(delMe.site == 1,:);
delMe3 = delMe(delMe.site == 3,:);
delMe4 = delMe(delMe.site == 5,:);
mean(delMe2.FirstThirdUpdAccN2) % .80
mean(delMe3.FirstThirdUpdAccN2) % .6994
mean(delMe4.FirstThirdUpdAccN2) % .647
mean(delMe2.LastThirdUpdAccN2) % .828
mean(delMe3.LastThirdUpdAccN2) % .823
mean(delMe4.LastThirdUpdAccN2) % .738

% BOMAT
delMe = zRFP3_BOMAT_sum;
delMe.site = zeros(height(delMe),1);
%subjs = unique(delMe.Subject)
for row = 1:height(delMe)
    delMe.site(row) = ( delMe.Subject(row) - (1000 + mod(delMe.Subject(row), 100)) ) / 100;
end    
[p,tbl] = anova1(delMe.Accuracy,delMe.site,'off') % .35 - no difference
[p,tbl] = anova1(delMe.Attempted,delMe.site,'off') % .67 - no difference
[p,tbl] = anova1(delMe.Correct,delMe.site,'off') % .29 - no difference

% MITRE
delMe = zRFP3_MITRE;
delMe.site = zeros(height(delMe),1);
%subjs = unique(delMe.Subject)
for row = 1:height(delMe)
    delMe.site(row) = ( delMe.Subject(row) - (1000 + mod(delMe.Subject(row), 100)) ) / 100;
end    
[p,tbl] = anova1(delMe.FScore,delMe.site,'off') % .01 - check back on this
delMe2 = delMe(delMe.site == 1,:);
delMe3 = delMe(delMe.site == 3,:);
delMe4 = delMe(delMe.site == 5,:);
mean(delMe2.FScore) % 18.8
nanmean(delMe3.FScore) % 19.5
mean(delMe4.FScore) % 22.8
[p,tbl] = anova1(delMe.FScaled,delMe.site,'off') % .009 - check back on this
mean(delMe2.FScaled) % 2
nanmean(delMe3.FScaled) % 2.18
mean(delMe4.FScaled) % 3.28
[p,tbl] = anova1(delMe.LScore,delMe.site,'off') % .0001 - check back on this
mean(delMe2.LScore) % 12.7
nanmean(delMe3.LScore) % 10.56
mean(delMe4.LScore) % 8.17


% Noncompliance




% extra things to try:
% - look into just the test set for categorization
% - create a "GF Ability" GLM including info from MITRE and BOMAT
% - ask Umut about his HMM for predicting the rule that people are using in categorization 






% GLM Ability for the first two days of 1B (NOT PILOT 3!!!), for Karen
delMe = first_40_included;%(first_40_included.StimShowTime < 4,:); % exclude strange timeouts
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.RespTime];
RF_GLM_1B_first40 = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + EFcount + anyLogic + TrialCount + RT','distr','binomial','CategoricalVars',[1,2,3,4,5],'VarNames',{'Subj','Ndiff','SwRep','EFcount','anyLogic','TrialCount','RT','Correct'})
printGLMcoeffs(RF_GLM_1B_first40, true);

% Switch performance for the first two days of 1B (NOT PILOT 3!!!)
[sw_switchTrials, sw_nonSwitchTrials, sw_allTrials] = getCleanSwitchTrials_RF_1B(true, true, 'both', 'all', first_40_included, false);
[~, upd_N2Trials, ~, ~] = getCleanUpdateTrials_RF_1A3('both', false, first_40_included, false);
subjs = unique(sw_switchTrials.Subject);
tempTable = array2table(subjs, 'VariableNames', {'Subject'});
tempTable.SwCost = zeros(height(tempTable),1);
tempTable.UpdAcc = zeros(height(tempTable),1);
for row = 1:height(tempTable)
    subj = tempTable.Subject(row);
    subjReps = sw_nonSwitchTrials(sw_nonSwitchTrials.Subject == subj, :);
    subjRepsCorrect = subjReps(subjReps.Correct == 1, :);
    subjSwitches = sw_switchTrials(sw_switchTrials.Subject == subj, :);
    subjSwitchesCorrect = subjSwitches(subjSwitches.Correct == 1, :);
    tempTable.SwCost(row) = nanmean(subjRepsCorrect.RespTime) - nanmean(subjSwitchesCorrect.RespTime);
    
    subjN2 = upd_N2Trials(upd_N2Trials.Subject == subj, :);
    tempTable.UpdAcc(row) = nanmean(subjN2.Correct);
end
delMe = first_40_included(strcmpi(first_40_included.Cluster,'I'),:);
delMe2 = getSSRT_RF_1B(delMe, 'single', false, false, false);
tempTable.SSRT = delMe2.SSRT_est
writetable(tempTable, getFileNameForThisOS('2016_11_10-1B_firstTwoDays_Measures.csv', 'IntResults'),'WriteRowNames',false);

clear RF_GLM_1B_first40 sw_switchTrials sw_nonSwitchTrials sw_allTrials upd_N2Trials
clear subjs tempTable row subj subjReps subjRepsCorrect subjSwitches subjSwitchesCorrect subjN2





% Single-EF ranges for subjects in 1A3 (NOT PILOT 3!!!), for Jessamy
load('/Users/Shared/SHARP/ParsedData/zRF_1A3.mat')
[~, zRFSum_1A3, ~] = formTables_RF_1A3('', 'Trial3.rf-sum_final.xlsx', '', true);
zRF_1A3 = excludeSubjects_RF_1A3('both', true, zRF_1A3);
zRFSum_1A3 = excludeSubjects_RF_1A3('both', true, zRFSum_1A3);
subjs = unique(zRF_1A3.Subject);
tempTable = array2table(subjs, 'VariableNames', {'Subject'});
tempTable.Utrials = zeros(height(tempTable),1);
tempTable.Strials = zeros(height(tempTable),1);
tempTable.Itrials = zeros(height(tempTable),1);
tempTable.Ushifts = zeros(height(tempTable),1);
tempTable.Sshifts = zeros(height(tempTable),1);
tempTable.Ishifts = zeros(height(tempTable),1);
for row = 1:length(subjs)
    subj = subjs(row);
    subjTrials = zRF_1A3(zRF_1A3.Subject == subj, :);
    subjShifts = zRFSum_1A3(zRFSum_1A3.Subject == subj, :);
    subjItrials = subjTrials(strcmpi(subjTrials.Cluster, 'I'), :);
    subjUtrials = subjTrials(strcmpi(subjTrials.Cluster, 'U'), :);
    subjStrials = subjTrials(strcmpi(subjTrials.Cluster, 'S'), :);
    subjIshifts = subjShifts(strcmpi(subjShifts.Cluster, 'I'), :);
    subjUshifts = subjShifts(strcmpi(subjShifts.Cluster, 'U'), :);
    subjSshifts = subjShifts(strcmpi(subjShifts.Cluster, 'S'), :);
    tempTable.Itrials(row) = height(subjItrials);
    tempTable.Utrials(row) = height(subjUtrials);
    tempTable.Strials(row) = height(subjStrials);
    tempTable.Ishifts(row) = height(subjIshifts);
    tempTable.Ushifts(row) = height(subjUshifts);
    tempTable.Sshifts(row) = height(subjSshifts);
end

writetable(tempTable, getFileNameForThisOS('2016_11_29-1A3_singleEF_shiftTrialCount.csv', 'IntResults'),'WriteRowNames',false);

clear subjs row subj
clear subjTrials subjUtrials subjStrials subjItrials
clear subjShifts subjIshifts subjUshifts subjSshifts
clear tempTable zRF_1A3 zRFSum_1A3




% investigate exhaustion effects in 1B (NOT PILOT 3!!!)
load('/Users/Shared/SHARP/ParsedData/RFSum_1B_final-2015_10_29.mat')
zRFSum_1B_included = excludeSubjects_RF_1B(true, true, false, zRFSum_1B); % [tableWithoutExcludedSubjects] = excludeSubjects_RF_1B(justRF, onlyFinished, noChancePerformance, fullData)
% first, figure out whether people did worse on the last day of training
HalfPlusOneSD = 50 + std(zRFSum_1B_included.Accuracy,'omitnan');
rfPerfTable = table(0,0,0,0,0.0,'VariableNames',{'Subject','TrainingDay','TotalShifts','ShiftsNearChancePerf','PercentNearChance'});

nextRowToWrite = 1; % reset
subjects = unique(zRFSum_1B_included.Subject);
for row = 1:length(subjects)
    subj = subjects(row);
    subjRows = zRFSum_1B_included(zRFSum_1B_included.Subject == subj, :);
    days = unique(subjRows.Date);
    days = sort(days); % get them in order by date; this way i = the training day
    for i = 1:length(days)
        day = days(i);
        subjDayRows = subjRows(subjRows.Date == day, :);
        subjDayRowsNearChance = subjDayRows(subjDayRows.Accuracy < HalfPlusOneSD, :);
        
        rfPerfTable(nextRowToWrite,:) = table(subj, i, height(subjDayRows),...
            height(subjDayRowsNearChance),( height(subjDayRowsNearChance) / height(subjDayRows) ), ...
            'VariableNames',{'Subject','TrainingDay','TotalShifts','ShiftsNearChancePerf','PercentNearChance'});
        nextRowToWrite = nextRowToWrite + 1;
    end
end
nextRowToWrite = 1; % reset
worseOnLastDay = table(0,0.0,0.0,0,'VariableNames',{'Subject','AvgPctNearChance','PctNearChanceLastDay','WorseOnLastDay'});
for row = 1:length(subjects)
    subj = subjects(row);
    subjRows = rfPerfTable(rfPerfTable.Subject == subj, :);
    lastDay = max(subjRows.TrainingDay);
    worseOnLastDay(nextRowToWrite,:) = table(subj, mean(subjRows.PercentNearChance), ...
        subjRows(subjRows.TrainingDay == lastDay,:).PercentNearChance,...
        subjRows(subjRows.TrainingDay == lastDay,:).PercentNearChance > mean(subjRows.PercentNearChance), ...
        'VariableNames',{'Subject','AvgPctNearChance','PctNearChanceLastDay','WorseOnLastDay'});
    nextRowToWrite = nextRowToWrite + 1;
end
nextRowToWrite = 1; % reset
lastFiveShiftsTable = table(0,0,0.0,0,0.0,'VariableNames',{'Subject',...
    'TotalShiftsNearChance','TotalShiftsPctNearChance','LastShiftsNearChance','LastShiftsPctNearChance'});
for row = 1:length(subjects)
    subj = subjects(row);
    subjRows = zRFSum_1B_included(zRFSum_1B_included.Subject == subj, :);
    subjRowsNearChance = subjRows(subjRows.Accuracy < HalfPlusOneSD, :);
    days = unique(subjRows.Date);
    days = sort(days); % get them in order by date; this way i = the training day
    subjLastShiftsNearChance = [];
    subjDayRows = [];
    for i = 1:length(days)
        day = days(i);
        subjLastRows = subjRows(subjRows.Date == day, :);
        subjLastRows = subjLastRows(subjLastRows.ShiftNum > (max(subjLastRows.ShiftNum) - 5), :); % limit this to the last five shifts of the day
        subjDayRows = [subjDayRows; subjLastRows];
        subjLastShiftsNearChance = [subjLastShiftsNearChance; subjLastRows(subjLastRows.Accuracy < HalfPlusOneSD, :)];    
    end
    lastFiveShiftsTable(nextRowToWrite,:) = table(subj, height(subjRowsNearChance), ...
        ( height(subjRowsNearChance) / height(subjRows) ), ...
        height(subjLastShiftsNearChance), ( height(subjLastShiftsNearChance) / height(subjDayRows) ), ...
        'VariableNames',{'Subject','TotalShiftsNearChance','TotalShiftsPctNearChance',...
        'LastShiftsNearChance','LastShiftsPctNearChance'});
    nextRowToWrite = nextRowToWrite + 1;
end

writetable(worseOnLastDay, getFileNameForThisOS('2016_12_5-1B_RF_nearChance_perDay.csv', 'IntResults'),'WriteRowNames',false);
writetable(lastFiveShiftsTable, getFileNameForThisOS('2016_12_5-1B_RF_nearChance_lastShifts.csv', 'IntResults'),'WriteRowNames',false);

clear zRFSum_1B zRFSum_1B_included
clear HalfPlusOneSD nextRowToWrite subjects row subj subjRows subjRowsNearChance days i day 
clear lastDay subjLastRows subjLastShiftsNearChance subjDayRows subjDayRowsNearChance
clear rfPerfTable worseOnLastDay lastFiveShiftsTable







% investigate categorization timing
delMe = zRFP3_included(strcmpi(zRFP3_included.Cluster, 'cat'),:);
catTimingTable = table(0,0,{'test'},0.0,0.0,'VariableNames',{'Subject','ShiftNum','Automaton','Duration_s','Duration_m'});
nextRowToWrite = 1; % reset
subjs = unique(delMe.Subject);
for row = 1:length(subjs)
    subj = subjs(row);
    subjRows = delMe(delMe.Subject == subj, :);
    shiftNums = unique(subjRows.CumShiftNum);
    for row2 = 1:length(shiftNums)
        shiftNum = shiftNums(row2);
        shiftRows = subjRows(subjRows.CumShiftNum == shiftNum,:);
        firstShiftRow = shiftRows(1,:);
        lastShiftRow = shiftRows(height(shiftRows),:);
        shiftDuration = lastShiftRow.TrialTime - firstShiftRow.TrialTime;
        catTimingTable(nextRowToWrite,:) = table(subj,shiftNum,firstShiftRow.Automaton,...
            shiftDuration, shiftDuration / 60,...
            'VariableNames',{'Subject','ShiftNum','Automaton','Duration_s','Duration_m'});
        nextRowToWrite = nextRowToWrite + 1;
    end
end
catTimingTable(1:3,:) % just to see it
mean(catTimingTable.Duration_m) % 4.55 minutes
std(catTimingTable.Duration_m) % 1.65 minutes

clear nextRowToWrite subjs subj row subjRows shiftNums row2 
clear shiftNum shiftRows firstShiftRow lastShiftRow shiftDuration
clear delMe catTimingTable


    


% create a logistic per-shift difficulty table for Misha out of 1B data (NOT PILOT 3 DATA!!!) 
learningSpeed1BTable = table(0,{'test'},0,0,0,0.0,0.0,0.0,0.0,0,0,'VariableNames',...
    {'Subject','Shift','TrainingDay','CumShiftNum','DailyShiftNum','beta0',...
    'b0pVal','beta1','b1pVal','IterationLimit','PerfectSeparation'});
nextRowToWrite = 1; % NOTE: this should keep growing through zRF_1B_0_49, zRF_1B_50_99, etc! Do not reset it!!!

% NOTE: Only do one of these variables (e.g., zRF_1B_0_49, zRF_1B_50_99, etc.) at a time!!! They are too big to do all at once. 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-0_49-2015_10_29.mat') % variable: zRF_1B_0_49, subj 1 shiftNum 1 to subj 48 shiftNum 220
zRF_1B_0_49(1,:) % checking - subj 1 shiftNum 1
zRF_1B_0_49(end,:) % checking - subj 48 shiftNum 220
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_0_49); % have to change this line to zRF_1B_50_99 or whatever else we use
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-50_99-2015_10_29.mat') % variable: zRF_1B_50_99, subj 51 shiftNum 1 to subj 94 shiftNum 200
zRF_1B_50_99(1,:) % checking - subj 51 shiftNum 1
zRF_1B_50_99(end,:) % checking - subj 94 shiftNum 200
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_50_99); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-100_149-2015_10_29.mat') % variable: zRF_1B_100_149, subj 100 shiftNum 1 to subj 132 shiftNum 180
zRF_1B_100_149(1,:) % checking - subj 100 shiftNum 1
zRF_1B_100_149(end,:) % checking - subj 132 shiftNum 180
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_100_149); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-150_199-2015_10_29.mat') % variable: zRF_1B_150_199, but there are no such subjects
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-200_249-2015_10_29.mat') % variable: zRF_1B_200_249, subj 201 shiftNum 1 to subj 249 shiftNum 203
zRF_1B_200_249(1,:) % checking - subj 201 shiftNum 1
zRF_1B_200_249(end,:) % checking - subj 249 shiftNum 203
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_200_249); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-250_299-2015_10_29.mat') % variable: zRF_1B_250_299, subj 251 shiftNum 1 to subj 297 shiftNum 220
zRF_1B_250_299(1,:) % checking - subj 251 shiftNum 1
zRF_1B_250_299(end,:) % checking - subj 297 shiftNum 220
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_250_299); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-300_349-2015_10_29.mat') % variable: zRF_1B_200_249, subj 300 shiftNum 1 to subj 349 shiftNum 20
zRF_1B_300_349(1,:) % checking - subj 300 shiftNum 1
zRF_1B_300_349(end,:) % checking - subj 349 shiftNum 20(!)
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_300_349); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-350_399-2015_10_29.mat') % variable: zRF_1B_350_399, subj 350 shiftNum 1 to subj 356 shiftNum 225
zRF_1B_350_399(1,:) % checking - subj 350 shiftNum 1
zRF_1B_350_399(end,:) % checking - subj 356 shiftNum 225(!)
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_350_399); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-400_449-2015_10_29.mat') % variable: zRF_1B_400_449, subj 401 shiftNum 1 to subj 449 shiftNum 220
zRF_1B_400_449(1,:) % checking - subj 401 shiftNum 1
zRF_1B_400_449(end,:) % checking - subj 449 shiftNum 220
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_400_449); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-450_499-2015_10_29.mat') % variable: zRF_1B_450_499, subj 450 shiftNum 1 to subj 498 shiftNum 220
zRF_1B_450_499(1,:) % checking - subj 450 shiftNum 1
zRF_1B_450_499(end,:) % checking - subj 498 shiftNum 225(!)
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_450_499); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-500_549-2015_10_29.mat') % variable: zRF_1B_500_549, subj 500 shiftNum 1 to subj 510 shiftNum 218
zRF_1B_500_549(1,:) % checking - subj 500 shiftNum 1
zRF_1B_500_549(end,:) % checking - subj 510 shiftNum 218
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_500_549); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-550_599-2015_10_29.mat') % variable: zRF_1B_550_599, but there are no such subjects
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-600_649-2015_10_29.mat') % variable: zRF_1B_600_649, subj 602 shiftNum 1 to subj 649 shiftNum 200
zRF_1B_600_649(1,:) % checking - subj 602 shiftNum 1
zRF_1B_600_649(end,:) % checking - subj 649 shiftNum 200
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_600_649); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-650_699-2015_10_29.mat') % variable: zRF_1B_650_699, subj 651 shiftNum 1 to subj 698 shiftNum 209
zRF_1B_650_699(1,:) % checking - subj 651 shiftNum 1
zRF_1B_650_699(end,:) % checking - subj 698 shiftNum 209(!)
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_650_699); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-700_749-2015_10_29.mat') % variable: zRF_1B_700_749, subj 700 shiftNum 1 to subj 726 shiftNum 200
zRF_1B_700_749(1,:) % checking - subj 700 shiftNum 1
zRF_1B_700_749(end,:) % checking - subj 726 shiftNum 200
delMe = excludeSubjects_RF_1B(true, true, false, zRF_1B_700_749); 
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-750_799-2015_10_29.mat') % variable: zRF_1B_750_799, but there are no such subjects


subjs = unique(delMe.Subject);
for row = 1:length(subjs)
    subj = subjs(row);
    subjRows = delMe(delMe.Subject == subj, :);
    days = unique(subjRows.Date);
    days = sort(days); % get them in order by date; this way i = the training day
    for row2 = 1:length(days)
        date = days(row2);
        subjDayRows = subjRows(subjRows.Date == date,:);
        shiftNums = unique(subjDayRows.ShiftNum);
        shiftNumBeforeToday = min(shiftNums) - 1; % subtract this to find out how many shifts there were today
        for row3 = 1:length(shiftNums)
            shiftNum = shiftNums(row3);
            subjDayShiftRows = subjDayRows(subjDayRows.ShiftNum == shiftNum,:);
            shiftY = subjDayShiftRows.Correct; % now that we have the shift, do a logistic regression on it to get the slope
            shiftX = subjDayShiftRows.Problem; % only estimating a single slope and intercept right now
            shiftRegression = fitglm(shiftX,shiftY,'logit(Correct) ~ 1 + X','distr','binomial','VarNames',{'X','Correct'});
            % now, this fitglm sometimes throws two warnings
            iterationLimitWarning = 0; % assume no warning
            PerfectSeparationWarning = 0; % assume no warning
            [warnMsg, warnID] = lastwarn;
            if (~isempty(warnMsg)) % warnMsg is not empty; we have a warning
                if (strcmpi(warnMsg, 'Iteration limit reached.'))
                    iterationLimitWarning = 1;
                    warning(''); % clear lastwarn
                elseif (strcmpi(warnMsg(1:70), 'The estimated coefficients perfectly separate failures from successes.'))
                    PerfectSeparationWarning = 1;
                    warning(''); % clear lastwarn
                else % not one of these two expected warnings - something else
                    warnMsg
                    iterationLimitWarning = 999;
                    PerfectSeparationWarning = 999;
                end
            end
            learningSpeed1BTable(nextRowToWrite,:) = table(subj,subjDayShiftRows.Shift(1),row2,...
                subjDayShiftRows.ShiftNum(1), subjDayShiftRows.ShiftNum(1) - shiftNumBeforeToday,...
                shiftRegression.Coefficients.Estimate(1), shiftRegression.Coefficients.pValue(1),...
                shiftRegression.Coefficients.Estimate(2), shiftRegression.Coefficients.pValue(2),...
                iterationLimitWarning,PerfectSeparationWarning,...
                'VariableNames',{'Subject','Shift','TrainingDay','CumShiftNum',...
                'DailyShiftNum','beta0','b0pVal','beta1','b1pVal','IterationLimit','PerfectSeparation'});
            nextRowToWrite = nextRowToWrite + 1;
        end
    end
end

learningSpeed1BTable(351:355,:) % just to see it
height(learningSpeed1BTable) % should grow with every zRF_1B_0_49, zRF_1B_50_99, etc. (5562,9860,13544,18446)
learningSpeed1BTable(learningSpeed1BTable.IterationLimit == 1,:) % how many of these do we have?
learningSpeed1BTable(learningSpeed1BTable.PerfectSeparation == 1,:) % how many of these do we have?
learningSpeed1BTable(learningSpeed1BTable.PerfectSeparation == 999,:) % should be empty
% can clear these with each new zRF_1B_0_49, zRF_1B_50_99, etc.
clear delMe subjs subj row subjRows 
clear days row2 date subjDayRows
clear shiftNums shiftNumBeforeToday row3 shiftNum subjDayShiftRows
clear shiftY shiftX shiftRegression 
clear warnMsg warnID iterationLimitWarning PerfectSeparationWarning
% can clear these as soon as we're done with each
clear zRF_1B_0_49 zRF_1B_50_99 zRF_1B_100_149 zRF_1B_150_199 zRF_1B_200_249 
clear zRF_1B_250_299 zRF_1B_300_349 zRF_1B_350_399 zRF_1B_400_449 zRF_1B_450_499
clear zRF_1B_500_549 zRF_1B_550_599 zRF_1B_600_649 zRF_1B_650_699 zRF_1B_700_749 zRF_1B_750_799

% once you've gone through all the subjects variables, write the table (and save it, so you don't have to do this again!) 
writetable(learningSpeed1BTable, getFileNameForThisOS('2016_12_7-1B_RF_logisticRegPerShift.csv', 'IntResults'),'WriteRowNames',false);
save(getFileNameForThisOS('2016_12_7-1B_RF_logisticRegPerShift.mat', 'IntResults'), 'learningSpeed1BTable')

delMe = learningSpeed1BTable;
delMe(delMe.IterationLimit == 1, :) = []; % get rid of the ones that had warnings on the calculations
delMe(delMe.PerfectSeparation == 1, :) = [];  % get rid of the ones that had warnings on the calculations
delMe2 = delMe;
for row = 1:height(delMe2)
    if (delMe2.beta1(row) < 0)
        delMe2.beta1(row) = 0; % for Misha - assume nobody has negative learning
    end
end
avg1BLearningSpeed = table({'test'},0.0,0.0,0.0,'VariableNames',...
    {'Shift','avgBeta0','avgBeta1','avgBeta1_zeroNegatives'});
shifts = unique(delMe.Shift);
for row = 1:length(shifts)
    shift = shifts(row);
    shiftRows = delMe(strcmpi(delMe.Shift, shift),:);
    shiftRows_zeroNegatives = delMe2(strcmpi(delMe2.Shift, shift),:);
    avg1BLearningSpeed(row,:) = table(shift,mean(shiftRows.beta0),...
        mean(shiftRows.beta1),mean(shiftRows_zeroNegatives.beta1),...
        'VariableNames',{'Shift','avgBeta0','avgBeta1','avgBeta1_zeroNegatives'});
end
avg1BLearningSpeed
writetable(avg1BLearningSpeed, getFileNameForThisOS('2016_12_7-1B_RF_avgLearningSpeed.csv', 'IntResults'),'WriteRowNames',false);

clear delMe delMe2 row shift shifts shiftRows shiftRows_zeroNegatives

% be careful clearing these, as they take a long time to recreate
clear learningSpeed1BTable nextRowToWrite avg1BLearningSpeed





