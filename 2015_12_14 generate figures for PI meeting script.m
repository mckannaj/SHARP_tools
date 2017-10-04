


% find out differences between conditions: reached L4?
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe2 = unique(delMe(strcmpi(delMe.Condition, 'RF tDCS'), :).Subject); % tDCS = red
length(delMe2) % total finished tDCS
delMe3 = unique(delMe(strcmpi(delMe.Condition, 'RF tRNS'), :).Subject); % tRNS = blue
length(delMe3) % total finished tRNS
delMe4 = unique(delMe(strcmpi(delMe.Condition, 'RF tDCS Sham'), :).Subject);
delMe4 = [delMe4; unique(delMe(strcmpi(delMe.Condition, 'RF tRNS Sham'), :).Subject)]; % both shams = green
length(delMe4) % total finished sham

delMe5 = unique(delMe((strcmpi(delMe.Condition, 'RF tDCS')) & (strcmpi(delMe.Cluster, 'L4aV1')), :).Subject);
length(delMe5) % total finished tDCS who got to L4
delMe6 = unique(delMe((strcmpi(delMe.Condition, 'RF tRNS')) & (strcmpi(delMe.Cluster, 'L4aV1')), :).Subject);
length(delMe6) % total finished tRNS who got to L4
delMe7 = unique(delMe((strcmpi(delMe.Condition, 'RF tDCS Sham')) & (strcmpi(delMe.Cluster, 'L4aV1')), :).Subject);
delMe7 = [delMe7; unique(delMe((strcmpi(delMe.Condition, 'RF tDCS Sham')) & (strcmpi(delMe.Cluster, 'L4aV1')), :).Subject)];
length(delMe7) % total finished sham who got to L4





% get EF measures, by thirds, on SWING server 
delMe = excludeSubjects_RF_1B(false, true, false, zRF_1B); % getEFmeasures_RF_1A3(excludeSubjects_RF_1B(false, true, false, zRF_1B), false, false, true);
[delMe_switchTrials, delMe_nonSwitchTrials, delMe_allSwTrials] = getCleanSwitchTrials_RF_1B(true, true, true, 'S', delMe, true);
[delMe_N1Trials,delMe_N2Trials,delMe_N1Trials, delMe_allUpdateTrials] = getCleanUpdateTrials_RF_1A3('both', false, delMe, true);
[delMe_inh_goTrials, delMe_inh_inhibitTrials] = getCleanInhibitTrials_RF_1A3(true, 'GoBoth', 'correct', true, false, delMe);

[~, delMe_thirdsAcc_updN2] = getNewAccuracy_RF_1A3(delMe_N2Trials, false);
[delMe_updAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_updN2, false);

[~, delMe_thirdsAcc_Switch] = getNewAccuracy_RF_1A3(delMe_switchTrials, false);
[delMe_SwitchAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_Switch, false);
delMe_SwitchAcc.Properties.VariableNames = {'Subject' 'FirstThirdSwAcc' 'LastThirdSwAcc' 'DeltaSwAcc'}
[~, delMe_thirdsAcc_Inh] = getNewAccuracy_RF_1A3(delMe_inh_inhibitTrials, false);
[delMe_InhAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_Inh, false);
delMe_InhAcc.Properties.VariableNames = {'Subject' 'FirstThirdInhAcc' 'LastThirdInhAcc' 'DeltaInhAcc'}
   
[delMe_updAcc, delMe_SwitchAcc] = removeNonMatchingSubjects(delMe_updAcc.Subject, delMe_updAcc, delMe_SwitchAcc.Subject, delMe_SwitchAcc, true, false); 
[delMe_updAcc, delMe_InhAcc] = removeNonMatchingSubjects(delMe_updAcc.Subject, delMe_updAcc, delMe_InhAcc.Subject, delMe_InhAcc, true, false); 
[delMe_SwitchAcc, delMe_InhAcc] = removeNonMatchingSubjects(delMe_SwitchAcc.Subject, delMe_SwitchAcc, delMe_InhAcc.Subject, delMe_InhAcc, true, false); 

    EFmeasures = array2table(delMe_SwitchAcc.Subject, 'VariableNames', {'Subject'}); % there must be a better way to do this...?
    EFmeasures.FirstThirdSwAcc = delMe_SwitchAcc.FirstThirdSwAcc;
    EFmeasures.LastThirdSwAcc = delMe_SwitchAcc.LastThirdSwAcc;
    EFmeasures.DeltaSwAcc = delMe_SwitchAcc.DeltaSwAcc;

    EFmeasures.FirstThirdUpdAccN2 = delMe_updAcc.FirstThirdUpdAccN2;
    EFmeasures.LastThirdUpdAccN2 = delMe_updAcc.LastThirdUpdAccN2;
    EFmeasures.DeltaUpdAccN2 = delMe_updAcc.DeltaUpdAccN2;

    EFmeasures.FirstThirdInhAcc = delMe_InhAcc.FirstThirdInhAcc;
    EFmeasures.LastThirdInhAcc = delMe_InhAcc.LastThirdInhAcc;
    EFmeasures.DeltaInhAcc = delMe_InhAcc.DeltaInhAcc;

