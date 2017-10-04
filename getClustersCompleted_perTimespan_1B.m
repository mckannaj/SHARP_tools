% Zephy McKanna
% getclustersCompleted_perTimespan_1B[
% 12/2/15
%
% This function takes a timespan which it imposes on the data before
% calculation, and then calls the getClustersCompleted_1B() function. 
% It expects that the days involved in the timespan be located
% in a variable called SessionNum.
% Note that startDay and EndDay are INCLUSIVE. If you want data from just a
% single day, make startDay = endDay.
% 
function [clustersCompletedInTimespan] = getClustersCompleted_perTimespan_1B(sumTable1B, onlyUniqueCompletions, startDay, endDay, printTable, verbose)
    shiftsInTheTimespan = [];
    uniqueSubjNums = unique(sumTable1B.Subject);
    for rowNum = 1:length(uniqueSubjNums)
        subj = uniqueSubjNums(rowNum); % subj
        subjTrials = sumTable1B(sumTable1B.Subject == subj, :); % subjTrials from SUM file
        maxSessionNum = max(subjTrials.SessionNum); % last training day (NOTE IF WE ACTUALLY ACCOUNT FOR SKIPPED DAYS (eg no T5), THIS DOESN'T WORK!!!
        if (maxSessionNum < startDay) % this participant has no shifts in this day range 
            insertTheseTrials = subjTrials(1,:); % add the very first row; presumably this cannot be a completed cluster, so completedClusters will mark it 0
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
                insertTheseTrials = subjTrials(1,:); % add the very first row; presumably this cannot be a completed cluster, so completedClusters will mark it 0
                if (verbose == true)
                    fprintf('Inserting 1 shift for Subject %d, who has a max sessionNum of %d but no shifts between day %d and %d, somehow!?\n', subj, maxSessionNum, startDay, endDay);
                end
            else
                if (verbose == true)
                    fprintf('Inserted %d shifts from %d days for Subject %d.\n', height(insertTheseTrials), length(unique(insertTheseTrials.SessionNum)), subj);
                end
            end
        end
        shiftsInTheTimespan = [shiftsInTheTimespan; insertTheseTrials]; % add the shifts to those already present in the list
    end
    
    [~, clustersCompletedInTimespan] = getClustersCompleted_1B(shiftsInTheTimespan, onlyUniqueCompletions, false);
      
    fileName = '';
    if ((strcmpi('', printTable) == 0) && (printTable ~= false)) % there's something in printTable, and it's not "false"
        if (printTable == true) % do a default filename
            fileNameStr = sprintf('clustersCompleted_days%dto%d-output.csv', startDay, endDay);
            fileName = getFileNameForThisOS(fileNameStr, 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(clustersCompletedInTimespan, fileName);
    end

end


