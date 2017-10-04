% Zephy McKanna
% 11/18/14
%
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% It returns a set of four tables: one that contains all trials for
% single EFs (U, S, and I clusters), one that contains all non-single EF
% trials, and one that contains just level 4 trials. 
% It also returns a matrix with counts of all of these trials (four rows:
% subj, singleEFcount, multipleEFcount, level4count)
%
function [singleEFtrials, multipleEFtrials, level4trials, trialCounts] = getEFtrialCounts(allTrialData)
    singleEFtrials = allTrialData(strcmpi(allTrialData.Cluster,'U') | strcmpi(allTrialData.Cluster,'S') | strcmpi(allTrialData.Cluster,'I'),:); % Any trials in these clusters are single-EF trials

    multipleEFtrials = allTrialData;
    multipleEFtrials(strcmpi(multipleEFtrials.Cluster,'U') | strcmpi(multipleEFtrials.Cluster,'S') | strcmpi(multipleEFtrials.Cluster,'I'),:) = []; % Any trials in these clusters are single-EF trials, so delete them from the multiple-EF matrix

    level4trials = allTrialData(strcmpi(allTrialData.Cluster,'L4') | strcmpi(allTrialData.Cluster,'L4a') | strcmpi(allTrialData.Cluster,'L4b') | strcmpi(allTrialData.Cluster,'L4aV1') | strcmpi(allTrialData.Cluster,'L4aV2') | strcmpi(allTrialData.Cluster,'L4bV1') | strcmpi(allTrialData.Cluster,'L4bV2'),:); % Any trials in these clusters are level 4 trials
    
    allSubjects = unique(allTrialData.Subject);
    trialCountMat = [allSubjects(1), 0,0,0];
    trialCountMatRow = 1; % the row of newSumMat that we're on
    for subjIndex = 1:length(allSubjects)
        subj = allSubjects(subjIndex); % get the subject number
        singleEFcount = height(singleEFtrials(singleEFtrials.Subject == subj, :));
        multipleEFcount = height(multipleEFtrials(multipleEFtrials.Subject == subj, :));
        level4count = height(level4trials(level4trials.Subject == subj, :));
        
        trialCountMat(trialCountMatRow, :) = [subj, singleEFcount, multipleEFcount, level4count];
        
        trialCountMatRow = trialCountMatRow + 1; % prepare to do the next row
    end

    trialCounts = array2table(trialCountMat, 'VariableNames', {'Subject','singleEFcount','multipleEFcount','level4count'});

end

