

[zRFData_1A3, zRFSum_1A3, ~] = formTables_RF_1A3('Trial3.rf-data_final.xlsx', 'Trial3.rf-sum_final.xlsx', 'Trial3.rf-data_final.xlsx', true);

% zNOTE - you really need to read CSVs rather than XLSs; for these, you can just load in the vars from ParsedData 

% zNOTE2: in case we need to get the latest 1B data: look in "2015_4_26 compare Pretest to RF EFs script.m"...
%[zRFData_1B, zRFSum_1B, ~] = formTables_RF_1A3('1b-latest-Parsed.rf-data.xlsx', '1b-latest-Parsed.rf-sum.xlsx', '1b-latest-Parsed.rf-data.xlsx', true);
%[delMe, delMe2, ~] = formTables_RF_1A3('1b-latest-Parsed.robotfactory1.xlsx', '1b-latest-Parsed.robotfactory2.xlsx', '1b-latest-Parsed.rf-data.xlsx', true);
%zRFAll_1B = [delMe; delMe2];
%zRF_1B = putNewColsIntoDataTable_1B(zRFAll_1B);
%[zPPinhibit_1B, zPPswitch_1B, zPPupdate_1B] = formTables_RF_1A3('1b-latest-Parsed.inhibit.xlsx', '1b-latest-Parsed.switch.xlsx', '1b-latest-Parsed.rotation.xlsx', true);






includedSubjs_1A3 = excludeSubjects_RF_1A3('both', true, zRF_1A3); % pre-exclude for speed 

