% Zephy McKanna
% insertClusterIntoAllTable_1A1()
% 3/8/15
% 
% This function takes as input the "all" table created by
% formTables_RF_1A3(), and assumes that it has been formed using 1A-1 data
% (thus, has no "Cluster" column). If it is given a table that already has
% a Cluster column, the results are not predictable.
%
function [newTable] = insertClusterIntoAllTable_1A1(allDataTable1A1)

    newTable = allDataTable1A1;
    newTable.Cluster = newTable.Game; % necessary? just trying to get the right number of rows...    
    newTable.Cluster(:) = {'unknown'}; % set to a value we know doesn't exist, for error checking
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Update n-back'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U'}; % fill that table with 'U'
    newTable(strcmpi(newTable.Game, 'Update n-back'),:).Cluster = tmpClusterTable; % then assign it to the right rows
% don't need this (I think?)    tmpClusterTable = []; % finally, clear it for the next "game to cluster" translation

    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Inhibit Go-NoGo'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'I'}; % fill that table with 'I'
    newTable(strcmpi(newTable.Game, 'Inhibit Go-NoGo'),:).Cluster = tmpClusterTable; % then assign it to the right rows

    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Switch NoModeSwitch ED'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'S'}; % fill that table with 'S'
    newTable(strcmpi(newTable.Game, 'Switch NoModeSwitch ED'),:).Cluster = tmpClusterTable; % then assign it to the right rows

    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Inhibit StopSignal'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'I'}; % fill that table with 'I'
    newTable(strcmpi(newTable.Game, 'Inhibit StopSignal'),:).Cluster = tmpClusterTable; % then assign it to the right rows

    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Switch NoModeSwitch ID'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'S'}; % fill that table with 'S'
    newTable(strcmpi(newTable.Game, 'Switch NoModeSwitch ID'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Switch/Inhibit ED and GoNoGo'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'S/I'}; % fill that table with 'S/I'
    newTable(strcmpi(newTable.Game, 'Switch/Inhibit ED and GoNoGo'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Update/Inhibit Stop-Signal and n-back'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/I'}; % fill that table with 'U/I'
    newTable(strcmpi(newTable.Game, 'Update/Inhibit Stop-Signal and n-back'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Update/Switch ED and n-back'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/S'}; % fill that table with 'U/S'
    newTable(strcmpi(newTable.Game, 'Update/Switch ED and n-back'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Switch/Inhibit ID and StopSignal'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'S/I'}; % fill that table with 'S/I'
    newTable(strcmpi(newTable.Game, 'Switch/Inhibit ID and StopSignal'),:).Cluster = tmpClusterTable; % then assign it to the right rows

    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Update/Inhibit GoNoGo n-back'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/I'}; % fill that table with 'U/I'
    newTable(strcmpi(newTable.Game, 'Update/Inhibit GoNoGo n-back'),:).Cluster = tmpClusterTable; % then assign it to the right rows
   
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Update - xOR'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/Logic'}; % fill that table with 'U/Logic'
    newTable(strcmpi(newTable.Game, 'Update - xOR'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Inhibit - Identity - OneStim'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'I/Logic'}; % fill that table with 'I/Logic'
    newTable(strcmpi(newTable.Game, 'Inhibit - Identity - OneStim'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Switch - Identity - OneStim'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'S/Logic'}; % fill that table with 'U/Logic'
    newTable(strcmpi(newTable.Game, 'Switch - Identity - OneStim'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Update - Identity'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/Logic'}; % fill that table with 'U/Logic'
    newTable(strcmpi(newTable.Game, 'Update - Identity'),:).Cluster = tmpClusterTable; % then assign it to the right rows

    tmpClusterTable = newTable(strcmpi(newTable.Game, 'Inhibit - GoNoGo - xOR'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'I/Logic'}; % fill that table with 'I/Logic'
    newTable(strcmpi(newTable.Game, 'Inhibit - GoNoGo - xOR'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'UpdateSwitch - Identity - OneStim'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/S/Logic'}; % fill that table with 'U/S/Logic'
    newTable(strcmpi(newTable.Game, 'UpdateSwitch - Identity - OneStim'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'UpdateSwitch - Relational - OneStim'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/S/Relational'}; % fill that table with 'U/S/Relational'
    newTable(strcmpi(newTable.Game, 'UpdateSwitch - Relational - OneStim'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'UpdateInhibit - Identity - OneStim'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/I/Logic'}; % fill that table with 'U/I/Logic'
    newTable(strcmpi(newTable.Game, 'UpdateInhibit - Identity - OneStim'),:).Cluster = tmpClusterTable; % then assign it to the right rows

    tmpClusterTable = newTable(strcmpi(newTable.Game, 'UpdateSwitch - xOR - OneStim'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/S/Logic'}; % fill that table with 'U/S/Logic'
    newTable(strcmpi(newTable.Game, 'UpdateSwitch - xOR - OneStim'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'SwitchInhibit - Identity - OneStim'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'S/I/Logic'}; % fill that table with 'U/S/Logic'
    newTable(strcmpi(newTable.Game, 'SwitchInhibit - Identity - OneStim'),:).Cluster = tmpClusterTable; % then assign it to the right rows
    
    tmpClusterTable = newTable(strcmpi(newTable.Game, 'UpdateInhibit - xOR - OneStim'),:).Cluster; % make a table the right height
    tmpClusterTable(:,1) = {'U/I/Logic'}; % fill that table with 'U/I/Logic'
    newTable(strcmpi(newTable.Game, 'UpdateInhibit - xOR - OneStim'),:).Cluster = tmpClusterTable; % then assign it to the right rows

    
    % testing - if we still have unknown clusters, we've got an error...
    if (isempty(newTable(strcmpi(newTable.Cluster, 'unknown'),:)) == false)
        newTable(strcmpi(newTable.Cluster, 'unknown'),:)
        error('We still have unknown clusters! They should be printed out above this line.\n');
    end


end