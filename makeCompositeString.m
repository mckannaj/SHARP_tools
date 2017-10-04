% Zephy McKanna
% makeCompositeString
% 11/19/15
%
% This function is intended to take an arbitrary number of strings (in a cell array) and
% concatenate them with '___' (three underscores) in between, for naming purposes. It will also
% remove any '___' from the strings prior to concatenating them (replacing them with a single underscore), so
% that '___' can always be used to get back the original strings.
% Note that the returned string is a character array, not a cell array.
%
function [compositeString] = makeCompositeString(arrayOfStrings)
    compositeString = '';
    for s = 1:length(arrayOfStrings)
        if (s > 1) % not the first string we've put in
            compositeString = strcat(compositeString, '___'); % add a delimiter between them
        end
        
        % first, replace unacceptable characters
        arrayOfStrings{s} = strrep(arrayOfStrings{s}, '-', '_'); % matlab can't handle / in its table names or variable names; replace with _
        arrayOfStrings{s} = strrep(arrayOfStrings{s}, '/', '_'); % matlab can't handle / in its table names or variable names; replace with _
        arrayOfStrings{s} = strrep(arrayOfStrings{s}, '___', '_'); % reserve triple-underscore for between-strings concatenation
 
        compositeString = strcat(compositeString, arrayOfStrings{s});
    end
end