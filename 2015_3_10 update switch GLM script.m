% Zephy McKanna
% Script to create and display Switch and Update GLMs
% 3/10/15

% in case we need to get the latest 1B data: look in "2015_4_26 compare Pretest to RF EFs script.m"...
%[zRFData_1B, zRFSum_1B, zRFAll_1B] = formTables_RF_1A3('1b-latest-Parsed.rf-data.xlsx', '1b-latest-Parsed.rf-sum.xlsx', '1b-latest-Parsed.robotfactory.xlsx', false);
%[zPPinhibit_1B, zPPswitch_1B, zPPupdate_1B] = formTables_RF_1A3('1b-latest-Parsed.inhibit.xlsx', '1b-latest-Parsed.switch.xlsx', '1b-latest-Parsed.rotation.xlsx', true);


% Switch GLM without TrialCount (learning)
[x_PreSw, y_PreSw] = getDataForPreSwitchGLM_1A3(zPPswitch_1A3, true, false);
PreSwModel = fitglm(x_PreSw,y_PreSw,'linear','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','Correct'})
[x_RFSw, y_RFSw] = getDataForSwitchGLM_1A3(zRFAll_1A3, true, false, false, false);
RFSwModel = fitglm(x_RFSw,y_RFSw,'linear','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','Correct'})

% Switch plot
delMe = RFSwModel.Coefficients.Estimate(:,1);
delMe2 = PreSwModel.Coefficients.Estimate(:,1);
scatter(delMe(2:37), delMe2(2:37), 'MarkerEdgeColor', 'blue')
lsline; % add a least-suqres regression line just for the ability coefficients
[delP, delS] = polyfit(delMe(2:37), delMe2(2:37),1); % grab the equation
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(0, 0, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(delMe(2:37),delMe2(2:37),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(0, -.5, delStr, 'FontSize', 14);
hold on;
scatter(delMe(1), delMe2(1), 'MarkerEdgeColor', 'cyan') % add the GLM Intercept
scatter(delMe(38), delMe2(38), 'MarkerEdgeColor', 'magenta') % add the repetition trials coefficient
scatter(delMe(39), delMe2(39), 'MarkerEdgeColor', 'red') % add the reaction time coefficient
title('Switch Coeffs from GLM: Intercept = cyan, Ability = blue, RepTrials = magenta, ReactionTime = red')
xlabel('RobotFactory Switch only')
ylabel('Pretest Switch')
hold off;

% Update GLM
[x_PreUpd, y_PreUpd] = getDataForPreUpdateGLM_1A3(zPPupdate_1A3, true, false);
PreUpdModel = fitglm(x_PreUpd,y_PreUpd,'logit(Correct) ~ 1 + Subj - Memback + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','Memback','RT','Correct'}) % note that I created a categorical variable to tell us how far back in memory any given thing is, but this model doesn't use it. Change the '-' to '+' before 'Memback' to put it back in.
[x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(zRFAll_1A3, true, false, false);
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'linear','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','Nval','RT','Correct'})

