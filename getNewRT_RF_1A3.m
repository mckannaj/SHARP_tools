% Zephy McKanna
% 11/13/14
%
% This function takes a table containing a "Subject" column, a "Problem"
% column, a "RespTime" column, and a "correct" column.
%
% Specifically, it expects to take the output of functions like:
% getCleanSwitchTrials_RF_1A3() and getCleanUpdateTrials_RF_1A3()
%
% It returns a table with one row for each subject, and 9 columns,
% including a Subj column and all combinations of:
% [firstThird/midThird/lastThird/all]
% [correct/incorrect]
%
% If the "printThirds" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the thirdsTable.
%
function [thirdsAvgRT] = getNewRT_RF_1A3(cleanData, printThirds)

    allSubjects = unique(cleanData.Subject);
    thirdsMat = [allSubjects(1), 2,3,4,5,6,7,8,9]; % this will be overwritten anyway, so just counting columns
    thirdsMatRow = 1; % the row of thirdsMat that we're on
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        thirdsMat(thirdsMatRow, :) = [subj, 2,3,4,5,6,7,8,9]; % this will be overwritten anyway, so just counting columns
        
        subjTable = cleanData(cleanData.Subject == subj, :); % just get this subject's rows
%        thisSubjsShifts = unique(subjTable.ShiftNum);
        
        
        correctTable = subjTable(subjTable.Correct == true, :); % just get trials that the subject got correct
        if (height(correctTable) > 3)
            firstThirdCorrect = correctTable(1:floor(height(correctTable)/3),:);
            midThirdCorrect = correctTable(ceil(height(correctTable)/3):floor((height(correctTable)/3)*2),:);
            lastThirdCorrect = correctTable(floor((height(correctTable)/3)*2):end,:);
            thirdsMat(thirdsMatRow, 1) = subj; % redundant, but shows what the first col is
            thirdsMat(thirdsMatRow, 2) = mean(firstThirdCorrect.RespTime); % mean RT, for correct trials, first third
            thirdsMat(thirdsMatRow, 3) = mean(midThirdCorrect.RespTime); % mean RT, for correct trials, middle third
            thirdsMat(thirdsMatRow, 4) = mean(lastThirdCorrect.RespTime); % mean RT, for correct trials, last third
            thirdsMat(thirdsMatRow, 5) = mean(correctTable.RespTime); % mean RT, for correct trials, across all trials
        else % exclude this participant
            fprintf('ALERT getNewRT_RF_1A3: subj %d has only %d correct trials; returning -9999 for thirds.\n', subj, height(correctTable));
            thirdsMat(thirdsMatRow, 2) = -9999;
            thirdsMat(thirdsMatRow, 3) = -9999;
            thirdsMat(thirdsMatRow, 4) = -9999;
            thirdsMat(thirdsMatRow, 5) = -9999;
        end            
        
        incorrectTable = subjTable(subjTable.Correct == false, :); % just get trials that the subject got wrong
        if (height(incorrectTable) > 3)
            firstThirdIncorrect = incorrectTable(1:floor(height(incorrectTable)/3),:);
            midThirdIncorrect = incorrectTable(ceil(height(incorrectTable)/3):floor((height(incorrectTable)/3)*2),:);
            lastThirdIncorrect = incorrectTable(floor((height(incorrectTable)/3)*2):end,:);
            thirdsMat(thirdsMatRow, 6) = mean(firstThirdIncorrect.RespTime); % mean RT, for incorrect trials, first third
            thirdsMat(thirdsMatRow, 7) = mean(midThirdIncorrect.RespTime); % mean RT, for incorrect trials, middle third
            thirdsMat(thirdsMatRow, 8) = mean(lastThirdIncorrect.RespTime); % mean RT, for incorrect trials, last third
            thirdsMat(thirdsMatRow, 9) = mean(incorrectTable.RespTime); % mean RT, for incorrect trials, across all trials
        else % exclude this participant (? maybe... we don't use incorrect trials for Switch Cost calculated by Reaction time...)
            fprintf('getNewRT_RF_1A3: subj %d has only %d incorrect trials; returning -9999 for thirds (may not matter).\n', subj, height(incorrectTable));
            thirdsMat(thirdsMatRow, 6) = -9999;
            thirdsMat(thirdsMatRow, 7) = -9999;
            thirdsMat(thirdsMatRow, 8) = -9999;
            thirdsMat(thirdsMatRow, 9) = -9999;
        end            

        thirdsMatRow = thirdsMatRow + 1; % get ready to write the next row
    end % subjIndex loop

    thirdsAvgRT = array2table(thirdsMat, 'VariableNames', {'Subject','FirstThirdCorrect','MidThirdCorrect','LastThirdCorrect','TotalCorrect','FirstThirdWrong','MidThirdWrong','LastThirdWrong','TotalWrong'});

    fileName = '';
    if (strcmpi('', printThirds) == 0) % there's something in printThirds
        if (printThirds == false) % do nothing
        elseif (printThirds == true) % do a default filename
            fileName = getFileNameForThisOS('getNewAccuracy_RF_1A3-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printThirds, 'IntResults');
        end
        
        writetable(thirdsAvgRT, fileName);
    end

end


