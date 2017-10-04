% Zephy McKanna
% singleArrowPerTrial_PP_1B()
% 7/13/15
%
% This function takes a table made from pre/post update (rotation task) data. Note: if you
% wish to exclude certain subjects, pass RotationData through some exclusion function 
% (e.g. excludeSubjects_RF_1B) before giving it to this function.
%
% It returns a new table, in which each (letter and) arrow response is its
% own column, so that you can treat them as separate "trial"s in a GLM or
% other analysis.
% In order to make these make sense, it adds several columns:
%  - origTrialNum: the count of the trial in the original file (which has several
%  letters/arrows per trial) (resets per subject and per block (i.e., pre/postTest))
%  - SeqLength: the total count of the arrows ("trials" in this table)
%  (resets per subject and per block (i.e., pre/postTest))
%  - RTsecs: response time for a particular arrow or letter (have to
%  subtract the presentation time from the original respTime, and then
%  divide by 10000 to get seconds)
%
% If the "printTable" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the SSRTtable.
%
function [updateTable] = singleArrowPerTrial_PP_1B(UpdateData, printTable)
    if (nargin ~= nargin('singleArrowPerTrial_PP_1B'))
        error('singleArrowPerTrial_PP_1B expects %d inputs, but received %d. Please update any calling code.\n', nargin('singleArrowPerTrial_PP_1B'), nargin);
    end
    
    % set up a temporary table that we can keep adding to updateTable
    tmpTable = UpdateData(1,1:23); % up through "NumArrCleared", just to have the variable names

    newRowNum = 1; % the row number in the new table (will be 3-5 per row of the old table)        
    allSubjects = unique(UpdateData.Subject);
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        fprintf('singleArrowPerTrial_PP_1B handling subj %d.\n', subj);
        subjTrials = UpdateData((UpdateData.Subject == subj), :);
        
        preTrials = subjTrials(strcmpi(subjTrials.Period,'0-PreTest'), :);
%        preAllArrowCorrectTrials = preTrials(preTrials.SeqLength == preTrials.NumArrCorr, :); % to calculate "absolute span"
        origTrialNum = 1; % the number of this row in the original file (reset per subj and block)