writetable(EFmeasures, getFileNameForThisOS('2015_12_14_EFsingleTaskThirds.csv', 'IntResults'));
[~,~,delMe] = xlsread(getFileNameForThisOS('2015_12_14_EFsingleTaskThirds.xlsx', 'IntResults')); 
delMe_EFthirds = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names

delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe2 = unique(delMe(strcmpi(delMe.Condition, 'RF tDCS'), :).Subject); % tDCS = red
delMe3 = unique(delMe(strcmpi(delMe.Condition, 'RF tRNS'), :).Subject); % tRNS = blue
delMe4 = unique(delMe(strcmpi(delMe.Condition, 'RF tDCS Sham'), :).Subject);
delMe4 = [delMe4; unique(delMe(strcmpi(delMe.Condition, 'RF tRNS Sham'), :).Subject)]; % both shams = green

delMe_tDCSthirds = delMe_EFthirds(ismember(delMe_EFthirds.Subject, delMe2),:);
writetable(delMe_tDCSthirds, getFileNameForThisOS('2015_12_14 tDCS singleEF thirds.csv', 'IntResults'));
delMe_tRNSthirds = delMe_EFthirds(ismember(delMe_EFthirds.Subject, delMe3),:);
writetable(delMe_tRNSthirds, getFileNameForThisOS('2015_12_14 tRNS singleEF thirds.csv', 'IntResults'));
delMe_SHAMthirds = delMe_EFthirds(ismember(delMe_EFthirds.Subject, delMe4),:);
writetable(delMe_SHAMthirds, getFileNameForThisOS('2015_12_14 SHAM singleEF thirds.csv', 'IntResults'));

clear delMe_switchTrials;
clear delMe_nonSwitchTrials;
clear delMe_allSwTrials;
clear delMe_N1Trials;
clear delMe_N2Trials;
clear delMe_N1Trials;
clear delMe_allUpdateTrials;
clear delMe_inh_inhibitTrials;
clear delMe_inh_goTrials;
clear delMe_thirdsAcc_updN2;
clear delMe_updAcc;
clear delMe_thirdsAcc_Switch;
clear delMe_SwitchAcc;
clear delMe_thirdsAcc_Inh;
clear delMe_InhAcc;
clear EFmeasures;



% same, for dual tasks: Switch + other
[delMe_switchGivenUpdate, ~, ~] = getCleanSwitchTrials_RF_1B(true, true, true, 'U/S', delMe, true);
[delMe_switchGivenInhibit, ~, ~] = getCleanSwitchTrials_RF_1B(true, true, true, 'S/I', delMe, true);

[~, delMe_thirdsAcc_SwitchUpdate] = getNewAccuracy_RF_1A3(delMe_switchGivenUpdate, false);
[delMe_SUAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_SwitchUpdate, false);
delMe_SUAcc.Properties.VariableNames = {'Subject' 'FirstThirdSwUpdAcc' 'LastThirdSwUpdAcc' 'DeltaSwUpdAcc'};

[~, delMe_thirdsAcc_SwitchInhibit] = getNewAccuracy_RF_1A3(delMe_switchGivenInhibit, false);
[delMe_SIAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_SwitchInhibit, false);
delMe_SIAcc.Properties.VariableNames = {'Subject' 'FirstThirdSwInhAcc' 'LastThirdSwInhAcc' 'DeltaSwInhAcc'};

writetable(delMe_SUAcc, getFileNameForThisOS('2015_12_14_Switch_Update.csv', 'IntResults'));
writetable(delMe_SIAcc, getFileNameForThisOS('2015_12_14_Switch_Inhibit.csv', 'IntResults'));


