% Zephy McKanna
% 9/3/17
% removeUncommonShifts_1B()
% 
% This function takes some data containing RobotFactory shiftIDs and removes
% those that have been seen by fewer than minNumberSubjs, or were seen
% fewer than minNumberTimes in total, or both.
% 
% If either minNumberSubjs or minNumberTimes > 0, then it will be included
% in the search for shifts. Any shifts that do not meet the criteria are
% discarded.
%
function [commonData] = removeUncommonShifts_1B(allData, minNumberSubjs, minNumberTimes, verbose)
    commonData = allData;
    shiftIDs = unique(allData.ShiftID);
    for i = 1:length(shiftIDs)
        thisShiftID = shiftIDs(i);
        thisShiftRows = commonData(commonData.ShiftID == thisShiftID,:);
        subjs = unique(thisShiftRows.Subject);
        if (minNumberSubjs > 0)
            if (minNumberSubjs > length(subjs))
                commonData(commonData.ShiftID == thisShiftID,:) = []; % remove these; not seen by enough people
            end
            if (verbose == true)
                fprintf('ShiftID %d was seen by %d subjects.\n', thisShiftID, length(subjs)); % mostly for debugging
            end
        end
        if (minNumberTimes > 0)
            shiftSeenCount = 0;
            shiftNums = unique(thisShiftRows.ShiftNum); % (NOTE: should be cumulativeShiftNum, for 2B!)
            for j = 1:length(shiftNums) % only unique identifier for a particular shift is Subj + ShiftNum
                shiftsWithThisNum = thisShiftRows(thisShiftRows.ShiftNum == shiftNums(j),:);
                shiftSeenCount = shiftSeenCount + length(unique(shiftsWithThisNum.Subject)); % add the number of Subjs who had this ShiftNum
            end
            if (shiftSeenCount < minNumberTimes) 
                commonData(commonData.ShiftID == thisShiftID,:) = []; % remove these; not seen enough times
            end
        end
    end
end