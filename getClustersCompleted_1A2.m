% Zephy McKanna
% 11/9/14
% 
% This function attempts to calculate the number of clusters that have been passed by
% each participant, for builds in progressions for experiment 1A-2. 
% 
% It does this by first compiling all the clusters that the participant has
% seen into a list, then finding the last example of each seen cluster. 
% If the last example of a cluster was seen more than 13 before the
%    end, that cluster was passed. 
% The longest possible cluster enumeration (if you've unlocked the most 
% possible clusters at once) has 13 clusters unlocked. This would have
% the following unlocked: U/I, S/I, U/S, U/Logic(xOR), U/Logic(ID), S/Logic(xOR), S/Logic(ID), I/Logic(xOR), I/Logic(ID), U/S/Relational, L4aV1, L4aV2, L4b
% 
%
function [clustersCompleteCount] = getClustersCompleted_1A2(sumTable1A2)

    uniqueSubjNums = unique(sumTable1A2.Subject); % grab the subj numbers
    sumTable1A2.Cluster(strcmpi(sumTable1A2.Cluster,'U/Logic(xOR)'),:) = {'U/Logic'}; % for some reason, these are two different clusters; merge them before counting

    for rowNum = 1:(length(uniqueSubjNums)), % loop through all subjs
        subj = uniqueSubjNums(rowNum);
        clustersCompleteCount(rowNum, 1) = subj; % first col is subject number

        subjRows = sumTable1A2(sumTable1A2.Subject == subj, :); % grab all the rows for the subject (zNOTE: might be more efficient to grab only relevant columns?)
        clusters = subjRows.Cluster;
        uniqueClusters = unique(subjRows.Cluster);
        clusterCount = length(clusters);
        lastThirteenSeen = clusters(clusterCount - 12 : clusterCount); % grab the last thirteen clusters seen
        
        completedClusters = setdiff(uniqueClusters, lastThirteenSeen); % anything seen that's not in the last 13 must have been completed
        
        clustersCompleteCount(rowNum, 2) = length(completedClusters); % second col is number of clusters completed
        if (subj == 2250)
% just for testing            completedClusters
        end
        
    end

end