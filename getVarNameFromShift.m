% Zephy McKanna
% getVarNameFromShift()
% 4/19/16
%
% This function is intended to take a "Shift" name (from RobotFactory
% output logs) and return a string that can be used as a variable (i.e.,
% doesn't contain any illegal characters for matlab table variable names).
% It should produce unique varNames per shift name, and the shift names
% should be recoverable via getShiftFromVarName(). 
%
% If given a char, it will return a char. 
% If given a cell, it will return a cell.
% 
% It also allows you to add the N value to the end, if the shift is an
% Update shift. If "addNval" is a whole number >0, it will add "_#" to the
% end of the variableName, where # is the number given in addNval.
%
function [variableName] = getVarNameFromShift(shiftName, addNval, verbose)
    modName = shiftName;
    modName = strrep(modName, ' ', '');
    modName = strrep(modName, '?', '');
    modName = strrep(modName, '_', '');
    modName = strrep(modName, '-', '');
    modName = strrep(modName, '(U)', '');
    modName = strrep(modName, '(I)', '');
    modName = strrep(modName, '(S)', '');
    modName = strrep(modName, '(S/I)', '');
    modName = strrep(modName, '(U/I)', '');
    modName = strrep(modName, '(U/S)', '');
    modName = strrep(modName, '4bT:1a', '');
    modName = strrep(modName, '4bT:1b', '');
    modName = strrep(modName, '4bT:1c', '');
    modName = strrep(modName, '4bT:2a', '');
    modName = strrep(modName, '4bT:2b', '');
    modName = strrep(modName, '4bT:2c', '');
    modName = strrep(modName, '4bT:3a', '');
    modName = strrep(modName, '4bT:3b', '');
    modName = strrep(modName, '4bT:3c', '');

    
    % now, if we want to add the N value, do that at the end
    if (isnumeric(addNval)) % it's a number
        if (addNval > 0) % and it's >1, so we should add it if this is an update shift
            if (iscell(shiftName)) % the comparing needs to be done in a non-cell, so make sure shiftName isn't a cell
                cmpName = shiftName{1}; % make it not a cell anymore
            else
                cmpName = shiftName;
            end
            % now, compare parts of shiftName to see if it's an update shift    
            if ( (strcmpi(cmpName(end-4:end), '(U/S)') == 1) || ... % add to Update-shift list
                    (strcmpi(cmpName(end-4:end), '(U/I)') == 1) || ...
                    (strcmpi(cmpName(end-2:end), '(U)') == 1) || ...
                    (strcmpi(cmpName, 'Algorithmic Comprehension (S/I)') == 1) || ... % this is a Lv4a
                    (strcmpi(cmpName, 'Computational Vocalizations (S/I)') == 1) || ... % this is a Lv4a
                    (strcmpi(cmpName, '4b T:1c - AAAAAAAA') == 1) || ... % this is a Lv4b with update in it
                    (strcmpi(cmpName, '4b T:2a - Meat-Bag Edition') == 1) || ... % this is a Lv4b with update in it
                    (strcmpi(cmpName, '4b T:3a - Specializations') == 1) ) % this is a Lv4b with update in it
                        modName = strcat(modName, '_N', num2str(addNval));
            else
                if (verbose == true)
                    warning('Trying to put a N value %d on a non-update shift (next line)\n', addNval);
                    shiftName % Z - there has to be a way to put strings into a warning, right? Figure it out.
                end
            end
        end
    end

    variableName = modName;
end
