% Zephy McKanna
% getClustersCompleted_1B
% 4/9/15
%  
% This function consolidates the clusters that have been passed by each
% participant, from the list in the "sum" file.
%
% It takes as input the "sum" file from Phase 1B, which has a "clusterComplete" column. 
%
% It returns two matrices. Both have a list of subjects as the first
% column. The clustersCompleteCount matrix lists the count of clusters
% complete in the second column. The clustersCompleteTable has 17 other
% columns, each of which has a logical value indicating passed (1) or not
% passed (0). The columns, in order (from 2 to 18) are:
% U, S, I, U/I, S/I, U/S, U/Logic, S/Logic, I/Logic, U/I/Logic, S/I/Logic, U/S/Logic, U/S/Relational, L4aV1, L4aV2, L4bV1, L4bV2
%
% If onlyUniqueCompletions = true, then it deletes any duplicate cluster
% completions (e.g., if you complete 'U' and then complete it again when it
% "jumps back" to the single-EF shift of the day).
%
function [clustersCompleteCount, clustersCompleteTable] = getClustersCompleted_1B(sumTable1B, onlyUniqueCompletions, printTable)

    uniqueSubjNums = unique(sumTable1B.Subject); % grab the subj numbers
    sumTable1B.ClusterComplete(strcmpi(sumTable1B.ClusterComplete,'U/Logic(xOR)'),:) = {'U/Logic'}; % for some reason, these are marked as two different clusters; merge them before counting
    
    clustersCompleteTable = table(0,0,{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},'VariableNames',{'Subject', 'total', 'Cluster1', 'Cluster2', 'Cluster3', 'Cluster4', 'Cluster5', 'Cluster6', 'Cluster7', 'Cluster8', 'Cluster9', 'Cluster10', 'Cluster11', 'Cluster12', 'Cluster13', 'Cluster14', 'Cluster15', 'Cluster16', 'Cluster17', 'Cluster18', 'Cluster19', 'Cluster20', 'Cluster21', 'Cluster22', 'Cluster23'});
    
    for rowNum = 1:(length(uniqueSubjNums)), % loop through all subjs
%        clustersCompleteTable{rowNum, 1} = 0;
%        clustersCompleteTable{rowNum, 2} = 0;
        clustersCompleteTable(rowNum, 1:end) = table(0,0,{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'});
% just for testing        fprintf('getClustersCompleted_1B: subject %d.\n', uniqueSubjNums(rowNum));

        subj = uniqueSubjNums(rowNum);
        clustersCompleteCount(rowNum, 1) = subj; % first col is subject number
        clustersCompleteTable{rowNum, 1} = subj;
%        clustersCompleteMatrix(rowNum, 1) = subj; % first col is subject number
       
        subjRows = sumTable1B(sumTable1B.Subject == subj, :); % grab all the rows for the subject (zNOTE: might be more efficient to grab only relevant columns?)
%        clustersComplete = unique(subjRows.ClusterComplete);
        clustersCompleteSubj = subjRows.ClusterComplete;
        
        findNANsFunction = @(x) all(isnan(x(:)));
        clustersCompleteSubj(cellfun(findNANsFunction, clustersCompleteSubj)) = []; % delete all the "NaN"s

        if (onlyUniqueCompletions == true) % make sure we just have unique Clusters in our count (can't "complete" the jump-back clusters twice)
            clustersCompleteSubj = unique(clustersCompleteSubj);
        end
        
        clustersCompleteSubj = clustersCompleteSubj.'; % transpose col to row
        
        for colNum = 1:length(clustersCompleteSubj)
%            clustersCompleteSubj(colNum)
            clustersCompleteTable{rowNum, colNum+2} = clustersCompleteSubj(colNum);
        end
        
        
%        clustersCompleteMatrix{rowNum, :} = [subj clustersCompleteSubj];
        clustersCompleteCount(rowNum,2) = length(clustersCompleteSubj);
        clustersCompleteTable.total(rowNum) = length(clustersCompleteSubj);
        
    end
    
    fileName = '';
    if ((strcmpi('', printTable) == 0) && (printTable ~= false)) % there's something in printTable, and it's not "false"
        if (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getClustersCompleted_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(clustersCompleteTable, fileName);
    end


end

