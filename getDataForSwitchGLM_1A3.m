% Zephy McKanna
% getDataForSwitchGLM_1A3()
% 2/18/15
% 
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% It uses getCleanSwitchTrials_RF_1A3 to clean the switch trials and
% separate them into switch and repetition trials.
% - remove first trial of each shift
% - remove all trials immediately after errors
% - (for now) leaving in all the "no response" trials
%
% It returns two matrices:
% 1. a single-column matrix intended to be the Y values (correct/incorrect)
% 2. a multiple-column matrix in which each column is an X value. This
% matrix includes cols for subj, "difficulty" (1 = switch and 2 = repetition), and 
% responseTime. 
%
% Note that this only (right now) uses the single-EF Switch trials.
%
% If the timeCount flag is 'ShiftCount', this includes a fourth xVals column
% that is the number of times that the subject has seen this particular EF shift 
% (i.e., the number of Switch shifts that came before this one), added to
% the subject number multiplied by 1000 (so that you can see which subject
% it is). This should be a measure of learning - that is, the scores should
% go up as they go on. Otherwise (default), the fourth col instead contains
% Switch trials that came up before this one.
% 
% If the excludeSubjs flag is true, it excludes the agreed-upon subjects
% from 1A3. It also excludes any subjects not in the RobotFactory training
% group, though this should be redundant.
%
% If the splitSubjBySwRep flag is true, it splits the categorical "subjects"
% column into different categories by multiplying it by 10 and then adding
% the difficulty. In this case, the "difficulty" is just switch (1) or
% repetition (2), so it makes two categories for the ability of each
% subject.
% If splitSubjBySwRep is false, it keeps subjects in a single category,
% meaning that each subject gets a single ability, across all switch/repetition categories. 
%
% If the subjNum variable is 'all', then data from all subjects will be used.
% Otherwise, only the subject number in subjNum will be used.
%
% If the dualTasks variable is 'dual', then only data from dual-EF shifts
% (U/I and U/S) will be used. If it's 'both', then both dual-EF and
% single-EF (U) trials will be included. Otherwise, it will assume just
% single EF should be used.
%
% This function expects to be called just prior to a fitglm call something like this one: 
% RFSwModel = fitglm(x_RFSw,y_RFSw,'linear','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','Correct'})
%
function [xVals, yVals] = getDataForSwitchGLM_1A3(allDataTable1A3, excludeSubjs, splitSubjBySwRep, timeCount, subjNum, dualTasks, verbose)
    
    % first, see if we're limiting the amount of data we collect
    if (excludeSubjs == true)
        allDataTable1A3 = excludeSubjects_RF_1A3('both', true, allDataTable1A3);
    end
    if (strcmpi(subjNum, 'all') == 0) % we're not doing all subjects
        allDataTable1A3(allDataTable1A3.Subject ~= subjNum, :) = []; % delete all but subjNum's data
        if (verbose == true)
            fprintf('getDataForSwitchGLM_1A3: using only subject number %d.\n', subjNum(1,1));
        end
    else 
        if (verbose == true)
            fprintf('getDataForSwitchGLM_1A3: using all subjects.\n');
        end
    end
    if (isempty(allDataTable1A3))
        error('getDataForSwitchGLM_1A3: with exclusions and subjNum = %d, we have no data to return!', subjNum(1,1));
    end
        
    % then, grab the clean trials (removing all the "no response" trials ('both', below) for now...)
    allSwitchTrials = getAllSwitchTrials_1A3(allDataTable1A3, 'both', 'all', dualTasks);
