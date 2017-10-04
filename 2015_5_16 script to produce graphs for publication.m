% Zephy McKanna
% script to produce useful graphs for publication
% 4/16/15


% All-subj Update GLM with TrialCount learning parameter and a Cluster difficulty parameter (used for Ability and Difficulty plots) 
[x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(includedSubjs, false, false, 'TrialCount', 'all', 'both');
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + TrialCount + Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','Nval','RT','TrialCount','Cluster','Correct'})
printGLMcoeffs(RFUpdModel, true);

% All-subj Switch GLM with TrialCount learning parameter and a Cluster difficulty parameter (used for Ability and Difficulty plots)  
[x_RFSw, y_RFSw] = getDataForSwitchGLM_1A3(includedSubjs, false, false, 'TrialCount', 'all', 'both');
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount + Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','Correct'})
printGLMcoeffs(RFSwModel, true);


% Ability plot: comparing ability of Update vs Switch
delMe = RFSwModel.Coefficients.Estimate(:,1);
delMe2 = RFUpdModel.Coefficients.Estimate(:,1);
delMin = min(min(delMe), min(delMe2));
delMe = delMe + (delMin * -1) + 1; % add a constant to make all values positive
delMe2 = delMe2 + (delMin * -1) + 1; % add a constant to make all values positive
delMax = max(max(delMe), max(delMe2));
scatter(delMe(2:37), delMe2(2:37), 'MarkerEdgeColor', 'blue')
axis([0 delMax 0 delMax]);
h = lsline; % add a least-suqres regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(delMe(2:37), delMe2(2:37),1); % grab the equation
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(mean(delMe), mean(delMe2)-1, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(delMe(2:37),delMe2(2:37),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(mean(delMe), mean(delMe2)-2, delStr, 'FontSize', 14);
str = sprintf('Ability Coeffs from Update and Switch GLMs\n(Single and Dual EF) for each subject');
title(str)
xlabel('Switch')
ylabel('Update')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)


% Difficulty plots
delMe = [0 RFSwModel.Coefficients.Estimate(38,1)]; % 0 = switch diff, (38,1) = rep diff
delMe = delMe * -1; % invert the values so higher means more difficult (more intuitive)
delMe = delMe + 1; % add a constant to make all difficulty values positive
delMe2 = [0 RFUpdModel.Coefficients.Estimate(38,1) RFUpdModel.Coefficients.Estimate(39,1)]; % 0 = N1, (38,1) = N2, (39,1) = N3
delMe2 = delMe2 * -1; % invert the values so higher means more difficult (more intuitive)
delMe2 = delMe2 + 1; % add a constant to make all difficulty values positive
delMax = max(max(delMe), max(delMe2));

bar(delMe); % bar plot for Sw/Rep diff
set(gca,'XTickLabel',{'Switch Trials' 'Repetition Trials'})
str = sprintf('Difficulty coefficients from Switch GLM\n(Single and Dual EF) over all subjects');
title(str)
xlabel('Type of trial')
str = sprintf('Difficulty\n(higher is more difficult)'); % now that we multiplied by -1...
ylabel(str) 
% ylabel('Difficulty (higher is easier)')
set(findall(gca,'type','text'),'FontSize',34)
set(findall(gca,'type','axes'),'FontSize',34)
axis([-inf inf 0 delMax]); 

bar(delMe2); % bar plot for N=1/2/3 diff
set(gca,'XTickLabel',{'N = 1' 'N = 2' 'N = 3'})
str = sprintf('Difficulty coefficients from Update GLM\n(Single and Dual EF) over all subjects');
title(str)
xlabel('Type of trial')
str = sprintf('Difficulty\n(higher is more difficult)'); % now that we multiplied by -1...
ylabel(str)
% ylabel('Difficulty (higher is easier)')
set(findall(gcf,'type','text'),'FontSize',34)
set(findall(gcf,'type','axes'),'FontSize',34)
axis([-inf inf 0 delMax]); 

% Difficulty plots for different clusters
delMe = [0 RFSwModel.Coefficients.Estimate(41,1) RFSwModel.Coefficients.Estimate(42,1)]; % 0 = S, (41,1) = S|I, (42,1) = S|U
delMe = delMe * -1; % invert the values so higher means more difficult (more intuitive)
delMe = delMe + 1; % add a constant to make all difficulty values positive
delMe2 = [0 RFUpdModel.Coefficients.Estimate(42,1) RFUpdModel.Coefficients.Estimate(43,1)]; % 0 = U, (42,1) = U|I, (43,1) = U|S
delMe2 = delMe2 * -1; % invert the values so higher means more difficult (more intuitive)
delMe2 = delMe2 + 1; % add a constant to make all difficulty values positive
delMax = max(max(delMe), max(delMe2));

bar(delMe);
set(gca,'XTickLabel',{'Switch only' 'Switch | Inhibit' 'Switch | Update'})
str = sprintf('Difficulty coefficients from Switch GLM\n(Single and Dual EF) over all subjects');
title(str)
xlabel('Type of trial')
str = sprintf('Difficulty\n(higher is more difficult)');
ylabel(str) 
% ylabel('Difficulty (higher is easier)')
set(findall(gca,'type','text'),'FontSize',34)
set(findall(gca,'type','axes'),'FontSize',34)
axis([-inf inf 0 delMax]); 

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
axis([-inf inf 0 delMax]); 









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