% All-subj Update GLM with TrialCount learning parameter, excluding a Cluster difficulty parameter  
updateDataRF = getAllUpdateTrials_1A3(includedSubjs_1A3, 'both', 'all', 'both');
[x_RFUpd_1A3, y_RFUpd_1A3] = getDataForUpdateGLM_1A3(updateDataRF, false, false, 'TrialCount', 'all', 'both');
RFUpdModel_1A3 = fitglm(x_RFUpd_1A3,y_RFUpd_1A3,'logit(Correct) ~ 1 + Subj + Nval + TrialCount - Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','Nval','RT','TrialCount','Cluster','Correct'})
printGLMcoeffs(RFUpdModel_1A3, true);
% All-subj Switch GLM with TrialCount learning parameter, excluding a Cluster difficulty parameter  
switchDataRF = getAllSwitchTrials_1A3(includedSubjs_1A3, 'both', 'all', 'both'); 
[x_RFSw_1A3, y_RFSw_1A3] = getDataForSwitchGLM_1A3(switchDataRF, false, false, 'TrialCount', 'all', 'both');
RFSwModel_1A3 = fitglm(x_RFSw_1A3,y_RFSw_1A3,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount - Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','Correct'})
printGLMcoeffs(RFSwModel_1A3, true);


% GLM for ALL EFs for ALL SUBJECTS for 1A3
y_RFall_1A3 = zRF_1A3.Correct;
x_RFall_1A3 = [zRF_1A3.Subject zRF_1A3.NbackDifficulty zRF_1A3.SwitchFlag zRF_1A3.InhibitDifficulty zRF_1A3.numOfEFsInThisTrial zRF_1A3.anyLogicFlag zRF_1A3.SwitchHandsFlag zRF_1A3.TotalTrialCount zRF_1A3.StimShowTime zRF_1A3.RespTime];
RF_EFmodel_1A3 = fitglm(x_RFall_1A3,y_RFall_1A3,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + SwHands + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,7,9],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','SwHands','TrialCount','Timeout','RT','Correct'})
printGLMcoeffs(RF_EFmodel_1A3, true);
    % compare to # of clusters completed...
    [delMe, delMe2] = getClustersCompleted_1A3(zRF_1A3);
    delMe3 = getFileNameForThisOS('clustersCompleted_allSubj_1A3.csv', 'IntResults');
    writetable(delMe2, delMe3);
% GLM for ALL EFs for INCLUDED SUBJECTS for 1A3
y_RFall_1A3 = includedSubjs_1A3.Correct;
x_RFall_1A3 = [includedSubjs_1A3.Subject includedSubjs_1A3.NbackDifficulty includedSubjs_1A3.SwitchFlag includedSubjs_1A3.InhibitDifficulty includedSubjs_1A3.numOfEFsInThisTrial includedSubjs_1A3.anyLogicFlag includedSubjs_1A3.SwitchHandsFlag includedSubjs_1A3.TotalTrialCount includedSubjs_1A3.StimShowTime includedSubjs_1A3.RespTime];
RF_EFmodel_1A3 = fitglm(x_RFall_1A3,y_RFall_1A3,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + SwHands + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,7,9],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','SwHands','TrialCount','Timeout','RT','Correct'})
printGLMcoeffs(RF_EFmodel_1A3, true);
    % compare to # of clusters completed...
    [delMe, delMe2] = getClustersCompleted_1A3(includedSubjs_1A3);
    delMe3 = getFileNameForThisOS('clustersCompleted_incSubj_1A3.csv', 'IntResults');
    writetable(delMe2, delMe3);
    
    
    

% GLM for ALL EFs for ALL SUBJECTS for 1B --- ZEPHY!! WE DON'T HAVE THESE DATA IN zRF_1B YET!!! 
% Z NOTE - THIS TAKES A LONG TIME; ONLY RUN ONCE:    zRF_1B = putNewColsIntoDataTable_1B(zRFAll_1B); 
y_RFall_1B = zRF_1B.Correct;
x_RFall_1B = [zRF_1B.Subject zRF_1B.NbackDifficulty zRF_1B.SwitchFlag zRF_1B.InhibitDifficulty zRF_1B.numOfEFsInThisTrial zRF_1B.anyLogicFlag zRF_1B.SwitchHandsFlag zRF_1B.TotalTrialCount zRF_1B.StimShowTime zRF_1B.RespTime];
RF_EFmodel_1B = fitglm(x_RFall_1B,y_RFall_1B,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + SwHands + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,7,9],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','SwHands','TrialCount','Timeout','RT','Correct'})
printGLMcoeffs(RF_EFmodel_1B, true);
    % compare to # of clusters completed...
    getClustersCompleted_1B(zRFSum_1B, true); % this prints to a file as well

    
    
    

% 1B GLM plots
includedSubjs_1B = excludeSubjects_RF_1B(true, zRF_1B); % pre-exclude for speed 

% All-subj Update GLM with TrialCount learning parameter and a Cluster difficulty parameter  
[x_RFUpd_1B, y_RFUpd_1B] = getDataForUpdateGLM_1A3(includedSubjs_1B, false, false, 'TrialCount', 'all', 'both');
RFUpdModel_1B = fitglm(x_RFUpd_1B,y_RFUpd_1B,'logit(Correct) ~ 1 + Subj + Nval + TrialCount + Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','Nval','RT','TrialCount','Cluster','Correct'})
printGLMcoeffs(RFUpdModel_1B, true);
% All-subj Switch GLM with TrialCount learning parameter and a Cluster difficulty parameter  
[x_RFSw_1B, y_RFSw_1B] = getDataForSwitchGLM_1A3(includedSubjs_1B, false, false, 'TrialCount', 'all', 'both');
RFSwModel_1B = fitglm(x_RFSw_1B,y_RFSw_1B,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount + Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','Correct'})
printGLMcoeffs(RFSwModel_1B, true);







% 1B Ability plots for Switch and Update: histograms
delMe = RFSwModel_1B.Coefficients.Estimate(2:(end-5),1);
delBins = [-.75 -.65 -.55 -.45 -.35 -.25 -.15 -0.05 0.05 0.15 0.25 0.35 0.45 0.55 0.65 0.75];
delMe = delMe + 1; % add a constant to make all ability values positive
delBins = delBins + 1;  % add a constant to make all values positive
hist(delMe(2:37), delBins,'FontSize',14,'LineWidth',2);
axis([0 2 -inf inf]);
title('1B: ability coefficients from Switch GLM (Single and Dual EF) for each subject')
xlabel('Switch Ability')
ylabel('Number of participants in this Ability range')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
% Update...
delMe2 = RFUpdModel_1B.Coefficients.Estimate(2:(end-6),1);
delMe2 = delMe2 + 1; % add a constant to make all ability values positive
hist(delMe2, delBins);
axis([0 2 -inf inf]);
title('1B: ability coefficients from Update GLM (Single and Dual EF) for each subject')
xlabel('Update Ability')
ylabel('Number of participants in this Ability range')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)