%{
    if (strcmpi(dualTasks, 'dual')) % just use dual tasks
        [swTrials, repTrials] = getCleanSwitchTrials_dualTasks_RF_1A3(true, true, 'both', 'all', true, allDataTable1A3);
    elseif (strcmpi(dualTasks, 'both')) % use single and dual tasks
        [SingleSwTrials, SingleRepTrials] = getCleanSwitchTrials_RF_1A3(true, true, 'both', false, allDataTable1A3);
        [DualSwTrials, DualRepTrials] = getCleanSwitchTrials_dualTasks_RF_1A3(true, true, 'both', 'all', true, allDataTable1A3);
        SingleSwTrials.ShiftCount = SingleSwTrials.ShiftCount + 100; % just to distinguish between the two...
        SingleRepTrials.ShiftCount = SingleRepTrials.ShiftCount + 100; % just to distinguish between the two...
        DualSwTrials.ShiftCount = DualSwTrials.ShiftCount + 100; % just to distinguish between the two...
        DualRepTrials.ShiftCount = DualRepTrials.ShiftCount + 100; % just to distinguish between the two...
        % Z NOTE: TRIAL COUNT IS ACTUALLY WRONG HERE!!! NO INTERLEAVING OF SINGLE AND DUAL EFs....?!??!!
        
%        singleEFtrials.updateTrial = ones(height(singleEFtrials), 1); % dualEFtrials has this col, so need it to merge
        swTrials = [SingleSwTrials;DualSwTrials];
        repTrials = [SingleRepTrials;DualRepTrials];
        
        fprintf('getDataForSwitchGLM_1A3: using both single and dual tasks... loop may take a couple minutes...\n');
        % re-order ShiftCount and TrialCount, interleaving single and dual EF trials based on Subj and ShiftNum
        allSwitchTrials = [swTrials;repTrials];
        tNum = 1;
        sNum = 1;
        subjs = unique(allSwitchTrials.Subject);
        for subj = 1:(length(subjs))
            shifts = unique(allSwitchTrials(allSwitchTrials.Subject == subjs(subj),:).ShiftNum);
            for shift = 1:length(shifts)
                tmpCountTable = allSwitchTrials(allSwitchTrials.ShiftNum == shifts(shift), :).TrialCount;
                tmpCountTable(:,1) = tNum:(tNum+length(tmpCountTable)-1); % fill that table with numbers in order starting with tNum
                allSwitchTrials(allSwitchTrials.ShiftNum == shifts(shift), :).TrialCount = tmpCountTable; % then assign it to the right rows
                tNum = tNum + length(tmpCountTable);
                tmpCountTable(:,1) = sNum; % now just fill it with the one shift number
                allSwitchTrials(allSwitchTrials.ShiftNum == shifts(shift), :).ShiftCount = tmpCountTable; % then assign it to the right rows
                sNum = sNum + 1;
            end
        end
                
    else % default to just single tasks
        [swTrials, repTrials] = getCleanSwitchTrials_RF_1A3(true, true, 'both', false, allDataTable1A3);
    end
%}    
%    yVals = [table2array(swTrials(:,'Correct')); table2array(repTrials(:,'Correct'))];
    yVals = table2array(allSwitchTrials(:,'Correct'));    
    
%    xVals = [table2array(swTrials(:,'Subject')); table2array(repTrials(:,'Subject'))];
    xVals = table2array(allSwitchTrials(:,'Subject')); 
    
    % now make all switches 1s and all reps 2s...
%    xVals(:,2) = [ones(height(swTrials),1); (ones(height(repTrials),1) + 1)];
    xVals(:,2) = ones(height(allSwitchTrials),1); % assume switch trials
    tempRepTrialArray = table2array(allSwitchTrials(:,'nonSwitchTrial')); % this has 1 for rep trials and 0 for switch trials
    xVals(:,2) = xVals(:,2) + tempRepTrialArray; % add 1 to all repetition trials, making them 2
%    xVals(allSwitchTrials(allSwitchTrials.nonSwitchTrial == 1, :),2) = 2; % set the repTrials to 2
    
%    switchTrials = allTrialData(allTrialData.switchTrial == 1, :);
%    nonSwitchTrials = allTrialData(allTrialData.nonSwitchTrial == 1, :);
   
    
 
%    xVals(:,3) = [table2array(swTrials(:,'RespTime')); table2array(repTrials(:,'RespTime'))];
    xVals(:,3) = table2array(allSwitchTrials(:,'RespTime')); 

    if (strcmpi(timeCount, 'ShiftCount'))
