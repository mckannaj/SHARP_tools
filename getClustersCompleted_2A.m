% Zephy McKanna
% getClustersCompleted_2A
% 10/26/16
%  
% This function consolidates the clusters that have been passed by each
% participant, from the list in the "sum" file.
%
% It takes as input the "sum" file from Phase 2A, which has a "clusterComplete" column. 
%
% It returns two matrices. Both have as the first columns:
%   1. a list of subjects
%   2. the subjects' RF version number (which it expects to be in
%      SumTable as a column called RFversion)
%   3. the count of clusters complete, and 
%   4. the number of clusters complete per EF shift attempted (to balance
%      out the fact that one RF version is doing Categorization and the
%      other isn't)
%
% The clustersCompleteTable has 28 additional 
% columns, each of which has a logical value indicating passed (1) or not
% passed (0). The columns, in order (from 5 to 33) are:
% U, S, I, U/I, S/I, U/S, 
% U/Logic, S/Logic, I/Logic, 
% U/I/Logic, S/I/Logic, U/S/Logic, U/S/Relational, 
% L4aV1, L4aV2, 
% L4bV1, L4bV1b, L4bV1c, L4bV1d, L4bV1e, L4bV1f,     - NOTE: not sure how many of these there actually are (just <=f)... should check 
% L4bV2, L4bV2b, L4bV2c, L4bV2d, L4bV2e, L4bV2f,     - NOTE: not sure how many of these there actually are (just <=f)... should check 
% Cat
% 
% If onlyUniqueCompletions = true, then it deletes any duplicate cluster
% completions (e.g., if you complete 'U' and then complete it again when it
% "jumps back" to the single-EF shift of the day). This may not be
% necessary in 2A, since we don't have any jump-back shifts (at least in
% Pilot 3...), but it's useful for legacy (and for the continuing U/Logic
% versus U/Logic(xOR) issue).
%
function [clustersCompleteCount, clustersCompleteTable] = getClustersCompleted_2A(sumTable2A, onlyUniqueCompletions, printTable)

    uniqueSubjNums = unique(sumTable2A.Subject); % grab the subj numbers
    sumTable2A.ClusterComplete(strcmpi(sumTable2A.ClusterComplete,'U/Logic(xOR)'),:) = {'U/Logic'}; % for some reason, these are marked as two different clusters; merge them before counting
    
    clustersCompleteTable = table(0,{'XXX'},0,0.0,...
        {'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},...
        {'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},...
        {'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},...
        {'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},...
        'VariableNames',{'Subject', 'RFversion', 'total', 'totalPerEFshift',...
        'Cluster1', 'Cluster2', 'Cluster3', 'Cluster4', 'Cluster5', 'Cluster6', 'Cluster7',... 
        'Cluster8', 'Cluster9', 'Cluster10', 'Cluster11', 'Cluster12', 'Cluster13', 'Cluster14',...
        'Cluster15', 'Cluster16', 'Cluster17', 'Cluster18', 'Cluster19', 'Cluster20', 'Cluster21',...
        'Cluster22', 'Cluster23', 'Cluster24', 'Cluster25', 'Cluster26', 'Cluster27', 'Cluster28'});
    
    for rowNum = 1:(length(uniqueSubjNums)), % loop through all subjs
        clustersCompleteTable(rowNum, 1:end) = table(0,{'XXX'},0,0.0,...
            {'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},...
            {'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},...
            {'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},...
            {'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'},{'XXX'});
% just for testing        fprintf('getClustersCompleted_1B: subject %d.\n', uniqueSubjNums(rowNum));

        subj = uniqueSubjNums(rowNum);
        clustersCompleteCount(rowNum, 1) = subj; % first col is subject number
        clustersCompleteTable{rowNum, 1} = subj;
       
        subjRows = sumTable2A(sumTable2A.Subject == subj, :); % grab all the rows for the subject (zNOTE: might be more efficient to grab only relevant columns?)

%        clustersCompleteCount(rowNum, 2) = subjRows.Version(1); % second col is RF version (should be identical for all rows for this subj)
        clustersCompleteTable{rowNum, 2} = subjRows.Version(1); % second col is RF version (should be identical for all rows for this subj)
        
        clustersCompleteSubj = subjRows.ClusterComplete;
        EFattemptsSubj = subjRows.Cluster;
        EFattemptsSubj(strcmpi(EFattemptsSubj, 'Cat'),:) = []; % delete all the categorization tasks - not fair to compare them (2.5x as long, etc.)
        
        findNANsFunction = @(x) all(isnan(x(:)));
        clustersCompleteSubj(cellfun(findNANsFunction, clustersCompleteSubj)) = []; % delete all the "NaN"s

        if (onlyUniqueCompletions == true) % make sure we just have unique Clusters in our count (can't "complete" the jump-back clusters twice)
            clustersCompleteSubj = unique(clustersCompleteSubj);
        end
        
        clustersCompleteSubj = clustersCompleteSubj.'; % transpose col to row
        
        for colNum = 1:length(clustersCompleteSubj)
            clustersCompleteTable{rowNum, colNum+4} = clustersCompleteSubj(colNum);
        end
        
        
        clustersCompleteCount(rowNum,3) = length(clustersCompleteSubj);
        clustersCompleteCount(rowNum,4) = ( length(clustersCompleteSubj) / length(EFattemptsSubj) );
        clustersCompleteTable.total(rowNum) = length(clustersCompleteSubj);        
        clustersCompleteTable.totalPerEFshift(rowNum) = ( length(clustersCompleteSubj) / length(EFattemptsSubj) );        
    end
    
    % probably ought to make these an "if verbose=true" block
    fprintf('Average: %f, StdDev: %f.\n', mean(clustersCompleteTable.total), std(clustersCompleteTable.total));
    
    fileName = '';
    if ((strcmpi('', printTable) == 0) && (printTable ~= false)) % there's something in printTable, and it's not "false"
        if (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getClustersCompleted_2A-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(clustersCompleteTable, fileName);
    end
end

