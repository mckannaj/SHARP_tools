% Zephy McKanna
% Demo for Insight - script
% 7/7/17

% first, load the 1B data - do this beforehand, it takes ~45sec 
%       [~, zRFSum_1B, ~] = formTables_RF_1A3('', '1b-final-Parsed.rf-sum.xlsx', '', true);
%       load(getFileNameForThisOS('RFAll_1B-50_99-2015_10_29.mat','ParsedData')) % random 50 subjects' worth of per-trial data
% this also takes ~10min, so do it beforehand in case we get to demo 2
%       [zPPinhibit_1B, zPPswitch_1B, zPPupdate_1B] = formTables_RF_1A3('1b-final-Parsed.inhibit.xlsx', '1b-final-Parsed.switch.xlsx', '1b-final-Parsed.rotation.xlsx', true);
%       load(getFileNameForThisOS('first_40_RFshifts_1B_final-2015_10_29.mat','ParsedData')) % first two days' worth of trial data for all subjs



% first demo: more precise (continuous) Ability estimation
sumIncluded = excludeSubjects_RF_1B(true, true, false, zRFSum_1B); % excludeSubjects_RF_1B(justRF, onlyFinished, noChancePerformance, fullData)
% note this takes ~15sec
[~, ccTable] = getClustersCompleted_1B(sumIncluded, true, false) % getClustersCompleted_1B(sumTable1B, onlyUniqueCompletions, printTable)
zScatter(ccTable.total, ccTable.Subject, 'Clusters completed over the course of training', 'Clusters completed', 'Subject', false, '', '', 14, false, '', '');

trialsIncluded = excludeSubjects_RF_1B(true, true, false, zRF_1B_50_99); % excludeSubjects_RF_1B(justRF, onlyFinished, noChancePerformance, fullData)
glmData = trialsIncluded(trialsIncluded.StimShowTime < 5,:); % remove "didn't understand instructions" outliers
glmY = glmData.Correct;
% Note: should briefly explain each independent variable in the model
%   (but do it while it's running because it takes a few sec)
glmX = [glmData.Subject glmData.NbackDifficulty glmData.SwitchFlag glmData.InhibitDifficulty glmData.numOfEFsInThisTrial glmData.TotalTrialCount glmData.StimShowTime glmData.RespTime];
RF_Abilitymodel_1B = fitglm(glmX,glmY,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,7],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','TrialCount','Timeout','RT','Correct'})
% discuss the way we built the model and sanity checks from coeffs
%       printGLMcoeffs(RF_Abilitymodel_1B, true); % don't really need to print them, unless we want to look at the coeffs more easily...?
glmSubjs = glmLabelsToNumbers(RF_Abilitymodel_1B.CoefficientNames(2:22)); % remove the "Subj_" and make them numbers again
[~, clustComplete] = removeNonMatchingSubjects(glmSubjs, glmSubjs, ccTable.Subject, ccTable, true, true); % removeNonMatchingSubjects(names1, dataset1, names2, dataset2, willBeUsedForPlotting, verbose)
zScatter(clustComplete.total, RF_Abilitymodel_1B.Coefficients.Estimate(2:22), 'Clusters completed compared to Ability', 'Clusters completed', 'GLM-estimated Ability', true, '', '', 14, false, '', '');
% also show the Ability/CC for all subj, done on the SWING server

clear zRF_1B_50_99 sumIncluded ccTable glmData glmY glmX % trialsIncluded - leaving this for demo2
clear RF_Abilitymodel_1B glmSubjs clustComplete



% second demo (may not have time, depending on discussion): initial perf. and baseline EFs 
% leftover from demo1 
%       trialsIncluded = excludeSubjects_RF_1B(true, true, false, zRF_1B_50_99); % excludeSubjects_RF_1B(justRF, onlyFinished, noChancePerformance, fullData)
% this takes ~2min; consider doing it ahead of time (DONE; IGNORE FOR DEMO)
%       includedPPswitch = addPPswitchCols(excludeSubjects_RF_1B(true, true, false, zPPswitch_1B), false); % this last "false" is another verbose flag
% this takes ~30sec; consider doing it ahead of time (DONE; IGNORE FOR DEMO)
%       [x_PPSw, y_PPSw] = getDataForPreSwitchGLM(includedPPswitch, false, false); % getDataForPreSwitchGLM(preSwitchDataTable1A3, excludeSubjs, splitSubjBySwRep)

[sc_PP] = getSwitchCostRT_PP_1B(includedPPswitch, false, false); % getSwitchCostRT_PP_1B(SwitchData, printTable, verbose)
% now calculate the switch costs for the RF and Pretest data
% this takes ~2min; consider doing it ahead of time (DONE; IGNORE FOR DEMO)
%       note this prints out unusual error rates... too bad it takes too long for the demo (took a screenshot though)
%       [sc_RF] = getSwitchCostRT_RF_1B(first_N_RFshifts, 'single', false, true, false); 
% delete this unless we need it...?    [sc_PP] = getSwitchCostRT_PP_1B(excludeSubjects_RF_1B(true, true, delMe3), false, false); 

% if you want to remove subjs with >50% errors, run these lines (removes ~10 subjs, doesn't improve correlation) 
sc_RF(sc_RF.TotalErrPct > .5, :) = [];
sc_PP(sc_PP.TotalErrPct > .5, :) = [];

% clean up subjects that don't match between the two
[sc_RF, sc_PP] = removeNonMatchingSubjects(sc_RF.Subject, sc_RF, sc_PP.Subject, sc_PP, true, false);

% clean up subjects that don't have a SwCost for whatever reason
fprintf('We also may have some NaNs which will be deleted from both lists; here is the list:\n');
tableOfNonSCparticipants = table2array([sc_PP(isnan(sc_PP.Pre_SC),'Subject'); sc_RF(isnan(sc_RF.SwCost),'Subject')])
sc_PP(ismember(sc_PP.Subject, tableOfNonSCparticipants), :) = [];
sc_RF(ismember(sc_RF.Subject, tableOfNonSCparticipants), :) = [];

% Z - remember that zScatter can remove outliers if you want it to (not doing so right now) 
zScatter(sc_RF.SwCost, sc_PP.Pre_SC, 'Switch Cost from first two days of RF Switch trials compared to Pretest Switch Cost', 'RF Switch Cost (RT; first 2 days)', 'Pretest Switch Cost (ReactionTime)', true, '', '', 14, true, '', '')

clear trialsIncluded sc_PP tableOfNonSCparticipants % Note: clear all after the demo; this is just for the things that don't take long to run