% same, for dual tasks: Update + other
[~,delMe_updateGivenSwitch,~, ~] = getCleanUpdateTrials_dualTasks_RF_1A3('both', 'U/S', true, delMe);
[~,delMe_updateGivenInhibit,~, ~] = getCleanUpdateTrials_dualTasks_RF_1A3('both', 'U/I', true, delMe);

[~, delMe_thirdsAcc_UpdateSwitch] = getNewAccuracy_RF_1A3(delMe_updateGivenSwitch, false);
[delMe_USAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_UpdateSwitch, false);
delMe_SIAcc.Properties.VariableNames = {'Subject' 'FirstThirdUpdSwAcc' 'LastThirdUpdSwAcc' 'DeltaUpdSwAcc'};

[~, delMe_thirdsAcc_UpdateInhibit] = getNewAccuracy_RF_1A3(delMe_updateGivenInhibit, false);
[delMe_UIAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_UpdateInhibit, false);
delMe_UIAcc.Properties.VariableNames = {'Subject' 'FirstThirdUpdInhAcc' 'LastThirdUpdInhAcc' 'DeltaUpdInhAcc'};

writetable(delMe_USAcc, getFileNameForThisOS('2015_12_14_Update_Switch.csv', 'IntResults'));
writetable(delMe_UIAcc, getFileNameForThisOS('2015_12_14_Update_Inhibit.csv', 'IntResults'));





% same, for dual tasks: Inhibit + other
[~, delMe_inhibitGivenSwitch] = getCleanInhibitTrials_dualTasks_RF_1A3(true, 'GoBoth', 'correct', true, 'S/I', true, delMe);
[~, delMe_inhibitGivenUpdate] = getCleanInhibitTrials_dualTasks_RF_1A3(true, 'GoBoth', 'correct', true, 'U/I', true, delMe);

[~, delMe_thirdsAcc_InhibitSwitch] = getNewAccuracy_RF_1A3(delMe_inhibitGivenSwitch, false);
[delMe_ISAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_InhibitSwitch, false);
delMe_ISAcc.Properties.VariableNames = {'Subject' 'FirstThirdInhSwAcc' 'LastThirdInhSwAcc' 'DeltaInhSwAcc'};

[~, delMe_thirdsAcc_InhibitUpdate] = getNewAccuracy_RF_1A3(delMe_inhibitGivenUpdate, false);
[delMe_IUAcc] = getUpdateAccN2_RF_1A3(delMe_thirdsAcc_InhibitUpdate, false);
delMe_IUAcc.Properties.VariableNames = {'Subject' 'FirstThirdInhUpdAcc' 'LastThirdInhUpdAcc' 'DeltaInhUpdAcc'};

writetable(delMe_ISAcc, getFileNameForThisOS('2015_12_14_Inhbit_Switch.csv', 'IntResults'));
writetable(delMe_IUAcc, getFileNameForThisOS('2015_12_14_Inhibit_Update.csv', 'IntResults'));



clear delMe_ISAcc;
clear delMe_IUAcc;
clear delMe_SIAcc;
clear delMe_SUAcc;
clear delMe_UIAcc;
clear delMe_USAcc;
clear delMe_inhibitGivenSwitch;
clear delMe_inhibitGivenUpdate;
clear delMe_switchGivenInhibit;
clear delMe_switchGivenUpdate;
clear delMe_updateGivenInhibit;
clear delMe_updateGivenSwitch;
clear delMe_thirdsAcc_InhibitSwitch;
clear delMe_thirdsAcc_InhibitUpdate;
clear delMe_thirdsAcc_SwitchInhibit;
clear delMe_thirdsAcc_SwitchUpdate;
clear delMe_thirdsAcc_UpdateSwitch;
clear delMe_thirdsAcc_UpdateInhibit;





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
    
