% Zephy McKanna
% 11/9/14
% 
% This function attempts to calculate the number of clusters that have been passed by
% each participant, for builds in progressions for experiment 1A-3. 
% 
% It does this by first compiling all the clusters that the participant has
% seen into a list, then finding the last example of each seen cluster. At
% this point, there are two rules (NOTE: currently only using rule 2!):
%    1. If certain clusters were seen, then other clusters were passed. 
%        - If U/Logic is seen, U is passed. 
%        - If S/Logic is seen, S is passed. 
%        - If I/Logic is seen, I is passed. 
%        - If U/S/Relational is seen, U/S is passed. 
%    2. If the last example of a cluster was seen more than 11 before the
%    end, that cluster was passed. The longest possible cluster enumeration 
%    (if you've unlocked the most possible clusters at once) has 11 
%    clusters unlocked. This would have the following unlocked: 
% U/I, S/I, U/S, U/Logic, S/Logic, I/Logic, U/S/Relational, L4aV1, L4aV2, L4bV1, L4bV2
% 
% This function takes as input the "sum" table created by formTables_RF_1A3().
%
% It returns two matrices. Both have a list of subjects as the first
% column. The clustersCompleteCount matrix lists the count of clusters
% complete in the second column. The clustersCompleteTable has 17 other
% columns, each of which has a logical value indicating passed (1) or not
% passed (0). The columns, in order (from 2 to 18) are:
% U, S, I, U/I, S/I, U/S, U/Logic, S/Logic, I/Logic, U/I/Logic, S/I/Logic, U/S/Logic, U/S/Relational, L4aV1, L4aV2, L4bV1, L4bV2
%
function [clustersCompleteCount, clustersCompleteTable] = getClustersCompleted_1A3(sumTable1A3)

    uniqueSubjNums = unique(sumTable1A3.Subject); % grab the subj numbers
    sumTable1A3.Cluster(strcmpi(sumTable1A3.Cluster,'U/Logic(xOR)'),:) = {'U/Logic'}; % for some reason, these are marked as two different clusters; merge them before counting

    for rowNum = 1:(length(uniqueSubjNums)), % loop through all subjs
        subj = uniqueSubjNums(rowNum);
        clustersCompleteCount(rowNum, 1) = subj; % first col is subject number
        
        subjRows = sumTable1A3(sumTable1A3.Subject == subj, :); % grab all the rows for the subject (zNOTE: might be more efficient to grab only relevant columns?)
        clusters = subjRows.Cluster;
        uniqueClusters = unique(subjRows.Cluster);
        clusterCount = length(clusters);
        lastElevenSeen = clusters(clusterCount - 10 : clusterCount); % grab the last eleven clusters seen
        
        completedClusters = setdiff(uniqueClusters, lastElevenSeen); % anything seen that's not in the last 11 must have been completed
        
        clustersCompleteCount(rowNum, 2) = length(completedClusters); % second col is number of clusters completed
% just for testing        if (subj == 2250)
% just for testing            completedClusters
% just for testing        end
        
        clustersCompleteCellRow = {0, '','','','','','','','','','','','','','','','',''}; % make a cell structure with 18 columns, to hold max possible cluster info
        clustersCompleteCellRow{1,1} = subj; % first col is subject number
        for col = 1:length(completedClusters)
            clustersCompleteCellRow(1,col+1) = completedClusters(col);
        end
        % for now, just put placeholders in clustersCompleteTable
        clustersCompleteCells(rowNum, :) = clustersCompleteCellRow;
    end
    tableHeaders = {'Subject', 'U', 'S', 'I', 'U_I', 'S_I', 'U_S', 'U_Logic', 'S_Logic', 'I_Logic', 'U_I_Logic', 'S_I_Logic', 'U_S_Logic', 'U_S_Relational', 'L4aV1', 'L4aV2', 'L4bV1', 'L4bV2'};
    clustersCompleteTable = cell2table(clustersCompleteCells, 'VariableNames',tableHeaders);
end