% Zephy McKanna
% 11/14/14
%
% This function takes the Update N=2 "thirds" output from
% getNewAccuracy_RF_1A3(), and turns it into a table with one row per 
% subject and three columns involving the Accuracy: 
% N2AccFirstThird, N2AccLastThird, N2AccDelta
% N2AccDelta is simply the difference between the first and last thirds.
%
% If the "excludeSubjs" flag is set, we also exclude the decided-upon list
% of subjects for 1A-3.
%
function [updAcc] = getUpdateAccN2_RF_1A3(N2UpdThirds, excludeSubjs)
    
    for row=1:height(N2UpdThirds)
        % check for NaNs
        if (isnan(N2UpdThirds.FirstThirdAcc(row)) == 1)
            N2UpdThirds.FirstThirdAcc(row) = 0;
            fprintf('NaN in the firstThirdAcc for subj %d; substituting 0 so as not to break.\n', N2UpdThirds.Subject(row));
        end
        if (isnan(N2UpdThirds.LastThirdAcc(row)) == 1)
            N2UpdThirds.LastThirdAcc(row) = 0;
            fprintf('NaN in the lastThirdAcc for subj %d; substituting 0 so as not to break.\n', N2UpdThirds.Subject(row));
        end
        accDelta = N2UpdThirds.LastThirdAcc(row) - N2UpdThirds.FirstThirdAcc(row);        
        accMat(row, :) = [N2UpdThirds.Subject(row), N2UpdThirds.FirstThirdAcc(row), N2UpdThirds.LastThirdAcc(row), accDelta];
    end
    
    updAcc = array2table(accMat, 'VariableNames', {'Subject','FirstThirdUpdAccN2','LastThirdUpdAccN2','DeltaUpdAccN2'});
    
    if (excludeSubjs == true)
        updAcc = excludeSubjects_RF_1A3('both', updAcc);
    end
end