%        delMe2 = avgKernel_cluster_L4bV2(:,1:54);
%        delMe2 = [delMe2; avgKernel_cluster_L4bV1(:,1:54)];

    figure
    hold on
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe5),2:end)); % tDCS = red
    plot(1:length(delMe3),delMe3,'Color',[0.9,0.3,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe6),2:end)); % tRNS = green
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.9,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe7),2:end)); % sham = blue
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.3,0.9]);

    str = strrep(delMe{delMe4}, 'avgKernel_cluster_', 'Cluster: ')
    str = strrep(str, '_', '/')
    title(str)
    ylabel(sprintf('Average kernel-smoothed logit estimates\nof performance across all subjects.'))
    xlabel('Interpolated estimate points for average number of trials.')
    legend({'tDCS','tRNS','Sham'})
    set(findall(gca,'type','text'),'FontSize',16)
    set(findall(gca,'type','axes'),'FontSize',12)
    hold off
    hold off
end





% overall Ability per condition
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe5),:);
mean(delMe2.Coefficient)
delMe3 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe6),:);
mean(delMe3.Coefficient)
delMe4 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe7),:);
mean(delMe4.Coefficient)






% overall Ability per site
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
delMe5 = unique(delMe(strcmpi(delMe.Institution, 'Honeywell'), :).Subject);
delMe6 = unique(delMe(strcmpi(delMe.Institution, 'Oxford'), :).Subject); 
delMe7 = unique(delMe(strcmpi(delMe.Institution, 'NEU'), :).Subject);
delMe8 = unique(delMe(strcmpi(delMe.Institution, 'Harvard'), :).Subject); 

delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe5),:);
Honeywell = [mean(delMe2.Coefficient) std(delMe2.Coefficient)]
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe6),:);
Oxford = [mean(delMe2.Coefficient) std(delMe2.Coefficient)]
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe7),:);
NEU = [mean(delMe2.Coefficient) std(delMe2.Coefficient)]
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe8),:);
Harvard = [mean(delMe2.Coefficient) std(delMe2.Coefficient)]

delMe2 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), delMe5),:);
Honeywell = [mean(delMe2(:,2)) std(delMe2(:,2))]
delMe2 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), delMe6),:);
Oxford = [mean(delMe2(:,2)) std(delMe2(:,2))]
delMe2 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), delMe7),:);
NEU = [mean(delMe2(:,2)) std(delMe2(:,2))]
delMe2 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), delMe8),:);
Harvard = [mean(delMe2(:,2)) std(delMe2(:,2))]

delMe = {'avgKernel_cluster_I'...
,'avgKernel_cluster_I_logic','avgKernel_cluster_L4aV1','avgKernel_cluster_L4aV2','avgKernel_cluster_L4bV1'...
,'avgKernel_cluster_L4bV2','avgKernel_cluster_S','avgKernel_cluster_S_I','avgKernel_cluster_S_I_logic'...
,'avgKernel_cluster_S_logic','avgKernel_cluster_U','avgKernel_cluster_U_I','avgKernel_cluster_U_I_logic'...
,'avgKernel_cluster_U_S_logic','avgKernel_cluster_U_S','avgKernel_cluster_U_logic'};


% average across all subjects in one Institution
for delMe4 = 1:length(delMe)
    delMe2 = eval(delMe{delMe4});
    
%        delMe2 = avgKernel_cluster_L4bV2(:,1:54);
%        delMe2 = [delMe2; avgKernel_cluster_L4bV1(:,1:54)];

    figure
    hold on
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe5),2:end)); % Honeywell = red
    plot(1:length(delMe3),delMe3,'Color',[0.9,0.3,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe6),2:end)); % Oxford = green
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.9,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe7),2:end)); % NEU = blue
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.3,0.9]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),delMe8),2:end)); % Harvard = grey
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.3,0.3]);
    
    str = strrep(delMe{delMe4}, 'avgKernel_cluster_', 'Cluster: ')
    str = strrep(str, '_', '/')
    title(str)
    ylabel(sprintf('Average kernel-smoothed logit estimates\nof performance across all subjects.'))
    xlabel('Interpolated estimate points for average number of trials.')
    legend({'Honeywell','Oxford','NEU','Harvard'})
    set(findall(gca,'type','text'),'FontSize',16)
    set(findall(gca,'type','axes'),'FontSize',12)
    hold off
end

clear str;
clear Honeywell;
clear Oxford;
clear NEU;
clear Harvard;






% overall Ability per site*condition
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get subjects that finished
subjList_tDCS = unique(delMe(strcmpi(delMe.Condition, 'RF tDCS'), :).Subject); 
subjList_tRNS = unique(delMe(strcmpi(delMe.Condition, 'RF tRNS'), :).Subject);
subjList_sham_tDCS = unique(delMe(strcmpi(delMe.Condition, 'RF tDCS Sham'), :).Subject);
subjList_sham_tRNS = unique(delMe(strcmpi(delMe.Condition, 'RF tRNS Sham'), :).Subject);
subjList_sham = [subjList_sham_tDCS; subjList_sham_tRNS]; 

