% Zephy McKanna
% getIsoRperf_Shifts_1B
% 10/30/15
%
% This function takes the RobotFactory trials data, and runs misha_isorp()
% on each shift. It then takes the average of the first three data points
% returned as the "starting performance" and the last three data points
% returned as the "ending performance". 
%
% It returns a matrix roughly the size of the RF SUM file, listing the 
% starting and ending performance values for each shift for each participant.
% 
% It also returns a table that is identical to the RFtrialData input, with
% an isotonic-regressed estimate of performance for each trial. 
% NOTE THAT THIS IS PROBABLY A VERY LARGE TABLE!
function [perfShiftTable, allIsoEstTable] = getIsoRperf_Shifts_1B(RFtrialData, printTable, verbose)

    allIsoEstTable = table(0,{'XXX'},0.0,0,{'XXX'},{'XXX'},0,0.0,'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift','TrialNum','isoEst'});
    allIsoEstTableRow = 1;

    perfShiftTable = table(0,{'XXX'},0.0,0,{'XXX'},{'XXX'},{'XXX'},0,0,0.0,0.0,'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift','Automaton','totalShiftCount','trialsInThisShift','init_ISOest','end_ISOest'});
    perfTableRow = 1;
    
    uniqueSubjs = unique(RFtrialData.Subject);
    for subjIndex = 1:length(uniqueSubjs)
        subj = uniqueSubjs(subjIndex);
        subjTrials = RFtrialData(RFtrialData.Subject == subj, :);
        subjShiftCount = 1; % start each subject off anew
        if (verbose == true)
            fprintf('getIsoRperf_Shifts_1B working on subject %d\n', subj);
        end

        uniqueDates = unique(subjTrials.Date);
        for dateIndex = 1:length(uniqueDates)
            subjDay = uniqueDates(dateIndex);
            dayTrials = subjTrials(subjTrials.Date == subjDay, :);
        
            uniqueShifts = unique(dayTrials.ShiftNum);
            for shiftIndex = 1:length(uniqueShifts)
                shift = uniqueShifts(shiftIndex);
                shiftTrials = dayTrials(dayTrials.ShiftNum == shift, :);
                
                trialPerformance = shiftTrials.Correct;
                IsoPshift = misha_isorp(trialPerformance);
                IsoPshift_unchanged = IsoPshift; % store so we can put it in the trials table
                %fprintf('Num of trials = %d, iso estimates = %d\n',length(trialPerformance), length(IsoPshift));
                if (length(IsoPshift) > 3)
                    initialEstimate = mean(IsoPshift(1:3));
                    finalEstimate = mean(IsoPshift((end-3):end));
                    % Zephy: you're doing all this protection against 1s and 0s (for logit) twice. Consolidate it! 
                    if ( ((initialEstimate == 1) && (finalEstimate == 1)) || ...% only possible if every trial was a 1
                            ((initialEstimate == 0) && (finalEstimate == 0)) || ... % only possible if every trial was a 0
                            ((initialEstimate == 0) && (finalEstimate == 1)) || ... % relatively common
                            ((initialEstimate == 1) && (finalEstimate == 0)) ) % should be impossible
                        trialPerformance = [.5; trialPerformance; .5]; % add half responses at both ends to indicate uncertainty
                        IsoPshift = misha_isorp(trialPerformance);
                        initialEstimate = mean(IsoPshift(1:3));
                        finalEstimate = mean(IsoPshift((end-3):end));
                    elseif (initialEstimate == 0) % only the start needs correcting
                        trialPerformance = [.5; trialPerformance]; % add half responses at the start to indicate uncertainty
                        IsoPshift = misha_isorp(trialPerformance);
                        initialEstimate = mean(IsoPshift(1:3));
                        finalEstimate = mean(IsoPshift((end-3):end));
                    elseif (finalEstimate == 1) % only the end needs correcting
                        trialPerformance = [trialPerformance; .5]; % add half responses at the end to indicate uncertainty
                        IsoPshift = misha_isorp(trialPerformance);
                        initialEstimate = mean(IsoPshift(1:3));
                        finalEstimate = mean(IsoPshift((end-3):end));
                    end
                else
                    fprintf('WARNING: getIsoRperf_Shifts_1B subj %d shiftNum %d has only %d trials. Using all for both estimates.\n', subj, shift, length(IsoPshift));
                    initialEstimate = mean(IsoPshift);
                    finalEstimate = mean(IsoPshift);
                    % Zephy: you're doing all this protection against 1s and 0s (for logit) twice. Consolidate it! 
                    if ( ((initialEstimate == 1) && (finalEstimate == 1)) || ...% only possible if every trial was a 1
                            ((initialEstimate == 0) && (finalEstimate == 0)) || ... % only possible if every trial was a 0
                            ((initialEstimate == 0) && (finalEstimate == 1)) || ... % relatively common
                            ((initialEstimate == 1) && (finalEstimate == 0)) ) % should be impossible
                        trialPerformance = [.5; trialPerformance; .5]; % add half responses at both ends to indicate uncertainty
                        IsoPshift = misha_isorp(trialPerformance);
                        initialEstimate = mean(IsoPshift(1:3));
                        finalEstimate = mean(IsoPshift((end-3):end));
                    elseif (initialEstimate == 0) % only the start needs correcting
                        trialPerformance = [.5; trialPerformance]; % add half responses at the start to indicate uncertainty
                        IsoPshift = misha_isorp(trialPerformance);
                        initialEstimate = mean(IsoPshift(1:3));
                        finalEstimate = mean(IsoPshift((end-3):end));
                    elseif (finalEstimate == 1) % only the end needs correcting
                        trialPerformance = [trialPerformance; .5]; % add half responses at the end to indicate uncertainty
                        IsoPshift = misha_isorp(trialPerformance);
                        initialEstimate = mean(IsoPshift(1:3));
                        finalEstimate = mean(IsoPshift((end-3):end));
                    end
                end
                
                if ((initialEstimate == 0) || (initialEstimate == 1) || (finalEstimate == 0) || (finalEstimate == 1))
                    error('Somehow we still have initial = %f and final = %f for subj %d and shift %d. Fix it!\n', ...
                        initialEstimate, finalEstimate, subj, shift);
                end
               
                thisShiftRow = table(shiftTrials.Subject(1), shiftTrials.Condition(1), ...
                    shiftTrials.Date(1), shiftTrials.ShiftNum(1), shiftTrials.Cluster(1), ...
                    shiftTrials.Shift(1), shiftTrials.Automaton(1), ...
                    subjShiftCount, height(shiftTrials), initialEstimate, finalEstimate,...
                    'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift',...
                    'Automaton','totalShiftCount','trialsInThisShift','init_ISOest','end_ISOest'});
                perfShiftTable(perfTableRow,:) = thisShiftRow;
                
                %length(shiftTrials.Problem)
                %length(IsoPshift_unchanged)
                thisShiftTrials = table(shiftTrials.Subject, shiftTrials.Condition, ...
                    shiftTrials.Date, shiftTrials.ShiftNum, shiftTrials.Cluster, ...
                    shiftTrials.Shift, shiftTrials.Problem, IsoPshift_unchanged, ...
                    'VariableNames', {'Subject','Condition','Date','ShiftNum','Cluster','Shift','TrialNum','isoEst'});     
                %height(thisShiftTrials)
                
                allIsoEstTable(allIsoEstTableRow:(allIsoEstTableRow + length(IsoPshift_unchanged) - 1),:) = thisShiftTrials;
                allIsoEstTableRow = allIsoEstTableRow + length(IsoPshift_unchanged);
                
                perfTableRow = perfTableRow + 1;
                subjShiftCount = subjShiftCount + 1;
            end
        end
    end

    fileName = '';
    if (strcmpi('', printTable) == 0) % there's something in printTable
        if (printTable == false) % do nothing
        elseif (printTable == true) % do a default filename
            fileName = getFileNameForThisOS('getIsoRperf_Shifts_1B-output.csv', 'IntResults');
        else % assume printThirds is the filename
            fileName = getFileNameForThisOS(printTable, 'IntResults');
        end
        
        writetable(perfShiftTable, fileName);
    end
end

