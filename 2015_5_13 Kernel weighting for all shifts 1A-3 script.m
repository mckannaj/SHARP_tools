% Zephy McKanna
% 5/13/15
%
% This script will produce a kernel-weighted plot for each subject over all
% shifts. It will also produce a comparison matrix, comparing final
% performance in each shift (rows) to initial performance in the next shift (cols).
%   NOTE: performance matrix not yet complete.

% Prep (only need to set these once)
if (exist('zRFAll_1A3', 'var') == 0) % if we don't have this variable, we need to read in the tables
    [zRFData_1A3, zRFSum_1A3, zRFAll_1A3] = formTables_RF_1A3('Trial3.rf-data_final.xlsx', 'Trial3.rf-sum_final.xlsx', 'Trial3.robotfactory_final.xlsx', true);
end
%if (exist('zPPinhibit_1A3', 'var') == 0) % if we don't have this variable, assume we don't have any of them...
%    [zPPinhibit_1A3, zPPswitch_1A3, zPPupdate_1A3] = formTables_RF_1A3('Trial3.inhibit.xlsx', 'Trial3.switch.xlsx', 'Trial3.update.xlsx', true); % note that the feedback on the command line doesn't really make sense for pre/post data, but it still forms the tables correctly
%end
includedSubjs = excludeSubjects_RF_1A3('both', true, zRFAll_1A3); % could do this in each function, but pre-exclude here for speed 
windowLength = 10; % this can be set to whatever you want - it's the smoothing window size for the kernel function


% Generate a plot of each individual subject's all-trials kernel-weighted performance 
SubjList = unique(includedSubjs.Subject);
for subj = 1:length(SubjList)
    [logitY, probY, firstTrials, singleToDualTrials, dualToSingleTrials, ~] = getKernelValsPerShift_1A3(zRFAll_1A3, [], 'AllTrials', windowLength, SubjList(subj));
%    [logitY, probY, firstTrials, singleToDualTrials, dualToSingleTrials, ~] = getKernelValsPerShift_1A3(zRFAll_1A3, [], 'AllTrials', windowLength, 2316);
    plot(logitY,'Color','blue');
    hold on;
    for trial=1:length(firstTrials)
        if (singleToDualTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'Color','red'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        elseif (dualToSingleTrials(trial) == 1)
            hx = graph2d.constantline(trial, 'Color','green'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        elseif (firstTrials(trial) > 0)
            hx = graph2d.constantline(trial, 'LineStyle',':', 'Color','black'); % draw vertical line
            changedependvar(hx,'x'); % update graph
        end
    end
    str = sprintf('Logit of probability of success on all trials, weighted by kernel function; subj = %d, windowLength = %d', SubjList(subj), windowLength);
%    str = sprintf('Probability of success on Switch, weighted by kernel function; subj = %d, windowLength = %d', 2316, windowLength);
    title(str)
    xlabel('Trial number')
    ylabel('Logit of kernel-weighted probability of success')
% note that if we wanted a standard Y axis size, it would be -4 to +4, since our probability precision appears to go to 4 decimal places     
    hold off;
    pause(5);
end


% Generate a table of all subjects' performance from one cluster (row) to the next (col)
[logitY, ~, firstTrials, ~, ~, kernelClusters] = getKernelValsPerShift_1A3(zRFAll_1A3, [], 'AllTrials', windowLength, '');

[sumTransitionTable, countTransitionTable, avgTransitionTable] = getKernelTransitionMatrix_1A3(logitY, firstTrials, kernelClusters);

avgTransitionTable % display the average performance transition matrix

