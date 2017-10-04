% Zephy McKanna
% ensureEqualLengths()
% 8_7_15
%
% This function takes two tables or arrays, along with their names, and
% throws an error if they're of different lengths.
% 
function [] = zEnsureEqualLengths(data1, data2, name1, name2, verbose)
    if ((istable(data1)==1) && (istable(data2)==1)) % both tables
        if (height(data1) ~= height(data2))
            error('%s height = %d and %s height = %d; should be equal!\n', name1, height(data1), name2, height(data2));
        end
    elseif ((istable(data1)==1) && (istable(data2)==0)) % data2 isn't a table; assume it's an array
        if (height(data1) ~= length(data2(:,1)))
            error('%s height = %d and %s height = %d; should be equal!\n', name1, height(data1), name2, length(data2));
        end
    elseif ((istable(data1)==0) && (istable(data2)==1)) % data1 isn't a table; assume it's an array
        if (length(data1(:,1)) ~= height(data2))
            error('%s height = %d and %s height = %d; should be equal!\n', name1, length(data1), name2, height(data2));
        end
    else % neither are tables; assume they're arrays
        if (length(data1(:,1)) ~= length(data2(:,1)))
            error('%s length = %d and %s length = %d; should be equal!\n', name1, length(data1), name2, length(data2));
        end
    end
    
    if (verbose == true)
        fprintf('ensureEqualLengths: %s and %s have equal length.\n', name1, name2);    
    end
end