% 1B: Difficulty plots - Switch first
delMe3 = length(RFSwModel_1B.Coefficients.Estimate) - 4; % index of the RepetitionTrials coefficient
delMe = [0 RFSwModel_1B.Coefficients.Estimate(delMe3,1)];
delMe = delMe * -1; % invert the values so higher means more difficult (more intuitive)
delMe = delMe + 1; % add a constant to make all difficulty values positive
bar(delMe);
set(gca,'XTickLabel',{'Switch Trials' 'Repetition Trials'})
str = sprintf('Difficulty coefficients from Switch GLM\n(Single and Dual EF) over all subjects');
title(str)
xlabel('Type of trial')
str = sprintf('Difficulty\n(higher is more difficult)');
ylabel(str) % after we multiply by -1...
% ylabel('Difficulty (higher is easier)')
set(findall(gca,'type','text'),'FontSize',34)
set(findall(gca,'type','axes'),'FontSize',34)
axis([-inf inf 0 2]); % if you're not adding 1, this should be -1 to 1
% Update
delMe3 = length(RFUpdModel_1B.Coefficients.Estimate) - 5; % index of the N=2 coefficient
delMe2 = [0 RFUpdModel_1B.Coefficients.Estimate(delMe3,1) RFUpdModel_1B.Coefficients.Estimate(delMe3+1,1)];
delMe2 = delMe2 * -1; % invert the values so higher means more difficult (more intuitive)
delMe2 = delMe2 + 1; % add a constant to make all difficulty values positive
bar(delMe2);
set(gca,'XTickLabel',{'N = 1' 'N = 2' 'N = 3'})
str = sprintf('Difficulty coefficients from Update GLM\n(Single and Dual EF) over all subjects');
title(str)
xlabel('Type of trial')
str = sprintf('Difficulty\n(higher is more difficult)');
ylabel(str) % after we multiply by -1...
% ylabel('Difficulty (higher is easier)')
set(findall(gcf,'type','text'),'FontSize',34)
set(findall(gcf,'type','axes'),'FontSize',34)
axis([-inf inf 0 2]); % if you're not adding 1, this should be -1 to 1





% 1B: Difficulty plots for dual and single tasks (clusters) - Switch first
delMe3 = length(RFSwModel_1B.Coefficients.Estimate) - 1; % index of the 'Switch | Inhibit' coefficient
delMe = [0 RFSwModel_1B.Coefficients.Estimate(delMe3,1) RFSwModel_1B.Coefficients.Estimate(delMe3+1,1)];
delMe = delMe * -1; % invert the values so higher means more difficult (more intuitive)
delMe = delMe + 1; % add a constant to make all difficulty values positive
bar(delMe);
set(gca,'XTickLabel',{'Switch only' 'Switch | Inhibit' 'Switch | Update'})
str = sprintf('Difficulty coefficients from Switch GLM\n(Single and Dual EF) over all subjects');
title(str)
xlabel('Type of trial')
str = sprintf('Difficulty\n(higher is more difficult)');
ylabel(str) % after we multiply by -1...
% ylabel('Difficulty (higher is easier)')
set(findall(gca,'type','text'),'FontSize',34)
set(findall(gca,'type','axes'),'FontSize',34)
axis([-inf inf 0 3]); 
% Update...
delMe3 = length(RFUpdModel_1B.Coefficients.Estimate) - 1; % index of the 'Switch | Inhibit' coefficient
delMe2 = [0 RFUpdModel_1B.Coefficients.Estimate(delMe3,1) RFUpdModel_1B.Coefficients.Estimate(delMe3+1,1)];
delMe2 = delMe2 * -1; % invert the values so higher means more difficult (more intuitive)
delMe2 = delMe2 + 1; % add a constant to make all difficulty values positive
bar(delMe2);
set(gca,'XTickLabel',{'Update only' 'Update | Inhibit' 'Update | Switch'})
str = sprintf('Difficulty coefficients from Update GLM\n(Single and Dual EF) over all subjects');
title(str)
xlabel('Type of trial')
str = sprintf('Difficulty\n(higher is more difficult)');
ylabel(str) % after we multiply by -1...
% ylabel('Difficulty (higher is easier)')
set(findall(gcf,'type','text'),'FontSize',34)
set(findall(gcf,'type','axes'),'FontSize',34)
axis([-inf inf 0 3]); 
% 1B: comparing single- to dual-task InhDifficulty
delMe2 = zRF_1B_extraCols(strcmpi(zRF_1B_extraCols.Cluster,'I'),:);
delMe3 = zRF_1B_extraCols(strcmpi(zRF_1B_extraCols.Cluster,'U/I'),:);
delMe4 = zRF_1B_extraCols(strcmpi(zRF_1B_extraCols.Cluster,'S/I'),:);
delMe = [mean(delMe2.InhibitDifficulty) mean(delMe3.InhibitDifficulty) mean(delMe4.InhibitDifficulty)];
bar(delMe);
set(gca,'XTickLabel',{'Inhibit only' 'Inhibit | Update' 'Inhibit | Switch'})
str = sprintf('Inhibit SSD during InhTrials\n(Single and Dual EF) over all subjects');
title(str)
xlabel('Type of trial')
str = sprintf('Stop Signal Delay (ms)');
ylabel(str) % after we multiply by -1...
% ylabel('Difficulty (higher is easier)')
set(findall(gcf,'type','text'),'FontSize',34)
set(findall(gcf,'type','axes'),'FontSize',34)
axis([-inf inf 0 .15]); 





