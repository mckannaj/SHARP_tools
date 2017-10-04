% Zephy McKanna
% getISOtrialsThresholds_1B()
% 3/5/16
%
% This takes the SUM file (one row per shift) and the second output from 
% getIsoRperf_Shifts_1B (one row per trial).
%
% It returns an identical table to the SUM table, when each shift hits a
% given threshold (possibly .8, which is what we use for passing clusters).  
%
function [isoThresholdSumTable] = getISOtrialsThresholds_1B(sumTable, isoTrials, threshold, verbose)
    % go through the SUM file, find all the iso_trials for each shift, and add a value to the SUM file 
    isoThresholdSumTable = sumTable;
    isoThresholdSumTable.isoThresholdTrial = zeros(height(isoThresholdSumTable),1) - 1; % start with all -1s
    for sumFileRow = 1:height(sumTable)
        if (verbose == true)
            if (sumFileRow > 1)
                if (sumTable.Subject(sumFileRow) ~= sumTable.Subject(sumFileRow - 1))
                    fprintf('working on Subject %d\n', sumTable.Subject(sumFileRow));
                end
            end
        end
        shiftInfoThisRow = sumTable(sumFileRow,:);
        isoTrialsThisShift = isoTrials((isoTrials.Subject == shiftInfoThisRow.Subject) & (isoTrials.ShiftNum == shiftInfoThisRow.ShiftNum), :);
        if (isempty(isoTrialsThisShift)) % we have no ISO data for this shift
            warning('No ISO data for Subj %d ShiftNum %d.\n', sumTable.Subject(sumFileRow), sumTable.ShiftNum(sumFileRow));
            continue;
        end
        isoTrialsAboveThreshold = isoTrialsThisShift(isoTrialsThisShift.isoEst > threshold, :);
        if (isempty(isoTrialsAboveThreshold)) % nothing got above threshold
            isoThresholdEst = isoTrialsThisShift(height(isoTrialsThisShift),:).isoEst; % take the final one, as it will be the closest to threshold
        else % grab the trial number of the first one to meet threshold
            isoThresholdEst = isoTrialsAboveThreshold(1,:).TrialNum;
        end
        isoThresholdSumTable.isoThresholdTrial(sumFileRow) = isoThresholdEst;
    end
end






