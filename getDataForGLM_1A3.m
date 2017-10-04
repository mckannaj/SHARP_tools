% Zephy McKanna
% getDataForGLM_1A3()
% 2/1/15
% 
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% It returns two matrices:
% 1. a single-column matrix intended to be the Y values (correct/incorrect)
% 2. a multiple-column matrix in which each column is an X value. This
% matrix includes cols for subj, "difficulty" (made up of cluster + N value), and 
% respTime. We may later add stimDuration.
%
% If the onlySingleEFs flag is true, we only use data from three clusters:
% 'U', 'S', and 'I'.
%
% If the excludeSubjs flag is true, it excludes the agreed-upon subjects
% from 1A3.
%
function [xVals, yVals] = getDataForGLM_1A3(allDataTable1A3, onlySingleEFs, excludeSubjs)
    
    if (onlySingleEFs == true)
        allDataTable1A3 = allDataTable1A3(strcmpi(allDataTable1A3.Cluster,'U') | strcmpi(allDataTable1A3.Cluster,'S') | strcmpi(allDataTable1A3.Cluster,'I'), :);
    end
    
    if (excludeSubjs == true)
        allDataTable1A3 = excludeSubjects_RF_1A3('both', allDataTable1A3);
    end
        
    yVals = table2array(allDataTable1A3(:,'Correct'));
    
    xVals = table2array(allDataTable1A3(:,'Subject'));
    xVals(:,2) = categorical(table2array(allDataTable1A3(:,'Cluster'))); % Note: U=3, S=2, I=1
    temp = table2array(allDataTable1A3(:,'ActualN')); % N = 1 for S, I; N = 1-3 for U
    temp = temp-1; % now temp (N vals) ranges from 0-2
    xVals(:,2) = xVals(:,2) + temp; % now I=1, S=2, U+N1 = 3, U+N2 = 4, U+N3 = 5
% just for testing    unique(xVals(:, 2))
 
    xVals(:,3) = table2array(allDataTable1A3(:,'RespTime'));
% combining into "difficulty" (xVal2)    xVals(:,4) = table2array(allDataTable1A3(:,'ActualN'));

% not including this (yet)    xVals(:,5) = table2array(allDataTable1A3(:,'StimTime'));
    
%    xVals(:,1) = categorical(xVals(:,1)); % note: if we make this categorical from the start, it initializes the entire table as categorical for some reason

    xVals(:,1) = (xVals(:,1) * 10) + xVals(:,2);

    % NOTE: It just so happens that Subj #37 is the worst. If we want to
    % use him for reference, he must be first. This adds one to all of them
    % and then makes 37 (now 38) = 1.
%    xVals(:,1) = xVals(:,1) + 1;
%    xVals(xVals(:,1)==38) = 1;
%    xVals = sortrows(xVals,1);
    
end