zRF_1B_extraCols.InhibitDifficulty
%delMe = getSSRT_RF_1B(includedSubjs_1B, 'single', false);
%delMe2 = getSSRT_RF_1B(includedSubjs_1B, 'dual', false);




% 1B: comparing Switch to Update Ability (GLM)
delMe3 = length(RFSwModel_1B.Coefficients.Estimate) - 4; % index of the RepetitionTrials coefficient
delMe = RFSwModel_1B.Coefficients.Estimate(2:(delMe3-1),1); % just the Ability scores
delMe3 = length(RFUpdModel_1B.Coefficients.Estimate) - 5; % index of the N=2 coefficient
delMe2 = RFUpdModel_1B.Coefficients.Estimate(2:(delMe3-1),1); % just the Ability scores
delMe = delMe + abs(min([delMe;delMe2])); % add a constant to make all difficulty values positive
delMe2 = delMe2 + abs(min([delMe;delMe2])); % add a constant to make all difficulty values positive
delMax = max(max(delMe), max(delMe2));
scatter(delMe, delMe2, 'MarkerEdgeColor', 'blue')
axis([0 delMax 0 delMax]);
h = lsline; % add a least-suqres regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(delMe, delMe2,1); % grab the equation
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(mean(delMe), mean(delMe2)-.5, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(delMe,delMe2,'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(mean(delMe), mean(delMe2)-.7, delStr, 'FontSize', 14);
str = sprintf('Ability Coeffs from Update and Switch GLMs\n(Single and Dual EF) for each subject');
title(str)
xlabel('Switch')
ylabel('Update')
set(findall(gca,'type','text'),'FontSize',34)
set(findall(gca,'type','axes'),'FontSize',34)







% 1B: comparing Pretest to First Few Trials of RF

% 1B: Compare Switch RF Ability (first few trials) (from GLM) with Switch Pretest Ability (from GLM) 
% quick hack to get rid of a few participants, because they're not in the RF data for some reason... 
delMe4 = zPPswitch_1B; 
delMe4(delMe4.Subject == 990083, :) = [];
delMe4(delMe4.Subject == 990093, :) = [];
delMe4(delMe4.Subject == 990417, :) = [];
delMe4(delMe4.Subject == 990587, :) = [];
delMe4(delMe4.Subject == 990690, :) = [];
delMe4(delMe4.Subject == 990756, :) = [];
delMe3 = zRF_1B_extraCols; 
delMe3(delMe3.Subject == 990093, :) = [];
delMe3(delMe3.Subject == 990311, :) = [];
delMe3(delMe3.Subject == 990474, :) = [];
[x_PPSw_1B, y_PPSw_1B] = getDataForPreSwitchGLM(delMe4, '1B', false);
PPSwModel_1B = fitglm(x_PPSw_1B,y_PPSw_1B,'logit(Correct) ~ 1 + Subj + SwRep + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','Correct'})

delShifts = 3; % select the number of shifts you want to use
first3SwShifts = getSomeRFshifts(delMe3, delShifts, 'S', 'first');
switchDataRF = getAllSwitchTrials_1A3(first3SwShifts, 'both', 'S', 'single'); % now clean the trials from the first 3 switch shifts
[x_RFSw_1B_first3, y_RFSw_1B_first3] = getDataForSwitchGLM(switchDataRF, '1B', false, 'TrialCount', 'all', 'single');
RFSwModel_1B_first3 = fitglm(x_RFSw_1B_first3,y_RFSw_1B_first3,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount - Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','Correct'})

delMe = min(length(PPSwModel_1B.CoefficientNames), length(RFSwModel_1B_first3.CoefficientNames)); 
delMe2 = [transpose(PPSwModel_1B.CoefficientNames(1:delMe)) transpose(RFSwModel_1B_first3.CoefficientNames(1:delMe))] % make sure they match!!
% ZEPHY: STOP HERE AND MAKE SURE THE TWO MATRICES MATCH. IF THEY DON'T, CHANGE excludeSubjects_RF_1B() TO MAKE THEM MATCH.

delMe = RFSwModel_1B_first3.Coefficients.Estimate(:,1);
delMeEnd = length(delMe) - 3; % total length - SwRep, RT, TrialCount
delMe2 = PPSwModel_1B.Coefficients.Estimate(:,1);
delMe2End = length(delMe2) - 2; % total length - SwRep, RT
scatter(delMe(2:delMeEnd), delMe2(2:delMe2End), 'MarkerEdgeColor', 'blue') % RF has TrialCount, so has one more parameter (hence the -3 rather than -2)
h = lsline; % add a least-squares regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(delMe(2:delMeEnd), delMe2(2:delMe2End),1); % RF has TrialCount, so has one more parameter (hence the -3 rather than -2)
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(mean(delMe), mean(delMe2)-1, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(delMe(2:delMeEnd),delMe2(2:delMe2End),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(mean(delMe), mean(delMe2)-2, delStr, 'FontSize', 14);
str = sprintf('Ability Coeffs from RF (first %d shifts) and Pretest Switch GLMs for each subject', delShifts);
title(str)
xlabel('RF Switch Ability')
ylabel('Pretest Switch Ability')
set(findall(gca,'type','text'),'FontSize',24)
set(findall(gca,'type','axes'),'FontSize',24)




% 1B: Compare SSRT from RF (first few trials) to SSRT from Pretest
delMe4 = excludeSubjects_RF_1B(true, zPPinhibit_1B); % quick hack to get rid of people that aren't in the RF data for some reason 
delMe4(delMe4.Subject == 990083, :) = [];
delMe4(delMe4.Subject == 990093, :) = [];
delMe4(delMe4.Subject == 990311, :) = [];
delMe4(delMe4.Subject == 990417, :) = [];
delMe4(delMe4.Subject == 990587, :) = [];
delMe4(delMe4.Subject == 990690, :) = [];
delMe4(delMe4.Subject == 990756, :) = [];
delMe4(delMe4.Subject == 990090, :) = [];
delMe4(delMe4.Subject == 990212, :) = [];
delMe4(delMe4.Subject == 990475, :) = [];
delMe4(delMe4.Subject == 990649, :) = [];
delMe4(delMe4.Subject == 990654, :) = [];
[SSRT_PP_table] = getSSRT_PP_1B(delMe4, false); % make this last input "true" if you want this printed out

numberOfShiftsToInclude = 3;
delMe3(delMe3.Subject == 990090, :) = [];
delMe3(delMe3.Subject == 990212, :) = [];
delMe3(delMe3.Subject == 990475, :) = [];
delMe3(delMe3.Subject == 990649, :) = [];
delMe3(delMe3.Subject == 990654, :) = [];
[includedRFinhibit] = getSomeRFshifts(delMe3, numberOfShiftsToInclude, 'all', 'first');
[SSRT_RF_firstShifts_table] = getSSRT_RF_1B(includedRFinhibit, 'single', false);  % make this last input "true" if you want this printed out

if (height(SSRT_RF_firstShifts_table) ~= height(SSRT_PP_table))
    fprintf('We have %d subjects for pretest and %d subjects for RF. Fix excludeSubjects_RF_1B() and re-run.', height(SSRT_PP_table), height(SSRT_RF_firstShifts_table));
end

CompareSSRT_RF_Pretest = [SSRT_PP_table.Subject SSRT_RF_firstShifts_table.SSRT_est SSRT_PP_table.PreSSRT]; % NOTE: if you look at this, it'll look like the second and third columns are all 0s, but they're not!
% just to see if the two RF calculations correlate.....    CompareSSRT_RF_Pretest = [SSRT_PP_table.Subject inh_SSRT_thirds_RF_1B.FirstThirdSSRT SSRT_RF_firstShifts_table.SSRT_est]; % NOTE: if you look at this, it'll look like the second and third columns are all 0s, but they're not!

scatter(CompareSSRT_RF_Pretest(:,2), CompareSSRT_RF_Pretest(:,3), 'MarkerEdgeColor', 'blue') 
h = lsline; % add a least-squares regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(CompareSSRT_RF_Pretest(:,2), CompareSSRT_RF_Pretest(:,3),1); % RF has TrialCount, so has one more parameter (hence the -3 rather than -2)
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(mean(CompareSSRT_RF_Pretest(:,2))+.2, mean(CompareSSRT_RF_Pretest(:,3))+.3, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(CompareSSRT_RF_Pretest(:,2),CompareSSRT_RF_Pretest(:,3),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(mean(CompareSSRT_RF_Pretest(:,2))+.2, mean(CompareSSRT_RF_Pretest(:,3))+.4, delStr, 'FontSize', 14);
str = sprintf('SSRT from first third of RF Inhibit trials compared to Pretest Inhibit');
title(str)
xlabel('RF first-third SSRT (ms)')
ylabel('Pretest SSRT (ms)')
set(findall(gca,'type','text'),'FontSize',24)
set(findall(gca,'type','axes'),'FontSize',24)







