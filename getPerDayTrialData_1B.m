% Zephy McKanna
% 7/13/17
% getPerDayTrialData_1B()
% 
% This function takes a number from 1-12
% and returns the 1B trial data for that training day. Training days are
% defined as follows:
% T1 = ShiftNum 1-20
% T2 = ShiftNum 21-40
% T3 = ShiftNum 41-60
% ...
% TN = ShiftNum ((20(N-1))+1) through (20N), inclusive
%
% Note that T12 shouldn't exist, but in fact does for 43 subjects.
%
function [trialTable] = getPerDayTrialData_1B(trainingDay)
    trialTable = []; % assume we're returning nothing

    % first load and return the one requested
        % Znote: is there a better way to do this, by parsing the strings? Figure it out and refactor. 
    if (trainingDay == 1)
        load(getFileNameForThisOS('RFAll_1B-T1-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T1;
    elseif (trainingDay == 2)
        load(getFileNameForThisOS('RFAll_1B-T2-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T2;
    elseif (trainingDay == 3)
        load(getFileNameForThisOS('RFAll_1B-T3-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T3;
    elseif (trainingDay == 4)
        load(getFileNameForThisOS('RFAll_1B-T4-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T4;
    elseif (trainingDay == 5)
        load(getFileNameForThisOS('RFAll_1B-T5-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T5;
    elseif (trainingDay == 6)
        load(getFileNameForThisOS('RFAll_1B-T6-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T6;
    elseif (trainingDay == 7)
        load(getFileNameForThisOS('RFAll_1B-T7-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T7;
    elseif (trainingDay == 8)
        load(getFileNameForThisOS('RFAll_1B-T8-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T8;
    elseif (trainingDay == 9)
        load(getFileNameForThisOS('RFAll_1B-T9-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T9;
    elseif (trainingDay == 10)
        load(getFileNameForThisOS('RFAll_1B-T10-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T10;
    elseif (trainingDay == 11)
        load(getFileNameForThisOS('RFAll_1B-T11-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T11;
    elseif (trainingDay == 12)
        load(getFileNameForThisOS('RFAll_1B-T12-2015_10_29.mat', 'ParsedData')); 
        trialTable = zRF_1B_T12;
    else
        error('getPerDayTrialData_1B received unknown training day %d; should be between 1-12.\n', trainingDay);
    end

    % then clear any of these that still exist (might not be necessary? - if things are loaded inside a function, I don't think they exist outside of it...?) 
    clear zRF_1B_T1 zRF_1B_T2 zRF_1B_T3 zRF_1B_T4 zRF_1B_T5 zRF_1B_T6
    clear zRF_1B_T7 zRF_1B_T8 zRF_1B_T9 zRF_1B_T10 zRF_1B_T11 zRF_1B_T12
end