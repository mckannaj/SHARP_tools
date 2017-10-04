% Zephy McKanna
% formRotationContingencyTable_PP_1B()
% 6/15/15
%
% This function takes a table made from pre/post update (rotation task) data. Note: if you
% wish to exclude certain subjects, pass RotationData through some exclusion function 
% (e.g. excludeSubjects_RF_1B) before giving it to this function.
%
% You can indicate if you want to only consider the first or last
% letter/arrow pair in each trial by setting the "justFirst" or "justLast"
% flags to "true". Otherwise, they should both be "false".
%
% It returns a table with eight columns: subj, preWrongBoth, preCorrLet,
% preCorrArr, preCorrBoth, postWrongBoth, postCorrLet,
% postCorrArr, postCorrBoth. 
% These form a contingency table describing
% whether the participant primarily paid attention to letters, arrows, or
% both, for the pre and post tests.
%
%
% If the "printTable" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the SSRTtable.
%
function [updateTable] = formRotationContingencyTable_PP_1B(UpdateData, justFirst, justLast, printTable)
    if (nargin ~= nargin('formRotationContingencyTable_PP_1B'))
        error('formRotationContingencyTable_PP_1B expects %d inputs, but received %d. Please update any calling code.\n', nargin('formRotationContingencyTable_PP_1B'), nargin);
    end


    if ((justFirst == true) && (justLast == true))
        error('formRotationContingencyTable_PP_1B: cannot currently deal with justFirst and justLast both being true.');
    end

    allSubjects = unique(UpdateData.Subject);
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        subjTrials = UpdateData((UpdateData.Subject == subj), :);
        
        preTrials = subjTrials(strcmpi(subjTrials.Period,'0-PreTest'), :);
        if (height(preTrials) == 0)
            fprintf('getUpdateScores_PP_1B - Somehow subj %d has no pretest data...? Setting scores to NaN.\n', subj);
