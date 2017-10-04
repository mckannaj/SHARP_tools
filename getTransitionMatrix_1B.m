% Zephy McKanna
% getTransitionMatrix_1B
% 10/30/15
%
% This function takes the SUM RobotFactory file, and returns a 16x16
% table, in which each row and column is a Cluster, and each cell is a time
% that the row was played just before the column by a single participant.
%
function [countTransitionTable] = getTransitionMatrix_1B(RFsumData, ensureSameDate, printTable, verbose)
    RFsumData.Cluster = strrep(RFsumData.Cluster, '/', '_'); % matlab can't handle / in its table names or variable names; replace with _
    RFsumData.Cluster = strrep(RFsumData.Cluster, '(xOR)', ''); % for some reason we still have U/Logic(xOR) for a couple of shifts... remove the (xOR)
    RFsumData.Cluster = strrep(RFsumData.Cluster, 'Relational', 'Logic'); % HACK to be able to use this on 1A-3 data - U/S/Relational was a separate Cluster then

    clusterNamesInOrder = {'U', 'S', 'I', ...
        'U_Logic', 'S_Logic', 'I_Logic', ...
        'U_S', 'U_I', 'S_I', ...
        'U_S_Logic', 'U_I_Logic', 'S_I_Logic', ...
        'L4aV1', 'L4bV1', 'L4aV2', 'L4bV2'};
    countTransitionTable = array2table(zeros(16,16), 'VariableNames', clusterNamesInOrder, 'RowNames', clusterNamesInOrder);

    for shift = 2:height(RFsumData) % start with the 2nd one, because the 1st can't be a transition
        if (RFsumData.ShiftNum(shift) > 1) % again, for each subject, the first shift isn't a transition
            if (ensureSameDate == true) % we want only transitions on the same day
                if (RFsumData.Date(shift-1) ~= RFsumData.Date(shift))
                    continue % skip to the next shift (which should be the same day)
                end
            end
            countTransitionTable{RFsumData.Cluster(shift-1),RFsumData.Cluster(shift)} = countTransitionTable{RFsumData.Cluster(shift-1),RFsumData.Cluster(shift)} + 1;
%{
            fromCluster = 0;
            toCluster = 0;
            for findFrom = 1:length(clusterNamesInOrder)
                if (strcmpi(RFsumData.Cluster(shift-1), clusterNamesInOrder(findFrom)))
                    fromCluster = findFrom;
                end
            end
            for findTo = 1:length(clusterNamesInOrder)
                if (strcmpi(RFsumData.Cluster(shift), clusterNamesInOrder(findTo)))
                    toCluster = findTo;
                end
            end
            countTransitionTable
            %}
        else % shiftNum = 1, must be a new subject
            if (verbose == true)
                fprintf('getTransitionMatrix_1B working on subject %d\n', RFsumData.Subject(shift));
            end
        end
    end

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getTransitionMatrix_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(countTransitionTable, fileName);
    end
end

