% Zephy McKanna
% 12/9/14
%
% This function takes a table containing a "Subject" column, and removes
% data from the following subjects (agreed to be excluded from 1A-2):
% 
% Dropped/quit:
% 1212, 1225, (z: any more??? have to ask the sites...)
%
% Excluded:
% '1221' '1234' '1235' '1245' '2248'
%
% It returns the original table, less the rows of those subjects.
%
function [tableWithoutExcludedSubjects] = excludeSubjects_RF_1A2(fullData)
    tableWithoutExcludedSubjects = fullData;
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1212, :) = [];
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1225, :) = [];

    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1221, :) = [];
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1234, :) = [];
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1235, :) = [];
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1245, :) = [];
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2248, :) = [];
end
