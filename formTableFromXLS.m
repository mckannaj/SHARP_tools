% Zephy McKanna
% formTableFromXLS
% 2/2/16
% 
% This function takes the filename of an .xls or .xlsx file, and reads it
% into a Table.
%
% If the onlyNumbers flag is set to true, it will set any non-numerical
% data to NaN. This will prevent any '' inputs from forcing the entire
% column to be cells.
%
% If the delNonSubjLines flag is set to true, it will delete all the lines
% in which the "Subject" column is set to NaN. (This is just for convenience; 
% typically, these lines have no data, and are all NaN).
%
% It also checks to see whether we're in a Windows or Mac environment, and:
% if Windows, expects the path to be 'c:\SHARP\[filename]'
% if Mac, expects the path to be '/Users/Shared/SHARP/[filename]'
%    NOTE: please put these folders in your Matlab path!
%
% Finally, it will remove any non-viable characters (e.g., hyphens,
% slashes, etc.) from variable names.
%
function [tableOutput] = formTableFromXLS(inputFileName, onlyNumbers, delNaNsubjLines, verbose)
        
    dataPath = getFileNameForThisOS('', 'ParsedData');
    
    warning('off','MATLAB:nonIntegerTruncatedInConversionToChar'); % suppress this known and non-helpful warning for these functions
    
    dataFileFullPath = strcat(dataPath, inputFileName);
    [~,~,rawData] = xlsread(dataFileFullPath); 
% just for debugging    zRFraw3data(1,1:end)
    rawData(1,1:end) = strrep(rawData(1,1:end), '-', ''); % remove all hyphens from the first row; table variable names can't have hyphens, apparently
    rawData(1,1:end) = strrep(rawData(1,1:end), '#', ''); % remove all # from the first row; table variable names can't have #, apparently
    rawData(1,1:end) = strrep(rawData(1,1:end), '(', '_'); % remove all # from the first row; table variable names can't have (), apparently
    rawData(1,1:end) = strrep(rawData(1,1:end), ')', ''); % remove all # from the first row; table variable names can't have (), apparently
    rawData(1,1:end) = strrep(rawData(1,1:end), '/', ''); % remove all / from the first row; table variable names can't have hyphens, apparently
    
    % now find out if there are any hidden single spaces (damn you, excel) 
    cellSize = size(rawData);
    cellWidth = cellSize(2);
    for colNum = 1:cellWidth
        col = rawData(:,colNum);
        spacesToKill = find(strcmpi(' ',col));
        rawData(spacesToKill,colNum) = {NaN};
    end
        
%    delMe11 = find(strcmpi(' ',delMe9));
%    delMe9(delMe11) = {NaN}
    
    tableOutput = cell2table(rawData(2:end, 1:end), 'VariableNames', rawData(1,1:end)); % use the first row as the table col (variable) names
    
    warning('on','MATLAB:nonIntegerTruncatedInConversionToChar'); % turn the warning back on, in case it's helpful for other functions later

    if (delNaNsubjLines == true)
        tableOutput(isnan(tableOutput.Subject) == true,:) = [];
    end

    if (onlyNumbers == true) % enforce that there be no cell columns
        for colNum = 1:width(tableOutput)
            if (iscell(tableOutput{1,colNum})) % this is a cell column; delete anything that's not a number and make it a number column
                if (verbose == true)
                    fprintf('Column %d was read in as a cell; deleting all non-numeric elements and converting...\n', colNum);
                end
                cellCol = tableOutput{:,colNum};
                for rowNum = 1:length(cellCol) % ZEPHY: THERE HAS TO BE A FASTER WAY TO DO THIS!
                    if (isnumeric(cellCol{rowNum}) == 0) % Z: note that Logicals will return FALSE on this! (non-numeric!)
                        cellCol{rowNum} = NaN; % this isn't a numeric cell; delete it
                    end
                end
                
                varName = tableOutput.Properties.VariableNames{colNum};
                tableOutput.(varName) = cell2mat(cellCol);
                
            end
        end
    end

end

