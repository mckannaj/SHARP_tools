% Zephy McKanna
% getISOallTransitionMatrix_1B
% 11/5/15
%
% This function takes the SUM file (previously combined with the
% output table from getIsoRperf_Shifts_1B), and returns a 
% (shiftNameAndCluster*Nval*Timeout) x (shiftNameAndCluster*Nval*Timeout)
% table, in which each row and column is a single implementation of a shift
% (including its associated Cluster, N value, and Timeout), and each cell is the
% average difference between the end_estimate for the row and the
% init_estimate for the column, across all participants.
% Note that it only considers transitions played by a single person on a
% given day (no transitions across days).
%
function [diffSumISOtransitionTable, countISOtransitionTable, avgISOtransitionTable] = getISOallTransitionMatrix_1B(sumData, printTable, verbose)
    if ( ~ismember('init_ISOest',sumData.Properties.VariableNames) )
        error('getISOallTransitionMatrix_1B: This function requires added columns onto the sum file. Use getIsoRperf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end
    sumData.Cluster = strrep(sumData.Cluster, '/', '_'); % matlab can't handle / in its table names or variable names; replace with _
    sumData.Cluster = strrep(sumData.Cluster, '(xOR)', ''); % for some reason we still have U/Logic(xOR) for a couple of shifts... remove the (xOR)
    sumData.Cluster = strrep(sumData.Cluster, 'Relational', 'Logic'); % HACK to be able to use this on 1A-3 data - U/S/Relational was a separate Cluster then
    sumData.Shift = strrep(sumData.Shift, '(I)', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '(U)', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '(S)', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '(U/I)', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '(U/S)', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '(S/I)', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:1a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:1b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:1c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:2a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:2b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:2c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:3a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:3b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, '4b T:3c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
    sumData.Shift = strrep(sumData.Shift, ' ', ''); % matlab can't handle spaces in its table names or variable names; remove
    sumData.Shift = strrep(sumData.Shift, '-', ''); % matlab can't handle '-' in its table names or variable names; remove
    sumData.Shift = strrep(sumData.Shift, '?', ''); % matlab can't handle '?' in its table names or variable names; remove

    variableNamesInOrder(1) = {''}; % this will become a list of variable names
    variableNamesCount = 0;
    
    % each shift has a single name and a single cluster; combine those
    uniqueShiftNames = unique(sumData.Shift);
    for shift = 1:length(uniqueShiftNames)
        allRowsOfThisShift = sumData(strcmpi(sumData.Shift, uniqueShiftNames(shift)), :);
        row = allRowsOfThisShift(1,:); % any given row, to grab the cluster name
        % zNOTE: DOING IT THIS WAY WILL ONLY GIVE US ROWS AND COLS FOR EVERY COMBO WE'VE SEEN, NOT EVERY POSSBLE COMBO 
        totalNvalsThisShift = unique(allRowsOfThisShift.ActualN);
        for nIterator = 1:length(totalNvalsThisShift)
            Nval = totalNvalsThisShift(nIterator);
            totalTimeoutValsThisShift = unique(allRowsOfThisShift.StimTime);
            for tIterator = 1:length(totalTimeoutValsThisShift)
                timeout = totalTimeoutValsThisShift(tIterator);
                nameOfThisRow(1) = row.Shift;
                nameOfThisRow(2) = row.Cluster;
                nameOfThisRow(3) = {strcat('N', num2str(Nval))};
                nameOfThisRow(4) = {strcat('t', num2str(timeout))};
                variableNamesCount = variableNamesCount + 1; % assigned it as 0, so will start with 1
                variableNamesInOrder(variableNamesCount) = {makeCompositeString(nameOfThisRow)};
            end
        end
    end
    
    diffSumISOtransitionTable = array2table(zeros(variableNamesCount,variableNamesCount), ...
        'VariableNames', variableNamesInOrder, 'RowNames', variableNamesInOrder);
    countISOtransitionTable = array2table(zeros(variableNamesCount,variableNamesCount), ...
        'VariableNames', variableNamesInOrder, 'RowNames', variableNamesInOrder);
    avgISOtransitionTable = array2table(zeros(variableNamesCount,variableNamesCount), ...
        'VariableNames', variableNamesInOrder, 'RowNames', variableNamesInOrder);
    
    numNegative = 0;
    numPositive = 0;

    for shift = 2:height(sumData) % start with the 2nd one, because the 1st can't be a transition
        if (sumData.ShiftNum(shift) > 1) % again, for each subject, the first shift isn't a transition
%            if (ensureSameDate == true)
                if (sumData.Date(shift-1) ~= sumData.Date(shift)) % we want only transitions on the same day
                    continue % skip to the next shift (which should be the same day)
                end
%            end
            isoDiff = sumData.init_ISOest(shift) - sumData.end_ISOest(shift-1);
% only for debugging            fprintf('Subj: %d. ThisShiftNum: %d. PrevShiftNum: %d. ThisInitEst: %f. PrevEndEst: %f. isoDiff: %f.\n', ...
% only for debugging                sumData.Subject(shift), sumData.ShiftNum(shift), sumData.ShiftNum(shift-1), ...
% only for debugging                sumData.init_ISOest(shift), sumData.end_ISOest(shift-1), isoDiff);
            if (isoDiff > 0)
                numPositive = numPositive + 1;
            else
                numNegative = numNegative + 1;
            end
            % create the name of the "from" shift (i.e., shift-1) (row)
            compositeStringArray(1) = sumData.Shift(shift-1);
            compositeStringArray(2) = sumData.Cluster(shift-1);
            compositeStringArray(3) = {strcat('N', num2str(sumData.ActualN(shift-1)))};
            compositeStringArray(4) = {strcat('t', num2str(sumData.StimTime(shift-1)))};
            nameOfPrevShift = makeCompositeString(compositeStringArray);

            % create the name of the "to" shift (i.e., shift) (col)
            compositeStringArray(1) = sumData.Shift(shift);
            compositeStringArray(2) = sumData.Cluster(shift);
            compositeStringArray(3) = {strcat('N', num2str(sumData.ActualN(shift)))};
            compositeStringArray(4) = {strcat('t', num2str(sumData.StimTime(shift)))};
            nameOfCurrentShift = makeCompositeString(compositeStringArray);
            
            diffSumISOtransitionTable{nameOfPrevShift,nameOfCurrentShift} = diffSumISOtransitionTable{nameOfPrevShift,nameOfCurrentShift} + isoDiff;
            countISOtransitionTable{nameOfPrevShift,nameOfCurrentShift} = countISOtransitionTable{nameOfPrevShift,nameOfCurrentShift} + 1;
        else % shiftNum = 1, must be a new subject
            if (verbose == true)
                fprintf('getISOallTransitionMatrix_1B working on subject %d\n', sumData.Subject(shift));
                fprintf('NumNegative: %d. NumPositive:%d.\n', numNegative, numPositive);
                numNegative = 0;
                numPositive = 0;
            end
        end
    end
    
    % now go through the transitionTables and get the avg
    for row = 1:(height(avgISOtransitionTable))
        for col = 1:(width(avgISOtransitionTable)) % should be a square, but just in case we change that sometime...
            if (countISOtransitionTable{row, col} > 0)
                avgISOtransitionTable{row, col} = diffSumISOtransitionTable{row, col} / countISOtransitionTable{row, col};
                if (diffSumISOtransitionTable{row, col} == 0)
                    if (verbose == true)
                        fprintf('%s to %s has a zero diffSum and a count of %d, somehow.\n', ...
                            countISOtransitionTable.Properties.VariableNames{row}, ...
                            countISOtransitionTable.Properties.VariableNames{col}, countISOtransitionTable{row, col});
                    end
                end
            else
                avgISOtransitionTable{row, col} = NaN;
            end
        end
    end

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getISOallTransitionMatrix_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(avgISOtransitionTable, fileName);
    end
end

