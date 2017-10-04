% Zephy McKanna
% insertTotalTrialCount()
% 5/25/15
% 
% TotalTrialCount
%  Inserts the number of trials (of any sort) that this participant has
%  seen, into any table with 1 row per trial, and a Subject column.
%
function [newDataTable] = insertTotalTrialCount(oldDataTable)
    if (nargin ~= nargin('insertTotalTrialCount'))
        error('zError: insertTotalTrialCount expects %d inputs, but received %d. Please update any calling code.\n', nargin('insertTotalTrialCount'), nargin);
    end

    TotalTrialCount = zeros(height(oldDataTable),1) - 1; % -1 = error (sanity check)
    subjTrialCount = 0; % we will increment this before it gets used
    curParticipant = -1; % start with nonsense; will be updated
    for row = 1:height(oldDataTable) % loop through all the trials %!!! ZEPHY: IS THERE NO BETTER WAY TO DO THIS? LOOPS ARE REALLY SLOW!
        if (curParticipant ~= oldDataTable.Subject(row)) % different participant; give some "staying alive" output
            curParticipant = oldDataTable.Subject(row);
            subjTrialCount = 0; % we will increment this before it gets used
            fprintf('insertTotalTrialCount: adding rows for participant %d.\n', curParticipant);
        end
        
        subjTrialCount = subjTrialCount + 1;
        TotalTrialCount(row) = subjTrialCount;
    end
    newDataTable = oldDataTable;
    newDataTable.TotalTrialCount = TotalTrialCount;
end