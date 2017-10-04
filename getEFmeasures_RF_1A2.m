% Zephy McKanna
% 11/16/14
%
% This function takes as input the "all" table created by formTables_RF_1A3().
% NOTE: several of the functions called by this function are 1A3 functions;
% these have been checked to also work with 1A2 data. The rest have been
% changed to 1A2 versions.
%
% It then cleans the data and gets separate EF trials using:
% getCleanSwitchTrials_RF_1A3()
%    for which it uses default values ignoring the first trial of each
%    shift, ignoring trials right after error trials, and ignoring trials
%    where the subject didn't respond.
% getCleanUpdateTrials_RF_1A3()
%    for which it uses default values ignoring trials where the subject
%    didn't respond.
%
% Since SSRT can't be calculated from 1A-2 data (no SSD), we don't clean or
% use Inhibit trials.
%
% It then uses these trial tables to calculate the appropriate comparative
% measure for that EF, from first third to last third, using:
% getNewAccuracy_RF_1A3() and then getSwitchCostAcc_RF_1A2() to calculate Switch Cost using Accuracy.
% getNewRT_RF_1A3() and then getSwitchCostRT_RF_1A2() to calculate Switch Cost using Reaction Time.
% getNewAccuracy_RF_1A3() and then getUpdateAccN2_RF_1A2() to calculate Update Score for N=2 using Accuracy.
% Inhibit SSRT can't be calculated from 1A2 data, as there is no StopSignal
% Delay (SSD) in our Inhibit cues for 1A2.
%
% It puts all of these together in a single table, with one row per subject, 
% and a subject column and three column for each measure (firstThird, 
% lastThird, and delta, which is the difference between first and last third).
%
% It will error out if the subject lists aren't the same for all measures.
% (This would only happen if some subject didn't encounter all four EFs
% somehow...?)
%
% If the "dualTask" flag is set to true, then it uses data from dual tasks
% involved in the given EF (e.g., Update trials from "U/S" and "U/I"); if
% false, it will just use the single EF shifts (e.g. "U").
%
% If the "excludeSubjs" flag is true, then we will exclude the subjects for
% 1A-2.
%
% If the "printTable" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the thirdsTable.
%
function [EFmeasures] = getEFmeasures_RF_1A2(allData, excludeSubjs, dualTasks, printTable)
    fprintf('Cleaning the switch trials.\n');
    if (dualTasks == false)
        [sw_switchTrials, sw_nonSwitchTrials] = getCleanSwitchTrials_RF_1A3(true, true, 'both', dualTasks, allData);
    else
        [sw_switchTrials, sw_nonSwitchTrials] = getCleanSwitchTrials_dualTasks_RF_1A3(true, true, 'both', false, dualTasks, allData);        
    end
    fprintf('Cleaning the update trials.\n');
    if (dualTasks == false)
        [~, upd_N2Trials, ~, ~] = getCleanUpdateTrials_RF_1A3('both', dualTasks, allData);
    else
        [~, upd_N2Trials, ~, ~] = getCleanUpdateTrials_dualTasks_RF_1A3('both', false, dualTasks, allData);
    end

%{ 
Can't calculate SSRT, so I guess we don't do anything with Inhibit trials...?    
    fprintf('Cleaning the inhibit trials.\n');
    if (dualTasks == false)
        [inh_goTrials, inh_inhibitTrials] = getCleanInhibitTrials_RF_1A3(true, 'GoBoth', 'correct', true, dualTasks, allData);
    else
        [inh_goTrials, inh_inhibitTrials] = getCleanInhibitTrials_dualTasks_RF_1A3(true, 'GoBoth', 'correct', true, false, dualTasks, allData);
    end
%}
    
    fprintf('Calculating Switch Cost using Accuracy.\n');
    [~, thirdsAcc_swSwitch] = getNewAccuracy_RF_1A3(sw_switchTrials, false);
    [~, thirdsAcc_swRepetition] = getNewAccuracy_RF_1A3(sw_nonSwitchTrials, false);
    [sw_scAcc] = getSwitchCostAcc_RF_1A2(thirdsAcc_swSwitch, thirdsAcc_swRepetition, excludeSubjs);

    fprintf('Calculating Switch Cost using Response Time.\n');
    [thirdsRT_swSwitch] = getNewRT_RF_1A3(sw_switchTrials, false);
    [thirdsRT_swRepetition] = getNewRT_RF_1A3(sw_nonSwitchTrials, false);
    [sw_scRT] = getSwitchCostRT_RF_1A2(thirdsRT_swSwitch, thirdsRT_swRepetition, excludeSubjs);

    fprintf('Calculating Update score (for N=2).\n');
    [~, thirdsAcc_updN2] = getNewAccuracy_RF_1A3(upd_N2Trials, false);
    [updAcc] = getUpdateAccN2_RF_1A2(thirdsAcc_updN2, excludeSubjs);

    fprintf('SSRT for Inhibit cannot be calculated for 1A-2.\n');
%    [SSRTtable] = getSSRTthirds_RF_1A2(inh_goTrials, inh_inhibitTrials, excludeSubjs);

    % make sure all the "subject" rows are the same
    if (isequal(sw_scRT(:,1), sw_scAcc(:,1)) == 0)
        error('Somehow the subjects in the switchCostRT matrix and the switchCostAcc matrix are different. Aborting.');
    end
    if (isequal(sw_scRT(:,1), updAcc(:,1)) == 0)
        error('Somehow the subjects in the switchCostRT matrix and the updateAcc matrix are different. Aborting.');
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

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printThirds
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getSingleEFmeasures_RF_1A2-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(EFmeasures, fileName);
    end

end