% Zephy McKanna
% getKernelclusterInfoMatrix_1B
% 11/5/15
%
% This function takes the output table from getKernelRegressedPerf_Shifts_1B(), and returns a 16x5
% table, in which each row is a Cluster, and the columns are :
% 1. the average initial kernel regression estimate for all shifts in that cluster, across all subjects 
% 2. the standard error for #1, calculated as [ std(estimates going in) / sqrt(number of estimates) ]
% 3. the average end kernel regression estimate for all shifts in that cluster, across all subjects 
% 4. the standard error for #3, calculated as [ std(estimates going in) / sqrt(number of estimates) ]
% 5. the average end-initial kernel regression estimate for all shifts in that cluster, across all subjects 
%
% If breakOutL4shifts = true, than it will treat each Level 4 shift as its
% own cluster, rather than lumping them together.
%
function [kernelInfoTable] = getKernelclusterInfoMatrix_1B(RFkernelRegressionData, breakOutL4shifts, printTable)
    if ( ~ismember('init_KernelLogit',RFkernelRegressionData.Properties.VariableNames) )
        error('getKernelclusterInfoMatrix_1B: This function requires added columns onto the sum file. Use getKernelRegressedPerf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end
    RFkernelRegressionData.Cluster = strrep(RFkernelRegressionData.Cluster, '/', '_'); % matlab can't handle / in its table names or variable names; replace with _
    RFkernelRegressionData.Cluster = strrep(RFkernelRegressionData.Cluster, '(xOR)', ''); % for some reason we still have U/Logic(xOR) for a couple of shifts... remove the (xOR)
    RFkernelRegressionData.Cluster = strrep(RFkernelRegressionData.Cluster, 'Relational', 'Logic'); % HACK to be able to use this on 1A-3 data - U/S/Relational was a separate Cluster then
    if (breakOutL4shifts == true)
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '(I)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '(U)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '(S)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '(U/I)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '(U/S)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '(S/I)', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:1a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:1b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:1c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:2a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:2b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:2c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:3a - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:3b - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '4b T:3c - ', ''); % shift names don't also need to contain a short form of the cluster; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, ' ', ''); % matlab can't handle spaces in its table names or variable names; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '-', ''); % matlab can't handle '-' in its table names or variable names; remove
        RFkernelRegressionData.Shift = strrep(RFkernelRegressionData.Shift, '?', ''); % matlab can't handle '?' in its table names or variable names; remove

        clusterNamesInOrder = {'U', 'S', 'I', ...
            'U_Logic', 'S_Logic', 'I_Logic', ...
            'U_S', 'U_I', 'S_I', ...
            'U_S_Logic', 'U_I_Logic', 'S_I_Logic'};
        L4shiftsInOrder = [unique(RFkernelRegressionData(strcmpi(RFkernelRegressionData.Cluster,'L4aV1'),:).Shift); ...
            unique(RFkernelRegressionData(strcmpi(RFkernelRegressionData.Cluster,'L4aV2'),:).Shift); ...
            unique(RFkernelRegressionData(strcmpi(RFkernelRegressionData.Cluster,'L4bV1'),:).Shift); ...
            unique(RFkernelRegressionData(strcmpi(RFkernelRegressionData.Cluster,'L4bV2'),:).Shift)];
        clusterNamesInOrder = [clusterNamesInOrder, transpose(L4shiftsInOrder)];
            
        kernelInfoTable = array2table(zeros(length(clusterNamesInOrder),6), 'VariableNames', {'Count','init_est','stdErr_init','end_est','stdErr_end','diff_end_init'}, 'RowNames', clusterNamesInOrder);
    else        
        clusterNamesInOrder = {'U', 'S', 'I', ...
            'U_Logic', 'S_Logic', 'I_Logic', ...
            'U_S', 'U_I', 'S_I', ...
            'U_S_Logic', 'U_I_Logic', 'S_I_Logic', ...
            'L4aV1', 'L4bV1', 'L4aV2', 'L4bV2'};
        kernelInfoTable = array2table(zeros(length(clusterNamesInOrder),6), 'VariableNames', {'Count','init_est','stdErr_init','end_est','stdErr_end','diff_end_init'}, 'RowNames', clusterNamesInOrder);
    end

    for clusterNameEnumerator = 1:length(clusterNamesInOrder)
        clust = clusterNamesInOrder(clusterNameEnumerator);
        if ( (breakOutL4shifts == true) && (any(ismember(L4shiftsInOrder,clust)) == 1) ) % break these out by shift, rather than cluster
            clusterShifts = RFkernelRegressionData(strcmpi(RFkernelRegressionData.Shift, clust), :);
        else
            clusterShifts = RFkernelRegressionData(strcmpi(RFkernelRegressionData.Cluster, clust), :);
        end
        
        kernelInfoTable{clust,'Count'} = height(clusterShifts);
        kernelInfoTable{clust,'init_est'} = mean(clusterShifts.init_KernelLogit);
        kernelInfoTable{clust,'stdErr_init'} = (std(clusterShifts.init_KernelLogit) / sqrt(length(clusterShifts.init_KernelLogit)));

        kernelInfoTable{clust,'end_est'} = mean(clusterShifts.end_KernelLogit_AllPositive);
        kernelInfoTable{clust,'stdErr_end'} = (std(clusterShifts.end_KernelLogit_AllPositive) / sqrt(length(clusterShifts.end_KernelLogit_AllPositive)));

        diff = clusterShifts.end_KernelLogit_AllPositive - clusterShifts.init_KernelLogit;
        kernelInfoTable{clust,'diff_end_init'} = mean(diff);
    end
        


    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getKernelclusterInfoMatrix_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(kernelInfoTable, fileName);
    end
end

