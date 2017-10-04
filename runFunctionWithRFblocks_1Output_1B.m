% Zephy McKanna
% runFunctionWithRFblocks_1Output_1B
% 10/30/15
%
% This function takes a single-output function and all associated inputs in
% a single string, in which the 1B RobotFactory data is noted with XXXXX.
% It then runs that function (with inputs specified in the string)
% repeatedly on each block of ~50 1B subjects, concatenating the output so
% that the final output (from runFunctionWithRFblocks) should be the input 
% function's output over all 1B RF data.
%
% It returns the input function's [single] output, run over all 1B RF data.
%
function [singleOutput] = runFunctionWithRFblocks_1Output_1B(functionToRun, inputString)
    singleOutput = []; % start with nothing and build up (z: seems to be necessary for some reason?)
    
    commaIndex = strfind(inputString, ',');
    numberOfInputs = length(commaIndex) + 1;
    if (numberOfInputs == 1) % just first input
        input1 = inputString;
    elseif (numberOfInputs == 2) % just first and last inputs
        input1 = inputString(1:(commaIndex(1)-1));
        input2 = inputString((commaIndex(1)+1):end);
    else % more than two inputs (first, middle * X, and last)
        input1 = inputString(1:(commaIndex(1)-1));

        for iteration = 2:(numberOfInputs-1)
            eval(sprintf('input%d = inputString((commaIndex(%d)+1):(commaIndex(%d)-1));',iteration, iteration-1, iteration))
        end
        
        eval(sprintf('input%d = inputString((commaIndex(%d)+1):end);',numberOfInputs, numberOfInputs-1))
    end
    for iteration = 1:(numberOfInputs) % now replace any XXXXX with RFdata
        if ( strcmpi(eval(sprintf('input%d',iteration)), 'XXXXX') || strcmpi(eval(sprintf('input%d',iteration)), ' XXXXX') )
            delMe = 'RFdata'; % just to get the string into a variable format...
            eval(sprintf('input%d = delMe;',numberOfInputs))
        end
    end
    
    
    % Z: there's probably a better way to do this... refactor once you know more about load, eval, feval, and clear 
    for block = 1:16 % there are 16 blocks, in groups of 50 subjIDs, from 0-800 (zNote: some of these - e.g., 150-199,550-599, 750-799 - might have no data?)
        fprintf('Running %s on block number %d...\n', functionToRun, block);
        switch block % load different RFdata depending on the block
            case 1
                load(getFileNameForThisOS('RFAll_1B-0_49-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_0_49 within this function's workspace
                RFdata = zRF_1B_0_49; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_0_49;
            case 2
                load(getFileNameForThisOS('RFAll_1B-50_99-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_50_99 within this function's workspace
                RFdata = zRF_1B_50_99; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_50_99;
            case 3
                load(getFileNameForThisOS('RFAll_1B-100_149-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_100_149 within this function's workspace
                RFdata = zRF_1B_100_149; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_100_149;
            case 4
                load(getFileNameForThisOS('RFAll_1B-150_199-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_150_199 within this function's workspace
                RFdata = zRF_1B_150_199; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_150_199;
            case 5
                load(getFileNameForThisOS('RFAll_1B-200_249-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_200_249 within this function's workspace
                RFdata = zRF_1B_200_249; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_200_249;
            case 6
                load(getFileNameForThisOS('RFAll_1B-250_299-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_250_299 within this function's workspace
                RFdata = zRF_1B_250_299; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_250_299;
            case 7
                load(getFileNameForThisOS('RFAll_1B-300_349-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_300_349 within this function's workspace
                RFdata = zRF_1B_300_349; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_300_349;
            case 8
                load(getFileNameForThisOS('RFAll_1B-350_399-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_350_399 within this function's workspace
                RFdata = zRF_1B_350_399; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_350_399;
            case 9
                load(getFileNameForThisOS('RFAll_1B-400_449-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_400_449 within this function's workspace
                RFdata = zRF_1B_400_449; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_400_449;
            case 10
                load(getFileNameForThisOS('RFAll_1B-450_499-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_450_499 within this function's workspace
                RFdata = zRF_1B_450_499; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_450_499;
            case 11
                load(getFileNameForThisOS('RFAll_1B-500_549-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_500_549 within this function's workspace
                RFdata = zRF_1B_500_549; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_500_549;
            case 12
                load(getFileNameForThisOS('RFAll_1B-550_599-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_550_599 within this function's workspace
                RFdata = zRF_1B_550_599; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_550_599;
            case 13
                load(getFileNameForThisOS('RFAll_1B-600_649-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_600_649 within this function's workspace
                RFdata = zRF_1B_600_649; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_600_649;
            case 14
                load(getFileNameForThisOS('RFAll_1B-650_699-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_650_699 within this function's workspace
                RFdata = zRF_1B_650_699; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_650_699;
            case 15
                load(getFileNameForThisOS('RFAll_1B-700_749-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_700_749 within this function's workspace
                RFdata = zRF_1B_700_749; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_700_749;
            case 16
                load(getFileNameForThisOS('RFAll_1B-750_799-2015_10_29.mat', 'ParsedData')); % should create zRF_1B_750_799 within this function's workspace
                RFdata = zRF_1B_750_799; % store in a single variable name that we can keep re-using, so we don't clutter & slow the workspace
                clear zRF_1B_750_799;
            otherwise
                error('runFunctionWithRFblocks_1Output_1B weird block number: %d.\n', block);
        end
        
        
        switch numberOfInputs
            case 1
                [tmpOutput] = feval(functionToRun, eval(input1));
            case 2
                [tmpOutput] = feval(functionToRun, eval(input1), eval(input2));
            case 3
                [tmpOutput] = feval(functionToRun, eval(input1), eval(input2), eval(input3));
            case 4
                [tmpOutput] = feval(functionToRun, eval(input1), eval(input2), eval(input3), eval(input4));
            case 5
                [tmpOutput] = feval(functionToRun, eval(input1), eval(input2), eval(input3), eval(input4), eval(input5));
            case 6
                [tmpOutput] = feval(functionToRun, eval(input1), eval(input2), eval(input3), eval(input4), eval(input5), eval(input6));
            case 7
                [tmpOutput] = feval(functionToRun, eval(input1), eval(input2), eval(input3), eval(input4), eval(input5), eval(input6), eval(input7));
            otherwise
                error('runFunctionWithRFblocks_1Output_1B is unprepared for %d inputs - Zeph, create a switch line for it.\n', numberOfInputs);

        end            
        
        singleOutput = [singleOutput; tmpOutput];
    end
    
    
end
