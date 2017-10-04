% Zephy McKanna
% getClusterNameFromVar()
% 7/5/17
%
% Based on getShiftNameFromVar(), 
% this function is intended to take a variable name produced by
% getVarNameFromCluster() and return the original shift name. If there 
% is an N value on the end of the shift, it will also return that value.
% NOTE: it assumes the Nval is only a single char! (1-9)
%   ZEPH: fix this when you have time.
%
% If given a char, it will return a char. 
% If given a cell, it will return a cell.
% 
%
function [clusterName, nVal] = getClusterNameFromVar(variableName, verbose)
    varIsCell = 0; % first, check to see if we were given a cell
    if (iscell(variableName)) % the comparing needs to be done in a non-cell, so make sure shiftName isn't a cell
        modName = variableName{1}; % make it not a cell anymore
        varIsCell = 1; % note that it was one, so we can put it back before returning
    else
        modName = variableName;
    end

    % now remove the nValue, if any
    nVal = 0; % assume there is none
    if (strcmpi(modName(end-2:end-1),'_N') == 1) % there is '_N' on it
        nVal = str2double(modName(end));
        modName = modName(1:end-3); % remove the _N#
    end

    switch modName
        case 'I'
            clusterName = 'I';
        case 'I_Logic'
            clusterName = 'I/Logic';
        case 'L4aV1'
            clusterName = 'L4aV1';
        case 'L4aV2'
            clusterName = 'L4aV2';
        case 'L4bV1'
            clusterName = 'L4bV1';
        case 'L4bV2'
            clusterName = 'L4bV2';
        case 'S'
            clusterName = 'S';
        case 'S_I'
            clusterName = 'S/I';
        case 'S_I_Logic'
            clusterName = 'S/I/Logic';
        case 'U'
            clusterName = 'U';
        case 'U_I'
            clusterName = 'U/I';
        case 'U/Logic'
            clusterName = 'U/Logic'; % note this could also have been a U/Logic(xOR), but since we wish those didn't exist... ignore that?
        case 'U_S'
            clusterName = 'U/S';
        case 'U_S_Logic'
            clusterName = 'U/S/Logic';
        otherwise
            variableName % Z - there has to be a way to put strings into an error message, right? Figure it out.
            error('Unknown variable name (just above this line)');
    end
    
    if (varIsCell == 1) % we were given a cell; make it one again
        clusterName = {clusterName};
    end
end