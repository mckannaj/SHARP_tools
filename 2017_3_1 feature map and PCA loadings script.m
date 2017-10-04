% Zephy McKanna
% script to link the 1B shift feature map with the PC loadings from Maciej
% 3/1/17

% read in the feature map, clean it up for usability, and save it for later 
[~,~,delMe] = xlsread('/Users/z_home/Desktop/SHARP/ETC/2017_2_5 RF stimuli feature map - 1B.xlsx'); 
delSize = size(delMe);
delHeight = delSize(1);
delWidth = delSize(2);
for i = 1:delHeight
    if isnan(delMe{i,1})
        delMe(i:end,:) = []; % if it has no Shift_name, it's not a real row; delete it
        break;
    end
end
for i = 1:delWidth
    if isnan(delMe{1,i})
        delMe(:,i:end) = []; % if it has no title row, it's not a real col; delete it
        break;
    end
end
delMe(1,1:end) = strrep(delMe(1,1:end), ' ', '_'); % remove all spaces from the first row; table variable names can't have spaces
delMe(1,1:end) = strrep(delMe(1,1:end), ':', ''); % same with :
delMe(1,1:end) = strrep(delMe(1,1:end), '3dShape', 'Shape3d'); % can't start with a number either
feat_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
% first remove all the totally-NaN cols
deleteTheseCols = {'nothing yet'};
deleteTheseColsRow = 1;
for c = 17:width(feat_1B) % ANOTHER HACK! (I happen to know the first 17 are ok, and also contain some non-number cols)
    nanCount = sum(isnan(table2array(feat_1B(:,c))));
    if (nanCount == height(feat_1B)) % this col is 100% NaNs; remove it
        deleteTheseCols(deleteTheseColsRow,:) = feat_1B(:,c).Properties.VariableNames(1); % note the names of these cols, to delete
        deleteTheseColsRow = deleteTheseColsRow + 1;
    end
end
for i = 1:length(deleteTheseCols)
    feat_1B(:,deleteTheseCols(i)) = []; % delete the marked cols
end
% now change all the NaNs to 0s (note that this will take a minute, but not too long) 
for i = 1:height(feat_1B) 
    for c = 1:width(feat_1B)
        if (iscell(feat_1B{i,c}) == 0) % if it's not a cell, it's either a number or a NaN
            if (isnan(feat_1B{i,c})) % if it's a NaN...
                feat_1B{i,c} = 0; % make it a zero
            end
        end
    end
end
save(getFileNameForThisOS('2017_3_10-FeatureMap_AllShifts_1B.mat', 'IntResults'), 'feat_1B');
writetable(feat_1B, getFileNameForThisOS('2017_3_10-FeatureMap_AllShifts_1B.csv', 'IntResults'),'WriteRowNames',false);
clear delSize delHeight delWidth delMe i c deleteTheseCols deleteTheseColsRow nanCount



% now load in the PCA loadings Maciej gave us
[~,~,delMe] = xlsread(getFileNameForThisOS('2017_2_28-y25loadings3SD.xlsx', 'IntResults')); 
delMe(:,1) = []; % not sure what this first column is meant to be; remove it
PCAload_3SD_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names

% and now make a new matrix that associates the PCs with features
PCfeat_1B = table(0,0,'VariableNames', {'PCnum', 'nVal'}); % add the two faetures of these shifts that the feature map doesn't have
for i = 1:width(feat_1B) % then add all the ones that the feature map does have to the table
    PCfeat_1B(1,i+2) = feat_1B(1,i);
    PCfeat_1B.Properties.VariableNames{i+2} = feat_1B.Properties.VariableNames{i};
end
addingRowNum = 1;
for col = 2:width(PCAload_3SD_1B) % go through all the PCs
    pc = col-1; % first col is "shift", then it's PCs
    for row = 1:height(PCAload_3SD_1B)
        if (strcmpi(PCAload_3SD_1B{row,col},'NA') == 0) % this cell isn't just 'NA'
            if (addingRowNum > 1)
                PCfeat_1B(addingRowNum,:) = PCfeat_1B(addingRowNum-1,:); % just create a dummy space into which we can save values
            end
            n = mod(PCAload_3SD_1B{row,1},100); % get the n value
            shift = PCAload_3SD_1B{row,1} - n; % get the shift ID
            features = feat_1B(feat_1B.ShiftID == shift, :);
%            addThisRow = table(pc,n,features{1,14:end},'VariableNames', ['PCnum', 'nVal',features.Properties.VariableNames(14:end)])
            PCfeat_1B.PCnum(addingRowNum) = pc;
            PCfeat_1B.nVal(addingRowNum) = n;
            PCfeat_1B(addingRowNum,3:end) = feat_1B(feat_1B.ShiftID == shift, :);
            addingRowNum = addingRowNum + 1;
        end
    end
end
writetable(PCfeat_1B, getFileNameForThisOS('2017_3_10-PCAloads_3SDs_features_1B.csv', 'IntResults'),'WriteRowNames',false);
clear i addingRowNum col row pc n shift features addThisRow
 
