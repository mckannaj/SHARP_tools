% Zephy McKanna
% 11/13/14
%
% This function takes the SwitchTrials and RepetitionTrials outputs from
% getNewRT_RF_1A3(), and turns them into a combined table with one row per 
% subject and three columns involving the SwitchCost (SC): 
% SCFirstThird, SCLastThird, SCDiff
% SCDelta is simply the difference between the first and last thirds.
% NOTE: we use only the "correct" trials for reaction times, as per
% Franziska's instructions.
%
% If the "excludeSubjs" flag is set, we also exclude the decided-upon list
% of subjects for 1A-3.
%
function [scRT] = getSwitchCostRT_RF_1A3(switchRT, repetitionRT, excludeSubjs)
    if (isequal(switchRT(:,1), repetitionRT(:,1)) == 0)
        error('somehow the subjects in the two matrices you passed in are different; getSwitchCostRT_RF_1A3 cannnot handle this.');
    end
    
    for row=1:height(switchRT)
        if ((switchRT.FirstThirdCorrect(row) == -9999) || (switchRT.LastThirdCorrect(row) == -9999) || (repetitionRT.FirstThirdCorrect(row) == -9999) || (repetitionRT.LastThirdCorrect(row) == -9999)) % "exclude" flag passed in by getNewRT_RF_1A3()
            fprintf('getSwitchCostRT_RF_1A3: excluding subj %d due to previous issues.\n', switchRT(row,1));
            scFirstThird = -9999;
            scLastThird = -9999;
            scDelta = -9999;
        else % not marked for exclusion
            scFirstThird = switchRT.FirstThirdCorrect(row) - repetitionRT.FirstThirdCorrect(row);
            scLastThird = switchRT.LastThirdCorrect(row) - repetitionRT.LastThirdCorrect(row);
            scDelta = scLastThird - scFirstThird;
        end
        scMat(row, :) = [switchRT.Subject(row), scFirstThird, scLastThird, scDelta];
    end
    
    scRT = array2table(scMat, 'VariableNames', {'Subject','FirstThirdRTswitchCost','LastThirdRTswitchCost','DeltaRTswitchCost'});
    
    if (excludeSubjs == true)
        scRT = excludeSubjects_RF_1A3('both', scRT);
    end
end


