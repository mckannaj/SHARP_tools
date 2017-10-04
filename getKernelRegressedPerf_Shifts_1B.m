% Zephy McKanna
% getKernelRegressedPerf_Shifts_1B
% 10/30/15
%
% This function takes the RobotFactory trials data, and runs getKernelValsPerShift_1A3()
% on the "Correct" col of each shift to get kernel-smoothed logit data. It then
% uses regress() on these logit data to get the slope and intercept of the
% performance line, which it uses to calculate the initial and end
% performance estimates. 
% Note that it also includes an "adjustedEndEst" column which follows the
% assumption that learning cannot truly go down during a shift, so if the
% slope is negative then this column will equal the initial value.
% Otherwise it will equal the end value.
%
% It returns a matrix roughly the size of the RF SUM file, listing the 
% starting and ending performance values for each shift for each participant.
% 
% It also returns a table that is identical to the RFtrialData input, with
% a kernel-smoothed (logit) estimate of performance for each trial. 
% NOTE THAT THIS IS PROBABLY A VERY LARGE TABLE!
%
function [perfTable, allKernelEstTable] = getKernelRegressedPerf_Shifts_1B(RFtrialData, printTable, verbose)

    allKernelEstTable = table(0,{'XXX'},0.0,0,{'XXX'},{'XXX'},0,0,0.0,0.0,'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift','ActualN','TrialNum','kernelEst','kernelLogitEst'});
    allKernelEstTableRow = 1;

    perfTable = table(0,{'XXX'},0.0,0,{'XXX'},{'XXX'},{'XXX'},0,0,0,0.0,0.0,0.0,'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift','Automaton','ActualN','totalShiftCount','trialsInThisShift','init_KernelLogit','end_KernelLogit','end_KernelLogit_AllPositive'});
    perfTableRow = 1;
    
    uniqueSubjs = unique(RFtrialData.Subject);
    for subjIndex = 1:length(uniqueSubjs)
        subj = uniqueSubjs(subjIndex);
        subjTrials = RFtrialData(RFtrialData.Subject == subj, :);
        subjShiftCount = 1; % start each subject off anew
        if (verbose == true)
            fprintf('getKernelRegressedPerf_Shifts_1B working on subject %d\n', subj);
        end

        uniqueDates = unique(subjTrials.Date);
        for dateIndex = 1:length(uniqueDates)
            subjDay = uniqueDates(dateIndex);
            dayTrials = subjTrials(subjTrials.Date == subjDay, :);
        
            uniqueShifts = unique(dayTrials.ShiftNum);
            for shiftIndex = 1:length(uniqueShifts)
                shift = uniqueShifts(shiftIndex);
                shiftTrials = dayTrials(dayTrials.ShiftNum == shift, :);
                trialEnumeration = transpose(1:(height(shiftTrials)));
                shiftTrials.TrialCount = trialEnumeration;
                %trialPerformance = shiftTrials.Correct;
                shiftPlacement = [1;zeros(height(shiftTrials) - 1, 1)];
                [logitProbCorrect, probCorrect, ~, ~, ~, ~] = getKernelValsPerShift_1A3(shiftTrials, shiftPlacement, 'AllTrials', 10, '', false);
                
%                allKerneLEstTable((allKerneLEstTable.Subject == subj) & ...
%                    (allKerneLEstTable.Date == subjDay) & (allKerneLEstTable.ShiftNum == shift) ...
%                    , :).kernelLogitEst = logitProbCorrect; % store the kernel estimates in the big table
                
                [interceptAndslope] = regress(logitProbCorrect, ...
                    [ones(length(logitProbCorrect),1), transpose(0:(length(logitProbCorrect) - 1))]); % starting the X=0 ensures we get an intercept
                initialEstimate = interceptAndslope(1);
                finalEstimate = interceptAndslope(1) + (length(logitProbCorrect) * interceptAndslope(2));
                if (interceptAndslope(2) > 0) % positive slope
                    finalEstimate_JustPositiveSlope = finalEstimate; % keep the regression-estimated final value
                else
                    finalEstimate_JustPositiveSlope = initialEstimate; % assume a slope of zero (end=initial)
                end

                thisShiftRow = table(shiftTrials.Subject(1), shiftTrials.Condition(1), ...
                    shiftTrials.Date(1), shiftTrials.ShiftNum(1), shiftTrials.Cluster(1), ...
                    shiftTrials.Shift(1), shiftTrials.Automaton(1), shiftTrials.ActualN(1), ...
                    subjShiftCount, height(shiftTrials), initialEstimate, finalEstimate,finalEstimate_JustPositiveSlope,...
                    'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift',...
                    'Automaton','ActualN','totalShiftCount','trialsInThisShift','init_KernelLogit',...
                    'end_KernelLogit','end_KernelLogit_AllPositive'});
                perfTable(perfTableRow,:) = thisShiftRow;
                
                thisShiftTrials = table(shiftTrials.Subject, shiftTrials.Condition, ...
                    shiftTrials.Date, shiftTrials.ShiftNum, shiftTrials.Cluster, ...
                    shiftTrials.Shift, shiftTrials.ActualN, shiftTrials.Problem, probCorrect, logitProbCorrect, ...
                    'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift','ActualN','TrialNum','kernelEst','kernelLogitEst'});
                allKernelEstTable(allKernelEstTableRow:(allKernelEstTableRow + length(logitProbCorrect) - 1),:) = thisShiftTrials;
                allKernelEstTableRow = allKernelEstTableRow + length(logitProbCorrect);
                
                perfTableRow = perfTableRow + 1;
                subjShiftCount = subjShiftCount + 1;
            end
        end
    end

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getKernelRegressedPerf_Shifts_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(perfTable, fileName);
    end
end

