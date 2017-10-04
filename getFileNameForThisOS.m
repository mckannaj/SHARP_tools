% Zephy McKanna
% 11/12/14
%
% This function takes a filename and a subfolder, and puts those on the end of the
% following paths, depending on OS environment:
% if Windows, the path is 'c:\SHARP\[filename]'
% if Mac, the path is '/Users/Shared/SHARP/[filename]'
%
% Note that if you want to put the file in these higher-level folders, you
% can leave the subfolder input as ''.
%
function [fileNameWithPath] = getFileNameForThisOS(fileName, subFolder)

    dataPath = '/home/zephy/SHARP/'; % assume we're running on Unix - assuming swing@ece.neu.edu (note that this is (obviously) Zephy-specific...)
    if (ispc == 1) % we're running under Windows
%        dataPath = 'c:\Shared\SHARP\';
        dataPath = 'c:\users\pavelm\dropbox\projects\SHARP\'; % note that this is (obviously) Misha-specific...
    elseif (ismac == 1) % maybe a Mac? (note that this will also give 1 from isunix)
        dataPath = '/Users/Shared/SHARP/'; % 
    elseif (isunix == 1) % if it's only unix (e.g., SWING server), this is the only one that'll give a 1
        dataPath = '/home/zephy/SHARP/'; % 
    end
    if (strcmpi(subFolder,'') == 0) % we have a subFolder
        if (ispc == 1)
            folder = strcat(subFolder, '\');
        else
            folder = strcat(subFolder, '/');
        end
    end
    fileNameWithPath = strcat(dataPath, folder, fileName);

end