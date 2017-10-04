% Zephy McKanna
% getDataForPreUpdateGLM_1A3()
% 3/9/15
% 
% This function takes as input a table created by formTables_RF_1A3() from
% the pre/post Update test data.
%
% It uses getCleanUpdateTrials_RF_1A3 to clean the update trials and (for
% now) remove all the "no response" trials. This also selects for
% exclusively pretest trials.
%
% It returns two matrices:
% 1. a single-column matrix intended to be the Y values (correct/incorrect)
% 2. a multiple-column matrix in which each column is an X value. This
% matrix includes cols for subj, "difficulty" (N value), and 
% responseTime. 
%
% If the excludeSubjs flag is true, it excludes the agreed-upon subjects
% from 1A3. NOTE that this also excludes all subjects that are not in the
% RobotFactory training group, as we assume we'll want to be able to
% compare this GLM to a RF-based GLM.
%
% If the splitSubjByNval flag is true, it splits the categorical "subjects"
% column into different categories by multiplying it by 10 and then adding
% the N value. So it makes three categories for the ability of each subject.
% If splitSubjByNval is false, it keeps subjects in a single category,
% meaning that each subject gets a single ability, across all switch/repetition categories. 
%
% This function expects to be called preceding a GLM call like the following: 
% PreUpdModel = fitglm(x_PreUpd,y_PreUpd,'linear','distr','binomial','CategoricalVars',[1,2],'VarNames',{'Subj','memBack','RT','Correct'})
%
function [x_PreUpd, y_PreUpd] = getDataForPreUpdateGLM_1A3(preUpdateDataTable1A3, excludeSubjs, splitSubjByNval)
    
    if (excludeSubjs == true)
        preUpdateDataTable1A3 = excludeSubjects_RF_1A3('both', true, preUpdateDataTable1A3);
    end
        
    [allUpdateTrials] = getCleanUpdateTrials_PP_1A3('both', 'pre', preUpdateDataTable1A3);

    y_PreUpd = table2array(allUpdateTrials(:,'Correct'));
    
    x_PreUpd = table2array(allUpdateTrials(:,'Subject')); 
    
    % equivalent of N vals...?
    x_PreUpd(:,2) = table2array(allUpdateTrials(:,'MemBack')); 
 
    x_PreUpd(:,3) = table2array(allUpdateTrials(:,'RespTime'));

    %    xVals(:,1) = categorical(xVals(:,1)); % note: if we make this categorical from the start, it initializes the entire table as categorical for some reason

    if (splitSubjByNval == true)
        x_PreUpd(:,1) = (x_PreUpd(:,1) * 10) + x_PreUpd(:,2);
    end
    
end

