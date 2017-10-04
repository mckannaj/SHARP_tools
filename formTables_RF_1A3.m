% Zephy McKanna
% 10/25/14
% 
% This function takes up to three inputs, all of which are filenames, and
% reads them into Tables.
%
% Expected files are the parsed RobotFactory game files from SHARP / 
% Honeywell (rf-data, rf-sum, and RobotFactory). Expected file format is
% .xlsx.
%
% It returns the data in Table format. Note that there is also some interim 
% "Still alive" output to stdout.
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
% NOTE: We can't handle column names that have a hyphen in them! (Examples:
% n-back, n-backProb) These hyphens will be removed from variable names.
%
function [tableData, tableSum, tableAll] = formTables_RF_1A3(dataFile, sumFile, allFile, delNaNsubjLines)
        
    dataPath = getFileNameForThisOS('', 'ParsedData');
    
    warning('off','MATLAB:nonIntegerTruncatedInConversionToChar'); % suppress this known and non-helpful warning for these functions
    if (isempty(dataFile) == 0) % there's something in the dataFile input
        dataFileFullPath = strcat(dataPath, dataFile);
        [~,~,zRFraw3data] = xlsread(dataFileFullPath); 
    % just for debugging    zRFraw3data(1,1:end)
        zRFraw3data(1,1:end) = strrep(zRFraw3data(1,1:end), '-', ''); % remove all hyphens from the first row; table variable names can't have hyphens, apparently
        zRFraw3data(1,1:end) = strrep(zRFraw3data(1,1:end), '#', 'Number'); % remove all # from the first row; table variable names can't have #, apparently
        zRFraw3data(1,1:end) = strrep(zRFraw3data(1,1:end), '(', '_'); % remove all # from the first row; table variable names can't have (), apparently
        zRFraw3data(1,1:end) = strrep(zRFraw3data(1,1:end), ')', ''); % remove all # from the first row; table variable names can't have (), apparently
        zRFraw3data(1,1:end) = strrep(zRFraw3data(1,1:end), '/', ''); % remove all / from the first row; table variable names can't have hyphens, apparently
        tableData = cell2table(zRFraw3data(2:end, 1:end), 'VariableNames', zRFraw3data(1,1:end)); % use the first row as the table col (variable) names
    else
        tableData = table(0,'VariableNames',{'Subject'});
    end
    
    fprintf('Completed data file, starting sum file.\n'); % just let us know the program is still running

    if (isempty(sumFile) == 0) % there's something in the dataFile input
        sumFileFullPath = strcat(dataPath, sumFile);
        [~,~,zRFraw3sum] = xlsread(sumFileFullPath); 
        zRFraw3sum(1,1:end) = strrep(zRFraw3sum(1,1:end), '-', ''); % remove all hyphens from the first row; table variable names can't have hyphens, apparently
        zRFraw3sum(1,1:end) = strrep(zRFraw3sum(1,1:end), '#', 'Number'); % remove all # from the first row; table variable names can't have #, apparently
        zRFraw3sum(1,1:end) = strrep(zRFraw3sum(1,1:end), '(', '_'); % remove all # from the first row; table variable names can't have (), apparently
        zRFraw3sum(1,1:end) = strrep(zRFraw3sum(1,1:end), ')', ''); % remove all # from the first row; table variable names can't have (), apparently
        zRFraw3sum(1,1:end) = strrep(zRFraw3sum(1,1:end), '/', ''); % remove all / from the first row; table variable names can't have hyphens, apparently
        tableSum = cell2table(zRFraw3sum(2:end, 1:end), 'VariableNames', zRFraw3sum(1,1:end)); % use the first row as the table col (variable) names
    else
        tableSum = table(0,'VariableNames',{'Subject'});
    end
    
    fprintf('Completed sum file, starting all file (very large; expect to wait at least 10min with no further feedback).\n'); % just let us know the program is still running

    if (isempty(allFile) == 0) % there's something in the dataFile input
        allFileFullPath = strcat(dataPath, allFile);
        [~,~,zRFraw3all] = xlsread(allFileFullPath); 
        zRFraw3all(1,1:end) = strrep(zRFraw3all(1,1:end), '-', ''); % remove all hyphens from the first row; table variable names can't have hyphens, apparently
        zRFraw3all(1,1:end) = strrep(zRFraw3all(1,1:end), '#', 'Number'); % remove all # from the first row; table variable names can't have #, apparently
        zRFraw3all(1,1:end) = strrep(zRFraw3all(1,1:end), '(', '_'); % remove all # from the first row; table variable names can't have (), apparently
        zRFraw3all(1,1:end) = strrep(zRFraw3all(1,1:end), ')', ''); % remove all # from the first row; table variable names can't have (), apparently
        zRFraw3all(1,1:end) = strrep(zRFraw3all(1,1:end), '/', ''); % remove all / from the first row; table variable names can't have hyphens, apparently
        tableAll = cell2table(zRFraw3all(2:end, 1:end), 'VariableNames', zRFraw3all(1,1:end)); % use the first row as the table col (variable) names
    else
        tableAll = table(0,'VariableNames',{'Subject'});
    end
    
    warning('on','MATLAB:nonIntegerTruncatedInConversionToChar'); % turn the warning back on, in case it's helpful for other functions later

    if (delNaNsubjLines == true)
        tableData(isnan(tableData.Subject) == true,:) = [];
        tableSum(isnan(tableSum.Subject) == true,:) = [];
        tableAll(isnan(tableAll.Subject) == true,:) = [];
    end
    
end

