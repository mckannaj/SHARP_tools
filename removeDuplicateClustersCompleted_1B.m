% Zephy McKanna
% removeDuplicateClustersCompleted_1B
% 12/3/15
%
% This function takes a version of the 1B SUM table (or any table including
% a "Subject" variable and a "ClustersComplete" variable), and removes any
% clusters from the ClustersComplete that are "completed" more than once.
% This is primarily to correct for jump-back clusters being "completed"
% over and over for high-performing subjects.
% 
function [sumWithSingleClustersComplete] = removeDuplicateClustersCompleted_1B(sumTable1B, verbose)
    sumWithSingleClustersComplete = [];
    uniqueSubjNums = unique(sumTable1B.Subject);
    for rowNum = 1:length(uniqueSubjNums)
        subj = uniqueSubjNums(rowNum); % subj
        if (verbose == true)
            fprintf('Cleaning clusters from subject %d.\n', subj);
        end
        subjShifts = sumTable1B(sumTable1B.Subject == subj, :); % subjShifts from SUM file
        subjClustersComplete = {'initializing'};
        for shiftNum = 1:height(subjShifts)
            if (isnan(subjShifts.ClusterComplete{shiftNum}) == 0) % we completed a cluster
                clusterNameForSearching = strcat(subjShifts.ClusterComplete{shiftNum}, '_endOfClusterFlag'); % need this because (e.g.) 'S' is found in 'S/I/Logic'
                completedThisAlready = strfind(subjClustersComplete, clusterNameForSearching);
                if (isempty(cell2mat(completedThisAlready))) % we haven't completed this already
                    subjClustersComplete = [subjClustersComplete, {clusterNameForSearching}];
                else % we have completed this already; mark it as not complete here
                    subjShifts.ClusterComplete{shiftNum} = NaN;
                end
            end
        end
        sumWithSingleClustersComplete = [sumWithSingleClustersComplete; subjShifts]; % add this subject's shifts to the list
    end
end
  