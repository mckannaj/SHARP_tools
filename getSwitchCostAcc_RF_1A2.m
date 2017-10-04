% Zephy McKanna
% 12/9/14
%
% This function takes the SwitchTrials and RepetitionTrials "thirds" outputs from
% getNewAccuracy_RF_1A3(), and turns them into a combined table with one row per 
% subject and three columns involving the Accuracy (or, in the new version, 
% error rate) SwitchCost (SC): 
% SCFirstThird, SCLastThird, SCDelta
% SCDelta is simply the difference between the first and last thirds.
% NOTE: we start out with accuracy (correct/total), but change it to error 
% (1-accuracy), as per Franziska's instructions.
%
% If the "excludeSubjs" flag is set, we also exclude the decided-upon list
% of subjects for 1A-3.
%
function [scAcc] = getSwitchCostAcc_RF_1A2(switchAcc, repetitionAcc, excludeSubjs)
    if (isequal(switchAcc(:,1), repetitionAcc(:,1)) == 0)
        error('somehow the subjects in the two matrices you passed in are different; getSwitchCostRT_RF_1A2 cannnot handle this.');
    end
    
    for row=1:height(switchAcc)
        errFirstThirdSwitchTrials = 1 - switchAcc.FirstThirdAcc(row);
        errFirstThirdRepTrials = 1 - repetitionAcc.FirstThirdAcc(row);
        scFirstThird = errFirstThirdSwitchTrials - errFirstThirdRepTrials;
        errLastThirdSwitchTrials = 1 - switchAcc.LastThirdAcc(row);
        errLastThirdRepTrials = 1 - repetitionAcc.LastThirdAcc(row);
        scLastThird = errLastThirdSwitchTrials - errLastThirdRepTrials;
        scDelta = scLastThird - scFirstThird;
        scMat(row, :) = [switchAcc.Subject(row), scFirstThird, scLastThird, scDelta];
    end
    
    scAcc = array2table(scMat, 'VariableNames', {'Subject','FirstThirdAccSwitchCost','LastThirdAccSwitchCost','DeltaAccSwitchCost'});
    
    if (excludeSubjs == true)
        scAcc = excludeSubjects_RF_1A2(scAcc);
    end
end


