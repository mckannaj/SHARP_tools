% Zephy McKanna
% 1/18/17
% get50subjsTrialData_1B()
% 
% This function takes a number from 1-13
% and returns the 1B trial data for a set of subjects, as follows:
% 1 = 0-49
% 2 = 50-99
% 3 = 100-149
% 4 = 200-249 (150-199 doesn't exist!)
% 5 = 250-299
% 6 = 300-349
% 7 = 350-399
% 8 = 400-449
% 9 = 450-499
% 10 = 500-549
% 11 = 600-649 (550-599 doesn't exist!)
% 12 = 650-699
% 13 = 700-749 
% 14 = nothing (750-799 doesn't exist!)
%
% It also clears out any of the other datasets that exist, so as not to use
% up all the memory and slow down the automated calculation that is calling
% this function.
%
function [trialTable] = get50subjsTrialData_1B(subjSet)
    trialTable = []; % assume we're returning nothing

    % first load and return the one requested
    if (subjSet == 1)
        load(getFileNameForThisOS('RFAll_1B-0_49-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-0_49-2015_10_29.mat')
        trialTable = zRF_1B_0_49;
    elseif (subjSet == 2)
        load(getFileNameForThisOS('RFAll_1B-50_99-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-50_99-2015_10_29.mat')
        trialTable = zRF_1B_50_99;
    elseif (subjSet == 3)
        load(getFileNameForThisOS('RFAll_1B-100_149-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-100_149-2015_10_29.mat')
        trialTable = zRF_1B_100_149;
    elseif (subjSet == 4)
        load(getFileNameForThisOS('RFAll_1B-200_249-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-200_249-2015_10_29.mat')
        trialTable = zRF_1B_200_249;
    elseif (subjSet == 5)
        load(getFileNameForThisOS('RFAll_1B-250_299-2015_10_29', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-250_299-2015_10_29.mat')
        trialTable = zRF_1B_250_299;
    elseif (subjSet == 6)
        load(getFileNameForThisOS('RFAll_1B-300_349-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-300_349-2015_10_29.mat')
        trialTable = zRF_1B_300_349;
    elseif (subjSet == 7)
        load(getFileNameForThisOS('RFAll_1B-350_399-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-350_399-2015_10_29.mat')
        trialTable = zRF_1B_350_399;
    elseif (subjSet == 8)
        load(getFileNameForThisOS('RFAll_1B-400_449-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-400_449-2015_10_29.mat')
        trialTable = zRF_1B_400_449;
    elseif (subjSet == 9)
        load(getFileNameForThisOS('RFAll_1B-450_499-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-450_499-2015_10_29.mat')
        trialTable = zRF_1B_450_499;
    elseif (subjSet == 10)
        load(getFileNameForThisOS('RFAll_1B-500_549-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-500_549-2015_10_29.mat')
        trialTable = zRF_1B_500_549;
    elseif (subjSet == 11)
        load(getFileNameForThisOS('RFAll_1B-600_649-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-600_649-2015_10_29.mat')
        trialTable = zRF_1B_600_649;
    elseif (subjSet == 12)
        load(getFileNameForThisOS('RFAll_1B-650_699-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-650_699-2015_10_29.mat')
        trialTable = zRF_1B_650_699;
    elseif (subjSet == 13)
        load(getFileNameForThisOS('RFAll_1B-700_749-2015_10_29.mat', 'ParsedData')); 
        % load('/Users/Shared/SHARP/ParsedData/RFAll_1B-700_749-2015_10_29.mat')
        trialTable = zRF_1B_700_749;
    end

    % then clear any of these that still exist (might not be necessary? - if things are loaded inside a function, do they exist outside it?) 
    clear zRF_1B_0_49 zRF_1B_50_99 zRF_1B_100_149 zRF_1B_150_199
    clear zRF_1B_200_249 zRF_1B_250_299 zRF_1B_300_349 zRF_1B_350_399
    clear zRF_1B_400_449 zRF_1B_450_499 zRF_1B_500_549 zRF_1B_550_599
    clear zRF_1B_600_649 zRF_1B_650_699 zRF_1B_700_749 zRF_1B_750_799
end