subjList_Honeywell = unique(delMe(strcmpi(delMe.Institution, 'Honeywell'), :).Subject);
subjList_Oxford = unique(delMe(strcmpi(delMe.Institution, 'Oxford'), :).Subject); 
subjList_NEU = unique(delMe(strcmpi(delMe.Institution, 'NEU'), :).Subject);
subjList_Harvard = unique(delMe(strcmpi(delMe.Institution, 'Harvard'), :).Subject); 
subjList_Boston = [subjList_Harvard; subjList_NEU]; 
subjList_nonBoston = [subjList_Honeywell; subjList_Oxford]; 

subjList_Oxford_tDCS = subjList_tDCS(ismember(subjList_tDCS, subjList_Oxford),:);
subjList_Oxford_tRNS = subjList_tRNS(ismember(subjList_tRNS, subjList_Oxford),:);
subjList_Oxford_sham = subjList_sham(ismember(subjList_sham, subjList_Oxford),:);
subjList_NEU_tDCS = subjList_tDCS(ismember(subjList_tDCS, subjList_NEU),:);
subjList_NEU_tRNS = subjList_tRNS(ismember(subjList_tRNS, subjList_NEU),:);
subjList_NEU_sham = subjList_sham(ismember(subjList_sham, subjList_NEU),:);
subjList_Harvard_tDCS = subjList_tDCS(ismember(subjList_tDCS, subjList_Harvard),:);
subjList_Harvard_tRNS = subjList_tRNS(ismember(subjList_tRNS, subjList_Harvard),:);
subjList_Harvard_sham = subjList_sham(ismember(subjList_sham, subjList_Harvard),:);
subjList_Honeywell_tDCS = subjList_tDCS(ismember(subjList_tDCS, subjList_Honeywell),:);
subjList_Honeywell_tRNS = subjList_tRNS(ismember(subjList_tRNS, subjList_Honeywell),:);
subjList_Honeywell_sham = subjList_sham(ismember(subjList_sham, subjList_Honeywell),:);


delMe = table({'None'},0,0.0,0.0,0.0,0.0,0.0,0.0, 'VariableNames', {'Inst_Cond','N','meanAbility','sdAbility','stdErrAbility',...
    'meanClustComplete','sdClustComplete','stdErrClustComplete'})

delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Oxford_tDCS),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Oxford_tDCS),:);
delMe{1,1} = {'Oxford_tDCS'};
delMe(1,2:end) = {length(subjList_Oxford_tDCS),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Oxford_tDCS)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Oxford_tDCS))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Oxford_tRNS),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Oxford_tRNS),:);
delMe{2,1} = {'Oxford_tRNS'};
delMe(2,2:end) = {length(subjList_Oxford_tRNS),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Oxford_tRNS)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Oxford_tRNS))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Oxford_sham),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Oxford_sham),:);
delMe{3,1} = {'Oxford_Sham'};
delMe(3,2:end) = {length(subjList_Oxford_sham),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Oxford_sham)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Oxford_sham))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_NEU_tDCS),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_NEU_tDCS),:);
delMe{4,1} = {'NEU_tDCS'};
delMe(4,2:end) = {length(subjList_NEU_tDCS),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_NEU_tDCS)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_NEU_tDCS))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_NEU_tRNS),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_NEU_tRNS),:);
delMe{5,1} = {'NEU_tRNS'};
delMe(5,2:end) = {length(subjList_NEU_tRNS),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_NEU_tRNS)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_NEU_tRNS))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_NEU_sham),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_NEU_sham),:);
delMe{6,1} = {'NEU_Sham'};
delMe(6,2:end) = {length(subjList_NEU_sham),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_NEU_sham)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_NEU_sham))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Harvard_tDCS),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Harvard_tDCS),:);
delMe{7,1} = {'Harvard_tDCS'};
delMe(7,2:end) = {length(subjList_Harvard_tDCS),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Harvard_tDCS)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Harvard_tDCS))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Harvard_tRNS),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Harvard_tRNS),:);
delMe{8,1} = {'Harvard_tRNS'};
delMe(8,2:end) = {length(subjList_Harvard_tRNS),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Harvard_tRNS)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Harvard_tRNS))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Harvard_sham),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Harvard_sham),:);
delMe{9,1} = {'Harvard_Sham'};
delMe(9,2:end) = {length(subjList_Harvard_sham),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Harvard_sham)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Harvard_sham))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Honeywell_tDCS),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Honeywell_tDCS),:);
delMe{10,1} = {'Honeywell_tDCS'};
delMe(10,2:end) = {length(subjList_Honeywell_tDCS),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Honeywell_tDCS)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Honeywell_tDCS))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Honeywell_tRNS),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Honeywell_tRNS),:);
delMe{11,1} = {'Honeywell_tRNS'};
delMe(11,2:end) = {length(subjList_Honeywell_tRNS),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Honeywell_tRNS)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Honeywell_tRNS))}
delMe2 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, subjList_Honeywell_sham),:);
delMe3 = clustersCompleted1B(ismember(clustersCompleted1B(:,1), subjList_Honeywell_sham),:);
delMe{12,1} = {'Honeywell_Sham'};
delMe(12,2:end) = {length(subjList_Honeywell_sham),...
    mean(delMe2.Coefficient),std(delMe2.Coefficient),std(delMe2.Coefficient) / sqrt(length(subjList_Honeywell_sham)),...
    mean(delMe3(:,2)),std(delMe3(:,2)),std(delMe3(:,2)) / sqrt(length(subjList_Honeywell_sham))}

