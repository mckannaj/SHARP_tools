% Zephy McKanna
% 11/16/14
%
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% It then cleans the data and gets separate EF trials using:
% getCleanSwitchTrials_RF_1A3()
%    for which it uses default values ignoring the first trial of each
%    shift, ignoring trials right after error trials, and ignoring trials
%    where the subject didn't respond.
% getCleanUpdateTrials_RF_1A3()
%    for which it uses default values ignoring trials where the subject
%    didn't respond.
% getCleanInhibitTrials_RF_1A3()
%    for which it uses default values returning only correct Go trials where 
%        they actually responded, that are less than 3 standard deviations from the mean, 
%    and ignoring Inhibit trials where they wouldn't have responded anyway.
%
% It then uses these trial tables to calculate the appropriate comparative
% measure for that EF, from first third to last third, using:
% getNewAccuracy_RF_1A3() and then getSwitchCostAcc_RF_1A3() to calculate Switch Cost using Accuracy.
% getNewRT_RF_1A3() and then getSwitchCostRT_RF_1A3() to calculate Switch Cost using Reaction Time.
% getNewAccuracy_RF_1A3() and then getUpdateAccN2_RF_1A3() to calculate Update Score for N=2 using Accuracy.
% getSSRTthirds2_RF_1A3() to calculate Inhibit SSRT.
%
% It puts all of these together in a single table, with one row per subject, 
% and a subject column and three column for each measure (firstThird, 
% lastThird, and delta, which is the difference between first and last third).
%
% It will error out if the subject lists aren't the same for all measures.
% (This would only happen if some subject didn't encounter all four EFs
% somehow...?)
%
% If the "excludeSubjs" flag is true, then we will exclude the subjects for
% 1A-3.
%
% If the "printTable" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the thirdsTable.
%
function [EFmeasures] = getSingleEFmeasures_RF_1A3(allData, excludeSubjs, printTable)
    fprintf('Cleaning the switch trials.\n');
% [switchTrials, nonSwitchTrials, allTrials] = getCleanSwitchTrials_RF_1B(noFirstTrials, noAfterError, ignoreNoResponse, cluster, allTrialData, verbose)
    [sw_switchTrials, sw_nonSwitchTrials] = getCleanSwitchTrials_RF_1A3(true, true, 'both', allData);
    fprintf('Cleaning the update trials.\n');
% [N1Trials,N2Trials,N3Trials, allUpdateTrials] = getCleanUpdateTrials_RF_1A3(ignoreNoResponse, dualTasks, allTrialData, verbose)
    [~, upd_N2Trials, ~, ~] = getCleanUpdateTrials_RF_1A3('both', false, allData, false);
    fprintf('Cleaning the inhibit trials.\n');
% [goTrials, inhibitTrials] = getCleanInhibitTrials_RF_1A3(onlyCorrectGo, ignoreNoResponse, ignoreNoResponseAnyway, ignore3PlusSDs, dualTasks, allTrialData)
    [inh_goTrials, inh_inhibitTrials] = getCleanInhibitTrials_RF_1A3(true, 'GoBoth', 'correct', true, allData);

    fprintf('Calculating Switch Cost using Accuracy.\n');
    [~, thirdsAcc_swSwitch] = getNewAccuracy_RF_1A3(sw_switchTrials, false);
    [~, thirdsAcc_swRepetition] = getNewAccuracy_RF_1A3(sw_nonSwitchTrials, false);
    [sw_scAcc] = getSwitchCostAcc_RF_1A3(thirdsAcc_swSwitch, thirdsAcc_swRepetition, excludeSubjs);

    fprintf('Calculating Switch Cost using Response Time.\n');
    [thirdsRT_swSwitch] = getNewRT_RF_1A3(sw_switchTrials, false);
    [thirdsRT_swRepetition] = getNewRT_RF_1A3(sw_nonSwitchTrials, false);
    [sw_scRT] = getSwitchCostRT_RF_1A3(thirdsRT_swSwitch, thirdsRT_swRepetition, excludeSubjs);

    fprintf('Calculating Update score (for N=2).\n');
    [~, thirdsAcc_updN2] = getNewAccuracy_RF_1A3(upd_N2Trials, false);
    [updAcc] = getUpdateAccN2_RF_1A3(thirdsAcc_updN2, excludeSubjs);

    fprintf('Calculating SSRT for Inhibit.\n');
    [SSRTtable] = getSSRTthirds2_RF_1A3(inh_goTrials, inh_inhibitTrials, excludeSubjs);

    % make sure all the "subject" rows are the same
    if (isequal(sw_scRT(:,1), sw_scAcc(:,1)) == 0)
        error('Somehow the subjects in the switchCostRT matrix and the switchCostAcc matrix are different. Aborting.');
    end
    if (isequal(sw_scRT(:,1), updAcc(:,1)) == 0)
        error('Somehow the subjects in the switchCostRT matrix and the updateAcc matrix are different. Aborting.');
    end
    if (isequal(sw_scRT(:,1), SSRTtable(:,1)) == 0)
        error('Somehow the subjects in the switchCostRT matrix and the SSRT matrix are different. Aborting.');
    end

    EFmeasures = array2table(sw_scAcc.Subject, 'VariableNames', {'Subject'}); % there must be a better way to do this...?
    EFmeasures.FirstThirdAccSwitchCost = sw_scAcc.FirstThirdAccSwitchCost;
    EFmeasures.LastThirdAccSwitchCost = sw_scAcc.LastThirdAccSwitchCost;
    EFmeasures.DeltaAccSwitchCost = sw_scAcc.DeltaAccSwitchCost;

    EFmeasures.FirstThirdRTswitchCost = sw_scRT.FirstThirdRTswitchCost;
    EFmeasures.LastThirdRTswitchCost = sw_scRT.LastThirdRTswitchCost;
    EFmeasures.DeltaRTswitchCost = sw_scRT.DeltaRTswitchCost;

    EFmeasures.FirstThirdUpdAccN2 = updAcc.FirstThirdUpdAccN2;
    EFmeasures.LastThirdUpdAccN2 = updAcc.LastThirdUpdAccN2;
    EFmeasures.DeltaUpdAccN2 = updAcc.DeltaUpdAccN2;

    EFmeasures.FirstThirdSSRT = SSRTtable.FirstThirdSSRT;
    EFmeasures.LastThirdSSRT = SSRTtable.LastThirdSSRT;
    EFmeasures.DeltaSSRT = SSRTtable.DeltaSSRT;
    
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printThirds
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getSingleEFmeasures_RF_1A3-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(EFmeasures, fileName);
    end

end