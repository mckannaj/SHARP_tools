% Zephy McKanna
% getDataForUpdateGLM_1A3()
% 3/9/15
% 
% This function takes as input the "all" table created by formTables_RF_1A3().
%
% It uses getCleanUpdateTrials_RF_1A3 to clean the update trials and (for
% now) remove all the "no response" trials.
%
% It returns two matrices:
% 1. a single-column matrix intended to be the Y values (correct/incorrect)
% 2. a multiple-column matrix in which each column is an X value. This
% matrix includes cols for subj, "difficulty" (N value), and 
% responseTime. 
%
% Note that this only (right now) uses the single-EF Update trials.
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
% If the splitSubjByNval flag is true, it splits the categorical "subjects"
% column into different categories by multiplying it by 10 and then adding
% the N value. So it makes three categories for the ability of each subject.
% If splitSubjByNval is false, it keeps subjects in a single category,
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
% This function expects to be called preceding a GLM call like the following: 
% RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'linear','distr','binomial','CategoricalVars',[1,2,4],'VarNames',{'Subj','Nval','RT','ShiftCount','Correct'})
%
function [xVals, yVals] = getDataForUpdateGLM_1A3(allDataTable1A3, excludeSubjs, splitSubjByNval, timeCount, subjNum, dualTasks, verbose)

    % first, see if we're limiting the amount of data we collect
    if (excludeSubjs == true)
        allDataTable1A3 = excludeSubjects_RF_1A3('both', true, allDataTable1A3);
    end
    if (strcmpi(subjNum, 'all') == 0) % we're not doing all subjects
        allDataTable1A3(allDataTable1A3.Subject ~= subjNum, :) = []; % delete all but subjNum's data
        if (verbose == true)
            fprintf('getDataForUpdateGLM_1A3: using only subject number %d.\n', subjNum(1,1));
        end
    else 
        if (verbose == true)
            fprintf('getDataForUpdateGLM_1A3: using all subjects.\n');
        end
    end
    if (isempty(allDataTable1A3))
        error('getDataForUpdateGLM_1A3: with exclusions and subjNum = %d, we have no data to return!', subjNum(1,1));
    end
    
    % then, grab the clean trials
    allUpdateTrials = getAllUpdateTrials_1A3(allDataTable1A3, 'both', 'all', dualTasks, verbose);
%{    
    if (strcmpi(dualTasks, 'dual')) % just use dual tasks
        [~,~,~, allUpdateTrials] = getCleanUpdateTrials_RF_1A3('both', false, allDataTable1A3);
    elseif (strcmpi(dualTasks, 'both')) % use single and dual tasks
        [~,~,~, singleEFtrials] = getCleanUpdateTrials_RF_1A3('both', false, allDataTable1A3);
        [~,~,~, dualEFtrials] = getCleanUpdateTrials_dualTasks_RF_1A3('both', 'all', true, allDataTable1A3);
%        dualEFtrials.ShiftCount = dualEFtrials.ShiftCount + 100; % just to distinguish between the two...
        % Z NOTE: TRIAL COUNT IS ACTUALLY WRONG HERE!!! NO INTERLEAVING OF SINGLE AND DUAL EFs....?!??!!
        
        singleEFtrials.updateTrial = ones(height(singleEFtrials), 1); % dualEFtrials has this col, so need it to merge
        allUpdateTrials = [singleEFtrials;dualEFtrials];
        
        fprintf('getDataForUpdateGLM_1A3: using both single and dual tasks... loop may take a couple minutes...\n');
        % re-order ShiftCount and TrialCount, interleaving single and dual EF trials based on Subj and ShiftNum
        tNum = 1;
        sNum = 1;
        subjs = unique(allUpdateTrials.Subject);
        for subj = 1:(length(subjs))
            shifts = unique(allUpdateTrials(allUpdateTrials.Subject == subjs(subj),:).ShiftNum);
            for shift = 1:length(shifts)
                tmpCountTable = allUpdateTrials(allUpdateTrials.ShiftNum == shifts(shift), :).TrialCount;
                tmpCountTable(:,1) = tNum:(tNum+length(tmpCountTable)-1); % fill that table with numbers in order starting with tNum
                allUpdateTrials(allUpdateTrials.ShiftNum == shifts(shift), :).TrialCount = tmpCountTable; % then assign it to the right rows
                tNum = tNum + length(tmpCountTable);
                tmpCountTable(:,1) = sNum; % now just fill it with the one shift number
                allUpdateTrials(allUpdateTrials.ShiftNum == shifts(shift), :).ShiftCount = tmpCountTable; % then assign it to the right rows
                sNum = sNum + 1;
            end
        end
        
    else % default to just single tasks
        [~,~,~, allUpdateTrials] = getCleanUpdateTrials_dualTasks_RF_1A3('both', 'all', true, allDataTable1A3);
    end
%}
    yVals = table2array(allUpdateTrials(:,'Correct'));
    
    xVals = table2array(allUpdateTrials(:,'Subject')); 
    
    % N vals...
    xVals(:,2) = table2array(allUpdateTrials(:,'ActualN')); 
 
    xVals(:,3) = table2array(allUpdateTrials(:,'RespTime'));

    if (strcmpi(timeCount, 'ShiftCount'))
        xVals(:,4) = table2array(allUpdateTrials(:,'ShiftCount'));
%        if (splitShiftCountBySubjs == true) % make a different value for each subj+shift combination
%            xVals(:,4) = (xVals(:,1) * 100) + xVals(:,4);
%        end
    else % count trials rather than shifts
%        xVals(:,4) = table2array(allUpdateTrials(:,'TrialCount'));
        xVals(:,4) = table2array(allUpdateTrials(:,'TotalTrialCount'));
    end

%    xVals(:,5) = allUpdateTrials.Cluster;
    allUpdateTrials.ClusterNum = zeros(height(allUpdateTrials), 1);
    tmpClusterTable = allUpdateTrials(strcmpi(allUpdateTrials.Cluster, 'U/I'), :).ClusterNum; % make a table the right height
    tmpClusterTable(:,1) = 1; % fill that table with 1
    allUpdateTrials(strcmpi(allUpdateTrials.Cluster, 'U/I'), :).ClusterNum = tmpClusterTable; % then assign it to the right rows
    tmpClusterTable = allUpdateTrials(strcmpi(allUpdateTrials.Cluster, 'U/S'), :).ClusterNum; % make a table the right height
    tmpClusterTable(:,1) = 2; % fill that table with 2
    allUpdateTrials(strcmpi(allUpdateTrials.Cluster, 'U/S'), :).ClusterNum = tmpClusterTable; % then assign it to the right rows
    xVals(:,5) = table2array(allUpdateTrials(:,'ClusterNum'));

    
    %    xVals(:,1) = categorical(xVals(:,1)); % note: if we make this categorical from the start, it initializes the entire table as categorical for some reason

    if (splitSubjByNval == true)
        xVals(:,1) = (xVals(:,1) * 10) + xVals(:,2);
    end
    
end