writetable(delMe, getFileNameForThisOS('2015_12_15_OverallMeasures_ByPlaceAndCondition.csv', 'IntResults'));

delMe = {'avgKernel_cluster_I'...
,'avgKernel_cluster_I_logic','avgKernel_cluster_L4aV1','avgKernel_cluster_L4aV2','avgKernel_cluster_L4bV1'...
,'avgKernel_cluster_L4bV2','avgKernel_cluster_S','avgKernel_cluster_S_I','avgKernel_cluster_S_I_logic'...
,'avgKernel_cluster_S_logic','avgKernel_cluster_U','avgKernel_cluster_U_I','avgKernel_cluster_U_I_logic'...
,'avgKernel_cluster_U_S_logic','avgKernel_cluster_U_S','avgKernel_cluster_U_logic'};
for delMe4 = 1:length(delMe)
    delMe2 = eval(delMe{delMe4});

    figure
    hold on
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Honeywell_tDCS),2:end)); % Honeywell = red
    plot(1:length(delMe3),delMe3,'Color',[0.9,0.3,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Honeywell_tRNS),2:end)); % Honeywell = red
    plot(1:length(delMe3),delMe3,'--','Color',[0.9,0.3,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Honeywell_sham),2:end)); % Honeywell = red
    plot(1:length(delMe3),delMe3,':','Color',[0.9,0.3,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Oxford_tDCS),2:end)); % Oxford = green
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.9,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Oxford_tRNS),2:end)); % Oxford = green
    plot(1:length(delMe3),delMe3,'--','Color',[0.3,0.9,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Oxford_sham),2:end)); % Oxford = green
    plot(1:length(delMe3),delMe3,':','Color',[0.3,0.9,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_NEU_tDCS),2:end)); % NEU = blue
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.3,0.9]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_NEU_tRNS),2:end)); % NEU = blue
    plot(1:length(delMe3),delMe3,'--','Color',[0.3,0.3,0.9]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_NEU_sham),2:end)); % NEU = blue
    plot(1:length(delMe3),delMe3,':','Color',[0.3,0.3,0.9]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Harvard_tDCS),2:end)); % Harvard = black
    plot(1:length(delMe3),delMe3,'Color',[0.3,0.3,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Harvard_tRNS),2:end)); % Harvard = black
    plot(1:length(delMe3),delMe3,'--','Color',[0.3,0.3,0.3]);
    delMe3 = mean(delMe2(ismember(delMe2(:,1),subjList_Harvard_sham),2:end)); % Harvard = black
    plot(1:length(delMe3),delMe3,':','Color',[0.3,0.3,0.3]);
    
    str = strrep(delMe{delMe4}, 'avgKernel_cluster_', 'Cluster: ');
    str = strrep(str, '_', '/');
    title(str)
    ylabel(sprintf('Average kernel-smoothed logit estimates\nof performance across all subjects.'))
    xlabel('Interpolated estimate points for average number of trials.')
    legend({'HON_t_D_C_S','HON_t_R_N_S','HON_S_h_a_m',...
        'OX_t_D_C_S','OX_t_R_N_S','OX_S_h_a_m',...
        'NEU_t_D_C_S','NEU_t_R_N_S','NEU_S_h_a_m',...
        'HRV_t_D_C_S','HRV_t_R_N_S','HRV_S_h_a_m'})
    set(findall(gca,'type','text'),'FontSize',16)
    set(findall(gca,'type','axes'),'FontSize',12)
    hold off
