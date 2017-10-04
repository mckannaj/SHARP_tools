% Zephy McKanna
% createCategoryFeatureMap()
% 5/11/16
%
% This function is intended to take a categoryTable including the following
% columns:
% ShiftID (as returned by getVarNameFromShift())
% Category (numeric - this could be a principal component number, etc.)
%
% It returns three tables: a category feature map, a weighted category
% feature map, and a normalized weighted category feature map.
% Z: give more info on the dimensions, cols, etc. of each of these here.
%
% NOTE: this is an amalgamation of several "tools" that had been used more
% than once; it would almost certainly benefit from refactoring.
function [catFeatures, catWeights, catWeightPcts] = createCategoryFeatureMap(categoryTable, featMapWithNeg1s, verbose)
    deleteFeatMap = 0; % flag to indicate whether we need to remove this at the end
    if (isempty(featMapWithNeg1s)) % if this isn't passed in for speed, load it
        if (verbose == true)
            fprintf('No featMapWithNeg1s supplied; loading from file.\n');
        end
        load(getFileNameForThisOS('2017_5_10-FeatureMapWithNeg1s_1B.mat', 'IntResults')); % load featMapWithNeg1s
        deleteFeatMap = 1; % if we loaded it, be sure to get rid of it before we return
    end

    if (verbose == true)
        fprintf('Merging categories with features.\n');
    end
    catFeatures = table(0,0,'VariableNames',{'Category','ActualN'});
    insertThisCol = width(catFeatures) + 1;
    for i=1:width(featMapWithNeg1s) 
        catFeatures(1,insertThisCol) = featMapWithNeg1s(1,i);
        catFeatures.Properties.VariableNames(insertThisCol) = featMapWithNeg1s.Properties.VariableNames(i);
        insertThisCol = insertThisCol + 1;
    end
    % now populate that table with the features for each observed shift
    for i=1:height(categoryTable)
        catFeatures(i,:) = catFeatures(1,:); % create a placeholder for the next row without having to specify all the variables
        catFeatures.Category(i) = categoryTable.Category(i);
        catFeatures.ShiftID(i) = categoryTable.ShiftID(i);
        catFeatures.ActualN(i) = mod(catFeatures.ShiftID(i), 100);
        featShift = featMapWithNeg1s(featMapWithNeg1s.ShiftID == (catFeatures.ShiftID(i) - catFeatures.ActualN(i)), :); % feature map doesn't have N values in shiftIDs
        catFeatures.Shift_name(i) = featShift.Shift_name;
        catFeatures(i,5:end) = featShift(1,3:end);
    end

    if (deleteFeatMap == 1)
        clear featMapWithNeg1s % check and see if this happens automatically - it may, if we load it within a function
    end
    
    if (verbose == true)
        fprintf('Weighting the category features.\n');
    end
    % now weight the features by the category
    catWeights = table();
    for i=1:width(catFeatures) % set up the columns
        catWeights(1,i) = catFeatures(1,i);
        catWeights.Properties.VariableNames(i) = catFeatures.Properties.VariableNames(i);
    end
    % Note: these cols don't make sense in a weight matrix: Cluster, Shift_name, ShiftID, Scenario, ScenarioCode 
    categories = unique(catFeatures.Category);
    catWeights.Properties.VariableNames(2) = {'AvgUpdateN'}; % change from ActualN to average N for update shifts
    catWeights.Properties.VariableNames(17) = {'AvgNonEF'}; 
    catWeights.Properties.VariableNames(18) = {'AvgTimeoutCorrect'}; 
    catShiftCount = table(0,0,'VariableNames',{'Category','NumberOfShifts'}); % note the number of shifts in each so we can normalize
    for i=1:length(categories)
        cat = categories(i);
        catShifts = catFeatures(catFeatures.Category == cat, :);
        catWeights(i,:) = catWeights(1,:); % set up the weights with some default values
        % now weight them properly
        catWeights.Category(i) = cat;
        updateShifts = catShifts(catShifts.U == 1, :);
        catWeights.AvgUpdateN(i) = mean(updateShifts.ActualN);
        catWeights.Shift_name(i) = {'N/A'}; % remove this later
        catWeights.ShiftID(i) = -999; % remove this later
        catWeights.Scenario(i) = {'N/A'}; % remove this later
        for j=6:13 % columns U, I, S, xOR, ID, Relational, HypTest, NotTrueInhibit
            catWeights{i,j} = sum(catShifts{:,j});
        end
        catWeights.ScenarioCode(i) = -999; % remove this later
        catWeights.Cluster(i) = {'N/A'}; % remove this later
        catWeights.Logic(i) = sum(catShifts.Logic);
        catWeights.AvgNonEF(i) = mean(catShifts.NonEF);
        catWeights.AvgTimeoutCorrect(i) = mean(catShifts.TimeoutCorrect);
        catWeights.TotalCorrResp(i) = -999; % remove this later
        catWeights.GuessProb(i) = -999; % remove this later
        for j=20:width(catWeights) % remaining cols are all 1/-1
            catWeights{i,j} = sum(catShifts{:,j});
        end
        catShiftCount(i,:) = table(cat,height(catShifts),...
            'VariableNames',{'Category','NumberOfShifts'}); 
    end
     % remove the cols that don't make sense in the weighting aggregation
    catWeights.Shift_name = [];
    catWeights.ShiftID = []; 
    catWeights.Scenario = []; 
    catWeights.Cluster = []; 
    catWeights.ScenarioCode = []; 
    catWeights.TotalCorrResp = []; 
    catWeights.GuessProb = []; 
    
    if (verbose == true)
        fprintf('Normalizing the category weights.\n');
    end
    catWeightPcts = catWeights; % now divide these by the number of shifts that went into them to put them in the range of -1 to 1
    for i = 1:length(categories)
        for j = 1:width(catWeights) % ton of columns here; is there a faster way to do this?
            shiftsInThisCat = catShiftCount(catShiftCount.Category == catWeightPcts.Category(i),:).NumberOfShifts;
            catWeightPcts{i,j} = catWeightPcts{i,j} / shiftsInThisCat; % normalize back into -1 to 1 range
        end
    end
    catWeightPcts.Category = catWeights.Category; % several things were already correct, however; put those back
    catWeightPcts.AvgUpdateN = catWeights.AvgUpdateN;
    catWeightPcts.AvgNonEF = catWeights.AvgNonEF;
    catWeightPcts.AvgTimeoutCorrect = catWeights.AvgTimeoutCorrect;
end