%        origArrowNum = 1; % the number of this arrow (and letter) in the original file (1-5)
        trialNum = 1; % the count of this new "trial" (row) per block/subj
        for row = 1:height(preTrials)
            if (~isnan(preTrials.Arrow1{row})) % we have a first arrow in this old row; put the info into the new table
                tmpTable(1,1:23) = preTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 1; % Arrow/Letter 1
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = preTrials.Letter1(row); 
                tmpTable.LetScore(1) = preTrials.LetScore1(row); 
                tmpTable.LetPresentTime(1) = preTrials.LetPresentTime1(row); 
                tmpTable.LetDismissTime(1) = preTrials.LetDismissTime1(row); 
                tmpTable.LetQueryTime(1) = preTrials.LetQueryTime1(row); 
                tmpTable.LetAnsTime(1) = preTrials.LetAnsTime1(row); 
                tmpTable.Arrow(1) = preTrials.Arrow1(row); 
                tmpTable.ArrAns(1) = preTrials.ArrAns1(row); 
                tmpTable.ArrScore(1) = preTrials.ArrScore1(row); 
                tmpTable.ArrPresentTime(1) = preTrials.ArrPresentTime1(row); 
                tmpTable.ArrAnsTime(1) = preTrials.ArrAnsTime1(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            if (~isnan(preTrials.Arrow2{row})) % same with the second arrow
                tmpTable(1,1:23) = preTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 2; % Arrow/Letter 2
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = preTrials.Letter2(row); 
                tmpTable.LetScore(1) = preTrials.LetScore2(row); 
                tmpTable.LetPresentTime(1) = preTrials.LetPresentTime2(row); 
                tmpTable.LetDismissTime(1) = preTrials.LetDismissTime2(row); 
                tmpTable.LetQueryTime(1) = preTrials.LetQueryTime2(row); 
                tmpTable.LetAnsTime(1) = preTrials.LetAnsTime2(row); 
                tmpTable.Arrow(1) = preTrials.Arrow2(row); 
                tmpTable.ArrAns(1) = preTrials.ArrAns2(row); 
                tmpTable.ArrScore(1) = preTrials.ArrScore2(row); 
                tmpTable.ArrPresentTime(1) = preTrials.ArrPresentTime2(row); 
                tmpTable.ArrAnsTime(1) = preTrials.ArrAnsTime2(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            if (~isnan(preTrials.Arrow3{row})) % same with the third arrow
                tmpTable(1,1:23) = preTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 3; % Arrow/Letter 3
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = preTrials.Letter3(row); 
                tmpTable.LetScore(1) = preTrials.LetScore3(row); 
                tmpTable.LetPresentTime(1) = preTrials.LetPresentTime3(row); 
                tmpTable.LetDismissTime(1) = preTrials.LetDismissTime3(row); 
                tmpTable.LetQueryTime(1) = preTrials.LetQueryTime3(row); 
                tmpTable.LetAnsTime(1) = preTrials.LetAnsTime3(row); 
                tmpTable.Arrow(1) = preTrials.Arrow3(row); 
                tmpTable.ArrAns(1) = preTrials.ArrAns3(row); 
                tmpTable.ArrScore(1) = preTrials.ArrScore3(row); 
                tmpTable.ArrPresentTime(1) = preTrials.ArrPresentTime3(row); 
                tmpTable.ArrAnsTime(1) = preTrials.ArrAnsTime3(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            if (~isnan(preTrials.Arrow4{row})) % same with the fourth arrow
                tmpTable(1,1:23) = preTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 4; % Arrow/Letter 4
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = preTrials.Letter4(row); 
                tmpTable.LetScore(1) = preTrials.LetScore4(row); 
                tmpTable.LetPresentTime(1) = preTrials.LetPresentTime4(row); 
                tmpTable.LetDismissTime(1) = preTrials.LetDismissTime4(row); 
                tmpTable.LetQueryTime(1) = preTrials.LetQueryTime4(row); 
                tmpTable.LetAnsTime(1) = preTrials.LetAnsTime4(row); 
                tmpTable.Arrow(1) = preTrials.Arrow4(row); 
                tmpTable.ArrAns(1) = preTrials.ArrAns4(row); 
                tmpTable.ArrScore(1) = preTrials.ArrScore4(row); 
                tmpTable.ArrPresentTime(1) = preTrials.ArrPresentTime4(row); 
                tmpTable.ArrAnsTime(1) = preTrials.ArrAnsTime4(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            if (~isnan(preTrials.Arrow5{row})) % same with the fifth arrow
                tmpTable(1,1:23) = preTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 5; % Arrow/Letter 5
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = preTrials.Letter5(row); 
                tmpTable.LetScore(1) = preTrials.LetScore5(row); 
                tmpTable.LetPresentTime(1) = preTrials.LetPresentTime5(row); 
                tmpTable.LetDismissTime(1) = preTrials.LetDismissTime5(row); 
                tmpTable.LetQueryTime(1) = preTrials.LetQueryTime5(row); 
                tmpTable.LetAnsTime(1) = preTrials.LetAnsTime5(row); 
                tmpTable.Arrow(1) = preTrials.Arrow5(row); 
                tmpTable.ArrAns(1) = preTrials.ArrAns5(row); 
                tmpTable.ArrScore(1) = preTrials.ArrScore5(row); 
                tmpTable.ArrPresentTime(1) = preTrials.ArrPresentTime5(row); 
                tmpTable.ArrAnsTime(1) = preTrials.ArrAnsTime5(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            
            origTrialNum = origTrialNum + 1; % moving on to the next row in the original file
        end    
            origTrialNum = 1; % we're moving on to the next block for this participant
            trialNum = 1; % inc the trial num (gets reset every subj and block)

            postTrials = subjTrials(strcmpi(subjTrials.Period,'4-PostTest'), :);
        
        
        for row = 1:height(postTrials)
            if (~isnan(postTrials.Arrow1{row})) % we have a first arrow in this old row; put the info into the new table
                tmpTable(1,1:23) = postTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 1; % Arrow/Letter 1
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = postTrials.Letter1(row); 
                tmpTable.LetScore(1) = postTrials.LetScore1(row); 
                tmpTable.LetPresentTime(1) = postTrials.LetPresentTime1(row); 
                tmpTable.LetDismissTime(1) = postTrials.LetDismissTime1(row); 
                tmpTable.LetQueryTime(1) = postTrials.LetQueryTime1(row); 
                tmpTable.LetAnsTime(1) = postTrials.LetAnsTime1(row); 
                tmpTable.Arrow(1) = postTrials.Arrow1(row); 
                tmpTable.ArrAns(1) = postTrials.ArrAns1(row); 
                tmpTable.ArrScore(1) = postTrials.ArrScore1(row); 
                tmpTable.ArrPresentTime(1) = postTrials.ArrPresentTime1(row); 
                tmpTable.ArrAnsTime(1) = postTrials.ArrAnsTime1(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            if (~isnan(postTrials.Arrow2{row})) % same with the second arrow
                tmpTable(1,1:23) = postTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 2; % Arrow/Letter 2
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = postTrials.Letter2(row); 
                tmpTable.LetScore(1) = postTrials.LetScore2(row); 
                tmpTable.LetPresentTime(1) = postTrials.LetPresentTime2(row); 
                tmpTable.LetDismissTime(1) = postTrials.LetDismissTime2(row); 
                tmpTable.LetQueryTime(1) = postTrials.LetQueryTime2(row); 
                tmpTable.LetAnsTime(1) = postTrials.LetAnsTime2(row); 
                tmpTable.Arrow(1) = postTrials.Arrow2(row); 
                tmpTable.ArrAns(1) = postTrials.ArrAns2(row); 
                tmpTable.ArrScore(1) = postTrials.ArrScore2(row); 
                tmpTable.ArrPresentTime(1) = postTrials.ArrPresentTime2(row); 
                tmpTable.ArrAnsTime(1) = postTrials.ArrAnsTime2(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            if (~isnan(postTrials.Arrow3{row})) % same with the third arrow
                tmpTable(1,1:23) = postTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 3; % Arrow/Letter 3
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = postTrials.Letter3(row); 
                tmpTable.LetScore(1) = postTrials.LetScore3(row); 
                tmpTable.LetPresentTime(1) = postTrials.LetPresentTime3(row); 
                tmpTable.LetDismissTime(1) = postTrials.LetDismissTime3(row); 
                tmpTable.LetQueryTime(1) = postTrials.LetQueryTime3(row); 
                tmpTable.LetAnsTime(1) = postTrials.LetAnsTime3(row); 
                tmpTable.Arrow(1) = postTrials.Arrow3(row); 
                tmpTable.ArrAns(1) = postTrials.ArrAns3(row); 
                tmpTable.ArrScore(1) = postTrials.ArrScore3(row); 
                tmpTable.ArrPresentTime(1) = postTrials.ArrPresentTime3(row); 
                tmpTable.ArrAnsTime(1) = postTrials.ArrAnsTime3(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            if (~isnan(postTrials.Arrow4{row})) % same with the fourth arrow
                tmpTable(1,1:23) = postTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 4; % Arrow/Letter 4
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = postTrials.Letter4(row); 
                tmpTable.LetScore(1) = postTrials.LetScore4(row); 
                tmpTable.LetPresentTime(1) = postTrials.LetPresentTime4(row); 
                tmpTable.LetDismissTime(1) = postTrials.LetDismissTime4(row); 
                tmpTable.LetQueryTime(1) = postTrials.LetQueryTime4(row); 
                tmpTable.LetAnsTime(1) = postTrials.LetAnsTime4(row); 
                tmpTable.Arrow(1) = postTrials.Arrow4(row); 
                tmpTable.ArrAns(1) = postTrials.ArrAns4(row); 
                tmpTable.ArrScore(1) = postTrials.ArrScore4(row); 
                tmpTable.ArrPresentTime(1) = postTrials.ArrPresentTime4(row); 
                tmpTable.ArrAnsTime(1) = postTrials.ArrAnsTime4(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            if (~isnan(postTrials.Arrow5{row})) % same with the fifth arrow
                tmpTable(1,1:23) = postTrials(row,1:23); % up through "NumArrCleared"
                tmpTable.origTrialNum(1) = origTrialNum;
                tmpTable.origArrLettNum(1) = 5; % Arrow/Letter 5
                tmpTable.trialNum(1) = trialNum; % trial (per subj / block)
                
                % Letter1	LetScore1	LetPresentTime1	LetDismissTime1	LetQueryTime1	LetAnsTime1	Arrow1	ArrAns1	ArrScore1	ArrPresentTime1	ArrAnsTime1
                % now do all the stuff that we want to keep the same
                tmpTable.Letter(1) = postTrials.Letter5(row); 
                tmpTable.LetScore(1) = postTrials.LetScore5(row); 
                tmpTable.LetPresentTime(1) = postTrials.LetPresentTime5(row); 
                tmpTable.LetDismissTime(1) = postTrials.LetDismissTime5(row); 
                tmpTable.LetQueryTime(1) = postTrials.LetQueryTime5(row); 
                tmpTable.LetAnsTime(1) = postTrials.LetAnsTime5(row); 
                tmpTable.Arrow(1) = postTrials.Arrow5(row); 
                tmpTable.ArrAns(1) = postTrials.ArrAns5(row); 
                tmpTable.ArrScore(1) = postTrials.ArrScore5(row); 
                tmpTable.ArrPresentTime(1) = postTrials.ArrPresentTime5(row); 
                tmpTable.ArrAnsTime(1) = postTrials.ArrAnsTime5(row); 
                
                updateTable(newRowNum, :) = tmpTable(1,:); % transfer these vals, then re-initialize
                newRowNum = newRowNum + 1; % inc the row for the new table
                trialNum = trialNum + 1; % inc the trial num (gets reset every subj and block)
            end
            
            origTrialNum = origTrialNum + 1; % moving on to the next row in the original file

        end
    end
%    updateTable = array2table(updateMat, 'VariableNames', {'Subject','Trials','Condition','CondGroup','minPctLetter','preOverMin','preSeq','preLetCount','preLetter','preArrCount','preArrow','preAbsSpan','postOverMin','postSeq','postLetCount','postLetter','postArrCount','postArrow','postAbsSpan','bothOverMin','deltaLetter','deltaArrow'});

    % print the table, if requested
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('singleArrowPerTrial_PP_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(updateTable, fileName);
    end

end
