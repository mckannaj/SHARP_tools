% Zephy McKanna
% getKernelShiftInfoMatrix_1B
% 11/5/15
%
% This function takes the output table from getKernelRegressedPerf_Shifts_1B(), and returns a 197x5
% table, in which each row is a shift(+Nval), and the columns are:
% 1. the average initial kernel regression estimate for all shifts of that name, across all subjects 
% 2. the standard error for #1, calculated as [ std(estimates going in) / sqrt(number of estimates) ]
% 3. the average end kernel regression estimate for all shifts of that name, across all subjects 
% 4. the standard error for #3, calculated as [ std(estimates going in) / sqrt(number of estimates) ]
% 5. the average difference (end-initial) kernel regression estimate for all shifts of that name, across all subjects 
%
% If the "ignoreJumpBack" flag is set, then it will remove all jump-back
% shifts from RFkernelRegressionData before performing any calculations.
%
% Note: for L4a shifts, it uses "N4" as a catch-all for any N values
% greater than 3.
%
function [kernelInfoTable] = getKernelShiftInfoMatrix_1B(RFkernelRegressionData, ignoreJumpBack, printTable)
    if ( ~ismember('init_KernelLogit',RFkernelRegressionData.Properties.VariableNames) )
        error('getKernelShiftInfoMatrix_1B: This function requires added columns onto the sum file. Use getKernelRegressedPerf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end
    if ( ~ismember('ActualN',RFkernelRegressionData.Properties.VariableNames) )
        error('getKernelShiftInfoMatrix_1B: This function requires the N value added onto the kernel file. Use getKernelRegressedPerf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end
    if (ignoreJumpBack == true)
        if ( ~ismember('JumpBack',RFkernelRegressionData.Properties.VariableNames) )
            error('getKernelShiftInfoMatrix_1B: This function requires the JumpBack column added onto the kernel file. Use getKernelRegressedPerf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
        else % before doing anything else, remove all the jump-back shifts
            RFkernelRegressionData(RFkernelRegressionData.JumpBack == 1, :) = [];
        end
    end

    % first, get all the shift names (plus Nvals), in table-variable-friendly format 
    shiftNameList = unique(RFkernelRegressionData.Shift); % shift name list
    L4aShiftNameList = {}; % blank cell structure
    updateShiftNameList = {}; % blank cell structure
    varNamePlusNlist = {}; % blank cell structure
    for iterator = 1:length(shiftNameList) % first, grab all the update shifts
        shiftName = shiftNameList{iterator}; % particular shift name (non-cell)
        if ( (strcmpi(shiftName, '4a Update Switch V1 (U/S)') == 1) || ... % first break out the Lv4a shifts, might have N > 3
                (strcmpi(shiftName, '4a Update Switch V1 - 2 (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Biological Itemizing (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Reptile Plotting (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Algorithmic Comprehension (S/I)') == 1) || ...
                (strcmpi(shiftName, 'Typographic Trigonometry (U/I)') == 1) || ...
                (strcmpi(shiftName, 'Theoretical Aerodynamics (U/I)') == 1) || ...
                (strcmpi(shiftName, 'Mammalian Maneuvering (U/I)') == 1) || ...
                (strcmpi(shiftName, '4a Update Switch V2 (U/S)') == 1) || ...
                (strcmpi(shiftName, '4a Update Switch V2 - 2 (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Dimensional Jargonization (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Proportional Sympathizing (U/S)') == 1) || ...
                (strcmpi(shiftName, 'Computational Vocalizations (S/I)') == 1) || ...
                (strcmpi(shiftName, 'Tetromino Groking (U/I)') == 1) || ...
                (strcmpi(shiftName, 'Word/Number Partitioning (U/S)') == 1) )
            L4aShiftNameList(length(L4aShiftNameList)+1, 1) = shiftNameList(iterator); % add to Update-shift list
        elseif ( (strcmpi(shiftName(end-4:end), '(U/S)') == 1) || ... % if this shift involves Update (in any form)
                (strcmpi(shiftName(end-4:end), '(U/I)') == 1) || ...
                (strcmpi(shiftName(end-2:end), '(U)') == 1) || ...
                (strcmpi(shiftName, 'Algorithmic Comprehension (S/I)') == 1) || ... % this is a Lv4a
                (strcmpi(shiftName, 'Computational Vocalizations (S/I)') == 1) || ... % this is a Lv4a
                (strcmpi(shiftName, '4b T:1c - AAAAAAAA') == 1) || ... % this is a Lv4b involving Update
                (strcmpi(shiftName, '4b T:2a - Meat-Bag Edition') == 1) || ... % this is a Lv4b involving Update
                (strcmpi(shiftName, '4b T:3a - Specializations') == 1) ) % this is a Lv4b involving Update
            updateShiftNameList(length(updateShiftNameList)+1, 1) = shiftNameList(iterator); % add to Update-shift list
        else % not an update shift; might as well add it to the total shift list
            varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift(shiftNameList(iterator), 0, false); % make this into a variable name
        end
    end
    for iterator = 1:length(L4aShiftNameList)
        L4ShiftName = L4aShiftNameList{iterator}; % particular update shift name (non-cell)
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({L4ShiftName}, 1, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({L4ShiftName}, 2, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({L4ShiftName}, 3, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({L4ShiftName}, 4, false); % Note: catch-all for N>3
    end
    for iterator = 1:length(updateShiftNameList)
        updateShiftName = updateShiftNameList{iterator}; % particular update shift name (non-cell)
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 1, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 2, false); % make this into a variable name
        varNamePlusNlist(length(varNamePlusNlist)+1, 1) = getVarNameFromShift({updateShiftName}, 3, false); % make this into a variable name
    end

    shiftNamesInOrder = transpose(varNamePlusNlist); % just because the "table" creation expects it in cols(?)
    kernelInfoTable = array2table(zeros(length(shiftNamesInOrder),6), 'VariableNames', {'Count','init_est','stdErr_init','end_est','stdErr_end','diff_end_init'}, 'RowNames', shiftNamesInOrder);
    
    for shiftNameEnumerator = 1:length(shiftNamesInOrder)
        varNamePlusNval = shiftNamesInOrder(shiftNameEnumerator);
        [shiftName, nVal] = getShiftNameFromVar(varNamePlusNval, false); % get the actual shift name back
        relevantShifts = RFkernelRegressionData(strcmpi(RFkernelRegressionData.Shift, shiftName), :);
        if (nVal > 0) % this must be a shift involving update
            if (nVal > 3) % could only be a L4a shift
                relevantShifts = relevantShifts(relevantShifts.ActualN > 3, :); % using N4 as a catch-all for any N values > 3
            else
                relevantShifts = relevantShifts(relevantShifts.ActualN == nVal, :);
            end
        end
        
        kernelInfoTable{varNamePlusNval,'Count'} = height(relevantShifts);
        kernelInfoTable{varNamePlusNval,'init_est'} = mean(relevantShifts.init_KernelLogit);
        kernelInfoTable{varNamePlusNval,'stdErr_init'} = (std(relevantShifts.init_KernelLogit) / sqrt(length(relevantShifts.init_KernelLogit)));

        kernelInfoTable{varNamePlusNval,'end_est'} = mean(relevantShifts.end_KernelLogit_AllPositive);
        kernelInfoTable{varNamePlusNval,'stdErr_end'} = (std(relevantShifts.end_KernelLogit_AllPositive) / sqrt(length(relevantShifts.end_KernelLogit_AllPositive)));

        diff = relevantShifts.end_KernelLogit_AllPositive - relevantShifts.init_KernelLogit;
        kernelInfoTable{varNamePlusNval,'diff_end_init'} = mean(diff);
    end
        


    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getKernelShiftInfoMatrix_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(kernelInfoTable, fileName);
    end
end

