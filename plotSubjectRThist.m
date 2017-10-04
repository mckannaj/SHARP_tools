% Zephy McKanna
% plotSubjectRThist(subjData)
% 10/31/14
% 
% This function takes a subject number (or 'all') as well as correct and
% incorrect matrices output from getRespTimes_RF_1A3().
%       Note that this output contains subject numbers in column 1,
%       clusters in column 2, and reaction times in column 3.
% It can also take a cluster string (e.g. 'U', 'S', or 'I') if you want to
% limit it to a single cluster's data; otherwise, this value should be set
% to 'all'.
% It can take a value for N (substituting for difficulty in Update
% tasks). Note that specifying N > 1 will only give shifts with an Update
% component. To ignore this, just like the others, set it to 'all'.
% Finally, it can ignore timeouts (times when the subject did not respond), 
% for the correct, incorrect, both, or neither.
% Then it uses plotHistFitCompare() to plot comparison histograms for the correct
% versus incorrect responses' reaction times. Titles for the plot include the
% subject numbers, 
%
% 
function [success] = plotSubjectRThist(subjNum, cluster, nValue, ignoreNoResponseHist, ignoreNoResponseDist, corrData, incorrData)
    if (strcmpi(subjNum, 'all') == 0) % we're not doing all subjects
        corrData = corrData(cell2mat(corrData(:,1))==subjNum,:); % grab only the subject of interest's rows
        incorrData = incorrData(cell2mat(incorrData(:,1))==subjNum,:); % grab only the subject of interest's rows
        plotTitle = mat2str(subjNum(1,1)); % turn the subject number into a string and store it as the title
        fprintf('plotSubjectRThist: using only subject number %d.\n', subjNum(1,1));
    else % we're only doing a single subject
        plotTitle = 'allSubjs'; % indicate that we're doing all subjects in the plot title
        fprintf('plotSubjectRThist: using all subjects.\n');
    end
    
    if (strcmpi(cluster, 'all') == 0) % we're not doing all clusters for this subject
