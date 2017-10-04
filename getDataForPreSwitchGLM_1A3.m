% Zephy McKanna
% getDataForPreSwitchGLM_1A3()
% 3/9/15
% 
% This function takes as input a table created by formTables_RF_1A3() from
% the pre/post Switch test data.
%
% It uses getCleanSwitchTrials_RF_1A3 to clean the switch trials and
% separate them into switch and repetition trials.
% - remove first trial of each shift
% - remove all trials immediately after errors
% - only return pretest trials
% - (for now) remove all the "no response" trials
%
% It returns two matrices:
% 1. a single-column matrix intended to be the Y values (correct/incorrect)
% 2. a multiple-column matrix in which each column is an X value. This
% matrix includes cols for subj, "difficulty" (1 = switch and 2 = repetition), and 
% responseTime. 
%
% If the excludeSubjs flag is true, it excludes the agreed-upon subjects
% from 1A3. NOTE that this also excludes all subjects that are not in the
% RobotFactory training group, as we assume we'll want to be able to
% compare this GLM to a RF-based GLM.
%
% If the splitSubjBySwRep flag is true, it splits the categorical "subjects"
% column into different categories by multiplying it by 10 and then adding
% the difficulty. In this case, the "difficulty" is just switch (1) or
% repetition (2), so it makes two categories for the ability of each
% subject.
% If splitSubjBySwRep is false, it keeps subjects in a single category,
% meaning that each subject gets a single ability, across all switch/repetition categories. 
%
% This function expects to be called preceding a GLM call like the following: 
% PreSwModel = fitglm(x_PreSw,y_PreSw,'linear','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','Correct'})
%
function [x_PreSw, y_PreSw] = getDataForPreSwitchGLM_1A3(preSwitchDataTable1A3, excludeSubjs, splitSubjBySwRep)
    
    if (excludeSubjs == true)
        preSwitchDataTable1A3 = excludeSubjects_RF_1A3('both', true, 'switch', preSwitchDataTable1A3);
    end
        
    % get just clean pretest performance data, with the RespTimes fixed
    [swTrials, repTrials] = getCleanSwitchTrials_PP_1A3(true, true, 'both', 'pre', true, preSwitchDataTable1A3);

    y_PreSw = [table2array(swTrials(:,'Correct')); table2array(repTrials(:,'Correct'))];
    
    x_PreSw = [table2array(swTrials(:,'Subject')); table2array(repTrials(:,'Subject'))];
    
    % now make all switches 1s and all reps 2s...
    x_PreSw(:,2) = [ones(height(swTrials),1); (ones(height(repTrials),1) + 1)];
 
    x_PreSw(:,3) = [table2array(swTrials(:,'RespTime')); table2array(repTrials(:,'RespTime'))];

    x_PreSw(:,3) = x_PreSw(:,3); 
    
    if (splitSubjBySwRep == true)
        x_PreSw(:,1) = (x_PreSw(:,1) * 10) + x_PreSw(:,2);
    end
    
end

