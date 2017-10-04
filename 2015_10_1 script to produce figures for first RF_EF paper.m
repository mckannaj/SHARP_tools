% Zephy McKanna
% Script to produce figures for RF/EF paper
% 10/1/15
%



% first, determine noncompliant subjects in each EF
             
% from 2015_4_26 script: find Inhibit failures        
    includedPPinhibit = excludeSubjects_RF_1B(true, true, zPPinhibit_1B);
    includedPPinhibit(strcmpi(includedPPinhibit.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
    [delMe, delMe2, delMe3, delMe4] = exploreSSRT_1B(includedPPinhibit, SSRT_RF_firstShifts_table)
    delMe2(delMe2.ChanceGoPerformance == 1,:) % subjects with "chance" go performance
%{ failed Pretest Inhibit
12 % beforeCount (BC)*
157 % BC
174 % BC
199 % BC, CG
220 % BC
242 % BC
419 % BC*
562 % BC*
669 % BC*
737 % BC
41 % failedCatch (FC)
134 % FC
152 % FC
270 % FC*
496 % FC
607 % FC
673 % FC
707 % FC
775 % FC
10 % correctGo (< 1.96 * sigma) (CG)
90 % CG
435 % CG
554 % CG
587 % CG
663 % CG
% Pretest Inhibit
[12; 157; 174; 199; 220;242; 419; 562; 669; 737; 41; 134; 152; 270; 496; 607; 673; 707; 775; 10; 90; 435; 554; 587; 663]

%RF Inhibit
% failed RF catch (< 33%)
[41; 338; 562; 707; 737; 771]
    
% failed RF Go (< 1.96 * sigma)
[199; 435]




% now find Switch failures
includedPPSwitch = excludeSubjects_RF_1B(true, true, zPPswitch_1B);
delMe = table(0,0,0.0,0,0.0,'VariableNames', {'Subject','Task1_TrialCount','Task1_CorrectPct','Task2_TrialCount','Task2_CorrectPct'});
delMe5 = unique(includedPPSwitch.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedPPSwitch(includedPPSwitch.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe7 = delMe6(strcmpi(delMe6.Cue, 'cross'), :); % delMe7 = subjTask1Trials
    delMe11 = height(delMe7(strcmpi(delMe7.Score, 'timeout'),:)); % delMe11 = number of timeouts (add to errors)
    delMe7(strcmpi(delMe7.Score, 'timeout'),:) = []; % delete timeouts, so we can make "Score" non-cell
    delMe7.Score = cell2mat(delMe7.Score);
    delMe8 = height(delMe7(delMe7.Score == 1,:)) / (height(delMe7) + delMe11); % delMe8 = subjTask1Correct
    delMe9 = delMe6(strcmpi(delMe6.Cue, 'heart'), :); % delMe9 = subjTask2Trials
    delMe11 = height(delMe9(strcmpi(delMe9.Score, 'timeout'),:)); % delMe11 = number of timeouts (add to errors)
    delMe9(strcmpi(delMe9.Score, 'timeout'),:) = []; % delete timeouts, so we can make "Score" non-cell
    delMe9.Score = cell2mat(delMe9.Score);
    delMe10 = height(delMe9(delMe9.Score == 1,:)) / (height(delMe9) + delMe11);  % delMe10 = subjTask2Correct
    delMe(delMe4,:) = {delMe5(delMe4) (height(delMe7) + delMe11) delMe8 (height(delMe9) + delMe11) delMe10};
end
delMe.T1_ChancePerf = zeros(height(delMe),1); % assume no chance performance
delMe.T2_ChancePerf = zeros(height(delMe),1); % assume no chance performance
for row = 1:height(delMe)
    if ( (delMe.Task1_CorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.Task1_TrialCount(row)))) )
        delMe.T1_ChancePerf(row) = 1;
    end
    if ( (delMe.Task2_CorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.Task2_TrialCount(row)))) )
        delMe.T2_ChancePerf(row) = 1;
    end
end
delMe((delMe.T1_ChancePerf == 1) & (delMe.T2_ChancePerf == 0),:) % cross task
delMe((delMe.T1_ChancePerf == 0) & (delMe.T2_ChancePerf == 1),:) % heart task
delMe((delMe.T1_ChancePerf == 1) & (delMe.T2_ChancePerf == 1),:) % both
    
figure
hist([delMe.Task1_CorrectPct delMe.Task2_CorrectPct])
    title('Pretest Switch accuracy: blue=size(<>soccer ball), yellow=living/nonliving');
    xlabel('Accuracy')
    ylabel('Count')

    
% failed Pretest switch
% 'cross' task
[10; 40; 41; 69; 81; 254; 404; 412; 419; 450; 532; 679; 685; 718; 737; 744; 749; 771]
% 'heart' task
[241]
% both tasks
[88; 270; 275; 435; 474; 663]
% all/total Pretest switch
[10; 40; 41; 69; 81; 254; 404; 412; 419; 450; 532; 679; 685; 718; 737; 744; 749; 771; 241; 88; 270; 275; 435; 474; 663]



    

% RF switch
delMe2 = first_N_RFshifts(strcmpi(first_N_RFshifts.Cluster, 's'),:);
delMe = table(0,0,0.0,0,0.0,'VariableNames', {'Subject','Task1_TrialCount','Task1_CorrectPct','Task2_TrialCount','Task2_CorrectPct'});
delMe5 = unique(delMe2.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = delMe2(delMe2.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe7 = delMe6(strncmpi(delMe6.NextState, 'TASK_1', 6), :); % delMe7 = subjTask1Trials
    delMe8 = height(delMe7(delMe7.Correct == true,:)) / height(delMe7);
    delMe9 = delMe6(strncmpi(delMe6.NextState, 'TASK_2', 6), :); % delMe9 = subjTask2Trials
    delMe10 = height(delMe9(delMe9.Correct == true,:)) / height(delMe9);
    delMe(delMe4,:) = {delMe5(delMe4) height(delMe7) delMe8 height(delMe9) delMe10};
end
delMe.T1_ChancePerf = zeros(height(delMe),1); % assume no chance performance
delMe.T2_ChancePerf = zeros(height(delMe),1); % assume no chance performance
for row = 1:height(delMe)
    if ( (delMe.Task1_CorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.Task1_TrialCount(row)))) )
        delMe.T1_ChancePerf(row) = 1;
    end
    if ( (delMe.Task2_CorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.Task2_TrialCount(row)))) )
        delMe.T2_ChancePerf(row) = 1;
    end
