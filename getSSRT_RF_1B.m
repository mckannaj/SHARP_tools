% Zephy McKanna
% getSSRT_RF_1B
% 4_29_15
%
% This function takes a table made from RF inhibit data, such as that
% returned from getSomeRFshifts().
% Note: if you wish to exclude certain subjects, pass InhibitData through some exclusion function 
% (e.g. excludeSubjects_RF_1B) before giving it to this function.
%
% zNOTE: RIGHT NOW, JUST DOING 'I' CLUSTERS (could add dual/triple later)
% 
% 
function [SSRT_table] = getSSRT_RF_1B(InhibitData, singleOrDual, printTable, verbose, cleanByShift)
    if (nargin ~= nargin('getSSRT_RF_1B'))
        error('zError: getSSRT_RF_1B expects %d inputs, but received %d. Please update any calling code.\n', nargin('getSSRT_RF_1B'), nargin);
    end

    % First, clean the data
    if (strcmpi(singleOrDual, 'single') == 1)
        InhibitData = InhibitData(strcmpi(InhibitData.Cluster,'I'),:); % start with just the inihibt-shift trials
    elseif (strcmpi(singleOrDual, 'dual') == 1)
        InhibitData = InhibitData(strcmpi(InhibitData.Cluster,'S/I') | strcmpi(InhibitData.Cluster,'U/I'),:); % start with dual tasks involving inhibit
        error('zError: getSSRT_RF_1B is not yet set up to deal with dual tasks. Zephy, fix this!');
    elseif (strcmpi(singleOrDual, 'both') == 1)
        InhibitData = InhibitData(strcmpi(InhibitData.Cluster,'I') | strcmpi(InhibitData.Cluster,'S/I') | strcmpi(InhibitData.Cluster,'U/I'),:); % start with single and dual tasks involving inhibit
        error('zError: getSSRT_RF_1B is not yet set up to deal with dual tasks. Zephy, fix this!');
    else
        error('getSSRT_RF_1B: singleOrDual should be single, dual, or both.\n');
    end

    AllCatchTrials = InhibitData(InhibitData.UsedShortDelay == 1, :); % save the catch trials elsewhere
    AllCatchTrials(AllCatchTrials.DisplayedInhSignal == 0, : ) = []; % if we never got to display the Inhibit cue, it's not really a catch trial
    
    InhibitData(InhibitData.UsedShortDelay == 1, :) = []; % delete the catch trials from what will become Go trials and Staircase trials

    tmpGoTrials = InhibitData(InhibitData.DisplayedInhSignal == 0,'DisplayedInhSignal'); % identify the Inhibit trials where the participant responded before the cue (should be treated as Go trials)
    tmpGoTrials.DisplayedInhSignal(:) = NaN; % mark the correct length with NaNs (note that tmpGoTrials has only one column, DisplayedInhibitSignal)
    InhibitData(InhibitData.DisplayedInhSignal == 0,'InhDelayUsed') = tmpGoTrials; % save the NaNs to any cells that indicate this is an Inhibit trial
    InhibitData(InhibitData.DisplayedInhSignal == 0,'UsedShortDelay') = tmpGoTrials; % save the NaNs to any cells that indicate this is an Inhibit trial
    InhibitData(InhibitData.DisplayedInhSignal == 0,'DisplayedInhSignal') = tmpGoTrials; % save the NaNs to any cells that indicate this is an Inhibit trial

    StaircaseInhAll = InhibitData(InhibitData.DisplayedInhSignal == 1,:); % any trials in which we displayed an inhibit cue are staircase inhibit trials (since we've already deleted the catch trials)

    StaircaseInhErrors = StaircaseInhAll(~strcmpi(StaircaseInhAll.GivenResp,'NO_ACTION'),:); % if they responded after the cue, it's an error
    
    AllRespondedGo = InhibitData(isnan(InhibitData.DisplayedInhSignal),:); % get all the rows that have [NaN] in the DisplayedInhSignal col
    AllRespondedGo(strcmpi(AllRespondedGo.GivenResp,'NO_ACTION'),:) = []; % delete all the trials where they didn't respond, even if it's technically correct, since this doesn't help our RT estimation
    CorrectGo = AllRespondedGo; 
    CorrectGo(CorrectGo.Correct == 0,:) = []; % delete any trials in which their response was wrong

    
    % Then, use the cleaned data to estimate SSRT
    allSubjects = unique(InhibitData.Subject);
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number

        subjGoAll = AllRespondedGo(AllRespondedGo.Subject == subj, :); % get this subj's go trials
        subjGoCorrect = CorrectGo(CorrectGo.Subject == subj, :); % get this subj's correct go trials
        subjCatchAll = AllCatchTrials(AllCatchTrials.Subject == subj, :); % get this subj's catch trials
        subjCatchCorrect = subjCatchAll(subjCatchAll.Correct == 1, :); % get this subj's correct catch trials
        subjInhAll = StaircaseInhAll(StaircaseInhAll.Subject == subj, :); % get this subj's inhibit trials
        subjInhErrors = StaircaseInhErrors(StaircaseInhErrors.Subject == subj, :); % get this subj's inhibit errors
        
        if (cleanByShift == true) % remove shifts that the subj didn't pay attention to
            allShifts = unique(subjGoAll.Shift);
            for shiftIndex = 1:length(allShifts)
                deleteThisShift = false; % assume we're keeping this shift
                shift = allShifts(shiftIndex); % get the shift name
                shiftGoAll = subjGoAll(strcmpi(subjGoAll.Shift, shift), :);
                if (~isempty(shiftGoAll)) % this subject has seen this shift
                    shiftGoCorrect = subjGoCorrect(strcmpi(subjGoCorrect.Shift, shift), :); % get this subj/shift's correct go trials
                    shiftPctGoCorrect = height(shiftGoCorrect) / height(shiftGoAll);
                    if (shiftPctGoCorrect < .7) % somewhat arbirary...!
                        deleteThisShift = true;
                    end
                    shiftCatchAll = subjCatchAll(strcmpi(subjCatchAll.Shift, shift), :); % get this subj/shift's catch trials
                    shiftCatchCorrect = shiftCatchAll(shiftCatchAll.Correct == 1, :); % get this subj's correct catch trials
                    shiftPctCatchCorrect = height(shiftCatchCorrect) / height(shiftCatchAll);
                    if (shiftPctCatchCorrect < .4) % somewhat arbirary...!
                        deleteThisShift = true;
                    end
                end
                   
                if (deleteThisShift == true) % subject wasn't paying attention during this shift
                    subjGoAll(strcmpi(subjGoAll.Shift, shift), :) = [];
                    subjGoCorrect(strcmpi(subjGoCorrect.Shift, shift), :) = [];
                    subjCatchAll(strcmpi(subjCatchAll.Shift, shift), :) = [];
                    subjCatchCorrect(strcmpi(subjCatchCorrect.Shift, shift), :) = [];
                    subjInhAll(strcmpi(subjInhAll.Shift, shift), :) = [];
                    subjInhErrors(strcmpi(subjInhErrors.Shift, shift), :) = [];
                    
                    % zNOTE: not deleting from AllCatchTrials, StaircaseInhAll, etc...!
                    InhibitData((InhibitData.Subject == subj) & strcmpi(InhibitData.Shift, shift), :) = []; % InhibitData is used below to calculate how many trials this subj saw
                end
            end
        end
        
        if (height(subjInhErrors) > 0) % can't estimate SSRT unless the subject had some errors on Inhibit
            lower3SDbound = mean(subjGoCorrect.RespTime) - (3 * std(subjGoCorrect.RespTime));
            upper3SDbound = mean(subjGoCorrect.RespTime) + (3 * std(subjGoCorrect.RespTime));
            subjGoCorrect(((subjGoCorrect.RespTime < lower3SDbound) | (subjGoCorrect.RespTime > upper3SDbound)), :) = []; % delete all trials outside of 3 SDs around the mean

            inhErrRate = height(subjInhErrors) / (height(subjInhAll));

            sortedGoRT = sort(subjGoCorrect.RespTime); % sort the Go trials in ascending order
            GoRTindex = round(length(sortedGoRT) * inhErrRate); % grab the index to the go trial RT at (ErrRate)
            GoRTatErrRate = sortedGoRT(GoRTindex); % grab the RT of the go trial at that index
            meanSSD = mean(subjInhAll.InhDelayUsed);
            SSRTest = GoRTatErrRate - meanSSD;
            
            if (SSRTest < .060) % error checking - can't really have a reaction time this fast
                if (verbose == true)
                    fprintf('getSSRT_RF_1B: subj %d seems to be uncommonly fast (%f) in Pretest. GoRTatErrRate = %f, meanSSD = %f\n', subj, SSRTest, GoRTatErrRate, meanSSD);
                    fprintf('Further details: error inhibits: %d, total inhibits: %d, correct go: %d \n', height(subjInhErrors), height(subjInhAll), height(subjGoCorrect));
                    fprintf('Further details: Min correctGo RT: %d, Max correctGo RT: %d \n', min(sortedGoRT), max(sortedGoRT));
                end
            end
        else
            SSRTest = -888;
            if (verbose == true)
                fprintf('getSSRT_RF_1B: subj %d made no errors on inhibit; no way to calculate SSRT. Setting to -888.\n', subj);
            end
        end
        
        if (height(subjGoAll) > 0) % can't estimate CorrectGoPct unless the subject had some Go trials
            CorrectGoPct = height(subjGoCorrect) / height(subjGoAll);
        else
            CorrectGoPct = -99;
            if (verbose == true)
                fprintf('getSSRT_RF_1B: subj %d had no Go trials; no way to calculate CorrectGoPct. Setting to -99.\n', subj);
            end
        end
        
        if (height(subjCatchAll) > 0) % can't estimate CorrectGoPct unless the subject had some Go trials
            CorrectCatchPct = height(subjCatchCorrect) / height(subjCatchAll);
        else
            CorrectCatchPct = -88;
            if (verbose == true)
                fprintf('getSSRT_RF_1B: subj %d had no Catch trials; no way to calculate CorrectCatchPct. Setting to -88.\n', subj);
            end
        end
        
        subjTrials = height(InhibitData((InhibitData.Subject == subj), :));
        
        SSRTmat(subjIndex, 1:5) = [subj subjTrials SSRTest CorrectCatchPct CorrectGoPct];

    end

    SSRT_table = array2table(SSRTmat, 'VariableNames', {'Subject','TotTrials','SSRT_est','CorrectCatchPct','CorrectGoPct'});

    % print the table, if requested
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getSSRT_RF_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(SSRT_table, fileName);
    end

end