%        xVals(:,4) = [table2array(swTrials(:,'ShiftCount')); table2array(repTrials(:,'ShiftCount'))];
        xVals(:,4) = table2array(allSwitchTrials(:,'ShiftCount')); 
%        if (splitShiftCountBySubjs == true) % make a different value for each subj+shift combination
%            xVals(:,4) = (xVals(:,1) * 100) + xVals(:,4);
%        end
    else % default to counting trials
%        xVals(:,4) = [table2array(swTrials(:,'TrialCount')); table2array(repTrials(:,'TrialCount'))];
%        xVals(:,4) = table2array(allSwitchTrials(:,'TrialCount')); 
        xVals(:,4) = table2array(allSwitchTrials(:,'TotalTrialCount')); % comes from putNewColsIntoDataTable_1A3()
    end

%{    
    swTrials.ClusterNum = zeros(height(swTrials), 1);
    tmpClusterTable = swTrials(strcmpi(swTrials.Cluster, 'S/I'), :).ClusterNum; % make a table the right height
    tmpClusterTable(:,1) = 1; % fill that table with 1
    swTrials(strcmpi(swTrials.Cluster, 'S/I'), :).ClusterNum = tmpClusterTable; % then assign it to the right rows
    tmpClusterTable = swTrials(strcmpi(swTrials.Cluster, 'U/S'), :).ClusterNum; % make a table the right height
    tmpClusterTable(:,1) = 2; % fill that table with 2
    swTrials(strcmpi(swTrials.Cluster, 'U/S'), :).ClusterNum = tmpClusterTable; % then assign it to the right rows
    repTrials.ClusterNum = zeros(height(repTrials), 1);
    tmpClusterTable = repTrials(strcmpi(repTrials.Cluster, 'S/I'), :).ClusterNum; % make a table the right height
    tmpClusterTable(:,1) = 1; % fill that table with 1
    repTrials(strcmpi(repTrials.Cluster, 'S/I'), :).ClusterNum = tmpClusterTable; % then assign it to the right rows
    tmpClusterTable = repTrials(strcmpi(repTrials.Cluster, 'U/S'), :).ClusterNum; % make a table the right height
    tmpClusterTable(:,1) = 2; % fill that table with 2
    repTrials(strcmpi(repTrials.Cluster, 'U/S'), :).ClusterNum = tmpClusterTable; % then assign it to the right rows
    
    xVals(:,5) = [table2array(swTrials(:,'ClusterNum')); table2array(repTrials(:,'ClusterNum'))];
%}
    
    allSwitchTrials.ClusterNum = zeros(height(allSwitchTrials), 1); % make the 'S' trials zero (default)
    if (strcmpi(dualTasks, 'both')) % we're using dual tasks
        tmpClusterTable = allSwitchTrials(strcmpi(allSwitchTrials.Cluster, 'S/I'), :).ClusterNum; % make a table the right height
        tmpClusterTable(:,1) = 1; % fill that table with 1
        allSwitchTrials(strcmpi(allSwitchTrials.Cluster, 'S/I'), :).ClusterNum = tmpClusterTable; % then assign it to the right rows
        tmpClusterTable = allSwitchTrials(strcmpi(allSwitchTrials.Cluster, 'U/S'), :).ClusterNum; % make a table the right height
        tmpClusterTable(:,1) = 2; % fill that table with 2
        allSwitchTrials(strcmpi(allSwitchTrials.Cluster, 'U/S'), :).ClusterNum = tmpClusterTable; % then assign it to the right rows
    end
    xVals(:,5) = table2array(allSwitchTrials(:,'ClusterNum')); 
    
    
    
    
    %    xVals(:,1) = categorical(xVals(:,1)); % note: if we make this categorical from the start, it initializes the entire table as categorical for some reason

    if (splitSubjBySwRep == true)
        xVals(:,1) = (xVals(:,1) * 10) + xVals(:,2);
    end
    
end

