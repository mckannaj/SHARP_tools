% Zephy McKanna
% 11/9/14
%
% This function takes a table containing a "Subject" column, a "Problem"
% column, and a "correct" column.
%
% Specifically, it expects to take the output of functions like:
% getCleanSwitchTrials_RF_1A3() and getCleanUpdateTrials_RF_1A3()
%
% It returns a new "sum" table containing Subject, ShiftNumber, 
% correctTrials, totalTrials, Accuracy (correct/total), and whether or
% not they passed the shift (> 80% accuracy).
% It also returns a "Thirds" table, which has a Subj column, a FirstThird
% column containing the total accuracy (correct / total in the first third
% of trials seen), and a LastThird column (correct / total in the last third
% of trials seen).
%
% If the "printThirds" contains a filename, it will create a .csv with that
% name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the thirdsTable.
%
function [newSumTable, thirdsTable] = getNewAccuracy_RF_1A3(inputTable, printThirds)

    allSubjects = unique(inputTable.Subject);
    newSumMat = [allSubjects(1), 0,0,0,0,0];
    newSumMatRow = 1; % the row of newSumMat that we're on
    thirdsMat = [allSubjects(1), 0,0,0,0,0,0,0,0,0,0];
    thirdsMatRow = 1; % the row of newSumMat that we're on
%    newSumMat = [allsubjects; zeros(length(allSubjects),1); zeros(length(allSubjects),1); zeros(length(allSubjects),1)];
%    thirdsMat = [allsubjects; zeros(length(allSubjects),1); zeros(length(allSubjects),1); zeros(length(allSubjects),1); zeros(length(allSubjects),1)];
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        thirdsMat(thirdsMatRow, :) = [subj, 0,0,0,0,0,0,0,0,0,0];
        
        subjTable = inputTable(inputTable.Subject == subj, :); % just get this subject's rows
        thisSubjsShifts = unique(subjTable.ShiftNum);
        for shiftIndex = 1:length(thisSubjsShifts)
            shift = thisSubjsShifts(shiftIndex); % get the shift number
            shiftTable = subjTable(subjTable.ShiftNum == shift, :); % just get this shift's rows
        
            correctTrialsThisShift = height(shiftTable(shiftTable.Correct == true, :));
            totalTrialsThisShift = height(shiftTable);
            accuracyThisShift = correctTrialsThisShift / totalTrialsThisShift;
            passedThisShift = false;
            if (accuracyThisShift > .8)
                passedThisShift = true;
            end
            newSumMat(newSumMatRow, :) = [subj, shift, correctTrialsThisShift, totalTrialsThisShift, accuracyThisShift, passedThisShift];
            newSumMatRow = newSumMatRow + 1; % get ready to write the next row
