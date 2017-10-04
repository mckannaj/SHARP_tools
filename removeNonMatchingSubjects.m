% Zephy McKanna
% removeNonMatchingSubjects
% 8_9_15
%
% This function takes two lists of names, compares them, and then removes
% (from a different input) the ones that don't match. It is intended to
% help with situations in which you have two sets of subjects (e.g., one
% from Pretest and one from RobotFactory).
% For example, if you want to plot them together, but the overlap is not 
% perfect, so you need to remove those that only did Pretest or only did RF.
%
% It expects the two Name variables to be single columns, full of unique
% names.
%
% It expects that name1 and dataset1 are the same length/height (same with
% n2 and d2). It takes the indices from the name in case you have a list of
% CoefficientNames (e.g., from a GLM) that aren't in the same dataset as
% the actual coefficients themselves. If the datasets are the same, you can
% just pass in the dataset twice.
% 
% If the 'willBeUsedForPlotting' flag is set to true, then it will ensure
% that the two returned tables/matrices are the same length at the end, so
% that data from them can be plotted together. If this flag is not set, it
% doesn't check the length of the returns, allowing the function to be used 
% for non-graphing purposes.
%
function [newData1, newData2] = removeNonMatchingSubjects(names1, dataset1, names2, dataset2, willBeUsedForPlotting, verbose)
    if (nargin ~= nargin('removeNonMatchingSubjects'))
        error('removeNonMatchingSubjects expects %d inputs, but received %d. Please update any calling code.\n', nargin('removeNonMatchingSubjects'), nargin);
    end
    if (verbose == true)
        fprintf('removeNonMatchingSubjects: ensuring equal lengths between names and datasets.\n');
    end
    
    zEnsureEqualLengths(names1, dataset1, 'names1', 'dataset1', verbose);
    zEnsureEqualLengths(names2, dataset2, 'names2', 'dataset2', verbose);

    newData1 = dataset1;
    newData2 = dataset2;
    if (verbose == true)
        fprintf('removeNonMatchingSubjects: we have %d in set1 and %d in set2; deleting the following:\n', length(names1), length(names2));

        in1andnot2 = setdiff(names1, names2) % display the names that are in 1 that are not in 2
    else
        in1andnot2 = setdiff(names1, names2);
    end
    newData1(ismember(names1, in1andnot2), :) = []; % remove from the *dataset* the *names* that are not the same
    if (verbose == true)
        in2andnot1 = setdiff(names2, names1) % display the names that are in 2 that are not in 1
    else
        in2andnot1 = setdiff(names2, names1);
    end
    newData2(ismember(names2, in2andnot1), :) = []; % remove from the *dataset* the *names* that are not the same
    
    if (willBeUsedForPlotting == true) % these data will be compared in a graph, so must be equal length
        zEnsureEqualLengths(newData1, newData2, 'newData1', 'newData2', verbose); % make sure they're equal before we return them
    end
end