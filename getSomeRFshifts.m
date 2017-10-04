% Zephy McKanna
% % getSomeRFshifts()
% 3/27/15
% 
% This function takes as input:
%   - the "all" table created by formTables_RF_1A3(), or 
%   - (if some subjects should be excluded), the table produced by
%         excludeSubjects_RF_1A3(), or
%   - if only a single subject should be used, just the data from that
%         subject
% ... as well as a number of shifts that should be returned.
%
% Finally, it takes a flag to note whether the first or last shifts should
% be returned. If firstOrLast = 'last', then it will return the input data
% in the same form, but with all but the last [numShifts] shifts removed.
% Otherwise (default), it will return all but the first [numShifts] shifts.
%
% If the "cluster" flag contains anything but 'all', we will assume that it
% contains a cluster (e.g., 'U', 'U/S', etc.); we will only return shifts
% of that cluster.
%
% This function is intended to allow other functions to use data from only the first
% or the last X shifts, to compare them to the pre/post test results.
% 
function [requestedShifts] = getSomeRFshifts(preExcludedData1A3, numShifts, cluster, firstOrLast)
    if (strcmpi(firstOrLast, 'last') == 0) % not looking for the last specifically
        firstOrLast = 'first'; % explicitly state that we're looking for the first
    end
    fprintf('getSomeRFshifts: returning the %s %d shifts.\n', firstOrLast, numShifts);
    
    if (strcmpi(cluster, 'all') == 0) % we're not just using every cluster, so just grab the rows from the cluster "cluster"
        preExcludedData1A3 = preExcludedData1A3(strcmpi(preExcludedData1A3.Cluster, cluster), :);
    end

    requestedShifts = []; % start with a clean slate, so we can build it up subj by subj
    subjs = unique(preExcludedData1A3.Subject);
    for subj = 1:(length(subjs)) % go through all subjects
        subjData = preExcludedData1A3(preExcludedData1A3.Subject == subjs(subj),:);
        uniqueShifts = unique(subjData.ShiftNum);
        
        if (length(uniqueShifts) < numShifts)
            fprintf('getSomeRFshifts: subj %d has fewer shifts than %d. Returning all shifts (%d).\n', subjs(subj), numShifts, length(uniqueShifts));
            requestedShifts = [requestedShifts; subjData]; % add this subject's shifts to the growing list
        else
            if (strcmpi(firstOrLast, 'last')) % just grab the last numShifts shifts
                subjNumShifts = subjData(subjData.ShiftNum > uniqueShifts(length(uniqueShifts) - numShifts), :); % note that this should be > and not >=, since we don't want the [total - N]th shift
            else % looking for the first numShifts shifts (default)
                subjNumShifts = subjData(subjData.ShiftNum <= uniqueShifts(numShifts), :);
            end
            requestedShifts = [requestedShifts; subjNumShifts]; % add this subject's shifts to the growing list
        end
    end
        
end