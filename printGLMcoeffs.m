% Zephy McKanna
% printGLMcoeffs()
% 3/10/15
%
% This function takes a GLM produced by fitglm() and prints an output file
% that includes five columns:
% - coefficient names
% - coef estimates
% - std err
% - tStats
% - pVals
%
% If filename = true, it will use a default file name. Otherwise, it will
% assume that filename is the name you'd like to use.
% Files are placed into 
% /users/shared/SHARP/IntResults (for Mac), or
% c:\SHARP\IntResults (for Windows).
%
function [success] = printGLMcoeffs(glm, filename)

    if (filename == true) % do a default filename
        fN = getFileNameForThisOS('printGLMcoeffs-output.csv', 'IntResults');
    else % assume it's the filename
        fN = getFileNameForThisOS(filename, 'IntResults');
    end

    tempTable = array2table(transpose(glm.CoefficientNames), 'VariableNames', {'Name'});
    tempTable.Subject = glmLabelsToNumbers(tempTable.Name);
    tempTable.Coefficient = glm.Coefficients.Estimate;
    tempTable.SE = glm.Coefficients.SE;
    tempTable.tStat = glm.Coefficients.tStat;
    tempTable.pValue = glm.Coefficients.pValue;

    writetable(tempTable, fN);

    success = true;

end