% Doesn't work - might find a substring       corrData = corrData(cellfun(@isempty, strfind(corrData(:,2), cluster)),:);
% Doesn't work - might find a substring       incorrData = incorrData(cellfun(@isempty, strfind(incorrData(:,2), cluster)),:); 
        corrData = corrData(strcmpi(corrData(:,2),cluster), :); % grab only the cluster of interest's rows
        incorrData = incorrData(strcmpi(incorrData(:,2),cluster), :); % grab only the cluster of interest's rows
        plotTitle = strcat(plotTitle, '-', cluster); % specify which cluster we're using in the plot title
        fprintf('plotSubjectRThist: using only cluster: %s.\n', cluster);
    else % we are doing all clusters
        plotTitle = strcat(plotTitle, '-', 'allClusters');
        fprintf('plotSubjectRThist: using all clusters.\n');
    end
    if (strcmpi(nValue, 'all') == 0) % we're not doing all N-values
        corrData = corrData(cell2mat(corrData(:,4))==nValue,:); % grab only rows with the proper N value
        incorrData = incorrData(cell2mat(incorrData(:,4))==nValue,:); % grab only rows with the proper N value
        
        nValString = mat2str(nValue(1,1)); % turn the nValue number into a string and store it as the title
        plotTitle = strcat(plotTitle, '-Nval=', nValString); % specify which cluster we're using in the plot title
        fprintf('plotSubjectRThist: using trials where N = %d.\n', nValue);
    else % we are doing all N-values
        plotTitle = strcat(plotTitle, '-', 'allNvals');
        fprintf('plotSubjectRThist: using all N values.\n');
    end
    
    % if we're splitting up the fit data and the histogram data, do the fit first
    fitCorr = corrData;
    fitIncorr = incorrData;
    if (strcmpi(ignoreNoResponseDist, 'both') == 1) % we're ignoring all cases where the subject didn't respond
        fitCorr(strcmp(fitCorr(:,5),'NO_ACTION'), :) = []; % delete incorrect rows with no action
        fitIncorr(strcmp(fitIncorr(:,5),'NO_ACTION'), :) = []; % delete incorrect rows with no action
        fprintf('plotSubjectRThist: excluding from distribution fit all trials where the subject did not respond.\n');
    elseif (strcmpi(ignoreNoResponseDist, 'correct') == 1) % we're ignoring only cases where the subject was correct not to respond
        fitCorr(strcmp(fitCorr(:,5),'NO_ACTION'), :) = []; % delete incorrect rows with no action
        fprintf('plotSubjectRThist: excluding from distribution fit   cases where was correct to not respond.\n');
    elseif (strcmpi(ignoreNoResponseDist, 'incorrect') == 1) % we're ignoring only cases where the subject should have responded but didn't
        fitIncorr(strcmp(fitIncorr(:,5),'NO_ACTION'), :) = []; % delete incorrect rows with no action
        fprintf('plotSubjectRThist: excluding from distribution fit   cases where the subject should have responded but did not.\n');
    else
        fprintf('plotSubjectRThist: including in distribution fit  all NoResponse trials.\n');
    end

    % now do the same for the histogram data
    if (strcmpi(ignoreNoResponseHist, 'both') == 1) % we're ignoring all cases where the subject didn't respond
        corrData(strcmp(corrData(:,5),'NO_ACTION'), :) = []; % delete incorrect rows with no action
        plotTitle = strcat(plotTitle, '-', 'correctTimeoutsExcluded');
        incorrData(strcmp(incorrData(:,5),'NO_ACTION'), :) = []; % delete incorrect rows with no action
        plotTitle = strcat(plotTitle, '-', 'incorrectTimeoutsExcluded');
        fprintf('plotSubjectRThist: excluding from histograms all trials where the subject did not respond.\n');
    elseif (strcmpi(ignoreNoResponseHist, 'correct') == 1) % we're ignoring only cases where the subject was correct not to respond
        corrData(strcmp(corrData(:,5),'NO_ACTION'), :) = []; % delete incorrect rows with no action
        plotTitle = strcat(plotTitle, '-', 'correctTimeoutsExcluded');
        fprintf('plotSubjectRThist: excluding from histograms  cases where was correct to not respond.\n');
    elseif (strcmpi(ignoreNoResponseHist, 'incorrect') == 1) % we're ignoring only cases where the subject should have responded but didn't
        incorrData(strcmp(incorrData(:,5),'NO_ACTION'), :) = []; % delete incorrect rows with no action
        plotTitle = strcat(plotTitle, '-', 'incorrectTimeoutsExcluded');
        fprintf('plotSubjectRThist: excluding from histograms  cases where the subject should have responded but did not.\n');
    else
        plotTitle = strcat(plotTitle, '-', 'noResponseIncluded');
        fprintf('plotSubjectRThist: including in histograms all NoResponse trials.\n');
    end
    
    
    RTcorr = corrData(:,3); % all reaction times for correct trials for the given subject
    RTincorr = incorrData(:,3); % all reaction times for incorrect trials for the given subject
    RTfitCorr = fitCorr(:,3); % same, for the distribution fit
    RTfitIncorr = fitIncorr(:,3); % same, for the distribution fit

    plotHistFitCompare(RTcorr, RTincorr, RTfitCorr, RTfitIncorr, plotTitle, 'correct', 'incorrect');
    
    fprintf('plotSubjectRThist: Hist1 is correct; Hist2 is incorrect.\n'); % to determine which has the listed number of trials
    fprintf('plotHistFitCompare: Trials in correctHist: %d. Trials in incorrectHist: %d.\n', length(RTcorr), length(RTincorr));
    fprintf('plotHistFitCompare: Trials fit for correctDist: %d. Trials fit for incorrectDist: %d.\n', length(RTfitCorr), length(RTfitIncorr));

    success = true; % if we got here, the function completed successfully
end
