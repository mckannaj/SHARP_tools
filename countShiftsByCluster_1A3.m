% Zephy McKanna
% countShiftsByCluster_1A3()
% 1/24/15
% 
% This function takes as input the "sum" table created by formTables_RF_1A3().
% It returns a table in which each subject has a single row,
% the first col is the subject number, the second col is the total shifts
% attempted by that subject, and the remaining cols are clusters from the following list:
% U, I, S,
% U/I, S/I, U/S
% U/Logic, S/Logic, I/Logic
% U/I/Logic, S/I/Logic, U/S/Logic, U/S/Relational
% L4aV1, L4aV2, L4bV1, L4bV2
%
% Each cell is the number of times that the participant encountered/attempted
% a shift in that cluster.
% 
% If the "excludeSubjs" flag is true, then we will exclude the subjects for
% 1A-3.
%
% If the "printTable" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the thirdsTable.
% Note: "printTable" can also just be set to true for a default filename.
%
function [clustersAttemptedTable] = countShiftsByCluster_1A3(sumTable1A3, excludeSubjs, printTable)
    
    if (excludeSubjs == true)
        sumTable1A3 = excludeSubjects_RF_1A3('both', sumTable1A3);
    end

    uniqueSubjNums = unique(sumTable1A3.Subject); % grab the subj numbers
    sumTable1A3.Cluster(strcmpi(sumTable1A3.Cluster,'U/Logic(xOR)'),:) = {'U/Logic'}; % for some reason, these are (sometimes?) marked as two different clusters; merge them before counting

    for rowNum = 1:(length(uniqueSubjNums)), % loop through all subjs
        clustersAttemptedCells(rowNum, :) = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}; % make a cell structure with 19 columns; all should be replaced
        subj = uniqueSubjNums(rowNum);
        clustersAttemptedCells{rowNum, 1} = subj; % first col is subject number

        subjRows = sumTable1A3(sumTable1A3.Subject == subj, :); % grab all the rows for the subject
        clustersAttemptedCells{rowNum, 2} = height(subjRows); % second col is the total shifts attempted
        
        % now count each cluster in turn
        clustersAttemptedCells{rowNum, 3} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'U'),:));
        clustersAttemptedCells{rowNum, 4} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'S'),:));
        clustersAttemptedCells{rowNum, 5} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'I'),:));
        clustersAttemptedCells{rowNum, 6} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'U/I'),:));
        clustersAttemptedCells{rowNum, 7} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'S/I'),:));
        clustersAttemptedCells{rowNum, 8} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'U/S'),:));
        clustersAttemptedCells{rowNum, 9} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'U/Logic'),:));
        clustersAttemptedCells{rowNum, 10} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'S/Logic'),:));
        clustersAttemptedCells{rowNum, 11} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'I/Logic'),:));
        clustersAttemptedCells{rowNum, 12} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'U/I/Logic'),:));
        clustersAttemptedCells{rowNum, 13} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'S/I/Logic'),:));
        clustersAttemptedCells{rowNum, 14} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'U/S/Logic'),:));
        clustersAttemptedCells{rowNum, 15} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'U/S/Relational'),:));
        clustersAttemptedCells{rowNum, 16} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'L4aV1'),:));
        clustersAttemptedCells{rowNum, 17} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'L4aV2'),:));
        clustersAttemptedCells{rowNum, 18} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'L4bV1'),:));
        clustersAttemptedCells{rowNum, 19} = length(subjRows.Cluster(strcmpi(subjRows.Cluster,'L4bV2'),:));
    end
    
    tableHeaders = {'Subject', 'total', 'U', 'S', 'I', 'U_I', 'S_I', 'U_S', 'U_Logic', 'S_Logic', 'I_Logic', 'U_I_Logic', 'S_I_Logic', 'U_S_Logic', 'U_S_Relational', 'L4aV1', 'L4aV2', 'L4bV1', 'L4bV2'};
    clustersAttemptedTable = cell2table(clustersAttemptedCells, 'VariableNames',tableHeaders);

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('countShiftsByCluster_1A3-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(clustersAttemptedTable, fileName);
    end

end
