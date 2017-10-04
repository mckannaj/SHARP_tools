% Zephy McKanna
% getHalfRFshifts()
% 6/29/15
% 
% This function takes as input some number of shifts, such as those returned by getSomeRFshifts().
% ... as well as whether we want trials from the 'first' (default) or 'last' half of these
% shifts.
%
% This function is intended to allow other functions to use data from only the first
% or the last half of some shifts, to try to account for the initial dip in 
% performance switching from shift to shift.
% 
function [requestedTrials] = getHalfRFshifts(shifts, firstOrLast)
    if (strcmpi(firstOrLast, 'last') == 0) % not looking for the last specifically
        firstOrLast = 'first'; % explicitly state that we're looking for the first
    end
    fprintf('getHalfRFshifts: returning the %s half of these shifts. Might take a bit.\n', firstOrLast);
    
    requestedTrials = []; % start with a clean slate, so we can build it up subj by subj and shift by shift
    subjs = unique(shifts.Subject);
    for subj = 1:(length(subjs)) % go through all subjects, because shiftNums are not unique across subjects
        subjData = shifts(shifts.Subject == subjs(subj),:);
        uniqueShifts = unique(subjData.ShiftNum); % unique shifts for this subject
        for subjShift = 1:(length(uniqueShifts)) % go through each shift for this subject
            shiftData = subjData(subjData.ShiftNum == uniqueShifts(subjShift),:);
            totTrials = height(shiftData);
            if (strcmpi(firstOrLast, 'first')) % asking for the first half
                requestedTrials = [requestedTrials; shiftData(1:floor(totTrials/2),:)]; % add this half of this shift to the growing list
            else % last half
                requestedTrials = [requestedTrials; shiftData(ceil(totTrials/2):end,:)]; % add this half of this shift to the growing list
            end
        end
    end
        
end