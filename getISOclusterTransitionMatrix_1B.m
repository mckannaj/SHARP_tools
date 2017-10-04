% Zephy McKanna
% getISOclusterTransitionMatrix_1B
% 11/5/15
%
% This function takes the output table from getIsoRperf_Shifts_1B(), and returns a 16x16
% table, in which each row and column is a Cluster, and each cell is the
% average difference between the end_estimate for the row and the
% init_estimate for the column, across all participants.
% Note that it only considers transitions played by a single person on a
% given day (no transitions across days).
%
function [diffSumISOtransitionTable, countISOtransitionTable, avgISOtransitionTable] = getISOclusterTransitionMatrix_1B(RFisoData, printTable, verbose)
    if ( ~ismember('logit_init_ISOest',RFisoData.Properties.VariableNames) )
        error('getISOclusterTransitionMatrix_1B: This function requires added columns onto the sum file. Use getIsoRperf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end
    RFisoData.Cluster = strrep(RFisoData.Cluster, '/', '_'); % matlab can't handle / in its table names or variable names; replace with _
    RFisoData.Cluster = strrep(RFisoData.Cluster, '(xOR)', ''); % for some reason we still have U/Logic(xOR) for a couple of shifts... remove the (xOR)
    RFisoData.Cluster = strrep(RFisoData.Cluster, 'Relational', 'Logic'); % HACK to be able to use this on 1A-3 data - U/S/Relational was a separate Cluster then

    clusterNamesInOrder = {'U', 'S', 'I', ...
        'U_Logic', 'S_Logic', 'I_Logic', ...
        'U_S', 'U_I', 'S_I', ...
        'U_S_Logic', 'U_I_Logic', 'S_I_Logic', ...
        'L4aV1', 'L4bV1', 'L4aV2', 'L4bV2'};
    diffSumISOtransitionTable = array2table(zeros(16,16), 'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);
    countISOtransitionTable = array2table(zeros(16,16), 'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);
    avgISOtransitionTable = array2table(zeros(16,16), 'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);

    for shift = 2:height(RFisoData) % start with the 2nd one, because the 1st can't be a transition
        if (RFisoData.ShiftNum(shift) > 1) % again, for each subject, the first shift isn't a transition
%            if (ensureSameDate == true)
                if (RFisoData.Date(shift-1) ~= RFisoData.Date(shift)) % we want only transitions on the same day
                    continue % skip to the next shift (which should be the same day)
                end
%            end
            isoDiff = RFisoData.logit_init_ISOest(shift) - RFisoData.logit_end_ISOest(shift-1);
            diffSumISOtransitionTable{RFisoData.Cluster(shift-1),RFisoData.Cluster(shift)} = diffSumISOtransitionTable{RFisoData.Cluster(shift-1),RFisoData.Cluster(shift)} + isoDiff;
            countISOtransitionTable{RFisoData.Cluster(shift-1),RFisoData.Cluster(shift)} = countISOtransitionTable{RFisoData.Cluster(shift-1),RFisoData.Cluster(shift)} + 1;
        else % shiftNum = 1, must be a new subject
            if (verbose == true)
                fprintf('getISOclusterTransitionMatrix_1B working on subject %d\n', RFisoData.Subject(shift));
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
            fileName = getFileNameForThisOS('getISOclusterTransitionMatrix_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(avgISOtransitionTable, fileName);
    end
end

