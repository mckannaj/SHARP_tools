% Zephy McKanna
% getKernelclusterTransitionMatrix_1B
% 11/5/15
%
% This function takes the output table from getKernelRegressedPerf_Shifts_1B(), and returns a 16x16
% table, in which each row and column is a Cluster, and each cell is the
% average difference between the end_estimate for the row and the
% init_estimate for the column, across all participants.
% Note that it only considers transitions played by a single person on a
% given day (no transitions across days).
%
% If breakOutL4shifts = true, than it will treat each Level 4 shift as its
% own cluster, rather than lumping them together.
%
function [diffSumKerneltransitionTable, countKerneltransitionTable, avgKerneltransitionTable] = getKernelclusterTransitionMatrix_1B(RFkernelData, breakOutL4shifts, printTable, verbose)
    if ( ~ismember('init_KernelLogit',RFkernelData.Properties.VariableNames) )
        error('getKernelclusterTransitionMatrix_1B: This function requires added columns onto the sum file. Use getKernelRegressedPerf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end
    RFkernelData.Cluster = strrep(RFkernelData.Cluster, '/', '_'); % matlab can't handle / in its table names or variable names; replace with _
    RFkernelData.Cluster = strrep(RFkernelData.Cluster, '(xOR)', ''); % for some reason we still have U/Logic(xOR) for a couple of shifts... remove the (xOR)
    RFkernelData.Cluster = strrep(RFkernelData.Cluster, 'Relational', 'Logic'); % HACK to be able to use this on 1A-3 data - U/S/Relational was a separate Cluster then

    if (breakOutL4shifts == true)
        RFkernelData.Shift = strrep(RFkernelData.Shift, '(I)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '(U)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '(S)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '(U/I)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '(U/S)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '(S/I)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:1a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:1b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:1c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:2a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:2b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:2c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:3a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:3b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '4b T:3c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, ' ', ''); % matlab can't handle spaces in its table names or variable names; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '-', ''); % matlab can't handle '-' in its table names or variable names; remove
        RFkernelData.Shift = strrep(RFkernelData.Shift, '?', ''); % matlab can't handle '?' in its table names or variable names; remove
        
        clusterNamesInOrder = {'U', 'S', 'I', ...
            'U_Logic', 'S_Logic', 'I_Logic', ...
            'U_S', 'U_I', 'S_I', ...
            'U_S_Logic', 'U_I_Logic', 'S_I_Logic'};
        L4shiftsInOrder = [unique(RFkernelData(strcmpi(RFkernelData.Cluster,'L4aV1'),:).Shift); ...
            unique(RFkernelData(strcmpi(RFkernelData.Cluster,'L4aV2'),:).Shift); ...
            unique(RFkernelData(strcmpi(RFkernelData.Cluster,'L4bV1'),:).Shift); ...
            unique(RFkernelData(strcmpi(RFkernelData.Cluster,'L4bV2'),:).Shift)];
        clusterNamesInOrder = [clusterNamesInOrder, transpose(L4shiftsInOrder)];
        
        RFkernelData(ismember(RFkernelData.Cluster,{'L4aV1' 'L4aV2' 'L4bV1' 'L4bV2'}),:).Cluster = ...
            RFkernelData(ismember(RFkernelData.Cluster,{'L4aV1' 'L4aV2' 'L4bV1' 'L4bV2'}),:).Shift; % make the cluster name the shift name
    else        
        clusterNamesInOrder = {'U', 'S', 'I', ...
            'U_Logic', 'S_Logic', 'I_Logic', ...
            'U_S', 'U_I', 'S_I', ...
            'U_S_Logic', 'U_I_Logic', 'S_I_Logic', ...
            'L4aV1', 'L4bV1', 'L4aV2', 'L4bV2'};
    end
    diffSumKerneltransitionTable = array2table(zeros(length(clusterNamesInOrder),length(clusterNamesInOrder)),...
        'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);
    countKerneltransitionTable = array2table(zeros(length(clusterNamesInOrder),length(clusterNamesInOrder)),...
        'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);
    avgKerneltransitionTable = array2table(zeros(length(clusterNamesInOrder),length(clusterNamesInOrder)),...
        'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);

    for shift = 2:height(RFkernelData) % start with the 2nd one, because the 1st can't be a transition
        if (RFkernelData.ShiftNum(shift) > 1) % again, for each subject, the first shift isn't a transition
%            if (ensureSameDate == true)
                if (RFkernelData.Date(shift-1) ~= RFkernelData.Date(shift)) % we want only transitions on the same day
                    continue % skip to the next shift (which should be the same day)
                end
%            end
            kernelDiff = RFkernelData.init_KernelLogit(shift) - RFkernelData.end_KernelLogit_AllPositive(shift-1);

            diffSumKerneltransitionTable{RFkernelData.Cluster(shift-1),RFkernelData.Cluster(shift)} = diffSumKerneltransitionTable{RFkernelData.Cluster(shift-1),RFkernelData.Cluster(shift)} + kernelDiff;
            countKerneltransitionTable{RFkernelData.Cluster(shift-1),RFkernelData.Cluster(shift)} = countKerneltransitionTable{RFkernelData.Cluster(shift-1),RFkernelData.Cluster(shift)} + 1;
        else % shiftNum = 1, must be a new subject
            if (verbose == true)
                fprintf('getKernelclusterTransitionMatrix_1B working on subject %d\n', RFkernelData.Subject(shift));
            end
        end
    end
    
    % now go through the transitionTables and get the avg
    for row = 1:(height(avgKerneltransitionTable))
        for col = 1:(width(avgKerneltransitionTable)) % should be a square, but just in case we change that sometime...
            if (countKerneltransitionTable{row, col} > 0)
                avgKerneltransitionTable{row, col} = diffSumKerneltransitionTable{row, col} / countKerneltransitionTable{row, col};
            else
                avgKerneltransitionTable{row, col} = NaN;
            end
        end
    end

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getKernelclusterTransitionMatrix_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(avgKerneltransitionTable, fileName);
    end
end

