% Zephy McKanna
% getConditions_1B
% 5/31/15
%  
% This function takes any data table with a "Subject" column and a
% "Condition" column, and returns a table with two columns: one row per
% subject, and their condition (tRNS, sham TDCS, etc).
%
% It also returns their Status (Finished, Active, Quit, etc.).
%
function [subjCondTable] = getConditions_1B(dataTable1B, printTable)
    uniqueSubjNums = unique(dataTable1B.Subject); % grab the subj numbers
    
    subjCondTable = table(0,{'XXX'},{'XXX'},'VariableNames',{'Subject', 'Condition', 'Status'});
    
    for rowNum = 1:(length(uniqueSubjNums)), % loop through all subjs
%        subjCondTable.Subject(rowNum,1) = uniqueSubjNums(rowNum);
        subjRows = dataTable1B(dataTable1B.Subject == uniqueSubjNums(rowNum),:);
%        subjCondTable.Condition(rowNum,2) = subjRows.Condition(1); % should be the same condition throughout, so just take the first row
        subjCondTable(rowNum,1:end) = table(uniqueSubjNums(rowNum),subjRows.Condition(1),subjRows.Status(1)); % placeholder, so we can change them one at a time
    end
        
    fileName = '';
    if ((strcmpi('', printTable) == 0) && (printTable ~= false)) % there's something in printTable, and it's not "false"
        if (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getConditions_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(subjCondTable, fileName);
    end

end
