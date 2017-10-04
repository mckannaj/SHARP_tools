% Zephy McKanna
% getDataForSwitchGLM()
% 4/16/15
% 
% This function expects to take the 'allTrials' output from
% getAllSwitchTrials_1A3() or getCleanSwitchTrials_RF_1B().
%
% It returns two matrices:
% 1. a single-column matrix intended to be the Y values (correct/incorrect)
% 2. a multiple-column matrix in which each column is an X value. This
% matrix includes cols for subj, "difficulty" (1 = switch and 2 = repetition), and 
% responseTime. 
%
% If the timeCount flag is 'ShiftCount', this includes a fourth xVals column
% that is the number of times that the subject has seen this particular EF shift 
% (i.e., the number of Switch shifts that came before this one), added to
% the subject number multiplied by 1000 (so that you can see which subject
% it is). This should be a measure of learning - that is, the scores should
% go up as they go on. Otherwise (default), the fourth col instead contains
% Switch trials that came up before this one (i.e., 'TrialCount') - which
% should be a higher-resolution measure of the same learning parameter.
% 
% If the excludeSubjs flag is '1A3', it excludes the agreed-upon subjects
% from 1A3. If the flag is '1B', it excludes the agreed-upon subjects for
% 1B. In either of these cases it also excludes any subjects not in the 
% RobotFactory training group, though this may be redundant.
%
% If the splitSubjBySwRep flag is true, it splits the categorical "subjects"
% column into different categories by multiplying it by 10 and then adding
% the difficulty. In this case, the "difficulty" is just switch (1) or
% repetition (2), so it makes two categories for the ability of each
% subject.
% If splitSubjBySwRep is false (default), it keeps subjects in a single category,
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
function [xVals, yVals] = getDataForSwitchGLM(switchTable, excludeSubjs, splitSubjBySwRep, timeCount, subjNum, dualTasks, verbose)
    if ( (~ismember('SwitchShiftCount',switchTable.Properties.VariableNames)) || ...
            (~ismember('ScenarioCode',switchTable.Properties.VariableNames)) )
        error('getDataForSwitchGLM: This function requires added columns onto the data. Use getCleanSwitchTrials_RF_1B() on the data first.');
    end

    % first, see if we're limiting the amount of data we collect
    if (strcmpi(excludeSubjs, '1A3') == 1) % excluding 1A3 subjects
        if (verbose == true)
            fprintf('getDataForSwitchGLM_1A3: excluding subjects from 1A3.\n');
        end
        switchTable = excludeSubjects_RF_1A3('both', true, switchTable); % exclude both people with weird progression and noncompliant people, as well as non-RF people
    elseif (strcmpi(excludeSubjs, '1B') == 1) % excluding 1B subjects
        if (verbose == true)
            fprintf('getDataForSwitchGLM_1A3: excluding subjects from 1B.\n');
        end
        switchTable = excludeSubjects_RF_1B(true, true, false, switchTable); % also exclude all non-RF people
    end
    if (strcmpi(subjNum, 'all') == 0) % we're not doing all subjects
        switchTable(switchTable.Subject ~= subjNum, :) = []; % delete all but subjNum's data
        if (verbose == true)
            fprintf('getDataForSwitchGLM_1A3: using only subject number %d.\n', subjNum(1,1));
        end
    else 
        if (verbose == true)
            fprintf('getDataForSwitchGLM_1A3: using all subjects.\n');
        end
    end
    if (isempty(switchTable))
        error('getDataForSwitchGLM_1A3: with exclusions and subjNum = %d, we have no data to return!', subjNum(1,1));
    end
        
    % NO LONGER CLEANING HERE; SHOULD CLEAN BEFORE CALLING THIS FUNCTION       then, grab the clean trials (removing all the "no response" trials ('both', below) for now...)
    % allSwitchTrials = getAllSwitchTrials_1A3(switchTable, 'both', 'all', dualTasks);
    allSwitchTrials = switchTable; % these data should already be "clean" switch data
    allSwitchTrials(allSwitchTrials.SwitchFlag == 0, :) = []; % remove trials where we can't tell if it's switch or rep
    allSwitchTrials(allSwitchTrials.SwitchFlag == -1, :) = []; % remove trials in non-switch shifts (how did this even get in here?)

    yVals = table2array(allSwitchTrials(:,'Correct'));    
    
    xVals = table2array(allSwitchTrials(:,'Subject')); 
    
    % now make all switches 1s and all reps 2s...
%    xVals(:,2) = ones(height(allSwitchTrials),1); % assume switch trials
%    tempRepTrialArray = table2array(allSwitchTrials(:,'nonSwitchTrial')); % this has 1 for rep trials and 0 for switch trials
%    xVals(:,2) = xVals(:,2) + tempRepTrialArray; % add 1 to all repetition trials, making them 2
    xVals(:,2) = allSwitchTrials.SwitchFlag; % switch = 1, rep = 2, shouldn't have anything else at this point
%    unique(xVals(:,2)) % just make sure

    xVals(:,3) = table2array(allSwitchTrials(:,'RespTime')); 

    if (strcmpi(timeCount, 'ShiftCount'))
        xVals(:,4) = table2array(allSwitchTrials(:,'SwitchShiftCount')); 
%        if (splitShiftCountBySubjs == true) % make a different value for each subj+shift combination
%            xVals(:,4) = (xVals(:,1) * 100) + xVals(:,4);
%        end
    else % default to counting trials
        xVals(:,4) = table2array(allSwitchTrials(:,'SwitchTrialCount')); 
    end
%{    
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
%}
    xVals(:,5) = table2array(allSwitchTrials(:,'numOfEFsInThisShift'));
    
    xVals(:,6) = table2array(allSwitchTrials(:,'StimShowTime')); 

    if (splitSubjBySwRep == true)
        xVals(:,1) = (xVals(:,1) * 10) + xVals(:,2);
    end
    
end