% and now summarize those features in a new matrix: sums
PCfeat_1B_sums = PCfeat_1B(1,:);
uniquePCs = unique(PCfeat_1B.PCnum);
for i = 1:length(uniquePCs)
    pc = uniquePCs(i);
    pcRows = PCfeat_1B(PCfeat_1B.PCnum == pc, :);
    if (i > 1) 
        PCfeat_1B_sums(i,:) = PCfeat_1B_sums(i-1,:); % just create a dummy space into which we can save values
    end
    for c = 1:width(PCfeat_1B)
        if (strcmpi(PCfeat_1B.Properties.VariableNames{c},'PCnum'))
            PCfeat_1B_sums{pc,c} = pcRows{1,c};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'nVal'))
            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Shift_name'))
            PCfeat_1B_sums{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'ShiftID'))
            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Scenario'))
            PCfeat_1B_sums{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'ScenarioCode'))
            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Cluster'))
            PCfeat_1B_sums{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'NonEF'))
            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'TimeoutCorrect'))
            PCfeat_1B_sums{pc,c} = -1;
        else
            PCfeat_1B_sums{pc,c} = sum(pcRows{:,c});
        end
    end
end
width(PCfeat_1B_sums) % 193 cols
PCfeat_1B_sums_noZeros = PCfeat_1B_sums; % now create one that doesn't have any sum=0 cols
PCfeat_1B_sums_noZeros.nVal = [];
PCfeat_1B_sums_noZeros.Shift_name = [];
PCfeat_1B_sums_noZeros.ShiftID = [];
PCfeat_1B_sums_noZeros.Scenario = [];
PCfeat_1B_sums_noZeros.ScenarioCode = [];
PCfeat_1B_sums_noZeros.Cluster = [];
PCfeat_1B_sums_noZeros.NonEF = [];
PCfeat_1B_sums_noZeros.TimeoutCorrect = [];
for i=width(PCfeat_1B_sums_noZeros):-1:1
    if (sum(PCfeat_1B_sums_noZeros{:,i}) == 0)
        PCfeat_1B_sums_noZeros(:,i) = [];
    end
end
width(PCfeat_1B_sums_noZeros) % 87 cols
writetable(PCfeat_1B_sums_noZeros, getFileNameForThisOS('2017_3_10-PCfeat_1B_sums_noZeros.csv', 'IntResults'),'WriteRowNames',false);

% and now summarize those features in a new matrix: weights (based on loadings) 
PCfeat_1B_weights = PCfeat_1B(1,:);
uniquePCs = unique(PCfeat_1B.PCnum);
for i = 1:length(uniquePCs)
    pc = uniquePCs(i);
    pcRows = PCfeat_1B(PCfeat_1B.PCnum == pc, :);
    pcShiftWeights = zeros(1, height(pcRows));
    for j = 1:height(pcRows)
        weightShiftID = pcRows.ShiftID(j) + pcRows.nVal(j);
        weightCell = PCAload_3SD_1B{PCAload_3SD_1B.Shift == weightShiftID, i+1}; % i+1 because PC1 is col 2 in PCAload_3SD_1B
        pcShiftWeights(1,j) = weightCell{1};
    end
    if (i > 1) 
        PCfeat_1B_weights(i,:) = PCfeat_1B_weights(i-1,:); % just create a dummy space into which we can save values
    end
    for c = 1:width(PCfeat_1B)
        if (strcmpi(PCfeat_1B.Properties.VariableNames{c},'PCnum'))
            PCfeat_1B_weights{pc,c} = pcRows{1,c};
% weight might be interesting for nVal?       elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'nVal'))
%            PCfeat_1B_sums{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Shift_name'))
            PCfeat_1B_weights{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'ShiftID'))
            PCfeat_1B_weights{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Scenario'))
            PCfeat_1B_weights{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'ScenarioCode'))
            PCfeat_1B_weights{pc,c} = -1;
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'Cluster'))
            PCfeat_1B_weights{pc,c} = {'NA'};
        elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'NonEF'))
            PCfeat_1B_weights{pc,c} = -1;
% weight might be interesting for timeoutCorrect?       elseif (strcmpi(PCfeat_1B.Properties.VariableNames{c},'TimeoutCorrect'))
%            PCfeat_1B_sums{pc,c} = -1;
        else
            PCfeat_1B_weights{pc,c} = pcShiftWeights * pcRows{:,c};
        end
    end
end
width(PCfeat_1B_weights) % 193 cols

PCfeat_1B_weights_noZeros = PCfeat_1B_weights; % now create one that doesn't have any sum=0 cols
%PCfeat_1B_weights_noZeros.nVal = [];
PCfeat_1B_weights_noZeros.Shift_name = [];
PCfeat_1B_weights_noZeros.ShiftID = [];
PCfeat_1B_weights_noZeros.Scenario = [];
PCfeat_1B_weights_noZeros.ScenarioCode = [];
PCfeat_1B_weights_noZeros.Cluster = [];
PCfeat_1B_weights_noZeros.NonEF = [];
%PCfeat_1B_sums_noZeros.TimeoutCorrect = [];
for i=width(PCfeat_1B_weights_noZeros):-1:1
    if (sum(PCfeat_1B_weights_noZeros{:,i}) == 0)
        PCfeat_1B_weights_noZeros(:,i) = [];
    end
end
width(PCfeat_1B_weights_noZeros) % 89 cols

writetable(PCfeat_1B_weights_noZeros, getFileNameForThisOS('2017_3_10-PCfeat_1B_weights_noZeros.csv', 'IntResults'),'WriteRowNames',false);



