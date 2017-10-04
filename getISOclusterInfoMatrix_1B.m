% Zephy McKanna
% getISOclusterInfoMatrix_1B
% 11/5/15
%
% This function takes the output table from getIsoRperf_Shifts_1B(), and returns a 16x5
% table, in which each row is a Cluster, and the columns are :
% 1. the average initial iso_estimate for all shifts in that cluster, across all subjects 
% 2. the standard error for #1, calculated as [ std(estimates going in) / sqrt(number of estimates) ]
% 3. the average end iso_estimate for all shifts in that cluster, across all subjects 
% 4. the standard error for #3, calculated as [ std(estimates going in) / sqrt(number of estimates) ]
% 5. the average end-initial iso_estimate for all shifts in that cluster, across all subjects 
%
function [isoInfoTable] = getISOclusterInfoMatrix_1B(RFisoData, printTable)
    if ( ~ismember('init_ISOest',RFisoData.Properties.VariableNames) )
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
    isoInfoTable = array2table(zeros(16,6), 'VariableNames', {'Count','init_est','stdErr_init','end_est','stdErr_end','diff_end_init'}, 'RowNames', clusterNamesInOrder);
%    countClustersSeen = array2table(zeros(16,1), 'VariableNames', {'Count'}, 'RowNames', clusterNamesInOrder);

    for clusterNameEnumerator = 1:length(clusterNamesInOrder)
        clust = clusterNamesInOrder(clusterNameEnumerator);
        clusterShifts = RFisoData(strcmpi(RFisoData.Cluster, clust), :);
%        countClustersSeen{clust,'Count'} = height(clusterShifts); % NO NEED TO PUT THIS IN A DIFFERENT TABLE 
        isoInfoTable{clust,'Count'} = height(clusterShifts);
        isoInfoTable{clust,'init_est'} = mean(clusterShifts.logit_init_ISOest);
        isoInfoTable{clust,'stdErr_init'} = (std(clusterShifts.logit_init_ISOest) / sqrt(length(clusterShifts.logit_init_ISOest)));
       
        isoInfoTable{clust,'end_est'} = mean(clusterShifts.logit_end_ISOest);
        isoInfoTable{clust,'stdErr_end'} = (std(clusterShifts.logit_end_ISOest) / sqrt(length(clusterShifts.logit_end_ISOest)));
        
        diff = clusterShifts.logit_end_ISOest - clusterShifts.logit_init_ISOest;
        isoInfoTable{clust,'diff_end_init'} = mean(diff);
    end
    

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getISOclusterInfoMatrix_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(isoInfoTable, fileName);
    end
end

