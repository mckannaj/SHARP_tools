% Zephy McKanna
% getKernelShiftTransitionPOpercentages_1B
% 5/5/16
%
% This function is identical to getKernelShiftTransitionMatrix_1B(), except
% that it is intended to find out what percent of each transition actually
% follows the partial ordering (PO). 
% As such, it takes a PO as input, and expects this PO to be a square with
% shifts(+Nvals) on both rows and cols. It should have a 1 anywhere that
% the col is >= the row in terms of difficulty, and a 0 everywhere else.
%
% The output is a square matrix with shifts(+Nvals) on both rows and cols,
% in which:
% Each cell is the percentage of the time that the observed
% transition from row to col was in the direction indicated by the PO.
% NaN means we never saw this transition.
%
% It will also return a Count table, so that transitions with low numbers
% of observations can be ignored (identical to the Count table returned by
% getKernelShiftTransitionMatrix_1B).
%
function [pctInOrderWithPOTable, countKerneltransitionTable] = getKernelShiftTransitionPOpercentages_1B(RFkernelData, PartialOrder, printTable, verbose)
    if ( ~ismember('init_KernelLogit',RFkernelData.Properties.VariableNames) )
        error('getKernelShiftTransitionPOpercentages_1B: This function requires added columns onto the sum file. Use getKernelRegressedPerf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end
    if ( ~ismember('ActualN',RFkernelData.Properties.VariableNames) )
        error('getKernelShiftTransitionPOpercentages_1B: This function requires the N value added onto the kernel file. Use getKernelRegressedPerf_Shifts_1B() and the utility in "2015_11_19 useful utilities scripts.m" first.\n');
    end

    % first, get all the shift names (plus Nvals), in table-variable-friendly format 
    shiftNameList = unique(RFkernelData.Shift); % shift name list
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
    
    countKerneltransitionTable = array2table(zeros(length(shiftNamesInOrder),length(shiftNamesInOrder)),...
        'VariableNames', shiftNamesInOrder, 'RowNames', shiftNamesInOrder);
    pctInOrderWithPOTable = array2table(zeros(length(shiftNamesInOrder),length(shiftNamesInOrder)) - 1,... % all -1s
        'VariableNames', shiftNamesInOrder, 'RowNames', shiftNamesInOrder);
    numInOrderWithPOTable = array2table(zeros(length(shiftNamesInOrder),length(shiftNamesInOrder)),...
        'VariableNames', shiftNamesInOrder, 'RowNames', shiftNamesInOrder);

    for shift = 2:height(RFkernelData) % start with the 2nd one, because the 1st can't be a transition
        if (RFkernelData.ShiftNum(shift) > 1) % again, for each subject, the first shift isn't a transition
%right now assume we always want to ignore day-to-day transitions            if (ensureSameDate == true)
                if (RFkernelData.Date(shift-1) ~= RFkernelData.Date(shift)) % we want only transitions on the same day
                    continue % skip to the next shift (which should be the same day)
                end
%            end
            kernelDiff = RFkernelData.init_KernelLogit(shift) - RFkernelData.end_KernelLogit_AllPositive(shift-1); % calculate the diff to be stored

            prevShiftNval = RFkernelData.ActualN(shift-1);
            if (prevShiftNval > 3)
                prevShiftNval = 4; % lump all of these together
            end
            prevShiftVarName = getVarNameFromShift(RFkernelData.Shift(shift-1), prevShiftNval, false);
            thisShiftNval = RFkernelData.ActualN(shift);
            if (thisShiftNval > 3)
                thisShiftNval = 4; % lump all of these together
            end
            thisShiftVarName = getVarNameFromShift(RFkernelData.Shift(shift), thisShiftNval, false);
            
            countKerneltransitionTable{prevShiftVarName,thisShiftVarName} = countKerneltransitionTable{prevShiftVarName,thisShiftVarName} + 1;
            
            if (PartialOrder{prevShiftVarName,thisShiftVarName} == 1) % col is harder than row, in the PO
                if (kernelDiff >= 0) % the transition observed here shows that the second shift is more difficult (or they're equal)
                    numInOrderWithPOTable{prevShiftVarName,thisShiftVarName} = numInOrderWithPOTable{prevShiftVarName,thisShiftVarName} + 1;
                end
            elseif (PartialOrder{prevShiftVarName,thisShiftVarName} == 0)
                if (kernelDiff < 0) % the transition observed here shows that the first shift is more difficult
                    numInOrderWithPOTable{prevShiftVarName,thisShiftVarName} = numInOrderWithPOTable{prevShiftVarName,thisShiftVarName} + 1;
                end
            else
                error('Somehow we have a non-0 non-1 number in the PO: %d\n', PartialOrder{prevShiftVarName,thisShiftVarName});
            end
            
        else % shiftNum = 1, must be a new subject
            if (verbose == true)
                fprintf('getKernelShiftTransitionMatrix_1B working on subject %d\n', RFkernelData.Subject(shift));
            end
        end
    end
    
    % now go through the transitionTables and get the avg 
    for row = 1:(height(pctInOrderWithPOTable))
        for col = 1:(width(pctInOrderWithPOTable)) % should be a square, but just in case we change that sometime...
            if (countKerneltransitionTable{row, col} > 0)
                pctInOrderWithPOTable{row, col} = numInOrderWithPOTable{row, col} / countKerneltransitionTable{row, col};
            else
                pctInOrderWithPOTable{row, col} = NaN;
            end
        end
    end

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getKernelShiftTransitionPOpercentages_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(pctInOrderWithPOTable, fileName);
    end
end

