% Zephy McKanna
% exploreSSRT_1B
% 8_4_15
%
% This function attempts to explore and explain why straight SSRT
% calculations don't correlate between RF and PP in 1B.
% We will attempt to understand what participants to exclude, and why.
% 
function [InhBeforeCount, InhCatchCount, RF_FailedCatchTable, RF_FailedGoTable] = exploreSSRT_1B(PP_inhibitData, SSRT_RF_firstShifts_table)
    % count the number of times each participant answered "before" the inhibit cue in PPinhibit 
    InhBeforeCount = table(0,0,'VariableNames', {'Subject','BeforeCount'});

    allSubjects = unique(PP_inhibitData.Subject);
    for subjIndex = 1:length(allSubjects)
        delMe = PP_inhibitData((PP_inhibitData.Subject == allSubjects(subjIndex)), :);
        delMe2 = delMe(strcmpi(delMe.InhCorr,'before'),:);
        InhBeforeCount(subjIndex,:) = {allSubjects(subjIndex) height(delMe2)};
    end
    % InhBeforeCount
    % scatter(InhBeforeCount.Subject, InhBeforeCount.BeforeCount)
    % mean(InhBeforeCount.BeforeCount)
    % std(InhBeforeCount.BeforeCount)
    mean(InhBeforeCount.BeforeCount) + (2 * std(InhBeforeCount.BeforeCount)) % =~8.5
    InhBeforeCount(InhBeforeCount.BeforeCount > 8.5, :);

    % 12 has 9 "before"s; pretest SSRT = .167
    % 157 has 11 "before"s; pretest SSRT = -0.042618
    % 990174 has 16 "before"s; pretest SSRT = -0.1342
    % 199 has 13 "before"s; pretest SSRT = -0.13855
    % 220 has 10 "before"s; pretest SSRT = 0.12757
    % 242 has 13 "before"s; pretest SSRT = 0.082557
    % 419 has 9 "before"s; pretest SSRT = 0.05091
    % 990562 has 9 "before"s; pretest SSRT = .0089
    % 669 has 9 "before"s; pretest SSRT = 0.13873
    % 737 has 10 "before"s; pretest SSRT = 0.07895


    % count the number of times each participant failed a catch trial in PPinhibit 
    InhCatchCount = table(0,0,0,0,0.0,0,0,0,'VariableNames', {'Subject','FailedCatch','WouldveBeenCorrect','AvgFailedCatchRT','CorrectGoPct','AvgGoRT','TotalGoCount','ChanceGoPerformance'});

    allSubjects = unique(PP_inhibitData.Subject);
    for subjIndex = 1:length(allSubjects)
        delMe = PP_inhibitData((PP_inhibitData.Subject == allSubjects(subjIndex)), :);
        delMe2 = delMe(strcmpi(delMe.Inhibit,'S50'),:); % all catch trials
        delMe3 = delMe2(strcmpi(delMe2.InhCorr,'after'),:); % all the ones where they responded 'after' the cue (i.e., failed inhibit)
        delMe8 = (delMe3.RespTime - delMe3.StimTime) / 10000; % failed catch trial response times
        delMe4 = delMe3((delMe3.Animal == 0) & (strcmpi(delMe3.Response, 'right')),:); % no anmial and response = right: correct
        delMe5 = delMe3((delMe3.Animal == 1) & (strcmpi(delMe3.Response, 'left')),:); % yes anmial and response = left: correct
        delMe(strcmpi(delMe.Inhibit,'s50'),:) = []; % done with catch trials; delete them so we can get at Go trials
        delMe.Inhibit = cell2mat(delMe.Inhibit); % turn this into a matrix, so we can use isnan() on it
        delMe6 = delMe(isnan(delMe.Inhibit),:); % Go trials
        delMe7 = height(delMe6(delMe6.Score == 1,:)) / height(delMe6); % correct % of Go trials
        delMe6 = delMe6(isnan(delMe6.RespTime) == 0,:); % Go trials where the participant actually responded
        delMe9 = (delMe6.RespTime - delMe6.StimTime) / 10000; % all Go trial response times
        
        delMe10 = 0; % is this Go performance by chance?
        delMe11 = 1.96 * (sqrt((.5 * (1-.5))/height(delMe6))); % 1.96 * std dev. of probability of getting correct by chance
        if ((delMe7 - .5) < delMe11) % this was by chance
            delMe10 = 1; % can't say this is not by chance
        end

        InhCatchCount(subjIndex,:) = {allSubjects(subjIndex) height(delMe3) (height(delMe4)+height(delMe5)) mean(delMe8) delMe7 mean(delMe9) height(delMe6) delMe10};
    end
    % InhCatchCount
    % scatter(InhCatchCount.Subject, InhCatchCount.FailedCatch)
    % mean(InhCatchCount.FailedCatch)
    % std(InhCatchCount.FailedCatch)
    mean(InhCatchCount.FailedCatch) + (2 * std(InhCatchCount.FailedCatch)) % = ~7.9
    InhCatchCount(InhCatchCount.FailedCatch > 5, :);

    mean(InhCatchCount.CorrectGoPct) - (2 * std(InhCatchCount.CorrectGoPct)) % = ~69

    % 18 failed 6 catch trials; pretest SSRT = .3877
    % 990041 failed 11 catch trials; pretest SSRT = .813
    % 990090 failed 7 catch trials; pretest SSRT = .7004
    % 990134 failed 11 catch trials; pretest SSRT = .8018
    % 990152 failed 11 catch trials; pretest SSRT = .7609
    % 990270 failed 9 catch trials; pretest SSRT = .7947
    % 496 failed 11 catch trials; pretest SSRT = .8669
    % 524 failed 7 catch trials; pretest SSRT = .2797
    % 526 failed 8 catch trials; pretest SSRT = .6059
    % 990606 failed 8 catch trials; pretest SSRT = .4817
    % 990607 failed 11 catch trials; pretest SSRT = .7476
    % 990649 failed 6 catch trials; pretest SSRT = .3290
    % 673 failed 11 catch trials; pretest SSRT = 1.0205
    % 990703 failed 8 catch trials; pretest SSRT = .3367
    % 707 failed 11 catch trials; pretest SSRT = 1.2525
    % 775 failed 11 catch trials; pretest SSRT = 0.8325

    % 10 had 50% correct go trials; pretest SSRT = 0.2056
    % 90 had 50% correct go trials; pretest SSRT = 0.70042
    % 199 had 45% correct go trials; pretest SSRT = -0.13855
    % 435 had 50% correct go trials; pretest SSRT = 0.063998
    % 554 had 48% correct go trials; pretest SSRT = 0.19727
    % 587 had 45% correct go trials; pretest SSRT = 0.17941
    % 663 had 42% correct go trials; pretest SSRT = 0.30267


    % find people who failed a lot of Catch trials in RFinhibit 
    % mean(SSRT_RF_firstShifts_table.CorrectCatchPct) % ~.79
    catchCutoff = mean(SSRT_RF_firstShifts_table.CorrectCatchPct) - (2 * std(SSRT_RF_firstShifts_table.CorrectCatchPct)); % = ~.4
    RF_FailedCatchTable = SSRT_RF_firstShifts_table(SSRT_RF_firstShifts_table.CorrectCatchPct < catchCutoff,:);
    % scatter(SSRT_RF_firstShifts_table.Subject, SSRT_RF_firstShifts_table.CorrectCatchPct)

    % 41 had 29% correct catch trials; first_40_RF SSRT = 0.50
    % 338 had 0% correct catch trials; first_40_RF SSRT = 0.41
    % 562 had 33% correct catch trials; first_40_RF SSRT = 0.88
    % 707 had 0% correct catch trials; first_40_RF SSRT = 1.08
    % 737 had 18% correct catch trials; first_40_RF SSRT = 0.95
    % 771 had 29% correct catch trials; first_40_RF SSRT = 0.70


    % find people who failed a lot of Go trials in RFinhibit 
    % mean(SSRT_RF_firstShifts_table.CorrectGoPct) % ~.90
    
    SSRT_RF_firstShifts_table.ChanceGoPerformance = zeros(height(SSRT_RF_firstShifts_table),1); % assume no chance performance
    for row = 1:height(SSRT_RF_firstShifts_table)
        if ( (SSRT_RF_firstShifts_table.CorrectGoPct(row) - .5) < ...
                (1.96 * (sqrt((.5 * (1 - .5)) / SSRT_RF_firstShifts_table.TotTrials(row)))) )
            SSRT_RF_firstShifts_table.ChanceGoPerformance(row) = 1;
        end
    end
    RF_FailedGoTable = SSRT_RF_firstShifts_table(SSRT_RF_firstShifts_table.ChanceGoPerformance == 1, :);
        
%    goCutoff = mean(SSRT_RF_firstShifts_table.CorrectGoPct) - (2 * std(SSRT_RF_firstShifts_table.CorrectGoPct)) % = ~.76
%    RF_FailedGoTable = SSRT_RF_firstShifts_table(SSRT_RF_firstShifts_table.CorrectGoPct < goCutoff,:);
    
    % scatter(SSRT_RF_firstShifts_table.Subject, SSRT_RF_firstShifts_table.CorrectGoPct)

    % 171 had 72% correct go trials; first_40_RF SSRT = 0.41
    % 199 had 50% correct go trials; first_40_RF SSRT = 0.20
    % 435 had 56% correct go trials; first_40_RF SSRT = 0.27
    % 476 had 68% correct go trials; first_40_RF SSRT = 0.30
    % 496 had 74% correct go trials; first_40_RF SSRT = 0.68
    % 499 had 76% correct go trials; first_40_RF SSRT = 0.40
    % 781 had 75% correct go trials; first_40_RF SSRT = 0.42



end
