% Zephy McKanna
% getVarNameFromCluster()
% 7/5/17
%
% Based on getVarNameFromShift(), This function is intended to take a 
% "Cluster" name (from RobotFactory output logs) 
% and return a string that can be used as a variable (i.e.,
% doesn't contain any illegal characters for matlab table variable names).
% It should produce unique varNames per cluster name, and the shift names
% should be recoverable via getClusterFromVarName(). 
%
% If given a char, it will return a char. 
% If given a cell, it will return a cell.
% 
% It also allows you to add the N value to the end, if the shift is an
% Update shift. If "addNval" is a whole number >0, it will add "_#" to the
% end of the variableName, where # is the number given in addNval.
%
function [variableName] = getVarNameFromCluster(clusterName, addNval, verbose)
    modName = clusterName;
    modName = strrep(modName, ' ', '');
    modName = strrep(modName, 'U/Logic(xOR)', 'U/Logic'); % note that this won't be recovered by getClusterFromVarName()... maybe fix?
    modName = strrep(modName, '/', '_');
    
    % now, if we want to add the N value, do that at the end
    if (isnumeric(addNval)) % it's a number
        if (addNval > 0) % and it's >=1, so we should add it if this is an update shift
            if (iscell(clusterName)) % the comparing needs to be done in a non-cell, so make sure shiftName isn't a cell
                cmpName = clusterName{1}; % make it not a cell anymore
            else
                cmpName = clusterName;
            end
            % now, compare parts of shiftName to see if it's an update shift    
            if ( (strcmpi(cmpName(1), 'U') == 1) || ...
                    (strcmpi(cmpName(1), 'L') == 1) ) % this is a Lv4 shift; assume update matters (it does for all except some L4b shifts)
                        modName = strcat(modName, '_N', num2str(addNval));
            else
                if (verbose == true)
                    warning('Trying to put a N value %d on a non-update cluster (next line)\n', addNval);
                    clusterName % Z - there has to be a way to put strings into a warning, right? Figure it out.
                end
            end
        end
    end

    variableName = modName;
end
