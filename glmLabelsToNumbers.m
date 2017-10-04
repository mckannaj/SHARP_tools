% Zephy McKanna
% glmLabelsToNumbers()
% 8/26/15
%
% This function takes a column full of (presumably subject) labels, as
% produced by fitglm() - that is 'Subj_34' - and returns a column with just
% the numbers after the '_'.
%
function [subjNumbers] = glmLabelsToNumbers(subjLabels)
    subjNumbers = zeros(length(subjLabels),1); % prealloc for speed
    
    for row = 1:length(subjLabels)
        subjNumbers(row) = str2double(subjLabels{row}(strfind(subjLabels{row},'_')+1:end));
    end
    
end


