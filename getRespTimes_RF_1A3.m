% Zephy McKanna
% RF cumulative correct / incorrect
% 10/30/14
% 
% This function takes the "all" table created by formTables_RF_1A3() - or 
% any table containing Correct, Subject, Cluster, RespTime, ActualN, and GivenRep - and 
% creates two matrices (correct and incorrect) with the subject numbers, cluster, and response times
% 
%
function [correctRT, incorrectRT] = getRespTimes_RF_1A3(allTable)
    curCorrectRow = 1;
    curIncorrectRow = 1;
    totalRows = height(allTable(1:end, 1)); % count the number of rows in the table
    
    for row = 1:totalRows
       if (allTable{row, 'Correct'} == 1) % if this row was correct
           correctRT{curCorrectRow, 1} = allTable{row, 'Subject'};
           correctRT(curCorrectRow, 2) = allTable{row, 'Cluster'}; % use () for strings
           correctRT{curCorrectRow, 3} = allTable{row, 'RespTime'};
           correctRT{curCorrectRow, 4} = allTable{row, 'ActualN'};
           correctRT(curCorrectRow, 5) = allTable{row, 'GivenResp'}; % use () for strings
           correctRT{curCorrectRow, 6} = allTable{row, 'StimTime'};
           curCorrectRow = curCorrectRow + 1; % write to the next row next time
       elseif (allTable{row, 'Correct'} == 0) % if this row was incorrect
           incorrectRT{curIncorrectRow, 1} = allTable{row, 'Subject'};
           incorrectRT(curIncorrectRow, 2) = allTable{row, 'Cluster'}; % use () for strings
           incorrectRT{curIncorrectRow, 3} = allTable{row, 'RespTime'};
           incorrectRT{curIncorrectRow, 4} = allTable{row, 'ActualN'};
           incorrectRT(curIncorrectRow, 5) = allTable{row, 'GivenResp'}; % use () for strings
           incorrectRT{curIncorrectRow, 6} = allTable{row, 'StimTime'};
           curIncorrectRow = curIncorrectRow + 1; % write to the next row next time
       else
           error('Unknown value for Correct row: %d; aborting function.\n', allTable{row, 'Correct'});
       end
        
    end
    
end