% Zephy McKanna
% insertFirstTimeClusterFlagsIntoSum_1B
% 12/3/15
%
% This function takes a version of the 1B SUM table (or any table including
% a "Subject", "Date", and "Cluster" variable), and inserts two new rows
% into it: firstTimeSeeingCluster and firstTimeSeeingClusterToday. 
% firstTimeSeeingCluster is 1 when a participant encounters a cluster for the first
% time ever, and 0 otherwise. 
% firstTimeSeeingCluster is 1 when a participant encounters a cluster for 
% the first time in a given day, and 0 otherwise.
% 
function [sumWithFirstTimeClusterFlags] = insertFirstTimeClusterFlagsIntoSum_1B(sumTable1B, verbose)
    sumWithFirstTimeClusterFlags = [];
    sumTable1B.firstTimeSeeingCluster = zeros(height(sumTable1B), 1);
    sumTable1B.firstTimeSeeingClusterToday = zeros(height(sumTable1B), 1);
   
    uniqueSubjNums = unique(sumTable1B.Subject);
    for rowNum = 1:length(uniqueSubjNums)
        subj = uniqueSubjNums(rowNum); % subj
        if (verbose == true)
            fprintf('Inserting flags for subject %d.\n', subj);
        end
        subjShifts = sumTable1B(sumTable1B.Subject == subj, :); % subjShifts from SUM file
        subjClustersSeen = {'initializing'}; % strfind is more consistent in its results if it has something to search through 
        subjClustersSeenToday = {'initializing'}; % strfind is more consistent in its results if it has something to search through 
        for shiftNum = 1:height(subjShifts)
            if (shiftNum > 1) % the first shift/day is already initialized
                if (subjShifts.Date(shiftNum) ~= subjShifts.Date(shiftNum - 1)) % we're on a new day
                    subjClustersSeenToday = {'initializing'}; % reset the clusters we've seen today
                end
            end
            clusterNameForSearching = strcat(subjShifts.Cluster{shiftNum}, '_endOfClusterFlag'); % need this because (e.g.) 'S' is found in 'S/I/Logic'
            sawThisAlready = strfind(subjClustersSeen, clusterNameForSearching);
            if (isempty(cell2mat(sawThisAlready))) % we haven't seen this cluster before
                subjClustersSeen = [subjClustersSeen, {clusterNameForSearching}]; % add it to what we've seen before
                subjShifts.firstTimeSeeingCluster(shiftNum) = 1; % note that we hadn't seen it before
            end
            
            sawThisAlreadyToday = strfind(subjClustersSeenToday, clusterNameForSearching);
            if (isempty(cell2mat(sawThisAlreadyToday))) % we haven't seen this cluster before
                subjClustersSeenToday = [subjClustersSeenToday, {clusterNameForSearching}]; % add it to what we've seen before
                subjShifts.firstTimeSeeingClusterToday(shiftNum) = 1; % note that we hadn't seen it before today
            end
            
        end
        sumWithFirstTimeClusterFlags = [sumWithFirstTimeClusterFlags; subjShifts]; % add this subject's shifts to the list
    end
end
  