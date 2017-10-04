% Zephy McKanna
% Script to produce figures for RF/EF paper
% 10/1/15
%


if (exist('zPPinhibit_1B', 'var') == 0) % if we don't have this variable, assume we don't have any of them...
    [zPPinhibit_1B, zPPswitch_1B, zPPupdate_1B] = formTables_RF_1A3('1b-final-Parsed.inhibit.xlsx', '1b-final-Parsed.switch.xlsx', '1b-final-Parsed.rotation.xlsx', true);
end
[zRFData_1B, zRFSum_1B, ~] = formTables_RF_1A3('1b-final-Parsed.rf-data.xlsx', '1b-final-Parsed.rf-sum.xlsx', '', true);


% GET INFO ABOUT PARTICIPANTS TO DESCRIBE THEM IN A PAPER
% first, ensure that all the groups of subjects we're using are the same
%delMe7 = excludeSubjects_RF_1B(false, false, false, first_N_RFshifts); % zNOTE: this works just the same (sanity check) 
delMe7 = excludeSubjects_RF_1B(false, false, false, zRFSum_1B); % first, just start with the included subjects
[delMe8, delMe9] = removeNonMatchingSubjects(delMe7.Subject, delMe7, zPPinhibit_1B.Subject, zPPinhibit_1B, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe8.Subject)) % 332     <--- TOTAL PARTICIPANTS (zNOTE: **NOT** JUST THE ONES THAT FINISHED!!!!)
length(unique(delMe9.Subject)) % 332
[delMe8, delMe9] = removeNonMatchingSubjects(delMe8.Subject, delMe8, zPPswitch_1B.Subject, zPPswitch_1B, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe9.Subject)) % sanity check: should also be 331 (apparently somebody didn't do Switch???)
[delMe8, delMe9] = removeNonMatchingSubjects(delMe8.Subject, delMe8, zPPupdate_1B.Subject, zPPupdate_1B, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe9.Subject)) % sanity check: should also be 331
% then, describe them
delMe7 = []; % clear it, then get one line per subject (for demographics)
delMe6 = unique(delMe8.Subject); 
for delMe5 = 1:(length(delMe6))
    delMe4 = delMe9(delMe9.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
height(delMe7) % sanity check: should also be 331
length(unique(delMe7.Subject)) % sanity check: should also be 331
height(delMe7(strcmpi(delMe7.Gender, 'Male'),:)) % 75     <--- MALE PARTICIPANTS
height(delMe7(strcmpi(delMe7.Gender, 'Female'),:)) % 79
min(delMe7.Age) % 18     <--- PARTICIPANTS' AGE RANGE: MIN
max(delMe7.Age) % 64    <--- PARTICIPANTS' AGE RANGE: MAX
nanmean(delMe7.Age) % 24    <--- PARTICIPANTS' AGE RANGE: AVG
std(delMe7.Age) % 5.7    <--- PARTICIPANTS' AGE RANGE: SD
median(delMe7.Age) % 23    <--- PARTICIPANTS' AGE RANGE: MEDIAN
delMe7(strcmpi(delMe7.EduYears,'20+'),:).EduYears = {20}; % some chucklehead wrote a string rather than a number; replace it
delMe7.EduYears = cell2mat(delMe7.EduYears); % now that they're all numbers, we can make it a matrix rather than a cell structure
min(delMe7.EduYears) % 5     <--- PARTICIPANTS' EDUCATION RANGE: MIN
max(delMe7.EduYears) % 24     <--- PARTICIPANTS' EDUCATION RANGE: MAX
mean(delMe7.EduYears) % 16     <--- PARTICIPANTS' EDUCATION RANGE: AVG
median(delMe7.EduYears) % 16     <--- PARTICIPANTS' EDUCATION RANGE: MEDIAN
unique(delMe7.Institution)
height(delMe7(strcmpi(delMe7.Institution, 'NEU'),:)) % 96     <--- PARTICIPANTS WHO TRAINED AT NEU
height(delMe7(strcmpi(delMe7.Institution, 'Harvard'),:)) % 78     <--- PARTICIPANTS WHO TRAINED AT HARVARD
height(delMe7(strcmpi(delMe7.Institution, 'Honeywell'),:)) % 85     <--- PARTICIPANTS WHO TRAINED AT HONEYWELL
height(delMe7(strcmpi(delMe7.Institution, 'Oxford'),:)) % 72     <--- PARTICIPANTS WHO TRAINED AT OXFORD

% now find out info for just the sham stimulated RF groups
height(delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:)) % 56     <--- PARTICIPANTS WHO HAD SHAM STIMULATION
height(delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)) % 58     <--- PARTICIPANTS WHO HAD SHAM STIMULATION

