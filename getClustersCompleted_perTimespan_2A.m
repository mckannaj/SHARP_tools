% Zephy McKanna
% getclustersCompleted_perTimespan_2A
% 10/26/16
%
% This function takes a timespan which it imposes on the data before
% calculation, and then calls the getClustersCompleted_1B() function. 
% It expects that the days involved in the timespan be located
% in a variable called SessionNum.
%
% It also separates out the subjects by RFversion.
%
% Note that startDay and EndDay are INCLUSIVE. If you want data from just a
% single day, make startDay = endDay.
% 
function [clustersCompletedInTimespan_1B, clustersCompletedInTimespan_2A] = getClustersCompleted_perTimespan_2A(sumTable2A, onlyUniqueCompletions, startDay, endDay, printTable, verbose)
    shiftsInTheTimespan_1B = [];
    shiftsInTheTimespan_2A = [];
    uniqueSubjNums = unique(sumTable2A.Subject);
    for rowNum = 1:length(uniqueSubjNums)
        subj = uniqueSubjNums(rowNum); % subj
        subjTrials = sumTable2A(sumTable2A.Subject == subj, :); % subjTrials from SUM file
        subjFirstRow = subjTrials(1,:);
        maxSessionNum = max(subjTrials.SessionNum); % last training day (NOTE IF WE ACTUALLY ACCOUNT FOR SKIPPED DAYS (eg no T5), THIS DOESN'T WORK!!!
        insertTheseTrials = []; % reset this variable
        if (maxSessionNum < startDay) % this participant has no shifts in this day range 
            insertTheseTrials = subjFirstRow; % add the very first row; presumably this cannot be a completed cluster, so completedClusters will mark it 0
            if (verbose == true)
                fprintf('Inserting 1 shift for Subject %d, who has a max sessionNum of %d.\n', subj, maxSessionNum);
            end
        else
            insertTheseTrials = subjTrials((subjTrials.SessionNum >= startDay) & (subjTrials.SessionNum <= endDay), :); % 
            if (onlyUniqueCompletions == true) % if we want only unique completions, we have to remove ones that have already been completed
                if (startDay > 1) % only matters if there are days previous to the ones we're looking at
                    testTheseTrials = subjTrials((subjTrials.SessionNum >= 1) & (subjTrials.SessionNum <= endDay), :); % all the trials from the start of training

                end
            end
            
            if (height(insertTheseTrials) < 1) % this participant has no shifts in this day range, even though they should....
                insertTheseTrials = subjFirstRow; % add the very first row; presumably this cannot be a completed cluster, so completedClusters will mark it 0
                if (verbose == true)
                    fprintf('Inserting 1 shift for Subject %d, who has a max sessionNum of %d but no shifts between day %d and %d, somehow!?\n', subj, maxSessionNum, startDay, endDay);
                end
            else
                if (verbose == true)
                    fprintf('Inserted %d shifts from %d days for Subject %d.\n', height(insertTheseTrials), length(unique(insertTheseTrials.SessionNum)), subj);
                end
            end
        end
        if (subjFirstRow.RFversion == 1)
            shiftsInTheTimespan_1B = [shiftsInTheTimespan_1B; insertTheseTrials]; % add the shifts to those already present in the list
        elseif (subjFirstRow.RFversion == 2)
            shiftsInTheTimespan_2A = [shiftsInTheTimespan_2A; insertTheseTrials]; % add the shifts to those already present in the list
        else
            warning('Version for subj %d not recognized: %d', subj, subjFirstRow.RFversion)
        end
    end
    
    [~, clustersCompletedInTimespan_1B] = getClustersCompleted_2A(shiftsInTheTimespan_1B, onlyUniqueCompletions, false);
    [~, clustersCompletedInTimespan_2A] = getClustersCompleted_2A(shiftsInTheTimespan_2A, onlyUniqueCompletions, false);
      
    printBoth = [clustersCompletedInTimespan_1B; clustersCompletedInTimespan_2A];
    fileName = '';
    if ((strcmpi('', printTable) == 0) && (printTable ~= false)) % there's something in printTable, and it's not "false"
        if (printTable == true) % do a default filename
            fileNameStr = sprintf('clustersCompleted_days%dto%d-output.csv', startDay, endDay);
            fileName = getFileNameForThisOS(fileNameStr, 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(printBoth, fileName);
    end

end