% Update plot
delMe = RFUpdModel.Coefficients.Estimate(:,1);
delMe2 = PreUpdModel.Coefficients.Estimate(:,1);
scatter(delMe(2:37), delMe2(2:37), 'MarkerEdgeColor', 'blue')
lsline; % add a least-suqres regression line just for the ability coefficients
[delP, delS] = polyfit(delMe(2:37), delMe2(2:37),1); % grab the equation
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(1, -1.65, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(delMe(2:37),delMe2(2:37),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(1, -2, delStr, 'FontSize', 14);
hold on;
scatter(delMe(1), delMe2(1), 'MarkerEdgeColor', 'cyan') % add the Intercept point, just for interest
scatter(delMe(40), delMe2(38), 'MarkerEdgeColor', 'red') % add the reaction time coefficient
title('Update Coeffs from GLM: Intercept = cyan, Ability = blue, ReactionTime = red')
xlabel('RobotFactory Update only')
ylabel('Pretest Update')
hold off;



% Switch GLM with ShiftCount (learning)
[x_RFSw, y_RFSw] = getDataForSwitchGLM_1A3(zRFAll_1A3, true, false, true);
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + ShiftCount + RT','distr','binomial','CategoricalVars',[1,2,4],'VarNames',{'Subj','SwRep','RT','ShiftCount','Correct'})

linearX = transpose([1:length(RFSwModel.Coefficients.Estimate(40:end))]);
scatter(linearX, RFSwModel.Coefficients.Estimate(40:end), 'MarkerEdgeColor', 'blue');
title('Switch Learning across all subjects')
xlabel('Number of Switch shifts seen before this')
ylabel('Coefficient from GLM')

% And Update with ShiftCount
[x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(zRFAll_1A3, true, false, true);
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + ShiftCount + RT','distr','binomial','CategoricalVars',[1,2,4],'VarNames',{'Subj','Nval','RT','ShiftCount','Correct'})

linearX = transpose([1:length(RFUpdModel.Coefficients.Estimate(41:end))]);
scatter(linearX, RFUpdModel.Coefficients.Estimate(41:end), 'MarkerEdgeColor', 'blue');
title('Update Learning across all subjects')
xlabel('Number of Update shifts seen before this')
ylabel('Coefficient from GLM')


% Update with TrialCount and not ShiftCount
[x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(zRFAll_1A3, true, false, false, true);
... TrialCount across all subjects
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + TrialCount + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','Nval','RT','TrialCount','Correct'})
printGLMcoeffs(RFUpdModel, true);
% ... and as an interaction with subjects
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + (Subj*TrialCount) + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','Nval','RT','TrialCount','Correct'})

% Switch with TrialCount and not ShiftCount
[x_RFSw, y_RFSw] = getDataForSwitchGLM_1A3(zRFAll_1A3, true, false, false, true, 'all');
% ... TrialCount across all subjects
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','TrialCount','Correct'})
printGLMcoeffs(RFSwModel, true);
% ... and as an interaction with subjects
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + (Subj*TrialCount) + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','TrialCount','Correct'})


% Single-Subj Single-EF Switch GLMs with ShiftCount
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % pre-exclude for speed 
SubjList = unique(includedSubjs.Subject);
for subj = 1:length(SubjList)
    [x_RFSw, y_RFSw] = getDataForSwitchGLM_1A3(includedSubjs, false, false, true, false, SubjList(subj));
%    RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + ShiftCount + RT','distr','binomial','CategoricalVars',[1,2,4],'VarNames',{'Subj','SwRep','RT','ShiftCount','Correct'});
    RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + (ShiftCount*Subj) + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','ShiftCount','Correct'});

    if (length(RFSwModel.Coefficients.Estimate) < 4)
        fprintf('subj %d has no shifts (?)\n',subj);
    else
        linearX = transpose([1:length(RFSwModel.Coefficients.Estimate(4:end))]);
        percentThrough = subj / length(SubjList);
%        scatter(linearX, RFSwModel.Coefficients.Estimate(4:end), 'Marker','.', 'MarkerEdgeColor', [percentThrough,0.5,(1-percentThrough)]); % set a different RGB color for each participant
        plot(linearX, RFSwModel.Coefficients.Estimate(4:end),'Color', [percentThrough,0.5,(1-percentThrough)]); % set a different RGB color for each participant
        hold on; % only do this after the first one, to clear away whatever was there before
    end

end
title('Switch Learning: single subject (per color), single EF');
xlabel('Number of Switch shifts seen before this');
ylabel('Coefficient from GLM');
axis([0 inf -10 10]);
hold off;



% Single-Subj Single-EF Update GLMs with ShiftCount
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % pre-exclude for speed 
SubjList = unique(includedSubjs.Subject);
for subj = 1:length(SubjList)
    [x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(includedSubjs, false, false, true, false, SubjList(subj), 'single');
    RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + ShiftCount + RT','distr','binomial','CategoricalVars',[1,2,4],'VarNames',{'Subj','Nval','RT','ShiftCount','Correct'});
    if (length(RFUpdModel.Coefficients.Estimate) < 4)
        fprintf('subj %d has no shifts (?)\n',subj);
    else
        linearX = transpose([1:length(RFUpdModel.Coefficients.Estimate(4:end))]);
        percentThrough = subj / length(SubjList);
%        scatter(linearX, RFUpdModel.Coefficients.Estimate(4:end), 'Marker','.', 'MarkerEdgeColor', [percentThrough,0.5,(1-percentThrough)]); % set a different RGB color for each participant
        plot(linearX, RFUpdModel.Coefficients.Estimate(4:end),'Color', [percentThrough,0.5,(1-percentThrough)]); % set a different RGB color for each participant
        hold on; % only do this after the first one, to clear away whatever was there before
    end
end
title('Update Learning: single subject (per color), single EF');
xlabel('Number of Update shifts seen before this');
ylabel('Coefficient from GLM');
axis([0 inf -3 7]);
hold off;



% Sungle-Subj Update GLM, with both Single- and Dual-EF (good example: 2335)
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % pre-exclude for speed 
SubjList = unique(includedSubjs.Subject);
for subj = 1:length(SubjList)
    [x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(includedSubjs, false, false, true, false, SubjList(subj), 'both');
    RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + ShiftCount + RT','distr','binomial','CategoricalVars',[1,2,4],'VarNames',{'Subj','Nval','RT','ShiftCount','Correct'});
    if (length(RFUpdModel.Coefficients.Estimate) < 4)
        fprintf('subj %d has no shifts (?)\n',subj);
    else
        [x_RFUpdSingle, y_RFUpdSingle] = getDataForUpdateGLM_1A3(includedSubjs, false, false, true, false, SubjList(subj), 'single');
        RFUpdModelSingle = fitglm(x_RFUpdSingle,y_RFUpdSingle,'logit(Correct) ~ 1 + Subj + Nval + ShiftCount + RT','distr','binomial','CategoricalVars',[1,2,4],'VarNames',{'Subj','Nval','RT','ShiftCount','Correct'});
        singleShifts = transpose([1:length(RFUpdModelSingle.Coefficients.Estimate(4:end))]);
        singleEnd = length(singleShifts);
        linearX = transpose([1:length(RFUpdModel.Coefficients.Estimate(4:end))]);
        percentThrough = subj / length(SubjList);
%        scatter(linearX, RFUpdModel.Coefficients.Estimate(4:end), 'Marker','.', 'MarkerEdgeColor', [percentThrough,0.5,(1-percentThrough)]); % set a different RGB color for each participant
        plot(linearX(1:singleEnd+1), RFUpdModel.Coefficients.Estimate(4:(4+singleEnd)),'Color', [percentThrough,0.5,(1-percentThrough)]); % set a different RGB color for each participant
        hold on; % only do this after the first one, to clear away whatever was there before
        plot(linearX((singleEnd+1):end), RFUpdModel.Coefficients.Estimate((singleEnd+4):end),'Color', [0,0,0]); % set the "dual tasks" color to black
    end
end
title('Update Learning: subject (per color), single and dual EF');
xlabel('Number of Update shifts seen before this');
ylabel('Coefficient from GLM');
%axis([0 inf -20 20]);
hold off;

   
% ZEPHY: DON'T USE THESE. THEY DO TRIALCOUNT WRONG! USE getAllSwitchTrials_1A3() and getAllUpdateTrials_1A3()! 
% All-subj Update GLM with TrialCount learning parameter and a Cluster difficulty parameter  
[x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(includedSubjs, false, false, 'TrialCount', 'all', 'both');
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + TrialCount + Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','Nval','RT','TrialCount','Cluster','Correct'})
printGLMcoeffs(RFUpdModel, true);

% All-subj Switch GLM with TrialCount learning parameter and a Cluster difficulty parameter  
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
h = lsline; % add a least-squares regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(delMe(2:37), delMe2(2:37),1); % grab the equation
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
%text(-.7, -.5, delStr, 'FontSize', 14); % and put it on the graph
%delMean = mean(delMe);
text(mean(delMe), mean(delMe2)-1, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(delMe(2:37),delMe2(2:37),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
%text(-.7, -.6, delStr, 'FontSize', 14);
text(mean(delMe), mean(delMe2)-2, delStr, 'FontSize', 14);
title('Ability Coeffs from Update and Switch GLMs (Single and Dual EF) for each subject')
xlabel('Switch')
ylabel('Update')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)


% Ability plots for Update and Switch: histograms
delMe = RFSwModel.Coefficients.Estimate(:,1);
delBins = [-.75 -.65 -.55 -.45 -.35 -.25 -.15 -0.05 0.05 0.15 0.25 0.35 0.45 0.55 0.65 0.75];
delMe = delMe + 1; % add a constant to make all ability values positive
delBins = delBins + 1;  % add a constant to make all values positive
hist(delMe(2:37), delBins,'FontSize',14,'LineWidth',2);
axis([0 2 -inf inf]);
title('Ability coefficients from Switch GLM (Single and Dual EF) for each subject')
xlabel('Switch Ability')
ylabel('Number of participants in this Ability range')
%h = findobj(gca,'Type','patch'); % Get the handle to the patch object that creates the histogram plot.
%h.FaceColor = [0 0.5 0.5];
%h.EdgeColor = 'w';
%figureHandle = gcf;
%set(gca,'FontSize',14,'fontWeight','bold')
%set(findall(gcf,'type','text'),'FontSize',14,'fontWeight','bold')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)

delMe2 = RFUpdModel.Coefficients.Estimate(:,1);
delMe2 = delMe2 + 1; % add a constant to make all ability values positive
hist(delMe2(2:37), delBins);
axis([0 2 -inf inf]);
title('Ability coefficients from Update GLM (Single and Dual EF) for each subject')
xlabel('Update Ability')
ylabel('Number of participants in this Ability range')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)


% Difficulty plots
delMe = [0 RFSwModel.Coefficients.Estimate(38,1)];
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

delMe2 = [0 RFUpdModel.Coefficients.Estimate(38,1) RFUpdModel.Coefficients.Estimate(39,1)];
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

% Difficulty plots for different clusters
delMe = [0 RFSwModel.Coefficients.Estimate(41,1) RFSwModel.Coefficients.Estimate(42,1)];
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

delMe2 = [0 RFUpdModel.Coefficients.Estimate(42,1) RFUpdModel.Coefficients.Estimate(43,1)];
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




% Kernel-weighted Update plot
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % pre-exclude for speed 
updateData = getAllUpdateTrials_1A3(includedSubjs, 'both', 'all', 'both'); % pre-clean for speed
windowLength = 10;
% NOTE: unusual subjects = 2316, 2327, 3343
SubjList = unique(includedSubjs.Subject);
for subj = 1:length(SubjList)
%   [delY, firstTrials, singleToDualTrials, dualToSingleTrials] = getAllKernelValues_1A3(updateData, 'Update', windowLength, SubjList(subj));
%    [delY, firstTrials, singleToDualTrials, dualToSingleTrials] = getAllKernelValues_1A3(updateData, 'Update', 10, 2316);
%    [delY, firstTrials, singleToDualTrials, dualToSingleTrials] = getAllKernelValues_1A3(updateData, 'Update', 10, 2327);
    [delY, firstTrials, singleToDualTrials, dualToSingleTrials] = getAllKernelValues_1A3(updateData, 'Update', 10, 3343);
    plot(delY,'Color','blue');
    hold on;
    for trial=1:length(firstTrials)
        if (singleToDualTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'Color','red','LineWidth',2); % draw vertical line
            changedependvar(hx,'x'); % update graph
% testing            fprintf('red\n');
        elseif (dualToSingleTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'Color','green','LineWidth',2); % draw vertical line
            changedependvar(hx,'x'); % update graph
%            fprintf('green\n');
        elseif (firstTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'LineStyle',':', 'Color','black'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        end
    end
%    str = sprintf('Probability of success on Update, weighted by kernel function; subj = %d, windowLength = %d', SubjList(subj), windowLength);
    str = sprintf('Probability of success on Update, weighted by kernel function; subj = %d, windowLength = %d', 3343, windowLength);
    title(str)
    xlabel('Update trial number')
    ylabel('Weighted probability of success')
    hold off;
    pause(5);
end


% Kernel-weighted Switch plot (OLD, DEPRECATED)
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % pre-exclude for speed 
switchData = getAllSwitchTrials_1A3(includedSubjs, 'both', 'all', 'both'); % pre-clean for speed
windowLength = 10;
% NOTE: unusual subjects = 
SubjList = unique(includedSubjs.Subject);
for subj = 1:length(SubjList)
%    [delY, firstTrials, singleToDualTrials, dualToSingleTrials] = getAllKernelValues_1A3(switchData, 'Switch', windowLength, SubjList(subj));
%    [delY, firstTrials, singleToDualTrials, dualToSingleTrials] = getAllKernelValues_1A3(switchData, 'Switch', windowLength, 2316);
%    [delY, firstTrials, singleToDualTrials, dualToSingleTrials] = getAllKernelValues_1A3(switchData, 'Switch', windowLength, 2327);
    [delY, firstTrials, singleToDualTrials, dualToSingleTrials] = getAllKernelValues_1A3(switchData, 'Switch', windowLength, 3343);
    plot(delY,'Color','blue');
    hold on;
    for trial=1:length(firstTrials)
        if (singleToDualTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'Color','red'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        elseif (dualToSingleTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'Color','green'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        elseif (firstTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'LineStyle',':', 'Color','black'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        end
    end
%    str = sprintf('Probability of success on Switch, weighted by kernel function; subj = %d, windowLength = %d', SubjList(subj), windowLength);
    str = sprintf('Probability of success on Switch, weighted by kernel function; subj = %d, windowLength = %d', 3343, windowLength);
    title(str)
    xlabel('Switch trial number')
    ylabel('Weighted probability of success')
    hold off;
    pause(5);
end




% UNIT TEST FOR getAllSwitchTrials_1A3: returns TrialCount in the proper order, and ShiftNum supports that ordering as well 
switchData = getAllSwitchTrials_1A3(includedSubjs, 'both', 'all', 'both'); % pre-clean for speed
subjs = unique(switchData.Subject);
for subj = 1:length(subjs)
    delMe = switchData(switchData.Subject == subjs(subj), :);
    delMe2 = sortrows(delMe, 'TrialCount', 'ascend');
    for row = 2:height(delMe2)
        if (delMe2.ShiftNum(row) < delMe2.ShiftNum(row-1))
            error('Wrong Order: subj = %d, row = %d, row-1ShiftNum = %d, rowShiftNum=%d\n', subjs(subj), row, delMe2.ShiftNum(row-1), delMe2.ShiftNum(row));
        end
    end
end

% UNIT TEST FOR getAllUpdateTrials_1A3: returns TrialCount in the proper order, and ShiftNum supports that ordering as well 
updateData = getAllUpdateTrials_1A3(includedSubjs, 'both', 'all', 'both'); % pre-clean for speed
subjs = unique(updateData.Subject);
for subj = 1:length(subjs)
    delMe = updateData(updateData.Subject == subjs(subj), :);
    delMe2 = sortrows(delMe, 'TrialCount', 'ascend');
    for row = 2:height(delMe2)
        if (delMe2.ShiftNum(row) < delMe2.ShiftNum(row-1))
            error('Wrong Order: subj = %d, row = %d, row-1ShiftNum = %d, rowShiftNum=%d\n', subjs(subj), row, delMe2.ShiftNum(row-1), delMe2.ShiftNum(row));
        end
    end
end



% Compare RF Switch trials Ability (from the first X shifts) to Switch pre/post Ability
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % pre-exclude for speed 

%[~,~,switchDataPP] = getCleanSwitchTrials_PP_1A3(true, true, 'both', 'pre', true, zPPswitch_1A3);
[x_PPSw, y_PPSw] = getDataForPreSwitchGLM_1A3(zPPswitch_1A3, true, false);
PPSwModel = fitglm(x_PPSw,y_PPSw,'logit(Correct) ~ 1 + Subj + SwRep + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','Correct'});

delShifts = 3;
% use this to get ALL switch trials       switchDataRF = getAllSwitchTrials_1A3(includedSubjs, 'both', 'all', 'both'); % pre-clean for speed
first3SwShifts = getSomeRFshifts(includedSubjs, delShifts, 'S', 'first');
switchDataRF = getAllSwitchTrials_1A3(first3SwShifts, 'both', 'S', 'single'); % now clean the trials from the first 3 switch shifts
[x_RFSw, y_RFSw] = getDataForSwitchGLM_1A3(switchDataRF, false, false, 'TrialCount', 'all', 'single');
%RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount + Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','Correct'});
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount - Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','Correct'});

delMe = RFSwModel.Coefficients.Estimate(:,1);
delMe2 = PPSwModel.Coefficients.Estimate(:,1);
scatter(delMe(2:37), delMe2(2:37), 'MarkerEdgeColor', 'blue')
%axis([0 1.6 0 1.6]);
h = lsline; % add a least-suqres regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(delMe(2:37), delMe2(2:37),1); % grab the equation
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
%text(-.7, -.5, delStr, 'FontSize', 14); % and put it on the graph
text(0, 0, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(delMe(2:37),delMe2(2:37),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
%text(-.7, -.6, delStr, 'FontSize', 14);
text(0, -1, delStr, 'FontSize', 14);
str = sprintf('Ability Coeffs from RF (first %d shifts) and Pretest Switch GLMs for each subject', delShifts);
title(str)
xlabel('RF Switch')
ylabel('PP Switch')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)



% Compare RF Update trials Ability (from the first X shifts) to Update pre/post Ability
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % pre-exclude for speed 

%[~,~,switchDataPP] = getCleanSwitchTrials_PP_1A3(true, true, 'both', 'pre', true, zPPswitch_1A3);
[x_PPUpd, y_PPupd] = getDataForPreUpdateGLM_1A3(zPPupdate_1A3, true, false);
PPUpdModel = fitglm(x_PPUpd,y_PPupd,'logit(Correct) ~ 1 + Subj - Memback + RT','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','Memback','RT','Correct'});  % note that I created a categorical variable to tell us how far back in memory any given thing is, but this model doesn't use it. Change the '-' to '+' before 'Memback' to put it back in.

delShifts = 4;
% use this to get ALL switch trials       switchDataRF = getAllSwitchTrials_1A3(includedSubjs, 'both', 'all', 'both'); % pre-clean for speed
first3UpdShifts = getSomeRFshifts(includedSubjs, delShifts, 'U', 'first');
updateDataRF = getAllUpdateTrials_1A3(first3UpdShifts, 'both', 'U', 'single'); % now clean the trials from the first 3 update shifts
[x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(updateDataRF, false, false, 'TrialCount', 'all', 'single');
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + TrialCount - Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','Nval','RT','TrialCount','Cluster','Correct'});

delMe = RFUpdModel.Coefficients.Estimate(:,1);
delMe2 = PPUpdModel.Coefficients.Estimate(:,1);
scatter(delMe(2:37), delMe2(2:37), 'MarkerEdgeColor', 'blue')
%axis([0 1.6 0 1.6]);
h = lsline; % add a least-suqres regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(delMe(2:37), delMe2(2:37),1); % grab the equation
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
%text(-.7, -.5, delStr, 'FontSize', 14); % and put it on the graph
text(0, 0, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(delMe(2:37),delMe2(2:37),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
%text(-.7, -.6, delStr, 'FontSize', 14);
text(0, -1, delStr, 'FontSize', 14);
str = sprintf('Ability Coeffs from RF (first %d shifts) and Pretest Update GLMs for each subject', delShifts);
title(str)
xlabel('RF Update')
ylabel('PP Update')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)


% test new Kernel function
updateData = getAllUpdateTrials_1A3(includedSubjs, 'both', 'all', 'both'); % pre-clean for speed
[logitY, probY, firstTrials, singleToDualTrials, dualToSingleTrials, ~] = getKernelValsPerShift_1A3(updateData, [], 'Update', 10, 3343);

% Kernel-weighted Switch plot
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % pre-exclude for speed 
switchData = getAllSwitchTrials_1A3(includedSubjs, 'both', 'all', 'both'); % pre-clean for speed
windowLength = 10;
% NOTE: unusual subjects = 
SubjList = unique(includedSubjs.Subject);
for subj = 1:length(SubjList)
    [logitY, probY, firstTrials, singleToDualTrials, dualToSingleTrials, ~] = getKernelValsPerShift_1A3(switchData, [], 'Switch', windowLength, SubjList(subj));
%    [logitY, probY, firstTrials, singleToDualTrials, dualToSingleTrials, ~] = getKernelValsPerShift_1A3(switchData, [], 'Switch', windowLength, 2316);
%    [logitY, probY, firstTrials, singleToDualTrials, dualToSingleTrials, ~] = getKernelValsPerShift_1A3(switchData, [], 'Switch', windowLength, 2327);
%    [logitY, probY, firstTrials, singleToDualTrials, dualToSingleTrials, ~] = getKernelValsPerShift_1A3(switchData, [], 'Switch', windowLength, 3343);
    plot(logitY,'Color','blue');
    hold on;
    for trial=1:length(firstTrials)
        if (singleToDualTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'Color','red'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        elseif (dualToSingleTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'Color','green'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        elseif (firstTrials(trial) > 0)
            hx = graph2d.constantline(trial, 'LineStyle',':', 'Color','black'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        end
    end
    str = sprintf('Logit of probability of success on Switch, weighted by kernel function; subj = %d, windowLength = %d', SubjList(subj), windowLength);
%    str = sprintf('Probability of success on Switch, weighted by kernel function; subj = %d, windowLength = %d', 3343, windowLength);
    title(str)
    xlabel('Switch trial number')
    ylabel('Logit of kernel-weighted probability of success')
% note that if we wanted a standard Y axis size, it would be -4 to +4, since our probability precision appears to go to 4 decimal places     
    hold off;
    pause(5);
end