%            preSeqTotal = NaN;
            preBothWrong = NaN;
            preLetterCorr = NaN;
            preArrowCorr = NaN;
            preBothCorr = NaN;
        else
            preBothWrong = 0;
            preLetterCorr = 0;
            preArrowCorr = 0;
            preBothCorr = 0;
            for row = 1:height(preTrials)
                if (~isnan(preTrials.LetScore5{row})) % we have a pair #5; that must be the last one
                    lastPair = 5;
                elseif (~isnan(preTrials.LetScore4{row})) % we have a pair #4; that must be the last one
                    lastPair = 4;
                elseif (~isnan(preTrials.LetScore3{row})) % we have a pair #3; that must be the last one
                    lastPair = 3;
                elseif (~isnan(preTrials.LetScore2{row})) % we have a pair #2; that must be the last one
                    lastPair = 2;
                else % guess the first pair must be the "last" pair
                    lastPair = 1;
                end
                
                if ( ((lastPair >= 1) && (justLast == false)) || ((lastPair == 1) && (justLast == true)) ) % this pair exists and should be counted
                    if ( (strcmpi(preTrials.LetScore1{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore1{row}, 'incorrect')) )
                        preBothWrong = preBothWrong + 1;
                    elseif ( (strcmpi(preTrials.LetScore1{row}, 'correct')) && (strcmpi(preTrials.ArrScore1{row}, 'incorrect')) )
                        preLetterCorr = preLetterCorr + 1;
                    elseif ( (strcmpi(preTrials.LetScore1{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore1{row}, 'correct')) )
                        preArrowCorr = preArrowCorr + 1;
                    elseif ( (strcmpi(preTrials.LetScore1{row}, 'correct')) && (strcmpi(preTrials.ArrScore1{row}, 'correct')) )
                        preBothCorr = preBothCorr + 1;
                    end
                end
                if (justFirst == false) % ignore all this if we're just doing the first one
                    if ( ((lastPair >= 2) && (justLast == false)) || ((lastPair == 2) && (justLast == true)) ) % this pair exists and should be counted
                        if ( (strcmpi(preTrials.LetScore2{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore2{row}, 'incorrect')) )
                            preBothWrong = preBothWrong + 1;
                        elseif ( (strcmpi(preTrials.LetScore2{row}, 'correct')) && (strcmpi(preTrials.ArrScore2{row}, 'incorrect')) )
                            preLetterCorr = preLetterCorr + 1;
                        elseif ( (strcmpi(preTrials.LetScore2{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore2{row}, 'correct')) )
                            preArrowCorr = preArrowCorr + 1;
                        elseif ( (strcmpi(preTrials.LetScore2{row}, 'correct')) && (strcmpi(preTrials.ArrScore2{row}, 'correct')) )
                            preBothCorr = preBothCorr + 1;
                        end
                    end
                    if ( ((lastPair >= 3) && (justLast == false)) || ((lastPair == 3) && (justLast == true)) ) % this pair exists and should be counted
                        if ( (strcmpi(preTrials.LetScore3{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore3{row}, 'incorrect')) )
                            preBothWrong = preBothWrong + 1;
                        elseif ( (strcmpi(preTrials.LetScore3{row}, 'correct')) && (strcmpi(preTrials.ArrScore3{row}, 'incorrect')) )
                            preLetterCorr = preLetterCorr + 1;
                        elseif ( (strcmpi(preTrials.LetScore3{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore3{row}, 'correct')) )
                            preArrowCorr = preArrowCorr + 1;
                        elseif ( (strcmpi(preTrials.LetScore3{row}, 'correct')) && (strcmpi(preTrials.ArrScore3{row}, 'correct')) )
                            preBothCorr = preBothCorr + 1;
                        end
                    end
                    if ( ((lastPair >= 4) && (justLast == false)) || ((lastPair == 4) && (justLast == true)) ) % this pair exists and should be counted
                        if ( (strcmpi(preTrials.LetScore4{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore4{row}, 'incorrect')) )
                            preBothWrong = preBothWrong + 1;
                        elseif ( (strcmpi(preTrials.LetScore4{row}, 'correct')) && (strcmpi(preTrials.ArrScore4{row}, 'incorrect')) )
                            preLetterCorr = preLetterCorr + 1;
                        elseif ( (strcmpi(preTrials.LetScore4{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore4{row}, 'correct')) )
                            preArrowCorr = preArrowCorr + 1;
                        elseif ( (strcmpi(preTrials.LetScore4{row}, 'correct')) && (strcmpi(preTrials.ArrScore4{row}, 'correct')) )
                            preBothCorr = preBothCorr + 1;
                        end
                    end
                    if ( ((lastPair >= 5) && (justLast == false)) || ((lastPair == 5) && (justLast == true)) ) % this pair exists and should be counted
                        if ( (strcmpi(preTrials.LetScore5{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore5{row}, 'incorrect')) )
                            preBothWrong = preBothWrong + 1;
                        elseif ( (strcmpi(preTrials.LetScore5{row}, 'correct')) && (strcmpi(preTrials.ArrScore5{row}, 'incorrect')) )
                            preLetterCorr = preLetterCorr + 1;
                        elseif ( (strcmpi(preTrials.LetScore5{row}, 'incorrect')) && (strcmpi(preTrials.ArrScore5{row}, 'correct')) )
                            preArrowCorr = preArrowCorr + 1;
                        elseif ( (strcmpi(preTrials.LetScore5{row}, 'correct')) && (strcmpi(preTrials.ArrScore5{row}, 'correct')) )
                            preBothCorr = preBothCorr + 1;
                        end
                    end
                end
            end
                
        end
    
        postTrials = subjTrials(strcmpi(subjTrials.Period,'4-PostTest'), :);
        if (height(postTrials) == 0)
            fprintf('getUpdateScores_PP_1B - Subj %d has no posttest data. Setting scores to NaN.\n', subj);
            postBothWrong = NaN;
            postLetterCorr = NaN;
            postArrowCorr = NaN;
            postBothCorr = NaN;
        else
            postBothWrong = 0;
            postLetterCorr = 0;
            postArrowCorr = 0;
            postBothCorr = 0;
            for row = 1:height(postTrials)
                if (~isnan(postTrials.LetScore5{row})) % we have a pair #5; that must be the last one
                    lastPair = 5;
                elseif (~isnan(postTrials.LetScore4{row})) % we have a pair #4; that must be the last one
                    lastPair = 4;
                elseif (~isnan(postTrials.LetScore3{row})) % we have a pair #3; that must be the last one
                    lastPair = 3;
                elseif (~isnan(postTrials.LetScore2{row})) % we have a pair #2; that must be the last one
                    lastPair = 2;
                else % guess the first pair must be the "last" pair
                    lastPair = 1;
                end
                
                if ( ((lastPair >= 1) && (justLast == false)) || ((lastPair == 1) && (justLast == true)) ) % this pair exists and should be counted
                    if ( (strcmpi(postTrials.LetScore1{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore1{row}, 'incorrect')) )
                        postBothWrong = postBothWrong + 1;
                    elseif ( (strcmpi(postTrials.LetScore1{row}, 'correct')) && (strcmpi(postTrials.ArrScore1{row}, 'incorrect')) )
                        postLetterCorr = postLetterCorr + 1;
                    elseif ( (strcmpi(postTrials.LetScore1{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore1{row}, 'correct')) )
                        postArrowCorr = postArrowCorr + 1;
                    elseif ( (strcmpi(postTrials.LetScore1{row}, 'correct')) && (strcmpi(postTrials.ArrScore1{row}, 'correct')) )
                        postBothCorr = postBothCorr + 1;
                    end
                end
                if (justFirst == false) % ignore all this if we're just doing the first one
                    if ( ((lastPair >= 2) && (justLast == false)) || ((lastPair == 2) && (justLast == true)) ) % this pair exists and should be counted
                        if ( (strcmpi(postTrials.LetScore2{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore2{row}, 'incorrect')) )
                            postBothWrong = postBothWrong + 1;
                        elseif ( (strcmpi(postTrials.LetScore2{row}, 'correct')) && (strcmpi(postTrials.ArrScore2{row}, 'incorrect')) )
                            postLetterCorr = postLetterCorr + 1;
                        elseif ( (strcmpi(postTrials.LetScore2{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore2{row}, 'correct')) )
                            postArrowCorr = postArrowCorr + 1;
                        elseif ( (strcmpi(postTrials.LetScore2{row}, 'correct')) && (strcmpi(postTrials.ArrScore2{row}, 'correct')) )
                            postBothCorr = postBothCorr + 1;
                        end
                    end
                    if ( ((lastPair >= 3) && (justLast == false)) || ((lastPair == 3) && (justLast == true)) ) % this pair exists and should be counted
                        if ( (strcmpi(postTrials.LetScore3{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore3{row}, 'incorrect')) )
                            postBothWrong = postBothWrong + 1;
                        elseif ( (strcmpi(postTrials.LetScore3{row}, 'correct')) && (strcmpi(postTrials.ArrScore3{row}, 'incorrect')) )
                            postLetterCorr = postLetterCorr + 1;
                        elseif ( (strcmpi(postTrials.LetScore3{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore3{row}, 'correct')) )
                            postArrowCorr = postArrowCorr + 1;
                        elseif ( (strcmpi(postTrials.LetScore3{row}, 'correct')) && (strcmpi(postTrials.ArrScore3{row}, 'correct')) )
                            postBothCorr = postBothCorr + 1;
                        end
                    end
                    if ( ((lastPair >= 4) && (justLast == false)) || ((lastPair == 4) && (justLast == true)) ) % this pair exists and should be counted
                        if ( (strcmpi(postTrials.LetScore4{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore4{row}, 'incorrect')) )
                            postBothWrong = postBothWrong + 1;
                        elseif ( (strcmpi(postTrials.LetScore4{row}, 'correct')) && (strcmpi(postTrials.ArrScore4{row}, 'incorrect')) )
                            postLetterCorr = postLetterCorr + 1;
                        elseif ( (strcmpi(postTrials.LetScore4{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore4{row}, 'correct')) )
                            postArrowCorr = postArrowCorr + 1;
                        elseif ( (strcmpi(postTrials.LetScore4{row}, 'correct')) && (strcmpi(postTrials.ArrScore4{row}, 'correct')) )
                            postBothCorr = postBothCorr + 1;
                        end
                    end
                    if ( ((lastPair >= 5) && (justLast == false)) || ((lastPair == 5) && (justLast == true)) ) % this pair exists and should be counted
                        if ( (strcmpi(postTrials.LetScore5{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore5{row}, 'incorrect')) )
                            postBothWrong = postBothWrong + 1;
                        elseif ( (strcmpi(postTrials.LetScore5{row}, 'correct')) && (strcmpi(postTrials.ArrScore5{row}, 'incorrect')) )
                            postLetterCorr = postLetterCorr + 1;
                        elseif ( (strcmpi(postTrials.LetScore5{row}, 'incorrect')) && (strcmpi(postTrials.ArrScore5{row}, 'correct')) )
                            postArrowCorr = postArrowCorr + 1;
                        elseif ( (strcmpi(postTrials.LetScore5{row}, 'correct')) && (strcmpi(postTrials.ArrScore5{row}, 'correct')) )
                            postBothCorr = postBothCorr + 1;
                        end
                    end
                end
            end        
            
        end
        
        updateMat(subjIndex, 1:9) = [subj preBothWrong preLetterCorr preArrowCorr preBothCorr postBothWrong postLetterCorr postArrowCorr postBothCorr];
    end

    updateTable = array2table(updateMat, 'VariableNames', {'Subject','preBothWrong','preLetCorr','preArrCorr','preBothCorr','postBothWrong','postLetCorr','postArrCorr','postBothCorr'});

    % print the table, if requested
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('formRotationContingencyTable_PP_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(updateTable, fileName);
    end

end