end
delMe((delMe.T1_ChancePerf == 1) & (delMe.T2_ChancePerf == 0),:) % task 1
delMe((delMe.T1_ChancePerf == 0) & (delMe.T2_ChancePerf == 1),:) % task 2
delMe((delMe.T1_ChancePerf == 1) & (delMe.T2_ChancePerf == 1),:) % both

figure
hist([delMe.Task1_CorrectPct delMe.Task2_CorrectPct])
    title('RF Switch accuracy: blue=Task1, yellow=Task2');
    xlabel('Accuracy')
    ylabel('Count')


% task 1
[88; 291; 412; 586; 634; 707; 781]
% task 2
[40; 137; 199; 312; 345; 435; 476; 499; 644; 701; 718; 744; 749; 771]
% both 
[50; 195; 208; 241; 270; 404; 496; 526; 562; 572; 663; 669; 673; 737]
% all/total RF switch 
[88; 291; 412; 586; 634; 707; 781; 40; 137; 199; 312; 345; 435; 476; 499; 644; 701; 718; 744; 749; 771; 50; 195; 208; 241; 270; 404; 496; 526; 562; 572; 663; 669; 673; 737]




% PP update
includedPPupdate = excludeSubjects_RF_1B(true, true, zPPupdate_1B_singleTrials);
delMe = table(0,0,0.0,0.0,'VariableNames', {'Subject','TrialCount','Let_CorrectPct','Arr_CorrectPct'});
delMe5 = unique(includedPPupdate.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedPPupdate(includedPPupdate.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe8 = height(delMe6(strcmpi(delMe6.LetScore, 'correct'), :)) / height(delMe6);
    delMe10 = height(delMe6(strcmpi(delMe6.ArrScore, 'correct'), :)) / height(delMe6);
    
    delMe(delMe4,:) = {delMe5(delMe4) height(delMe6) delMe8 delMe10};
end
delMe.Let_ChancePerf = zeros(height(delMe),1); % assume no chance performance
delMe.Arr_ChancePerf = zeros(height(delMe),1); % assume no chance performance
for row = 1:height(delMe)
    if ( (delMe.Let_CorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.TrialCount(row)))) )
        delMe.Let_ChancePerf(row) = 1;
    end
    if ( (delMe.Arr_CorrectPct(row) - 0.0625) < ...  % zNOTE: chance here is 1/16 = .0625
            (1.96 * (sqrt((0.0625 * (1 - 0.0625)) / delMe.TrialCount(row)))) )
        delMe.Arr_ChancePerf(row) = 1;
    end
end
delMe((delMe.Let_ChancePerf == 1) & (delMe.Arr_ChancePerf == 0),:) % letters
delMe((delMe.Let_ChancePerf == 0) & (delMe.Arr_ChancePerf == 1),:) % arrows
delMe((delMe.Let_ChancePerf == 1) & (delMe.Arr_ChancePerf == 1),:) % both

% Pretest update: letters fail
[496; 572; 644; 669; 771]
% Pretest update: arrows fail (zNOTE: chance here is 1/16 = .0625)
[none]


% RF update (zNote: maybe should separate N-back from non-N-back trials?) 
delMe2 = first_N_RFshifts(strcmpi(first_N_RFshifts.Cluster, 'u'),:);
delMe = table(0,0,0.0,'VariableNames', {'Subject','TrialCount','TotalCorrectPct'});
delMe5 = unique(delMe2.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = delMe2(delMe2.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe8 = height(delMe6(delMe6.Correct == true,:)) / height(delMe6);
    delMe(delMe4,:) = {delMe5(delMe4) height(delMe6) delMe8};
end
delMe.ChancePerf = zeros(height(delMe),1); % assume no chance performance
for row = 1:height(delMe)
    if ( (delMe.TotalCorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.TrialCount(row)))) )
        delMe.ChancePerf(row) = 1;
    end
end
delMe((delMe.ChancePerf == 1),:) % subjs with chance performance

% all/total RF update 
[199]




% Aggregated noncompliance list (put into excludeSubjects_RF_1B())

% Failed Pretest and not RF
% Inhibit: 19
[12; 157; 174; 220; 242; 419; 669; 134; 152; 270; 496; 607; 673; 775; 10; 90; 554; 587; 663]
% Switch: 12
[10; 41; 69; 81; 254; 275; 419; 450; 474; 532; 679; 685]
% Update: 5
[496; 572; 644; 669; 771]
    
% Failed RF and not Pretest
% Inhibit: 2
[338; 771]
% Switch: 22
[50; 137; 195; 199; 208; 291; 312; 345; 476; 496; 499; 526; 562; 572; 586; 634; 644; 669; 673; 701; 707; 781]
% Update: 1
[199]
    
% Failed both
% Inhibit: 6
[41; 199; 435; 562; 707; 737]
% Switch: 13
[40; 88; 241; 270; 404; 412; 435; 663; 718; 737; 744; 749; 771]
% Update: 0
[none]











