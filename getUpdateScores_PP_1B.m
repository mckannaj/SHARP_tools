% Zephy McKanna
% getUpdateScores_PP_1B()
% 5/23/15
%
% This function takes a table made from pre/post update (rotation task) data. Note: if you
% wish to exclude certain subjects, pass RotationData through some exclusion function 
% (e.g. excludeSubjects_RF_1B) before giving it to this function.
%
% It does not yet clean the data, except that you can specify a percentage
% of the rotated letters that must be correct to be included
%  - on any given trial (minPctLetterCorrectTrial), and
%    NOTE: According to Todd, this is not a factor (should be 0)
%  - overall for any given subject (minPctLetterCorrectSubj)
%    NOTE: According to Todd, this should be 85%
%
% It cleans the data as follows: 
%   1. Deletes all trials where the letter %Correct is less than minPctLetterCorrectTrial
%   2. (after calculation of the scores) Marks all participants whose
%   overall letter %Correct is less than minPctLetterCorrectSubj
%
% It then calculates the UpdateScores for each subject as follows:
%   1. Letter = take the number of correct letters / total letters
%   2. Arrow = take the number of correct arrows / total arrows
%
% It outputs a table with columns: subj, condition, minLetter, 
% preOverMin, preLetter, preArrow, 
% postOverMin, postLetter, postArrow, 
% bothOverMin, deltaLetter, deltaArrow
%
% If the "printTable" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the SSRTtable.
%
function [updateTable] = getUpdateScores_PP_1B(UpdateData, minPctLetterCorrectTrial, minPctLetterCorrectSubj, printTable)
    if (nargin ~= nargin('getUpdateScores_PP_1B'))
        error('getUpdateScores_PP_1B expects %d inputs, but received %d. Please update any calling code.\n', nargin('getUpdateScores_PP_1B'), nargin);
    end

    if ((minPctLetterCorrectTrial >= 0) && (minPctLetterCorrectTrial <= 1)) % percentage - what we expect (do nothing)
    elseif ((minPctLetterCorrectTrial > 1) && (minPctLetterCorrectTrial <= 100)) % make into a percentage
        minPctLetterCorrectTrial = minPctLetterCorrectTrial / 100;
    else % we don't know what this is
        error('getUpdateScores_PP_1B: the minPercent inputs must be between 0 and 100. This was %d.\n', minPctLetterCorrectTrial);
    end
    if ((minPctLetterCorrectSubj >= 0) && (minPctLetterCorrectSubj <= 1)) % percentage - what we expect (do nothing)
    elseif ((minPctLetterCorrectSubj > 1) && (minPctLetterCorrectSubj <= 100)) % make into a percentage
        minPctLetterCorrectSubj = minPctLetterCorrectSubj / 100;
    else % we don't know what this is
        error('getUpdateScores_PP_1B: the minPercent inputs must be between 0 and 100. This was %d.\n', minPctLetterCorrectSubj);
    end
    
    if (minPctLetterCorrectTrial > 0) % we want to remove trials that have less than this % letters correct
        UpdateData.pctLetCorrect = zeros(height(UpdateData), 1) - 1; % -1 is an impossible percentage; sanity check
        for checkRow = 1:height(UpdateData)
            UpdateData.pctLetCorrect(checkRow) = UpdateData.NumLetCorrect(checkRow) / UpdateData.SeqLength(checkRow);