%{ 
z: no longer doing it like this (this just gives thirds in terms of shifts, not trials)
            fprintf('index:%d, 1Cutoff: %f, 2Cutoff: %f, 3cutoff: %d\n', shiftIndex, (length(thisSubjsShifts) / 3), ((length(thisSubjsShifts) / 3) * 2), length(thisSubjsShifts));
            if (shiftIndex <= (length(thisSubjsShifts) / 3)) % first third of the shifts we've seen
                if (passedThisShift == true)
                    thirdsMat(thirdsMatRow, 2) = thirdsMat(thirdsMatRow, 2) + 1; % add one to the "correct" for first third
                end
                thirdsMat(thirdsMatRow, 3) = thirdsMat(thirdsMatRow, 3) + 1; % add one to the "total" for first third
            elseif (shiftIndex <= ((length(thisSubjsShifts) / 3) * 2)) % middle third of the shifts we've seen
                if (passedThisShift == true)
                    thirdsMat(thirdsMatRow, 5) = thirdsMat(thirdsMatRow, 5) + 1; % add one to the "correct" for middle third
                end
                thirdsMat(thirdsMatRow, 6) = thirdsMat(thirdsMatRow, 6) + 1; % add one to the "total" for middle third
            else % last third
                if (passedThisShift == true)
                    thirdsMat(thirdsMatRow, 8) = thirdsMat(thirdsMatRow, 8) + 1; % add one to the "correct" for last third
                end
                thirdsMat(thirdsMatRow, 9) = thirdsMat(thirdsMatRow, 9) + 1; % add one to the "total" for last third
            end   
%}             
        end % shiftIndex loop
        
        if (height(subjTable) > 3)

            firstThirdTrials = subjTable(1:floor(height(subjTable)/3),:);
            midThirdTrials = subjTable(ceil(height(subjTable)/3):floor((height(subjTable)/3)*2),:);
            lastThirdTrials = subjTable(floor((height(subjTable)/3)*2):end,:);
            thirdsMat(thirdsMatRow, 1) = subj; % redundant, but shows what the first col is
            thirdsMat(thirdsMatRow, 2) = height(firstThirdTrials(firstThirdTrials.Correct == true, :)); % correct for the first third
            thirdsMat(thirdsMatRow, 3) = height(firstThirdTrials); % total for the first third
            thirdsMat(thirdsMatRow, 4) = thirdsMat(thirdsMatRow, 2) / thirdsMat(thirdsMatRow, 3); % accuracy for first third
            thirdsMat(thirdsMatRow, 5) = height(midThirdTrials(midThirdTrials.Correct == true, :)); % correct for the middle third
            thirdsMat(thirdsMatRow, 6) = height(midThirdTrials); % total for the middle third
            thirdsMat(thirdsMatRow, 7) = thirdsMat(thirdsMatRow, 5) / thirdsMat(thirdsMatRow, 6); % accuracy for middle third
            thirdsMat(thirdsMatRow, 8) = height(lastThirdTrials(lastThirdTrials.Correct == true, :)); % correct for the last third
            thirdsMat(thirdsMatRow, 9) = height(lastThirdTrials); % total for the last third
            thirdsMat(thirdsMatRow, 10) = thirdsMat(thirdsMatRow, 8) / thirdsMat(thirdsMatRow, 9); % accuracy for last third
            thirdsMat(thirdsMatRow, 11) = (thirdsMat(thirdsMatRow, 2)+thirdsMat(thirdsMatRow, 5)+thirdsMat(thirdsMatRow, 8)) / (thirdsMat(thirdsMatRow, 3)+thirdsMat(thirdsMatRow, 6)+thirdsMat(thirdsMatRow, 9)); % total accuracy
        else
            fprintf('ALERT getNewAccuracy_RF_1A3: subj %d has only %d trials; returning -9999 for thirds.\n', subj, height(subjTable));
            thirdsMat(thirdsMatRow, 2) = -9999;
            thirdsMat(thirdsMatRow, 3) = -9999;
            thirdsMat(thirdsMatRow, 4) = -9999;
            thirdsMat(thirdsMatRow, 5) = -9999;
            thirdsMat(thirdsMatRow, 6) = -9999;
            thirdsMat(thirdsMatRow, 7) = -9999;
            thirdsMat(thirdsMatRow, 8) = -9999;
            thirdsMat(thirdsMatRow, 9) = -9999;
            thirdsMat(thirdsMatRow, 10) = -9999;
            thirdsMat(thirdsMatRow, 11) = -9999;
        end
        thirdsMatRow = thirdsMatRow + 1; % get ready to write the next row
    end % subjIndex loop

    newSumTable = array2table(newSumMat, 'VariableNames', {'Subject','ShiftNumber','correctTrials','totalTrials','Accuracy','Passed'});
    thirdsTable = array2table(thirdsMat, 'VariableNames', {'Subject','FirstThirdCorrect','FirstThirdTotal','FirstThirdAcc','MidThirdCorrect','MidThirdTotal','MidThirdAcc','LastThirdCorrect','LastThirdTotal','LastThirdAcc','TotalAcc'});

    fileName = '';
    if (strcmpi('', printThirds) == 0) % there's something in printThirds
        if (printThirds == false) % do nothing
        elseif (printThirds == true) % do a default filename
            fileName = getFileNameForThisOS('getNewAccuracy_RF_1A3-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printThirds, 'IntResults');
        end
        
        writetable(thirdsTable, fileName);
    end

end