end


clear str;
clear subjList_tDCS;
clear subjList_tRNS;
clear subjList_sham_tDCS;
clear subjList_sham_tRNS;
clear subjList_sham;
clear subjList_Honeywell;
clear subjList_Oxford;
clear subjList_NEU;
clear subjList_NEU;
clear subjList_Boston;
clear subjList_nonBoston;
clear subjList_Oxford_tDCS;
clear subjList_Oxford_tRNS;
clear subjList_Oxford_sham;
clear subjList_NEU_tDCS;
clear subjList_NEU_tRNS;
clear subjList_NEU_sham;
clear subjList_Harvard_tDCS;
clear subjList_Harvard_tRNS;
clear subjList_Harvard_sham;
clear subjList_Honeywell_tDCS;
clear subjList_Honeywell_tRNS;
clear subjList_Honeywell_sham;






% Ability of high performers
delMe2 = unique(zRFSum_1B(zRFSum_1B.ActualN > 3, :).Subject);
delMe3 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe2),:);
mean(delMe3.Coefficient)
delMe4 = zRFSum_1B(ismember(zRFSum_1B.Subject, delMe2),:);
delMe8 = delMe4(strcmpi(delMe4.Cluster, 'L4bV1'),:);
delMe8 = [delMe8; delMe4(strcmpi(delMe4.Cluster, 'L4bV2'),:)];
delMe9 = delMe8(delMe8.Accuracy>80,:);
height(delMe9) / length(delMe2)
% Ability of non-high performers
delMe2 = unique(zRFSum_1B(~ismember(zRFSum_1B.Subject, delMe2),:).Subject);
delMe3 = zOverallAbility_GLM_1B(ismember(zOverallAbility_GLM_1B.Subject, delMe2),:);
mean(delMe3.Coefficient)
delMe4 = zRFSum_1B(ismember(zRFSum_1B.Subject, delMe2),:);
delMe8 = delMe4(strcmpi(delMe4.Cluster, 'L4bV1'),:);
delMe8 = [delMe8; delMe4(strcmpi(delMe4.Cluster, 'L4bV2'),:)];
delMe9 = delMe8(delMe8.Accuracy>80,:);
height(delMe9) / length(delMe2)


% L4b completed for each condition

delMe4 = zRFSum_1B(ismember(zRFSum_1B.Subject, delMe5),:); % tDCS
delMe8 = delMe4(strcmpi(delMe4.Cluster, 'L4bV1'),:);
%delMe8 = [delMe8; delMe4(strcmpi(delMe4.Cluster, 'L4bV2'),:)];
delMe9 = delMe8(delMe8.Accuracy>80,:);
height(delMe9) / length(delMe5)
delMe4 = zRFSum_1B(ismember(zRFSum_1B.Subject, delMe6),:); % tRNS
delMe8 = delMe4(strcmpi(delMe4.Cluster, 'L4bV1'),:);
%delMe8 = [delMe8; delMe4(strcmpi(delMe4.Cluster, 'L4bV2'),:)];
delMe9 = delMe8(delMe8.Accuracy>80,:);
height(delMe9) / length(delMe6)
delMe4 = zRFSum_1B(ismember(zRFSum_1B.Subject, delMe7),:); % Sham
delMe8 = delMe4(strcmpi(delMe4.Cluster, 'L4bV1'),:);
%delMe8 = [delMe8; delMe4(strcmpi(delMe4.Cluster, 'L4bV2'),:)];
delMe9 = delMe8(delMe8.Accuracy>80,:);
height(delMe9) / length(delMe7)





% components correlate to Gf? for Roi
[~,~,delMe] = xlsread(getFileNameForThisOS('1b-final-Gf-residuals.xlsx', 'ParsedData')); 
zGfResid_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names




c