%            if (pctLetCorrect < minPctLetterCorrectTrial) % this trial has too few letters correct to be considered
%                UpdateData(checkRow, :) = []; % delete it
%                fprintf('Deleting row %d from subj %d; pctLetCorrect=%f.\n',checkRow, UpdateData.Subject(checkRow), pctLetCorrect);
%            end
        end
        UpdateData(UpdateData.pctLetCorrect < minPctLetterCorrectTrial, :) = []; % delete the trials with too few letters correct to be considered
    end
    
    allSubjects = unique(UpdateData.Subject);
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        subjTrials = UpdateData((UpdateData.Subject == subj), :);
        
        preTrials = subjTrials(strcmpi(subjTrials.Period,'0-PreTest'), :);
        preAllArrowCorrectTrials = preTrials(preTrials.SeqLength == preTrials.NumArrCorr, :); % to calculate "absolute span"
        if (height(preTrials) == 0)
            fprintf('getUpdateScores_PP_1B - Somehow subj %d has no pretest data...? Setting scores to NaN.\n', subj);
            preSeqTotal = NaN;
            preLetterCount = NaN;
            preArrowCount = NaN;
            preLetter = NaN;
            preArrow = NaN;
        else
            preSeqTotal = sum(preTrials.SeqLength);
            preLetterCount = sum(preTrials.NumLetCorrect);
            preArrowCount = sum(preTrials.NumArrCorr);
            preAllArrowCorrectCount = sum(preAllArrowCorrectTrials.SeqLength); % "the sum of all correctly recalled set sizes"
            
            preLetter = preLetterCount / preSeqTotal;
            preArrow = preArrowCount / preSeqTotal;
        end
    
        postTrials = subjTrials(strcmpi(subjTrials.Period,'4-PostTest'), :);
        postAllArrowCorrectTrials = postTrials(postTrials.SeqLength == postTrials.NumArrCorr, :); % to calculate "absolute span"
        if (height(postTrials) == 0)
            fprintf('getUpdateScores_PP_1B - Subj %d has no posttest data. Setting scores to NaN.\n', subj);
            postSeqTotal = NaN;
            postLetterCount = NaN;
            postArrowCount = NaN;
            postLetter = NaN;
            postArrow = NaN;
        else
            postSeqTotal = sum(postTrials.SeqLength);
            postLetterCount = sum(postTrials.NumLetCorrect);
            postArrowCount = sum(postTrials.NumArrCorr);
            postAllArrowCorrectCount = sum(postAllArrowCorrectTrials.SeqLength); % "the sum of all correctly recalled set sizes"
            
            postLetter = postLetterCount / postSeqTotal;
            postArrow = postArrowCount / postSeqTotal;
        end

        trialCount = height(subjTrials);
        condition = -999; % assume we don't know, or it's weird
        if (strcmpi(subjTrials.Condition(1), 'RF tDCS') == 1)
            condition = 111; % RF, tDCS, not sham
            condGroup = 1; % RF + stimulation
        elseif (strcmpi(subjTrials.Condition(1), 'RF tDCS Sham') == 1)
            condition = 112; % RF, tDCS, sham
            condGroup = 2; % RF + sham
        elseif (strcmpi(subjTrials.Condition(1), 'AC tDCS Sham') == 1)
            condition = 212; % AC, tDCS, sham
            condGroup = 3; % AC + sham
        elseif (strcmpi(subjTrials.Condition(1), 'AC tRNS Sham') == 1)
            condition = 222; % AC, tRNS,  sham
            condGroup = 3; % AC + sham
        elseif (strcmpi(subjTrials.Condition(1), 'RF tRNS') == 1)
            condition = 121; % RF, tRNS, not sham
            condGroup = 1; % RF + stimulation
        elseif (strcmpi(subjTrials.Condition(1), 'RF tRNS Sham') == 1)
            condition = 122; % RF, tRNS, sham
            condGroup = 2; % RF + sham
        else
            condGroup = -999;
            fprintf('Subject %d - unusual condition: %s. Marking it -999.\n', subj, subjTrials.Condition{1});
        end
        preOverMin = 0;
        if (preLetter > minPctLetterCorrectSubj)
            preOverMin = 1;
        end
        postOverMin = 0;
        if (postLetter > minPctLetterCorrectSubj)
            postOverMin = 1;
        end
        bothOverMin = 0;
        if ((preLetter > minPctLetterCorrectSubj) && (postLetter > minPctLetterCorrectSubj))
            bothOverMin = 1;
        end
        if ((preLetter < 0) || (postLetter < 0) || isnan(postLetter))
            deltaLetter = NaN;
            deltaArrow = NaN;
        else
            deltaLetter = postLetter - preLetter;
            deltaArrow = postArrow - preArrow;
        end
        updateMat(subjIndex, 1:22) = [subj trialCount condition condGroup minPctLetterCorrectSubj preOverMin preSeqTotal preLetterCount preLetter preArrowCount preArrow preAllArrowCorrectCount postOverMin postSeqTotal postLetterCount postLetter postArrowCount postArrow postAllArrowCorrectCount bothOverMin deltaLetter deltaArrow];
    end

    updateTable = array2table(updateMat, 'VariableNames', {'Subject','Trials','Condition','CondGroup','minPctLetter','preOverMin','preSeq','preLetCount','preLetter','preArrCount','preArrow','preAbsSpan','postOverMin','postSeq','postLetCount','postLetter','postArrCount','postArrow','postAbsSpan','bothOverMin','deltaLetter','deltaArrow'});

    % print the table, if requested
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getUpdateScores_PP_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(updateTable, fileName);
    end

end
