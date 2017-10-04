% Zephy McKanna
% getSSRT_PP_1B
% 4_26_15
%
% This function takes a table made from pre/post inhibit data. Note: if you
% wish to exclude certain subjects, pass InhibitData through some exclusion function 
% (e.g. excludeSubjects_RF_1B) before giving it to this function.
%
% It cleans the data as follows: 
%   1. Deletes all Catch trials (Inhibit = S50)
%   2. Deletes all Practice trials (Block = "Train_wo_Inh", "Train_w_Inh",
%      or "Calibrate")
%   3. Changes all inhibit trials where the participant responded before
%      the cue into Go trials (delete anything in the Inhibit and InhCorr
%      columns)
%   4. Makes separate tables of CorrectGo trials (nothing in Inhibit col),
%      StaircaseInhCorrect trials ("TRUE" in InhCorr), and StaircaseInhErrors trials ("after"
%      in InhCorr)
%   5. Deletes all Go trials in which they made an error (i.e., make CorrectGo table into *only* Correct Go trials) 
%     - If they didn't respond, it's an error
%     - If ?Animal? = FALSE and ?Response? = left, it?s an error
%     - If ?Animal? = TRUE and ?Response? = right, it?s an error
%   6. Creates a meaningful "ResponseTime" column for the CorrectGo and StaircaseInhErrors trials, 
%      subtracting StimTime from RespTime and then dividing by 10,000 to get seconds
%
% It then calculates the SSRT for each subject as follows:
%   1. Delete all Go trials that are <> 3 SDs from the mean (of any given
%      subject's Correct Go trial Reaction Times)
%   2. Find the % errors in StaircaseInhibits [height of StaircaseInhErrors
%      / (height of StaircaseInhErrors + height of StaircaseInhCorrect)]
%   3. Sort the CorrectGo trials in ascending order of ReactionTime
%   4. Pick the CorrectGo reaction time corresponding with the %errors in
%      StaricaseInhibits. (Note that this usually must be rounded one way or
%      the other.)
%   5. Subtract the mean SSD (out of all numbers in the Inhibit column of
%      the StaircaseInhErrors and StaircaseInhCorrect tables) from #3 to get
%      the SSRT.
%
% It outputs a table with three columns: subj, pretestSSRT, posttestSSRT.
%
% If the "printTable" variable contains a filename, it will create a .csv 
% with that name in
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows)
% ... which contains the SSRTtable.
%
function [SSRT_table] = getSSRT_PP_1B(InhibitData, printTable, verbose, cleanByBlock)
    SSRTmat(1,:) = [0.0 0.0 0.0 0.0 0.0]; % these will be overwritten; just initializing the output in the right format

    origInhibitData = InhibitData; % just in case we need all the stuff we're about to delete, later
    allCatchTrials = InhibitData(strcmpi(InhibitData.Inhibit,'S50'),:); % in case we need the catch trials, later

    InhibitData(strcmpi(InhibitData.Inhibit,'S50'),:) = []; % delete all catch trials
    InhibitData(strcmpi(InhibitData.Block,'Train_wo_Inh'),:) = []; % delete all training trials
    InhibitData(strcmpi(InhibitData.Block,'Train_w_Inh'),:) = []; % delete all training trials
    InhibitData(strcmpi(InhibitData.Block,'Calibrate'),:) = []; % delete all calibration trials

    tmpGoTrials = InhibitData(strcmpi(InhibitData.InhCorr,'before'),'Inhibit'); % identify the Inhibit trials where the participant responded before the cue (should be treated as Go trials)
    tmpGoTrials.Inhibit(:) = {NaN}; % mark the correct length with NaNs
    InhibitData(strcmpi(InhibitData.InhCorr,'before'),'Inhibit') = tmpGoTrials; % save the NaNs to the cells marking this as an Inhibit trial
    InhibitData(strcmpi(InhibitData.InhCorr,'before'),'InhCorr') = tmpGoTrials; % save the NaNs to the cells marking this as an Inhibit trial
    
    findNANsFunction = @(x) all(isnan(x(:))); % this function will find NaNs in cells
    StaircaseInhAll = InhibitData(~cellfun(findNANsFunction, InhibitData.Inhibit),:); % all staircase inhibit trials (since we've already deleted the catch trials)
%    StaircaseInhCorrect = StaircaseInhAll(isnan(StaircaseInhAll.RespTime),:); % any staircase trials without a response time are correct
    StaircaseInhErrors = StaircaseInhAll(strcmpi(StaircaseInhAll.InhCorr,'after'),:); % if they responded after the cue, it's an error
    
    CorrectGo = InhibitData(cellfun(findNANsFunction, InhibitData.Inhibit),:); % get all the rows that have [NaN] in the Inhibit col
    CorrectGo(cellfun(findNANsFunction, CorrectGo.Response),:) = []; % delete all the errors where they didn't respond
    CorrectGo((CorrectGo.Animal == 1)&(strcmpi(CorrectGo.Response,'right')), :) = []; % delete the errors where Animal = TRUE
    CorrectGo((CorrectGo.Animal == 0)&(strcmpi(CorrectGo.Response,'left')), :) = []; % delete the errors where Animal = FALSE
    
    StaircaseInhErrors.newRT = ((StaircaseInhErrors.RespTime - StaircaseInhErrors.StimTime) / 10000); % get the response time (resp - stim) and put it in seconds (/ 10,000)
    CorrectGo.newRT = ((CorrectGo.RespTime - CorrectGo.StimTime) / 10000); % get the response time (resp - stim) and put it in seconds (/ 10,000)
    
    
    allSubjects = unique(InhibitData.Subject);
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        
        subjPreGoCorrect = CorrectGo(((CorrectGo.Subject == subj) & (strcmpi(CorrectGo.Period,'0-PreTest'))), :); % just get this subject's rows
        if (height(subjPreGoCorrect) == 0)
            if (verbose == true)
                fprintf('Somehow subj %d has no pretest data...? Setting SSRT to NaN.\n', subj);
            end
            PreSSRT = NaN;
        else
            subjPreInhAll = StaircaseInhAll(((StaircaseInhAll.Subject == subj) & (strcmpi(StaircaseInhAll.Period,'0-PreTest'))), :); % just get this subject's rows
    %        subjPreInhCorrect = StaircaseInhCorrect(((StaircaseInhCorrect.Subject == subj) & (strcmpi(StaircaseInhCorrect.Period,'0-PreTest'))), :); % just get this subject's rows
            subjPreInhErrors = StaircaseInhErrors(((StaircaseInhErrors.Subject == subj) & (strcmpi(StaircaseInhErrors.Period,'0-PreTest'))), :); % just get this subject's rows
            
            if (cleanByBlock == true)
                allBlocks = unique(subjPreGoCorrect.Block);
                for blockIndex = 1:length(allBlocks)
                    deleteThisBlock = false; % assume we're keeping this block
                    block = allBlocks(blockIndex); % get the block name
                    allBlockTrials = origInhibitData( (origInhibitData.Subject == subj) & ...
                        (strcmpi(origInhibitData.Period,'0-PreTest')) & ...
                        (strcmpi(origInhibitData.Block, block)), :);
                    if (~isempty(allBlockTrials)) % this subject has seen this block
                        blockGoCorrect = subjPreGoCorrect(strcmpi(subjPreGoCorrect.Block, block), :);
                        blockPctGoCorrect = height(blockGoCorrect) / height(allBlockTrials);
                        if (blockPctGoCorrect < .7) % somewhat arbirary...!
                            deleteThisBlock = true;
                        end
                        blockCatchAll = allCatchTrials( (allCatchTrials.Subject == subj) & ...
                        (strcmpi(allCatchTrials.Period,'0-PreTest')) & ...
                        (strcmpi(allCatchTrials.Block, block)), :);                    
                        blockCatchIncorrect = blockCatchAll(strcmpi(blockCatchAll.InhCorr,'after'),:); % all the ones where they responded 'after' the cue (i.e., failed inhibit)
                        blockPctCatchCorrect = height(blockCatchIncorrect) / height(blockCatchAll);
                        if (blockPctCatchCorrect > .5) % somewhat arbirary...!
                            deleteThisBlock = true;
                        end
                    end

                     if (deleteThisBlock == true) % subject wasn't paying attention during this shift
                        subjPreInhAll(strcmpi(subjPreInhAll.Block, block), :) = [];
                        subjPreInhErrors(strcmpi(subjPreInhErrors.Block, block), :) = [];
                        subjPreGoCorrect(strcmpi(subjPreGoCorrect.Block, block), :) = [];
                     end
                end
           end

            if (height(subjPreInhErrors) > 0)
                lower3SDbound = mean(subjPreGoCorrect.newRT) - (3 * std(subjPreGoCorrect.newRT));
                upper3SDbound = mean(subjPreGoCorrect.newRT) + (3 * std(subjPreGoCorrect.newRT));
                subjPreGoCorrect(((subjPreGoCorrect.newRT < lower3SDbound) | (subjPreGoCorrect.newRT > upper3SDbound)), :) = []; % delete all trials outside of 3 SDs around the mean

                inhErrRate = height(subjPreInhErrors) / (height(subjPreInhAll));

                sortedGoRT = sort(subjPreGoCorrect.newRT); % sort the Go trials in ascending order
                GoRTindex = round(length(sortedGoRT) * inhErrRate); % grab the index to the go trial RT at (ErrRate)
                GoRTatErrRate = sortedGoRT(GoRTindex); % grab the RT of the go trial at that index
                meanSSD = (mean(cell2mat(subjPreInhAll.Inhibit)) / 1000); % get the mean SSD (note that it's in ms now, needs to be in seconds, so / 1000)
                PreSSRT = GoRTatErrRate - meanSSD;

                if (PreSSRT < .060) % error checking - can't really have a reaction time this fast
                    if (verbose == true)
                        fprintf('getSSRT_PP_1B: subj %d seems to be uncommonly fast (%f) in Pretest. GoRTatErrRate = %f, meanSSD = %f\n', subj, PreSSRT, GoRTatErrRate, meanSSD);
                        fprintf('Further details: error inhibits: %d, total inhibits: %d, correct go: %d \n', height(subjPreInhErrors), height(subjPreInhAll), height(subjPreGoCorrect));
                        fprintf('Further details: Min correctGo RT: %d, Max correctGo RT: %d \n', min(sortedGoRT), max(sortedGoRT));
                    end
                end
            else
                PreSSRT = -888;
                if (verbose == true)
                    fprintf('getSSRT_PP_1B: subj %d made no errors on PreTest; no way to calculate SSRT. Setting to -888.\n', subj);
                end
            end
        end

        % now do the same for post-test, if it exists
        PostSSRT = -777; % assume we don't have one
        subjPostGoCorrect = CorrectGo(((CorrectGo.Subject == subj) & (strcmpi(CorrectGo.Period,'4-PostTest'))), :); % just get this subject's rows
        subjPostInhAll = StaircaseInhAll(((StaircaseInhAll.Subject == subj) & (strcmpi(StaircaseInhAll.Period,'4-PostTest'))), :); % just get this subject's rows
%        subjPostInhCorrect = StaircaseInhCorrect(((StaircaseInhCorrect.Subject == subj) & (strcmpi(StaircaseInhCorrect.Period,'4-PostTest'))), :); % just get this subject's rows
        subjPostInhErrors = StaircaseInhErrors(((StaircaseInhErrors.Subject == subj) & (strcmpi(StaircaseInhErrors.Period,'4-PostTest'))), :); % just get this subject's rows
        if (height(subjPostGoCorrect) > 0)
            if (height(subjPostInhErrors) > 0)
                lower3SDbound = mean(subjPostGoCorrect.newRT) - (3 * std(subjPostGoCorrect.newRT));
                upper3SDbound = mean(subjPostGoCorrect.newRT) + (3 * std(subjPostGoCorrect.newRT));
                subjPostGoCorrect(((subjPostGoCorrect.newRT < lower3SDbound) | (subjPostGoCorrect.newRT > upper3SDbound)), :) = []; % delete all trials outside of 3 SDs around the mean

                inhErrRate = height(subjPostInhErrors) / (height(subjPostInhAll));

                sortedGoRT = sort(subjPostGoCorrect.newRT); % sort the Go trials in ascending order
                GoRTindex = round(length(sortedGoRT) * inhErrRate); % grab the index to the go trial RT at (ErrRate)
                GoRTatErrRate = sortedGoRT(GoRTindex); % grab the RT of the go trial at that index
                meanSSD = (mean(cell2mat(subjPostInhAll.Inhibit)) / 1000);  % get the mean SSD (note that it's in ms now, needs to be in seconds, so / 1000)
                PostSSRT = GoRTatErrRate - meanSSD;
            else % no errors, no SSRT
                PostSSRT = -888;
                if (verbose == true)
                    fprintf('getSSRT_PP_1B: subj %d made no errors on PostTest; no way to calculate SSRT. Setting to -888.\n', subj);
                end
            end
        else % no PostTest, no SSRT
            PostSSRT = NaN;
            if (verbose == true)
                fprintf('getSSRT_PP_1B: subj %d has no PostTest data. Setting SSRT to NaN.\n', subj);
            end
        end

        subjTrials = height(InhibitData((InhibitData.Subject == subj), :));
        if ((PostSSRT < 0) || (PreSSRT < 0))
            deltaSSRT = NaN;
        else
            deltaSSRT = PostSSRT - PreSSRT;
        end
        SSRTmat(subjIndex, 1:5) = [subj subjTrials PreSSRT PostSSRT deltaSSRT];
    end

    SSRT_table = array2table(SSRTmat, 'VariableNames', {'Subject','Trials','PreSSRT','PostSSRT','DeltaSSRT'});

    % print the table, if requested
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getSSRT_PP_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(SSRT_table, fileName);
    end

end