delMe10 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe10 = [delMe10; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
height(delMe10(strcmpi(delMe10.Gender, 'Female'),:)) % 79

% now for everybody
delMe7 = []; % clear it, then get one line per subject (for demographics)
delMe6 = unique(zPPinhibit_1B.Subject);
length(delMe6) % 483 = TOTAL ACCEPTED INTO STUDY
for delMe5 = 1:(length(delMe6))
    delMe4 = zPPinhibit_1B(zPPinhibit_1B.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
height(delMe7(strcmpi(delMe7.Institution, 'NEU'),:)) % 142     <--- PARTICIPANTS WHO TRAINED AT NEU (Accepted, not Finished)
height(delMe7(strcmpi(delMe7.Institution, 'Harvard'),:)) % 126     <--- PARTICIPANTS WHO TRAINED AT HARVARD (Accepted, not Finished)
height(delMe7(strcmpi(delMe7.Institution, 'Honeywell'),:)) % 115     <--- PARTICIPANTS WHO TRAINED AT HONEYWELL (Accepted, not Finished)
height(delMe7(strcmpi(delMe7.Institution, 'Oxford'),:)) % 100     <--- PARTICIPANTS WHO TRAINED AT OXFORD (Accepted, not Finished)

delMe7 = []; % clear it, then get one line per subject (for demographics)
delMe8 = excludeSubjects_RF_1B(false, true, false, zPPinhibit_1B); % just get the people who Finished the study
delMe6 = unique(delMe8.Subject);
length(delMe6) % 391 = TOTAL FINISHED
for delMe5 = 1:(length(delMe6))
    delMe4 = zPPinhibit_1B(zPPinhibit_1B.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
height(delMe7(strcmpi(delMe7.Institution, 'NEU'),:)) % 106     <--- PARTICIPANTS WHO TRAINED AT NEU (Finished)
height(delMe7(strcmpi(delMe7.Institution, 'Harvard'),:)) % 95     <--- PARTICIPANTS WHO TRAINED AT HARVARD (Finished)
height(delMe7(strcmpi(delMe7.Institution, 'Honeywell'),:)) % 102     <--- PARTICIPANTS WHO TRAINED AT HONEYWELL (Finished)
height(delMe7(strcmpi(delMe7.Institution, 'Oxford'),:)) % 88     <--- PARTICIPANTS WHO TRAINED AT OXFORD (Finished)
height(delMe7(strcmpi(delMe7.Gender, 'Female'),:)) % 172 Female (Finished)
delMe = height(delMe7(strcmpi(delMe7.Condition, 'RF tDCS'),:)) % 99 RF_tDCS (Finished)
delMe2 = height(delMe7(strcmpi(delMe7.Condition, 'RF tRNS'),:)) % 95 RF_tRNS (Finished)
delMe3 = height(delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:)) % 42 RF_tDCS_Sham (Finished)
delMe4 = height(delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)) % 48 RF_tRNS_Sham (Finished)
delMe5 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS'),:);
delMe5 = [delMe5; delMe7(strcmpi(delMe7.Condition, 'RF tRNS'),:)];
delMe5 = [delMe5; delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:)];
delMe5 = [delMe5; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
height(delMe5) % 284 total RF (Finished)
delMe+delMe2+delMe3+delMe4 % sanity check: still 284 total RF (Finished)
height(delMe7) - height(delMe5) % 107 total AC (Finished)
height(delMe5(strcmpi(delMe5.Gender, 'Female'),:)) % 132 Female (RF+Finished)
delMe6 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe6 = [delMe6; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
height(delMe6) % 90 total Sham RF (Finished)
delMe3+delMe4 % sanity check: still 90 Sham RF (Finished)
height(delMe6(strcmpi(delMe6.Gender, 'Female'),:)) % 43 Female (RF_Sham+Finished)
height(delMe6(strcmpi(delMe6.Institution, 'NEU'),:)) % 23     <--- PARTICIPANTS WHO TRAINED AT NEU (RF+Sham+Finished)
height(delMe6(strcmpi(delMe6.Institution, 'Harvard'),:)) % 22     <--- PARTICIPANTS WHO TRAINED AT HARVARD (RF+Sham+Finished)
height(delMe6(strcmpi(delMe6.Institution, 'Honeywell'),:)) % 25     <--- PARTICIPANTS WHO TRAINED AT HONEYWELL (RF+Sham+Finished)
height(delMe6(strcmpi(delMe6.Institution, 'Oxford'),:)) % 20     <--- PARTICIPANTS WHO TRAINED AT OXFORD (RF+Sham+Finished)
delMe8 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe8 = [delMe8; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
delMe8 = [delMe8; delMe7(strcmpi(delMe7.Condition, 'AC tDCS Sham'),:)];
delMe8 = [delMe8; delMe7(strcmpi(delMe7.Condition, 'AC tRNS Sham'),:)];
height(delMe8) % 197 total (AC+RF_Sham+Finished)
height(delMe8(strcmpi(delMe8.Gender, 'Female'),:)) % 83 Female (AC+RF_Sham+Finished)
height(delMe8(strcmpi(delMe8.Institution, 'NEU'),:)) % 53     <--- PARTICIPANTS WHO TRAINED AT NEU (AC+RF+Sham+Finished)
height(delMe8(strcmpi(delMe8.Institution, 'Harvard'),:)) % 48     <--- PARTICIPANTS WHO TRAINED AT HARVARD (AC+RF+Sham+Finished)
height(delMe8(strcmpi(delMe8.Institution, 'Honeywell'),:)) % 52     <--- PARTICIPANTS WHO TRAINED AT HONEYWELL (AC+RF+Sham+Finished)
height(delMe8(strcmpi(delMe8.Institution, 'Oxford'),:)) % 44     <--- PARTICIPANTS WHO TRAINED AT OXFORD (AC+RF+Sham+Finished)

% now find out about people who *didn't* finish
delMe8 = excludeSubjects_RF_1B(false, true, false, zPPinhibit_1B); % just get the people who Finished the study
delMe7 = unique(zPPinhibit_1B.Subject);
delMe5 = unique(delMe8.Subject);
delMe6 = setdiff(delMe7, delMe5); % subj numbers who did not finish
length(delMe6) % 92 did not finish
delMe7 = []; % clear it, then get one line per subject (for demographics)
for delMe5 = 1:(length(delMe6))
    delMe4 = zPPinhibit_1B(zPPinhibit_1B.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
height(delMe7) % sanity check; still 92
delMe8 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe8 = [delMe8; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
delMe8 = [delMe8; delMe7(strcmpi(delMe7.Condition, 'AC tDCS Sham'),:)];
delMe8 = [delMe8; delMe7(strcmpi(delMe7.Condition, 'AC tRNS Sham'),:)];
height(delMe8) % 46 (total sham did not finish)
delMe8 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe8 = [delMe8; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
height(delMe8) % 28 (RF sham did not finish)
delMe8 = delMe7(strcmpi(delMe7.Condition, 'AC tDCS Sham'),:);
delMe8 = [delMe8; delMe7(strcmpi(delMe7.Condition, 'AC tRNS Sham'),:)];
height(delMe8) % 18 (AC sham did not finish)



% Now add the info about Active Control people
delMe1 = excludeSubjects_RF_1B(false, true, false, zACsilo_SUM_1B); % make sure we're only dealing with people who Finished (or Finished*)
delMe2 = excludeSubjects_RF_1B(false, true, false, zACthumb_SUM_1B); % make sure we're only dealing with people who Finished (or Finished*)
delMe3 = excludeSubjects_RF_1B(false, true, false, zACvisSearch_SUM_1B); % make sure we're only dealing with people who Finished (or Finished*)
% make sure we have the same number of Finished subjects in all three AC tasks (would be crazy otherwise, but check) 
[delMe8, delMe9] = removeNonMatchingSubjects(delMe2.Subject, delMe2, delMe1.Subject, delMe1, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe8.Subject)) % 112     <--- THUMB + SILO PARTICIPANTS
length(unique(delMe9.Subject)) % 112
[delMe8, delMe9] = removeNonMatchingSubjects(delMe2.Subject, delMe2, delMe3.Subject, delMe3, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe8.Subject)) % 112     <--- THUMB + VIS PARTICIPANTS
length(unique(delMe9.Subject)) % 112
[delMe8, delMe9] = removeNonMatchingSubjects(delMe3.Subject, delMe3, delMe1.Subject, delMe1, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe8.Subject)) % 112     <--- VIS + SILO PARTICIPANTS
length(unique(delMe9.Subject)) % 112
delMe7 = []; % clear it, then get one line per subject (for demographics)
delMe6 = unique(delMe8.Subject); 
for delMe5 = 1:(length(delMe6))
    delMe4 = delMe9(delMe9.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
height(delMe7) % sanity check: should also be 112
length(unique(delMe7.Subject)) % sanity check: should also be 112
height(delMe7(strcmpi(delMe7.Gender, 'Male'),:)) % 71     <--- MALE PARTICIPANTS
height(delMe7(strcmpi(delMe7.Gender, 'Female'),:)) % 41
min(delMe7.Age) % 18     <--- PARTICIPANTS' AGE RANGE: MIN
max(delMe7.Age) % 65    <--- PARTICIPANTS' AGE RANGE: MAX
mean(delMe7.Age) % 24.76    <--- PARTICIPANTS' AGE RANGE: AVG
std(delMe7.Age) % 7.5    <--- PARTICIPANTS' AGE RANGE: SD
median(delMe7.Age) % 23    <--- PARTICIPANTS' AGE RANGE: MEDIAN
min(delMe7.EduYears) % 6     <--- PARTICIPANTS' EDUCATION RANGE: MIN
max(delMe7.EduYears) % 30     <--- PARTICIPANTS' EDUCATION RANGE: MAX
mean(delMe7.EduYears) % 16.5     <--- PARTICIPANTS' EDUCATION RANGE: AVG
std(delMe7.EduYears) % 2.7    <--- PARTICIPANTS' EDUCATION RANGE: SD
median(delMe7.EduYears) % 16     <--- PARTICIPANTS' EDUCATION RANGE: MEDIAN
unique(delMe7.Institution)
height(delMe7(strcmpi(delMe7.Institution, 'NEU'),:)) % 34     <--- PARTICIPANTS WHO TRAINED AT NEU
height(delMe7(strcmpi(delMe7.Institution, 'Harvard'),:)) % 27     <--- PARTICIPANTS WHO TRAINED AT HARVARD
height(delMe7(strcmpi(delMe7.Institution, 'Oxford'),:)) % 24     <--- PARTICIPANTS WHO TRAINED AT OXFORD
height(delMe7(strcmpi(delMe7.Institution, 'Honeywell'),:)) % 27     <--- PARTICIPANTS WHO TRAINED AT HONEYWELL


% find out why Sham group from RF has different number than Sham group from pre/post EF 
delMe7 = []; % next few lines stolen from up above, where we do demographic analyses
delMe8 = excludeSubjects_RF_1B(false, true, false, zRFSum_1B); % just get the people who Finished the study
delMe6 = unique(delMe8.Subject);
for delMe5 = 1:(length(delMe6))
    delMe4 = zRFSum_1B(zRFSum_1B.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
delMe6 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe6 = [delMe6; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
delMe5 = unique(delMe6.Subject); % THIS IS THE SHAM+RF Subj list
length(delMe5) % there are 93 RF+sham subjects who finished
delMe2 = delMe5; % store these subjIDs
delMe7 = []; % do the same thing, but with Inhibit instead of RF_SUM
delMe8 = excludeSubjects_RF_1B(false, true, false, zPPinhibit_1B); % just get the people who Finished the study
delMe6 = unique(delMe8.Subject);
for delMe5 = 1:(length(delMe6))
    delMe4 = zPPinhibit_1B(zPPinhibit_1B.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
delMe6 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe6 = [delMe6; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
delMe5 = unique(delMe6.Subject); % THIS IS THE SHAM+RF Subj list
length(delMe5) % there are 90 RF+sham subjects who finished

delMe2(~ismember(delMe2, delMe5)) % SUBJECTS 125, 220, 500 ARE WEIRD

% find out more about these subjects
delMe = zPPinhibit_1B(zPPinhibit_1B.Subject == 125,:);
delMe.Condition(1) % 'Finished*'
delMe.Status(1) % 'RF tDCS'
delMe2 = zRFSum_1B(zRFSum_1B.Subject == 125,:);
delMe2.Condition(1) % 'Finished'
delMe2.Status(1) % 'RF tDCS Sham'

delMe = zPPinhibit_1B(zPPinhibit_1B.Subject == 220,:);
delMe.Condition(1) % 'Finished*'
delMe.Status(1) % 'RF tRNS'
delMe2 = zRFSum_1B(zRFSum_1B.Subject == 220,:);
delMe2.Condition(1) % 'Finished'
delMe2.Status(1) % 'RF tRNS Sham'

delMe = zPPinhibit_1B(zPPinhibit_1B.Subject == 500,:);
delMe.Condition(1) % 'Finished*'
delMe.Status(1) % 'RF tDCS'
delMe2 = zRFSum_1B(zRFSum_1B.Subject == 500,:);
delMe2.Condition(1) % 'Finished'
delMe2.Status(1) % 'RF tRNS Sham'








% now determine noncompliant subjects in each EF
             
% from 2015_4_26 script: find Inhibit failures        
[SSRT_RF_firstShifts_table] = getSSRT_RF_1B(first_N_RFshifts, 'single', false, true, false);  
    includedPPinhibit = excludeSubjects_RF_1B(true, true, false, zPPinhibit_1B);
    includedPPinhibit(strcmpi(includedPPinhibit.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
    [delMe, delMe2, delMe3, delMe4] = exploreSSRT_1B(includedPPinhibit, SSRT_RF_firstShifts_table)
    delMe2(delMe2.ChanceGoPerformance == 1,:) % subjects with "chance" go performance
    % now do the same for Posttest
    includedPPinhibit = excludeSubjects_RF_1B(true, true, false, zPPinhibit_1B);
    includedPPinhibit(strcmpi(includedPPinhibit.Period,'4-Posttest') == 0, :) = []; % only grab the posttest data
    [delMe, delMe2, delMe3, delMe4] = exploreSSRT_1B(includedPPinhibit, SSRT_RF_firstShifts_table)
    delMe2(delMe2.ChanceGoPerformance == 1,:) % subjects with "chance" go performance
%{ failed Pretest Inhibit
264 % beforeCount (BC)* (>= 12)
290 % BC
401 % BC
693 % BC
16 % failedCatch (FC) (>= 9)
30 % FC
107 % FC
109 % FC*
117 % FC
214 % FC
230 % FC
238 % FC
284 % FC
336 % FC
414 % FC
451 % FC
608 % FC
688 % FC
700 % FC
17 % correctGo (< 1.96 * sigma) (CG)
20 % CG
40 % CG
59 % CG
91 % CG
120 % CG
125 % CG
128 % CG
264 % CG
301 % CG
329 % CG
420 % CG
612 % CG
698 % CG
% Pretest Inhibit (?)
[z: fill this out!]
% Now do the same for Posttest
[271; 302; 493; 719] % BC (>= 12)
[16; 21; 42; 74; 107; 245; 451; 683; 701] % FC (>= 9)
[24; 230; 316; 698] % CG
% Total: 17

%RF Inhibit
% failed RF catch (< 33%)
[41; 338; 562; 707; 737; 771]
    
% failed RF Go (< 1.96 * sigma)
[199; 435]




% now find Switch failures
includedPPSwitch = excludeSubjects_RF_1B(true, true, false, zPPswitch_1B);
includedPPSwitch(strcmpi(includedPPSwitch.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
% only do per or post, not both...      includedPPSwitch(strcmpi(includedPPSwitch.Period,'4-Posttest') == 0, :) = []; % OR: only grab the posttest data
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
[5; 8; 15; 71; 80; 87; 108; 117; 202; 203; 216; 232; 249; 251; 257; 270; 273; 275; 277; 302; 316; 401; 408; 414; 424; 449; 450; 458; 473; 490; 496; 602; 641; 652; 660; 683; 720]
% 'heart' task
[77; 81; 104; 122; 319; 459; 615; 647; 701; 702]
% both tasks
[17; 20; 24; 40; 55; 59; 70; 91; 100; 115; 120; 125; 128; 230; 264; 282; 301; 420; 421; 444; 453; 456; 481; 493; 612; 619; 698; 722]
% all/total Pretest switch (75)
[5; 8; 15; 71; 80; 87; 108; 117; 202; 203; 216; 232; 249; 251; 257; 270; 273; 275; 277; 302; 316; 401; 408; 414; 424; 449; 450; 458; 473; 490; 496; 602; 641; 652; 660; 683; 720; 77; 81; 104; 122; 319; 459; 615; 647; 701; 702; 17; 20; 24; 40; 55; 59; 70; 91; 100; 115; 120; 125; 128; 230; 264; 282; 301; 420; 421; 444; 453; 456; 481; 493; 612; 619; 698; 722]

% failed Posttest switch
% 'cross' task
[81; 114; 119; 132; 204; 249; 283; 302; 403; 444; 449; 450; 458; 493; 602; 640; 652; 664; 687; 698; 702; 719]
% 'heart' task
[481]
% both tasks
[24; 71; 74; 91; 115; 128; 224; 230; 316; 319; 421; 691]
% all/total Posttest switch (35)
[81; 114; 119; 132; 204; 249; 283; 302; 403; 444; 449; 450; 458; 493; 602; 640; 652; 664; 687; 698; 702; 719; 481; 24; 71; 74; 91; 115; 128; 224; 230; 316; 319; 421; 691]


    

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
% only if you don't have it:      zPPupdate_1B_singleTrials = singleArrowPerTrial_PP_1B(zPPupdate_1B, false); % make the usual PPupdate into one-arrow-per-line
includedPPupdate = excludeSubjects_RF_1B(true, true, false, zPPupdate_1B_singleTrials);
includedPPupdate(strcmpi(includedPPupdate.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
% only do per or post, not both...      includedPPupdate(strcmpi(includedPPupdate.Period,'4-Posttest') == 0, :) = []; % OR: only grab the posttest data
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
[20; 80; 91; 275; 347; 426; 430; 451; 637]
% Pretest update: arrows fail (zNOTE: chance here is 1/16 = .0625)
[125; 502]
% Pretest update: both fail
[115; 251]
% all/total Pretest update (13)
[20; 80; 91; 275; 347; 426; 430; 451; 637; 125; 502; 115; 251]

% Posttest update: letters fail
[80; 91; 275; 426; 449; 451]
% Posttest update: arrows fail (zNOTE: chance here is 1/16 = .0625)
[none]
% Posttest update: both fail
[115]
% all/total Posttest update (7)
[80; 91; 275; 426; 449; 451; 115]



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

% All failures (includes duplicates!)
delMe = [12; 157; 174; 220; 242; 419; 669; 134; 152; 270; 496; 607; 673; 775; 10; 90; 554; 587; 663; ...
    10; 41; 69; 81; 254; 275; 419; 450; 474; 532; 679; 685; ...
    496; 572; 644; 669; 771; ...
    338; 771; ...
    50; 137; 195; 199; 208; 291; 312; 345; 476; 496; 499; 526; 562; 572; 586; 634; 644; 669; 673; 701; 707; 781; ...
    199; ...
    41; 199; 435; 562; 707; 737; ...
    40; 88; 241; 270; 404; 412; 435; 663; 718; 737; 744; 749; 771]
delMe = unique(delMe); % just individuals
length(delMe) % 60 total people are noncompliant

u




% now find Active Control failures
includedACSilo = excludeSubjects_RF_1B(false, true, false, zACsilo_ALL_1B);
delMe = table(0,0,0.0,'VariableNames', {'Subject','TrialCount','CorrectPct'});
delMe5 = unique(includedACSilo.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedACSilo(includedACSilo.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe11 = height(delMe6(strcmpi(delMe6.Score, 'timeout'),:)); % delMe11 = number of timeouts (add to errors)
    delMe6(strcmpi(delMe6.Score, 'timeout'),:) = []; % delete timeouts, so we can make "Score" non-cell
    delMe6.Score = cell2mat(delMe6.Score);
    delMe8 = height(delMe6(delMe6.Score == 1,:)) / (height(delMe6) + delMe11); % delMe8 = subjTask1Correct
    delMe(delMe4,:) = {delMe5(delMe4) (height(delMe6) + delMe11) delMe8};
end
delMe.ChancePerf = zeros(height(delMe),1); % assume no chance performance
for row = 1:height(delMe)
    if ( (delMe.CorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.TrialCount(row)))) )
        delMe.ChancePerf(row) = 1;
    end
end
delMe(delMe.ChancePerf == 1,:) % Chance performers (NONE???)


includedACThumb = excludeSubjects_RF_1B(false, true, false, zACthumb_ALL_1B);
delMe = table(0,0,0.0,'VariableNames', {'Subject','TrialCount','CorrectPct'});
delMe5 = unique(includedACThumb.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedACThumb(includedACThumb.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe11 = height(delMe6(strcmpi(delMe6.Score, 'timeout'),:)); % delMe11 = number of timeouts (add to errors)
    delMe6(strcmpi(delMe6.Score, 'timeout'),:) = []; % delete timeouts, so we can make "Score" non-cell
    delMe6.Score = cell2mat(delMe6.Score);
    delMe8 = height(delMe6(delMe6.Score == 1,:)) / (height(delMe6) + delMe11); % delMe8 = subjTask1Correct
    delMe(delMe4,:) = {delMe5(delMe4) (height(delMe6) + delMe11) delMe8};
end
delMe.ChancePerf = zeros(height(delMe),1); % assume no chance performance
for row = 1:height(delMe)
    if ( (delMe.CorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.TrialCount(row)))) )
        delMe.ChancePerf(row) = 1;
    end
end
delMe(delMe.ChancePerf == 1,:) % Chance performers (NONE???)



includedACVis = excludeSubjects_RF_1B(false, true, false, zACvisSearch_ALL_1B);
delMe = table(0,0,0.0,'VariableNames', {'Subject','TrialCount','CorrectPct'});
delMe5 = unique(includedACVis.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedACVis(includedACVis.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe11 = height(delMe6(strcmpi(delMe6.Score, 'timeout'),:)); % delMe11 = number of timeouts (add to errors)
    delMe6(strcmpi(delMe6.Score, 'timeout'),:) = []; % delete timeouts, so we can make "Score" non-cell
    delMe6.Score = cell2mat(delMe6.Score);
    delMe8 = height(delMe6(delMe6.Score == 1,:)) / (height(delMe6) + delMe11); % delMe8 = subjTask1Correct
    delMe(delMe4,:) = {delMe5(delMe4) (height(delMe6) + delMe11) delMe8};
end
delMe.ChancePerf = zeros(height(delMe),1); % assume no chance performance
for row = 1:height(delMe)
    if ( (delMe.CorrectPct(row) - .5) < ...
            (1.96 * (sqrt((.5 * (1 - .5)) / delMe.TrialCount(row)))) )
        delMe.ChancePerf(row) = 1;
    end
end
delMe(delMe.ChancePerf == 1,:) % Chance performers (NONE???)
delMe












% now compare pretest with the first two days of RF
numberOfShiftsToInclude = 40; % first two days' worth of shifts
[first_N_RFshifts] = getSomeRFshifts(excludeSubjects_RF_1B(true, true, zRF_1B), numberOfShiftsToInclude, 'all', 'first');


% 1B: Compare SwitchCost (reactionTime) from RF (first few trials) to SwitchCost from Pretest
    % these take a while; only do if you don't have the variables already
    zPPswitch_1B_extraCols = addPPswitchCols(zPPswitch_1B, false); % zNote: this takes a while!
    includedPPswitch = excludeSubjects_RF_1B(true, true, 'switch', zPPswitch_1B_extraCols);
    includedRFswitch = excludeSubjects_RF_1B(true, true, 'switch', first_N_RFshifts);

[delMe] = getSwitchCostRT_RF_1B(includedRFswitch, 'single', false, true, false);
[delMe2] = getSwitchCostRT_PP_1B(includedPPswitch, false, false); 

% clean up subjects that don't match between the two
[delMe, delMe2] = removeNonMatchingSubjects(delMe.Subject, delMe, delMe2.Subject, delMe2, true, false);

% clean up subjects that don't have a SwCost for whatever reason
fprintf('We also may have some NaNs which will be deleted from both lists; here is the list:\n');
delMe3 = table2array([delMe2(isnan(delMe2.Pre_SC),'Subject'); delMe(isnan(delMe.SwCost),'Subject')])
delMe2(ismember(delMe2.Subject, delMe3), :) = [];
delMe(ismember(delMe.Subject, delMe3), :) = [];

% also removing <>3SDs outliers from the graph
zScatter(delMe.SwCost, delMe2.Pre_SC, 'Switch Cost from first two days of RF Switch trials compared to Pretest Switch Cost', 'RF Switch Cost (RT; first 2 days)', 'Pretest Switch Cost (ReactionTime)', true, '', '', 14, true, '', '')





% 1B: Compare SSRT from RF (first two days) to SSRT from Pretest
    % these take a while; only do if you don't have the variables already
    includedPPinhibit = excludeSubjects_RF_1B(true, true, 'inhibit', zPPinhibit_1B);
    includedPPinhibit(strcmpi(includedPPinhibit.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
    includedRFinhibit = excludeSubjects_RF_1B(true, true, 'inhibit', first_N_RFshifts);
    
[SSRT_RF_firstShifts_table] = getSSRT_RF_1B(includedRFinhibit, 'single', false, true, false);  

[SSRT_PP_table] = getSSRT_PP_1B(includedPPinhibit, false, false, false); 

% make sure the two tables only have one set of subjects
[SSRT_RF_firstShifts_table, SSRT_PP_table] = removeNonMatchingSubjects(SSRT_RF_firstShifts_table.Subject, SSRT_RF_firstShifts_table, SSRT_PP_table.Subject, SSRT_PP_table, true, false);

% three cols: subj, RF SSRT, PP SSRT
CompareSSRT_RF_Pretest = [SSRT_PP_table.Subject SSRT_RF_firstShifts_table.SSRT_est SSRT_PP_table.PreSSRT] 

zScatter(CompareSSRT_RF_Pretest(:,2), CompareSSRT_RF_Pretest(:,3), 'SSRT from first two days of RF Inhibit trials compared to Pretest Inhibit', 'RF first-two-days SSRT', 'Pretest SSRT', true, '', '', 14, true, '', '')



% 1B: Compare Update Accuracy in Pretest (arrows) and first two days of RF (N-back) 
    % these take a while; only do if you don't have the variables already
    zPPupdate_1B_singleTrials = singleArrowPerTrial_PP_1B(zPPupdate_1B, false); % make the usual PPupdate into one-arrow-per-line
    includedPPupdate = excludeSubjects_RF_1B(true, true, 'update', zPPupdate_1B_singleTrials);
    includedPPupdate(strcmpi(includedPPupdate.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
    includedRFupdate = excludeSubjects_RF_1B(true, true, 'update', first_N_RFshifts);
    includedRFupdate = includedRFupdate(strcmpi(includedRFupdate.Cluster, 'u'),:);

delMe = table(0,0.0,0.0,'VariableNames', {'Subject','NonNBack_CorrectPct','NBack_CorrectPct'});
delMe5 = unique(includedRFupdate.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedRFupdate(includedRFupdate.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe7 = delMe6(delMe6.NbackFlag ~= 1, :); % delMe7 = Non N-back trials
    delMe8 = height(delMe7(delMe7.Correct == true,:)) / height(delMe7);
    delMe9 = delMe6(delMe6.NbackFlag == 1, :); % delMe9 = N-back trials
    delMe10 = height(delMe9(delMe9.Correct == true,:)) / height(delMe9);
    delMe(delMe4,:) = {delMe5(delMe4) delMe8 delMe10};
end

delMe2 = table(0,0.0,0.0,'VariableNames', {'Subject','Let_CorrectPct','Arr_CorrectPct'});
delMe5 = unique(includedPPupdate.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedPPupdate(includedPPupdate.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe8 = height(delMe6(strcmpi(delMe6.LetScore, 'correct'), :)) / height(delMe6);
    delMe10 = height(delMe6(strcmpi(delMe6.ArrScore, 'correct'), :)) / height(delMe6);
    
    delMe2(delMe4,:) = {delMe5(delMe4) delMe8 delMe10};
end

[delMe, delMe2] = removeNonMatchingSubjects(delMe.Subject, delMe, delMe2.Subject, delMe2, true, false);
%also removing outliers from graph
zScatter(delMe.NBack_CorrectPct, delMe2.Arr_CorrectPct, 'Update Accuracy from first two days of RF N-back trials\ncompared to Pretest Arrow trials', 'RF first-two-days N-back accuracy', 'Pretest arrow rotation accuracy', true, '', '', 14, true, '', '')





% 1B: Compare Switch RF Ability (first two days) (from GLM) with Switch Pretest Ability (from GLM) 
[x_PPSw, y_PPSw] = getDataForPreSwitchGLM(excludeSubjects_RF_1B(true, true, 'switch', zPPswitch_1B), false, false);
 PPSwModel = fitglm(x_PPSw,y_PPSw,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount + RT','distr','binomial','Intercept',true,'CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','TrialCount','Correct'})

[~,~,switchDataRF] = getCleanSwitchTrials_RF_1B(true, true, 'both', 'S', excludeSubjects_RF_1B(true, true, 'switch', first_N_RFshifts), true);
[x_RFSw, y_RFSw] = getDataForSwitchGLM(switchDataRF, false, false, 'TrialCount', 'all', 'single', false);
 RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount - Cluster - TrialDur + RT','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})

% clean up subjects that don't match between the two
delRFSubjLen = length(unique(x_RFSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delPPSubjLen = length(unique(x_PPSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delMe4 = transpose(RFSwModel.CoefficientNames(2:((2+delRFSubjLen)-1))); % just the Ability names (Subj_X)
delMe5 = transpose(PPSwModel.CoefficientNames(2:((2+delPPSubjLen)-1))); % just the Ability names (Subj_X)
delMe = RFSwModel.Coefficients.Estimate((2:((2+delRFSubjLen)-1)),1); % just the Ability estimates
delMe2 = PPSwModel.Coefficients.Estimate((2:((2+delPPSubjLen)-1)),1); % just the Ability estimates
[delMe, delMe2] = removeNonMatchingSubjects(delMe4, delMe, delMe5, delMe2, true, false);

zScatter(delMe, delMe2, 'Comparing Switch: Pretest Ability to RF Ability\n(first two days of training)', 'RF Switch Ability (GLM est.)', 'Pretest Switch Ability (excluding values > 15)', true, '', '', 14, true, '', [-15 15])





% 1B: Compare Update Ability (GLM) in Pretest and first two days of RF

[x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(excludeSubjects_RF_1B(true, true, 'update', first_N_RFshifts), false, false, 'TrialCount', 'all', 'single', true);
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + TrialCount - Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','Nval','RT','TrialCount','Cluster','Correct'})
Upd_RF_table = table(transpose(RFUpdModel.CoefficientNames(2:(end-6))),RFUpdModel.Coefficients.Estimate(2:(end-6)),'VariableNames', {'Subject','Coefficient'});

% note we should have already done this for update Accuracy plot, above         zPPupdate_1B_singleTrials = singleArrowPerTrial_PP_1B(zPPupdate_1B, false); % make the usual PPupdate into one-arrow-per-line
y_PPUpd = zeros(height(zPPupdate_1B_singleTrials),1);
y_PPUpd(strcmpi(zPPupdate_1B_singleTrials.ArrScore, 'correct'),1) = 1;
x_PPUpd = table2array(zPPupdate_1B_singleTrials(:,'Subject'));
x_PPUpd(:,2) = table2array(zPPupdate_1B_singleTrials(:,'origArrLettNum'));
x_PPUpd(:,3) = table2array(zPPupdate_1B_singleTrials(:,'SeqLength'));
PPUpdModel = fitglm(x_PPUpd,y_PPUpd,'logit(Correct) ~ 1 + Subj + ArrNum + SeqLen','distr','binomial','CategoricalVars',[1,2,3],'VarNames',{'Subj','ArrNum','SeqLen','Correct'})
Upd_PP_table = table(transpose(PPUpdModel.CoefficientNames(2:(end-7))),PPUpdModel.Coefficients.Estimate(2:(end-7)),'VariableNames', {'Subject','Coefficient'});

if (height(Upd_RF_table) ~= height(Upd_PP_table))
    fprintf('We have %d subjects for pretest and %d subjects for RF. Deleting the following subjects (may want to include them in excludeSubjects_RF_1B):\n', height(Upd_PP_table), height(Upd_RF_table));
    delMe = setdiff(Upd_PP_table.Subject, Upd_RF_table.Subject) % list the subjs in PP that aren't in RF
    Upd_PP_table(ismember(Upd_PP_table.Subject, delMe), :) = []; % and delete them
    delMe = setdiff(Upd_RF_table.Subject, Upd_PP_table.Subject) % list the subjs in RF that aren't in PP
    Upd_RF_table(ismember(Upd_RF_table.Subject, delMe), :) = []; % and delete them
end

zScatter(Upd_RF_table.Coefficient, Upd_PP_table.Coefficient, 'Update Ability from first two days of RF Update trials compared to Pretest Ability\n(both calculated from GLM)', 'RF first-two-days Update Ability', 'Pretest Update Ability (all arrows)', true, '', '', 14, false, '', '')







% now compare difficulties between the three

% Compare U and S difficulty, for each stimulus duration

delMe = excludeSubjects_RF_1B(true, true, 'update', first_N_RFshifts_Only1sDur(strcmpi(first_N_RFshifts_Only1sDur.Cluster, 'U'), :));
delMe2 = excludeSubjects_RF_1B(true, true, 'switch', first_N_RFshifts_Only1sDur(strcmpi(first_N_RFshifts_Only1sDur.Cluster, 'S'), :));
% run this loop to get the %correct for each
delMe10 = table(0,0.0,0.0,'VariableNames', {'Subject','U_PctCorrect','S_PctCorrect'});
delMe3 = unique(first_N_RFshifts.Subject); % delMe3 = uniqueSubjs
for delMe4 = 1:length(delMe3) % delMe4 = subjIndex
    delMe5 = delMe(delMe.Subject == delMe3(delMe4), :); % delMe5 = U subjTrials
    delMe6 = delMe2(delMe2.Subject == delMe3(delMe4), :); % delMe6 = S subjTrials
    
    delMe7 = height(delMe5(delMe5.Correct == 1,:)) / height(delMe5); % U PctCorrect
    delMe8 = height(delMe6(delMe6.Correct == 1,:)) / height(delMe6); % S PctCorrect
    
    delMe10(delMe4,:) = {delMe3(delMe4) delMe7 delMe8};
end
delMe10(isnan(delMe10.U_PctCorrect),:) = []; % also remove any NaNs from both sides
delMe10(isnan(delMe10.S_PctCorrect),:) = []; % also remove any NaNs from both sides
% now save it
delMe11 = delMe10; % table for 1s duration
% now re-run the above, with the following delMe and delMe2
delMe = excludeSubjects_RF_1B(true, true, 'update', first_N_RFshifts_Only2sDur(strcmpi(first_N_RFshifts_Only2sDur.Cluster, 'U'), :));
delMe2 = excludeSubjects_RF_1B(true, true, 'switch', first_N_RFshifts_Only2sDur(strcmpi(first_N_RFshifts_Only2sDur.Cluster, 'S'), :));
% now save it
delMe12 = delMe10; % table for 2s duration
% now re-run the above, with the following delMe and delMe2
delMe = excludeSubjects_RF_1B(true, true, 'update', first_N_RFshifts_Only3sDur(strcmpi(first_N_RFshifts_Only3sDur.Cluster, 'U'), :));
delMe2 = excludeSubjects_RF_1B(true, true, 'switch', first_N_RFshifts_Only3sDur(strcmpi(first_N_RFshifts_Only3sDur.Cluster, 'S'), :));
% now save it
delMe13 = delMe10; % table for 3s duration
% now re-run the above, with the following delMe and delMe2
delMe = excludeSubjects_RF_1B(true, true, 'update', first_N_RFshifts(strcmpi(first_N_RFshifts.Cluster, 'U'), :));
delMe2 = excludeSubjects_RF_1B(true, true, 'switch', first_N_RFshifts(strcmpi(first_N_RFshifts.Cluster, 'S'), :));
% now save it
delMe14 = delMe10; % table for 3s duration

% now, compare
mean(delMe11.U_PctCorrect)
mean(delMe11.S_PctCorrect)
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe11.U_PctCorrect, delMe11.S_PctCorrect,'Tail','both')

mean(delMe12.U_PctCorrect)
mean(delMe12.S_PctCorrect)
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe12.U_PctCorrect, delMe12.S_PctCorrect,'Tail','both')

mean(delMe13.U_PctCorrect)
mean(delMe13.S_PctCorrect)
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe13.U_PctCorrect, delMe13.S_PctCorrect,'Tail','both')

mean(delMe14.U_PctCorrect)
mean(delMe14.S_PctCorrect)
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe14.U_PctCorrect, delMe14.S_PctCorrect,'Tail','both')






% Compare U, I, S: mean, SD, and t-test for all PctCorrect (note: keep the timeout the same for all - 2s) 

delMeU = excludeSubjects_RF_1B(true, true, 'update', first_N_RFshifts_Only2sDur(strcmpi(first_N_RFshifts_Only2sDur.Cluster, 'U'), :));
delMeU_1 = delMeU(delMeU.ActualN == 1, :);
delMeU_2 = delMeU(delMeU.ActualN == 2, :);
delMeU_3 = delMeU(delMeU.ActualN == 3, :);
delMeS = excludeSubjects_RF_1B(true, true, 'switch', first_N_RFshifts_Only2sDur(strcmpi(first_N_RFshifts_Only2sDur.Cluster, 'S'), :));
delMeI = excludeSubjects_RF_1B(true, true, 'inhibit', first_N_RFshifts_Only2sDur(strcmpi(first_N_RFshifts_Only2sDur.Cluster, 'I'), :));
   delMeI(delMeI.InhibitFlag == 1, :) = []; % remove Inhibit trials (we control performance on these!) 

delMe10 = table(0,0.0,0.0,0.0,0.0,0.0,'VariableNames', {'Subject','U_N1_PctCorrect','U_N2_PctCorrect','U_N3_PctCorrect','S_PctCorrect','I_PctCorrect'});
delMe3 = unique(first_N_RFshifts.Subject); % delMe3 = uniqueSubjs
for delMe4 = 1:length(delMe3) % delMe4 = subjIndex
    delMe5 = delMeU_1(delMeU_1.Subject == delMe3(delMe4), :); % U (N=1) subjTrials
    delMe6 = height(delMe5(delMe5.Correct == 1,:)) / height(delMe5); % U (N=1) PctCorrect
    delMe5 = delMeU_2(delMeU_2.Subject == delMe3(delMe4), :); % U (N=2) subjTrials
    delMe7 = height(delMe5(delMe5.Correct == 1,:)) / height(delMe5); % U (N=2) PctCorrect
    delMe5 = delMeU_3(delMeU_3.Subject == delMe3(delMe4), :); % U (N=3) subjTrials
    delMe8 = height(delMe5(delMe5.Correct == 1,:)) / height(delMe5); % U (N=3) PctCorrect
    delMe5 = delMeS(delMeS.Subject == delMe3(delMe4), :); % S subjTrials
    delMe9 = height(delMe5(delMe5.Correct == 1,:)) / height(delMe5); % S PctCorrect
    delMe5 = delMeI(delMeI.Subject == delMe3(delMe4), :); % I subjTrials
    delMe = height(delMe5(delMe5.Correct == 1,:)) / height(delMe5); % I PctCorrect
        
    delMe10(delMe4,:) = {delMe3(delMe4) delMe6 delMe7 delMe8 delMe9 delMe};
end

delMeU_1 = delMe10.U_N1_PctCorrect(~isnan(delMe10.U_N1_PctCorrect));
delMeU_2 = delMe10.U_N2_PctCorrect(~isnan(delMe10.U_N2_PctCorrect));
delMeU_3 = delMe10.U_N3_PctCorrect(~isnan(delMe10.U_N3_PctCorrect));
delMeS = delMe10.S_PctCorrect(~isnan(delMe10.S_PctCorrect));
delMeI = delMe10.I_PctCorrect(~isnan(delMe10.I_PctCorrect));
% just to see what the values are...
mean(delMeU_1)
mean(delMeU_2)
mean(delMeU_3)
mean(delMeS)
mean(delMeI)
% and if any differences are likely significant (NOTE: should really make sure these are the same subjs first, for paired t-test)...
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe10.U_N1_PctCorrect, delMe10.S_PctCorrect,'Tail','both')
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe10.U_N3_PctCorrect, delMe10.I_PctCorrect,'Tail','both')
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe10.S_PctCorrect, delMe10.I_PctCorrect,'Tail','both')

% U_1: mean = .84, SD = .03, SEM = .0265
% U_2: mean = .77, SD = .14, SEM = .0289
% U_3: mean = .71, SD = .086, SEM = .0174 (NOT SIGNIFICANTLY DIFFERENT FROM S)
% S: mean = .7074, SD = .078, SEM = .0158
% I: mean = .9571, SD = .0389, SEM = .0079

% have to do all this nonsense to get bars different colors and widths 
%delMe = [mean(delMe10.U_N1_PctCorrect); mean(delMe10.U_N3_PctCorrect); mean(delMe10.U_N2_PctCorrect); mean(delMe10.S_PctCorrect); mean(delMe10.I_PctCorrect)];
delMe = [mean(delMeU_1); mean(delMeU_2); mean(delMeU_3); mean(delMeS); mean(delMeI)];
delMe2 = diag(delMe); % make a matrix that has zeros in each row, other than the data you want to display along the diagonal
delMe3 = [1 1 1 0.8 0.8]; % widths (Updating will be grouped together)
figure
hold on
bar(1:length(delMe),delMe2(:,1),delMe3(1),'c')
bar(1:length(delMe),delMe2(:,2),delMe3(2),'c')
bar(1:length(delMe),delMe2(:,3),delMe3(3),'c')
bar(1:length(delMe),delMe2(:,4),delMe3(4),'g')
bar(1:length(delMe),delMe2(:,5),delMe3(5),'m')
%errorbar(1:5,[mean(delMe10.U_N1_PctCorrect); mean(delMe10.U_N3_PctCorrect); mean(delMe10.U_N2_PctCorrect); mean(delMe10.S_PctCorrect); mean(delMe10.I_PctCorrect)],[SEM_calc(delMe10.U_N1_PctCorrect) SEM_calc(delMe10.U_N3_PctCorrect) SEM_calc(delMe10.U_N2_PctCorrect) SEM_calc(delMe10.S_PctCorrect) SEM_calc(delMe10.I_PctCorrect)],'.')
errorbar(1:5,[mean(delMeU_1); mean(delMeU_2); mean(delMeU_3); mean(delMeS); mean(delMeI)],[SEM_calc(delMeU_2) SEM_calc(delMeI) SEM_calc(delMeU_3) SEM_calc(delMeS) SEM_calc(delMeI)],'.')
xlabel('EF training task')
ylabel('Percent correct')
delMe = {'1-Back','2-Back','3-Back', 'Switching', 'Inhibition'};
set(gca, 'XTick', 1:5, 'XTickLabel', delMe);
set(findall(gca,'type','text'),'FontSize',24)
set(findall(gca,'type','axes'),'FontSize',20)
hold off





% Compare difficulty of pretest inhibit Go task to RF inhibit Go tasks 
includedRFinhibit = excludeSubjects_RF_1B(true, true, 'inhibit', first_N_RFshifts_Only2sDur(strcmpi(first_N_RFshifts_Only2sDur.Cluster, 'I'), :));
   includedRFinhibit(includedRFinhibit.InhibitFlag == 1, :) = []; % remove Inhibit trials (we control performance on these!) 
includedPPinhibit = excludeSubjects_RF_1B(true, true, 'inhibit', zPPinhibit_1B);
includedPPinhibit(strcmpi(includedPPinhibit.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
delMeI = includedPPinhibit; % remove the Inhibit trials in order to just have Go trials (we control performance on Inhibit trials)
    tmpGoTrials = delMeI(strcmpi(delMeI.InhCorr,'before'),'Inhibit'); % identify the Inhibit trials where the participant responded before the cue (should be treated as Go trials)
    tmpGoTrials.Inhibit(:) = {NaN}; % mark the correct length with NaNs
    delMeI(strcmpi(delMeI.InhCorr,'before'),'Inhibit') = tmpGoTrials; % save the NaNs to the cells marking this as an Inhibit trial
    delMeI(strcmpi(delMeI.InhCorr,'before'),'InhCorr') = tmpGoTrials; % save the NaNs to the cells marking this as an Inhibit trial
    findNANsFunction = @(x) all(isnan(x(:))); % this function will find NaNs in cells
    delMeI = delMeI(cellfun(findNANsFunction, delMeI.Inhibit),:); % get all the rows that have [NaN] in the Inhibit col

delMe10 = table(0,0.0,0.0,'VariableNames', {'Subject','I_RF_PctCorrect','I_PP_PctCorrect'});
delMe3 = unique(first_N_RFshifts.Subject); % delMe3 = uniqueSubjs
for delMe4 = 1:length(delMe3) % delMe4 = subjIndex
    delMe5 = includedRFinhibit(includedRFinhibit.Subject == delMe3(delMe4), :); % RF inhibit subjTrials
    delMe6 = height(delMe5(delMe5.Correct == 1,:)) / height(delMe5); % RF inhibit PctCorrect
    
    delMe7 = delMeI(delMeI.Subject == delMe3(delMe4), :); % Pretest inhibit subjTrials
    delMe8 = height(delMe7(delMe7.Score == 1,:)) / height(delMe7); % Pretest inhibit PctCorrect
        
    delMe10(delMe4,:) = {delMe3(delMe4) delMe6 delMe8};
end
delMe10(isnan(delMe10.I_RF_PctCorrect),:) = []; % delete any NaNs, so we can do a paired t-test
delMe10(isnan(delMe10.I_PP_PctCorrect),:) = []; % delete any NaNs, so we can do a paired t-test

1-mean(delMe10.I_RF_PctCorrect)
1-mean(delMe10.I_PP_PctCorrect)
% and if any differences are likely significant (NOTE: should really make sure these are the same subjs first, for paired t-test)...
[delMe15, delMe16, delMe17, delMe18] = ttest(1-delMe10.I_RF_PctCorrect, 1-delMe10.I_PP_PctCorrect,'Tail','both')








% grab the average number of times each cluster was seen (and SD)
includedInhibit_1B = excludeSubjects_RF_1B(false, true, false, zPPinhibit_1B); % only using this because zKernelShiftEstimates_1B doesn't have a "status" column
[includedKSE, ~] = removeNonMatchingSubjects(zKernelShiftEstimates_1B.Subject, zKernelShiftEstimates_1B, includedInhibit_1B.Subject, includedInhibit_1B, false, false); % last input is "verbose" - turn it on if something is unexpected
includedKSE.Cluster = strrep(includedKSE.Cluster, '/', '_');
uniqueSubj = unique(includedKSE.Subject); % all subjects
delMe = array2table(zeros(length(uniqueSubj),17), 'VariableNames', {'Subj','U', 'S', 'I', ...
        'U_Logic', 'S_Logic', 'I_Logic', ...
        'U_S', 'U_I', 'S_I', ...
        'U_S_Logic', 'U_I_Logic', 'S_I_Logic', ...
        'L4aV1', 'L4bV1', 'L4aV2', 'L4bV2'});
for subjIterator = 1:length(uniqueSubj)
    subjNum = uniqueSubj(subjIterator); % subj number
    fprintf('Dealing with subj %d.\n',subjNum);
    delMe(subjIterator,:).Subj = subjNum; % store the subj number
    subjShifts = includedKSE(includedKSE.Subject == subjNum, :); % all shifts for this subject
    
    subjShiftsClusters = unique(subjShifts.Cluster); % all clusters
    for clusterIterator = 1:length(subjShiftsClusters)
        currentCluster = subjShiftsClusters(clusterIterator); % Cluster we're looking for
        ccCount = height(subjShifts(strcmpi(subjShifts.Cluster, currentCluster),:));
        delMe{subjIterator,currentCluster} = ccCount; % store the number of times this subj saw this cluster
    end
end

writetable(delMe, getFileNameForThisOS('2016_1_10 count of clusters seen by only-included-subject.csv', 'IntResults'));

clear includedInhibit_1B includedKSE uniqueSubj subjIterator subjShifts
clear subjShiftsClusters clusterIterator currentCluster ccCount



% get the average number of transitions (for included subjects)
includedInhibit_1B = excludeSubjects_RF_1B(false, true, false, zPPinhibit_1B); % only using this because zKernelShiftEstimates_1B doesn't have a "status" column
[includedKSE, ~] = removeNonMatchingSubjects(zKernelShiftEstimates_1B.Subject, zKernelShiftEstimates_1B, includedInhibit_1B.Subject, includedInhibit_1B, false, false); % last input is "verbose" - turn it on if something is unexpected
[~, includedTransitionCount, ~] = getKernelclusterTransitionMatrix_1B(includedKSE, false, false, true); % NOTE: takes a long time!
% doesn't work for tables... just do it in Excel     avgTransitionTable = includedTransitionCount ./ (length(unique(includedKSE.Subject)));
length(unique(includedKSE.Subject))   % 284 subjs
writetable(includedTransitionCount, getFileNameForThisOS('2016_1_10 transition count all only-included-subjects.csv', 'IntResults'));


clear includedInhibit_1B includedKSE includedTransitionCount 



% find out the number of (SHAM, WHO FINISHED) people who actually got to U/S/Logic 
delMe7 = []; % next few lines stolen from up above, where we do demographic analyses
delMe8 = excludeSubjects_RF_1B(false, true, false, zPPinhibit_1B); % just get the people who Finished the study
delMe6 = unique(delMe8.Subject);
for delMe5 = 1:(length(delMe6))
    delMe4 = zPPinhibit_1B(zPPinhibit_1B.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
delMe6 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe6 = [delMe6; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
delMe5 = unique(delMe6.Subject); % THIS IS THE SHAM+RF Subj list
length(delMe5) % there are 90 RF+sham subjects who finished

delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B);
%length(unique(delMe.Subject)) % 285
delMe = delMe(ismember(delMe.Subject, delMe5),:); % note: reusing delMe!
delMe = delMe(strcmpi(delMe.Cluster,'U/S/Logic'),:); % note: reusing delMe!
delMe3 = unique(delMe.Subject);
length(delMe3) % 41
delMe2 = table(0,0,'VariableNames',{'SubjNum','Count'});
for delMe4 = 1:length(delMe3)
    delMe5 = delMe3(delMe4); % subject
    delMe6 = zRFSum_1B(zRFSum_1B.Subject == delMe5,:); % subjShifts
    delMe7 = delMe6(strcmpi(delMe6.Cluster,'U/S/Logic'),:); % subjUSLogicShifts
    delMe8 = table(delMe5, height(delMe7),'VariableNames',{'SubjNum','Count'}); % subjTableEntry
    delMe2(delMe4,:) = delMe8;
end
delMe2 % visualize
height(delMe2(delMe2.Count <= 3, :))
height(delMe2(delMe2.Count <= 4, :))
height(delMe2(delMe2.Count <= 5, :))
height(delMe2(delMe2.Count <= 6, :))
height(delMe2(delMe2.Count <= 7, :))



% find out the "clusterComplete" paths of (SHAM, WHO FINISHED) people 
delMe7 = []; % next few lines stolen from up above, where we do demographic analyses
delMe8 = excludeSubjects_RF_1B(false, true, false, zPPinhibit_1B); % just get the people who Finished the study
delMe6 = unique(delMe8.Subject);
for delMe5 = 1:(length(delMe6))
    delMe4 = zPPinhibit_1B(zPPinhibit_1B.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
delMe6 = delMe7(strcmpi(delMe7.Condition, 'RF tDCS Sham'),:);
delMe6 = [delMe6; delMe7(strcmpi(delMe7.Condition, 'RF tRNS Sham'),:)];
delMe5 = unique(delMe6.Subject); % THIS IS THE SHAM+RF Subj list
length(delMe5) % there are 90 RF+sham subjects who finished
delMe = excludeSubjects_RF_1B(false, true, false, zRFSum_1B);
delMe = delMe(ismember(delMe.Subject, delMe5),:); % note: reusing delMe!
length(unique(delMe.Subject)) % sanity check - should still be 90

% now, of these 90 people, who completed each of the clusters? Get averages 
delMe2 = table({'placeholder'},0,'VariableNames',{'Cluster','NumberCompleted'});
delMe2(1,:) = table({'U'},height(delMe(strcmpi(delMe.ClusterComplete,'U'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(2,:) = table({'S'},height(delMe(strcmpi(delMe.ClusterComplete,'S'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(3,:) = table({'I'},height(delMe(strcmpi(delMe.ClusterComplete,'I'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(4,:) = table({'U_Logic'},height(delMe(strcmpi(delMe.ClusterComplete,'U/Logic'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(5,:) = table({'S_Logic'},height(delMe(strcmpi(delMe.ClusterComplete,'S/Logic'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(6,:) = table({'I_Logic'},height(delMe(strcmpi(delMe.ClusterComplete,'I/Logic'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(7,:) = table({'U_I'},height(delMe(strcmpi(delMe.ClusterComplete,'U/I'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(8,:) = table({'S_I'},height(delMe(strcmpi(delMe.ClusterComplete,'S/I'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(9,:) = table({'U_S'},height(delMe(strcmpi(delMe.ClusterComplete,'U/S'),:)),'VariableNames',{'Cluster','NumberCompleted'}); % 0?? Really?
delMe2(10,:) = table({'U_I_Logic'},height(delMe(strcmpi(delMe.ClusterComplete,'U/I/Logic'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(11,:) = table({'S_I_Logic'},height(delMe(strcmpi(delMe.ClusterComplete,'S/I/Logic'),:)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(12,:) = table({'U_S_Logic'},height(delMe(strcmpi(delMe.ClusterComplete,'U/S/Logic'),:)),'VariableNames',{'Cluster','NumberCompleted'});

delMe2.AvgCompleted = delMe2.NumberCompleted / 90;
delMe2

% ZNOTE: NO ONE EVER PASSED U/S!???! ... How did they pass L4a? Just by not responding???? 
delMe=zRFSum_1B;
delMe2 = table({'placeholder'},0,'VariableNames',{'Cluster','NumberCompleted'});
delMe2(1,:) = table({'U_S'},height(delMe(strcmpi(delMe.ClusterComplete,'U/S'),:)),'VariableNames',{'Cluster','NumberCompleted'}); % 0?? Really?
delMe2

% ZNOTE2: THE ABOVE METHOD GIVES US >90 for some shifts!!! Impossible. Do it in a different way, ensuring max 1/subj:
delMe2 = table({'placeholder'},0,'VariableNames',{'Cluster','NumberCompleted'});
delMe2(1,:) = table({'U'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'U'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(2,:) = table({'S'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'S'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(3,:) = table({'I'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'I'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(4,:) = table({'U_Logic'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'U/Logic'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(5,:) = table({'S_Logic'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'S/Logic'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(6,:) = table({'I_Logic'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'I/Logic'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(7,:) = table({'U_I'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'U/I'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(8,:) = table({'S_I'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'S/I'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(9,:) = table({'U_S'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'U/S'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'}); % 0?? Really?
delMe2(10,:) = table({'U_I_Logic'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'U/I/Logic'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(11,:) = table({'S_I_Logic'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'S/I/Logic'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});
delMe2(12,:) = table({'U_S_Logic'},length(unique(delMe(strcmpi(delMe.ClusterComplete,'U/S/Logic'),:).Subject)),'VariableNames',{'Cluster','NumberCompleted'});

delMe2.AvgCompleted = delMe2.NumberCompleted / length(unique(delMe.Subject)); % should be / 90, but just in case we want to reuse this code...
delMe2


% count the number of days of training actually received by each participant 
trainingDayCount = table(0,0,0,0,0,0,0,'VariableNames',{'Subj','DaysOfTraining','T12orMore','T11','T10','T9','T8orLess'});
finishedSum_1B = delMe; % this is defined above: SUM file, finished, sham (90 subjs total)
subjs = unique(finishedSum_1B.Subject);
for i = 1:length(subjs)
    T12orMore = 0;
    T11 = 0;
    T10 = 0;
    T9 = 0;
    T8orLess = 0;
    subj = subjs(i);
    subjShifts = finishedSum_1B(finishedSum_1B.Subject == subj, :);
    subjDays = unique(subjShifts.Date);
    if (length(subjDays) > 11)
        T12orMore = 1;
    elseif (length(subjDays) == 11)
        T11 = 1;
    elseif (length(subjDays) == 10)
        T10 = 1;
    elseif (length(subjDays) == 9)
        T9 = 1;
    else
        T8orLess = 1;
    end
    trainingDayCount(i,:) = table(subj,length(subjDays),T12orMore,T11,T10,T9,T8orLess,...
        'VariableNames',{'Subj','DaysOfTraining','T12orMore','T11','T10','T9','T8orLess'});
end
clear finishedSum_1B subjs subj i subjShifts subjDays T12orMore T11 T10 T9 T8orLess
sum(trainingDayCount.T12orMore) % should be 0, but is 5
sum(trainingDayCount.T12orMore) + sum(trainingDayCount.T11) % 57
sum(trainingDayCount.T10) + sum(trainingDayCount.T9) + sum(trainingDayCount.T8orLess) % 33
sum(trainingDayCount.T10) % 25
sum(trainingDayCount.T9) % 8
sum(trainingDayCount.T8orLess) % should be 0 and is
clear trainingDayCount
