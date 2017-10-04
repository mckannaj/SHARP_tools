% Zephy McKanna
% getKernelTransitionMatrix_1A3()
% 5_13/15
% 
% This function takes values produced by getKernelValsPerShift_1A3() and
% produces a matrix of the average transition cost from one shift to
% another.
% 
function [sumTransitionTable, countTransitionTable, avgTransitionTable] = getKernelTransitionMatrix_1A3(logitY, firstTrials, kernelClusters)
    kernelClusters(1:end,1) = strrep(kernelClusters(1:end,1), '/', '_'); % matlab can't handle / in its table names or variable names; replace with _
    kernelClusters(1:end,1) = strrep(kernelClusters(1:end,1), '(xOR)', ''); % for some reason we still have U/Logic(xOR) for a couple of shifts... remove the (xOR)

    clusterNamesInOrder = {'U', 'S', 'I', 'U_Logic', 'S_Logic', 'I_Logic', 'U_S', 'U_I', 'S_I', 'U_S_Logic', 'U_I_Logic', 'S_I_Logic', 'U_S_Relational', 'L4aV1', 'L4bV1', 'L4aV2', 'L4bV2'};

    sumTransitionTable = array2table(zeros(17,17), 'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);
    countTransitionTable = array2table(zeros(17,17), 'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);
    avgTransitionTable = array2table(zeros(17,17), 'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);

    for trial=2:length(firstTrials) % start with 2 because the very first trial can't be a transition
        if (firstTrials(trial) == 1) % note that if we let this be > 0, it will include transitions between subjects
            diff = logitY(trial) - logitY(trial-1); % take the difference between the later shift and the former shift
            sumTransitionTable{kernelClusters(trial-1),kernelClusters(trial)} = sumTransitionTable{kernelClusters(trial-1),kernelClusters(trial)} + diff; % add the difference to the sum table
            countTransitionTable{kernelClusters(trial-1),kernelClusters(trial)} = countTransitionTable{kernelClusters(trial-1),kernelClusters(trial)} + 1; % count it, so we can divide for the average later
% just for testing            if (strcmpi(kernelClusters(trial), kernelClusters(trial-1)) == 1) % transitioning between a cluster and the same cluster???
% just for testing                fprintf('Going from %s to itself.\n', kernelClusters{trial});
% just for testing            end
        end
    end

    for fromShift = 1:17
        for toShift = 1:17
            if (countTransitionTable{fromShift, toShift} > 0)
                avgTransitionTable{fromShift, toShift} = sumTransitionTable{fromShift, toShift} / countTransitionTable{fromShift, toShift};
            elseif (sumTransitionTable{fromShift, toShift} > 0)
                error('Somehow {%s, %s} has a sum value of %d but a count value of %d...?\n', clusterNamesInOrder{fromShift}, clusterNamesInOrder{toShift}, sumTransitionTable{fromShift, toShift}, countTransitionTable{fromShift, toShift});
            else
                fprintf('Transition from %s to %s never observed.\n', clusterNamesInOrder{fromShift}, clusterNamesInOrder{toShift});
            end
        end
    end


end