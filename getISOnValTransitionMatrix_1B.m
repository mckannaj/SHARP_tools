% Zephy McKanna
% getISOnValTransitionMatrix_1B
% 11/5/15
%
% This function takes the output table from getIsoRperf_Shifts_1B()
%
% Note that it only considers transitions played by a single person on a
% given day (no transitions across days).
%
function [diffSumISOtransitionTable, countISOtransitionTable, avgISOtransitionTable] = getISOnValTransitionMatrix_1B(sumData, printTable, verbose)
    if ( ~ismember('init_ISOest',sumData.Properties.VariableNames) )
        error('getISOallTransitionMatrix_1B: This function requires added columns onto the sum file. Use getIsoRperf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end

    variableNamesInOrder = {'N1','N2','N3','N4','N5','N6','N7','N8','N9','N10'};
    diffSumISOtransitionTable = array2table(zeros(10,10), 'VariableNames', variableNamesInOrder, 'RowNames', variableNamesInOrder);
    countISOtransitionTable = array2table(zeros(10,10), 'VariableNames', variableNamesInOrder, 'RowNames', variableNamesInOrder);
    avgISOtransitionTable = array2table(zeros(10,10), 'VariableNames', variableNamesInOrder, 'RowNames', variableNamesInOrder);

    for shift = 2:height(sumData) % start with the 2nd one, because the 1st can't be a transition
        if (sumData.ShiftNum(shift) > 1) % again, for each subject, the first shift isn't a transition
%            if (ensureSameDate == true)
                if (sumData.Date(shift-1) ~= sumData.Date(shift)) % we want only transitions on the same day
                    continue % skip to the next shift (which should be the same day)
                end
%            end
            isoDiff = sumData.init_ISOest(shift) - sumData.end_ISOest(shift-1);
            % create the name of the "from" shift (i.e., shift-1) (row)
            nameOfPrevShift = {strcat('N', num2str(sumData.ActualN(shift-1)))};

            % create the name of the "to" shift (i.e., shift) (col)
            nameOfCurrentShift = {strcat('N', num2str(sumData.ActualN(shift)))};
            
            diffSumISOtransitionTable{nameOfPrevShift,nameOfCurrentShift} = diffSumISOtransitionTable{nameOfPrevShift,nameOfCurrentShift} + isoDiff;
            countISOtransitionTable{nameOfPrevShift,nameOfCurrentShift} = countISOtransitionTable{nameOfPrevShift,nameOfCurrentShift} + 1;
        else % shiftNum = 1, must be a new subject
            if (verbose == true)
                fprintf('getISOnValTransitionMatrix_1B working on subject %d\n', sumData.Subject(shift));
            end
        end
    end
    
    % now go through the transitionTables and get the avg
    for row = 1:(height(avgISOtransitionTable))
        for col = 1:(width(avgISOtransitionTable)) % should be a square, but just in case we change that sometime...
            if (countISOtransitionTable{row, col} > 0)
                avgISOtransitionTable{row, col} = diffSumISOtransitionTable{row, col} / countISOtransitionTable{row, col};
            else
                avgISOtransitionTable{row, col} = NaN;
            end
        end
    end

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getISOnValTransitionMatrix_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(avgISOtransitionTable, fileName);
    end
end

