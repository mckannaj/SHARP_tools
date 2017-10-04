% Zephy McKanna
% getSwitchCostRT_PP_1B
% 5/14/15
%
% This function takes a table made from pre/post switch data. Note: if you
% wish to exclude certain subjects, pass SwitchData through some exclusion function 
% (e.g. excludeSubjects_RF_1B) before giving it to this function.
%
% It cleans the data as follows: 
%   1. Marks all trials (except those at the start of a block) as "Switch"
%      or "Repetition".
%           zNOTE: DON'T NEED TO DO THIS; ALREADY DONE IN 1B! 
%   2. Deletes all Practice trials (Block = "Training_1" or "Training_2")
%   3. Notes any subject with > 50% errors (recommended for exclusion)
%   4. Deletes first trial of each Block
%   5. Deletes each trial immediately following a trial with an error (note
%      that "timeout" is an error in this case)
%   6. Deletes all error trials (note that "timeout" counts).
%   7. Creates a meaningful "ResponseTime" column for the CorrectGo and StaircaseInhErrors trials, 
%      subtracting StimTime from RespTime and then dividing by 10,000 to get seconds
%   8. Delete all correct trials that have reaction times <> 3 SDs from the mean (of any given
%      subject's Correct Reaction Times)
%
% It then calculates the mean ResponseTime for Switch trials and Repetition
% trials for each of Pretest and Posttest (if the latter data exist) for
% each subect. It returns a table with these values as well as the switch
% cost (difference between mean RT for Repetition and Switch trials).
%
function [SC_table] = getSwitchCostRT_PP_1B(SwitchData, printTable, verbose)
    if ( ~ismember('afterError',SwitchData.Properties.VariableNames) )
        error('getSwitchCostRT_PP_1B: This function requires added columns onto the data. Use addPPswitchCols() on the data first.');
    end

%    SwitchData.deleteThis = zeros(height(SwitchData), 1); % create a new variable to mark which trials need to be deleted
%    SwitchData.errors = zeros(height(SwitchData), 1); % create a new variable to mark errors, since mixing "timeout" and 0/1 is hard for matlab
%    SwitchData.errorProneSubj = zeros(height(SwitchData), 1); % create a new variable to mark which subjects get more than 50% errors

%    SwitchData{strcmpi(SwitchData.Block,'Training_1'),'deleteThis'} = 1; % delete all training trials
%    SwitchData{strcmpi(SwitchData.Block,'Training_2'),'deleteThis'} = 1; % delete all training trials
         
    allSubjects = unique(SwitchData.Subject);
    for subjIndex = 1:length(allSubjects) % do we really have to do this whole loop twice?
%        subjMadeTooManyErrors = false; % assume we don't have an error prone subject
        subj = allSubjects(subjIndex); % get the subject number
        subjTrials = SwitchData(SwitchData.Subject == subj, :);
%{        
        subjTrials.deleteThis(1) = 1; % the first trial is by definition the first trial of a block; mark it for deletion
        for trial = 1:height(subjTrials)
            if ((trial > 1) && (strcmpi(subjTrials.Block(trial-1), subjTrials.Block(trial)) == 0)) % this is the first trial of a block
                subjTrials.deleteThis(trial) = 1; % mark it for deletion
            end
            if ((strcmpi(subjTrials.Score{trial},'timeout') == 1) || (subjTrials.Score{trial} == 0)) % this is an error
                subjTrials.errors(trial) = 1; % note that it's an error
                subjTrials.deleteThis(trial) = 1; % mark it for deletion
                if (trial < (height(subjTrials))) % we're not at the very last one yet
                    subjTrials.deleteThis(trial+1) = 1; % mark the next one for deletion (note that if it spans two blocks, then this is the first trial of the next block and should be deleted anyway)
                end
            end
        end
%}

        errPercent = (height(subjTrials(subjTrials.error == 1, :))) / (height(subjTrials));
        if (errPercent > .5)
%            subjTrials.errorProneSubj = 1; % mark as error prone
%            subjMadeTooManyErrors = true; % NOTE: we don't actually use this value right now...
            if (verbose == true)
                fprintf('Subj %d has an error rate of %f.\n', subj, errPercent);
            end
        end
        
        subjTrials(subjTrials.deleteThis == 1, :) = []; % delete everything that needs deleting, except the <> 3SDs
        
%        subjTrials.newRT = ((subjTrials.RespTime - subjTrials.StimTime) / 10000); % get the response time (resp - stim) and put it in seconds (/ 10,000)
%        lower3SDbound = mean(subjTrials.newRT) - (3 * std(subjTrials.newRT));
%        upper3SDbound = mean(subjTrials.newRT) + (3 * std(subjTrials.newRT));
%        subjTrials(((subjTrials.newRT < lower3SDbound) | (subjTrials.newRT > upper3SDbound)), :) = []; % delete all trials outside of 3 SDs around the mean

        preSubjTrials = subjTrials(strcmpi(subjTrials.Period,'0-PreTest'), :);
        preTrialsUsed = height(preSubjTrials);
        postSubjTrials = subjTrials(strcmpi(subjTrials.Period,'4-PostTest'), :);
        postTrialsUsed = height(postSubjTrials);
        
        subjPreAvgSwRT = mean(table2array(preSubjTrials(preSubjTrials.IsSwitch == 1, 'newRT')));
        subjPreAvgRepRT = mean(table2array(preSubjTrials(isnan(preSubjTrials.IsSwitch), 'newRT')));
        subjPreSC = (subjPreAvgSwRT-subjPreAvgRepRT);
        subjPostAvgSwRT = mean(table2array(postSubjTrials(postSubjTrials.IsSwitch == 1, 'newRT')));
        subjPostAvgRepRT = mean(table2array(postSubjTrials(isnan(postSubjTrials.IsSwitch), 'newRT')));
        subjPostSC = (subjPostAvgSwRT-subjPostAvgRepRT);
        
        SCmat(subjIndex, :) = [subj errPercent preTrialsUsed subjPreAvgSwRT subjPreAvgRepRT subjPreSC postTrialsUsed subjPostAvgSwRT subjPostAvgRepRT subjPostSC (subjPostSC-subjPreSC)];
    end

    SC_table = array2table(SCmat, 'VariableNames', {'Subject','TotalErrPct','PreCleanTrials','Pre_avgSwRT','Pre_avgRepRT','Pre_SC','PostCleanTrials','Post_avgSwRT','Post_avgRepRT','Post_SC','DeltaSC'});

    % print the table, if requested
    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getSwitchCostRT_PP_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(SC_table, fileName);
    end

end