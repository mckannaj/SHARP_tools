% Zephy McKanna
% 10/25/14
%
%
%
% 12/9/14 ZEPHY: DO NOT USE THIS FUNCTION! IT IS OBSOLETE! USE:
% formTables_RF_1A3() or formTables_EF_1A3() INSTEAD!!!!
%
%
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
% It also checks to see whether we're in a Windows or Mac environment, and:
% if Windows, expects the path to be 'c:\SHARP\[filename]'
% if Mac, expects the path to be '/Users/Shared/SHARP/[filename]'
%    NOTE: please put these folders in your Matlab path!
%
% NOTE: We can't handle column names that have a hyphen in them! (Examples:
% n-back, n-backProb) Please remove these hyphens!
%
function [tableData, tableSum, tableAll] = formTables_1A3(dataFile, sumFile, allFile)
    
    fprintf('12/9/14: This function is obsolete. You should use formTables_RF_1A3 instead.\n'); % just let us know the program is still running

    dataPath = getFileNameForThisOS('', 'ParsedData');

    warning('off','MATLAB:nonIntegerTruncatedInConversionToChar'); % suppress this known and non-helpful warning for these functions
    dataFileFullPath = strcat(dataPath, dataFile);
    [~,~,zRFraw3data] = xlsread(dataFileFullPath); % note that we could deal with different tabs here, but we just expect one right now
    tableData = cell2table(zRFraw3data(2:end, 1:end), 'VariableNames', zRFraw3data(1,1:end)); % use the first row as the table col (variable) names
    
    fprintf('Completed data file, starting sum file.\n'); % just let us know the program is still running

    sumFileFullPath = strcat(dataPath, sumFile);
    [~,~,zRFraw3sum] = xlsread(sumFileFullPath); % note that we could deal with different tabs here, but we just expect one right now
    tableSum = cell2table(zRFraw3sum(2:end, 1:end), 'VariableNames', zRFraw3sum(1,1:end)); % use the first row as the table col (variable) names

    fprintf('Completed sum file, starting all file (very large; expect to wait at least 10min with no further feedback).\n'); % just let us know the program is still running

    allFileFullPath = strcat(dataPath, allFile);
    [~,~,zRFraw3all] = xlsread(allFileFullPath); % note that we could deal with different tabs here, but we just expect one right now
    tableAll = cell2table(zRFraw3all(2:end, 1:end), 'VariableNames', zRFraw3all(1,1:end)); % use the first row as the table col (variable) names
    warning('on','MATLAB:nonIntegerTruncatedInConversionToChar'); % turn the warning back on, in case it's helpful for other functions later

end

