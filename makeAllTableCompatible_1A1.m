% Zephy McKanna
% makeAllDataTableCompatible_1A1()
% 3/8/15
% 
% This function takes as input the "all" table created by
% formTables_RF_1A3(), formed using 1A-1 data (thus, has no "Cluster" column)
% and has various other discrepancies from the 1A-2 and -3 data. It
% attempts to correct these and where possible put the table into 1A-3
% format. 
% 
% The output is the new Table, containing the following changes:
% - addition of "Cluster" column
% - addition of "Problem" column (identical to "Trials")
% - addition of "ActualN" column (identical to "N")
% - addition of "ShiftNum" column (identical to "gameNum")
function [newTable] = makeAllTableCompatible_1A1(allDataTable1A1)

    newTable = insertClusterIntoAllTable_1A1(allDataTable1A1);
    newTable.Problem = newTable.Trial;
    newTable.ActualN = newTable.N;
    newTable.ShiftNum = newTable.GameNum;
    
end
