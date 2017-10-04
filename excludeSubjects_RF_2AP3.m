% Zephy McKanna
% excludeSubjects_RF_2AP3
% 11/7/16
%
% This function takes a table containing a "Subject" column, and removes
% data from the following subjects (to be excluded from 2A-Pilot3):
% 
% Participants who were noncompliant from AC
% 1101
% 1356
% 1363
% 1510
% 1519
% 1530
% 
% Participants who were noncompliant from RF
% 1529
% 1312
% 1514
% 1316
% 1323
% 
% If "justFinished" is true, then only participants with "Status" = "FINISHED" are returned. 
% If "justRF" is true, then participants with "Training" = "sharp_training" (i.e., AC) are excluded. 
%
% It returns "fullData", less the rows of those subjects.
%
function [tableWithoutExcludedSubjects] = excludeSubjects_RF_2AP3(justFinished, excludeNCRF, excludeNCAC, justRF, fullData)
    if (nargin ~= nargin('excludeSubjects_RF_2AP3'))
        error('zError: excludeSubjects_RF_2AP3 expects %d inputs, but received %d. Please update any calling code.\n', nargin('excludeSubjects_RF_2AP3'), nargin);
    end
    
    tableWithoutExcludedSubjects = fullData;
 
    if (excludeNCAC == true)
        % noncompliant from AC
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1101, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1356, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1363, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1510, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1519, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1530, :) = [];
    end
    
    if (excludeNCRF == true)
        % noncompliant from RF
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1529, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1312, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1340, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1115, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1514, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1316, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1323, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1356, :) = [];
    end
    
    if (justRF == true)
        tableWithoutExcludedSubjects(strcmpi(tableWithoutExcludedSubjects.Training, 'sharp_training'),:) = [];
    end
    if (justFinished == true)
        tableWithoutExcludedSubjects = tableWithoutExcludedSubjects(strcmpi(tableWithoutExcludedSubjects.Status, 'FINISHED'),:);
    end
    
    % regardless, we're excluding the ones who dropped out or quit
    tableWithoutExcludedSubjects(strcmpi(tableWithoutExcludedSubjects.Training, 'QUIT'),:) = [];
    tableWithoutExcludedSubjects(strcmpi(tableWithoutExcludedSubjects.Training, 'DROPPED'),:) = [];
end
