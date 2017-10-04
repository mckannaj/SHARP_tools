% Zephy McKanna
% Script to compare Pretest and Initial RF performance in Update, Switch,
% and Inhibit
% 4/26/15

% PREP: get the latest 1A-3 data if you don't have it yet
if (exist('zRFAll_1A3', 'var') == 0) % if we don't have this variable, we need to read in the tables
    [zRFData_1A3, zRFSum_1A3, zRFAll_1A3] = formTables_RF_1A3('Trial3.rf-data_final.xlsx', 'Trial3.rf-sum_final.xlsx', 'Trial3.robotfactory_final.xlsx', true);
    [zRF_1A3] = putNewColsIntoDataTable_1A3(zRFAll_1A3); % add the extra columns
end
if (exist('zPPinhibit_1A3', 'var') == 0) % if we don't have this variable, assume we don't have any of them...
    [zPPinhibit_1A3, zPPswitch_1A3, zPPupdate_1A3] = formTables_RF_1A3('Trial3.inhibit.xlsx', 'Trial3.switch.xlsx', 'Trial3.update.xlsx', true); % note that the feedback on the command line doesn't really make sense for pre/post data, but it still forms the tables correctly
end

% PREP: if you have the 1B final data, this will load it in (NOTE: TAKES A LONG TIME!) 
load(getFileNameForThisOS('RFAll_1B_2015_10_29.mat', 'ParsedData'));

% PREP: get the latest 1B data if you don't have it yet
% (Note: leaving these out of the "exists" check, because we need to keep getting the latest from Dennis...) 
[zPPinhibit_1B, zPPswitch_1B, zPPupdate_1B] = formTables_RF_1A3('1b-final-Parsed.inhibit.xlsx', '1b-final-Parsed.switch.xlsx', '1b-final-Parsed.rotation.xlsx', true);
%[zRFData_1B, zRFSum_1B, zRFAll_1B] = formTables_RF_1A3('1b-final-Parsed.rf-data.xlsx', '1b-final-Parsed.rf-sum.xlsx', '1b-final-Parsed.robotfactory.xlsx', true);

[zACsilo_SUM_1B, zACvisSearch_SUM_1B, zACthumb_SUM_1B] = formTables_RF_1A3('1b-final-Parsed-AC.silo-sum.xlsx', '1b-final-Parsed-AC.visualsearch-sum.xlsx', '1b-final-Parsed-AC.thumbprint-sum.xlsx', true);
[zACsilo_LVL_1B, zACvisSearch_LVL_1B, zACthumb_LVL_1B] = formTables_RF_1A3('1b-final-Parsed-AC.silo-level.xlsx', '1b-final-Parsed-AC.visualsearch-level.xlsx', '1b-final-Parsed-AC.thumbprint-level.xlsx', true);
[zACsilo_ALL_1B, zACvisSearch_ALL_1B, zACthumb_ALL_1B] = formTables_RF_1A3('1b-final-Parsed-AC.silo.xlsx', '1b-final-Parsed-AC.visualsearch.xlsx', '1b-final-Parsed-AC.thumbprint.xlsx', true);


% zNote: takes a bit more finesse now that we have too much data for one file 
[zRFData_1B, zRFSum_1B, ~] = formTables_RF_1A3('1b-final-Parsed.rf-data.xlsx', '1b-final-Parsed.rf-sum.xlsx', '', true);
    warning('off','MATLAB:nonIntegerTruncatedInConversionToChar'); % suppress this known and non-helpful warning for these functions
    delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '1b-final-Parsed.robotfactory.00.xlsx');
    [~,~,delMe] = xlsread(delPath); 
    delMe(1,1:end) = strrep(delMe(1,1:end), '-', ''); % remove all hyphens from the first row; table variable names can't have hyphens, apparently
    delMe(1,1:end) = strrep(delMe(1,1:end), '#', ''); % remove all # from the first row; table variable names can't have #, apparently
    delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '1b-final-Parsed.robotfactory.01.xlsx');
    [~,~,delMe2] = xlsread(delPath); 
    delMe = [delMe;delMe2]; % concatenate the new rows onto the end; should now have 1000001 rows
    length(delMe(:,1)) % should be 1000001 
    delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '1b-final-Parsed.robotfactory.02.xlsx');
    [~,~,delMe2] = xlsread(delPath); 
    delMe = [delMe;delMe2]; % concatenate the new rows onto the end; should now have 1500001 rows
    length(delMe(:,1)) % should be 1500001 
    delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '1b-final-Parsed.robotfactory.03.xlsx');
    [~,~,delMe2] = xlsread(delPath); 
    delMe = [delMe;delMe2]; % concatenate the new rows onto the end; should now have 2000001 rows
    length(delMe(:,1)) % should be 2000001 
    delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '1b-final-Parsed.robotfactory.04.xlsx');
    [~,~,delMe2] = xlsread(delPath); 
    delMe = [delMe;delMe2]; % concatenate the new rows onto the end; should now have 2500001 rows
    length(delMe(:,1)) % should be 2500001 
    delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '1b-final-Parsed.robotfactory.05.xlsx');
    [~,~,delMe2] = xlsread(delPath); 
    delMe = [delMe;delMe2]; % concatenate the new rows onto the end; should now have 3000001 rows
    length(delMe(:,1)) % should be 3000001 
    delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '1b-final-Parsed.robotfactory.06.xlsx');
    [~,~,delMe2] = xlsread(delPath); 
    delMe = [delMe;delMe2]; % concatenate the new rows onto the end; should now have 3500001 rows
    length(delMe(:,1)) % should be 3500001 
    delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '1b-final-Parsed.robotfactory.07.xlsx');
    [~,~,delMe2] = xlsread(delPath); 
    delMe = [delMe;delMe2]; % concatenate the new rows onto the end; should now have more than 3500001 rows
    length(delMe(:,1)) % should be ~3810000 

    zRFAll_1B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
    zRFAll_1B(isnan(zRFAll_1B.Subject) == true,:) = [];
    warning('on','MATLAB:nonIntegerTruncatedInConversionToChar'); % turn the warning back on, in case it's helpful for other functions later
    [zRF_1B] = putNewColsIntoDataTable_1B(zRFAll_1B); % add the extra columns
    
    clear zRFAll_1B % delete the old one
    %zNOTE: ONLY DO THIS ONCE! After that, just load it from this file.
    fprintf('saving the file... can stop this if you need the extra time...\n');
    save(getFileNameForThisOS('RFAll_1B_2015_12_01.mat', 'ParsedData'),'zRF_1B','-v7.3');
    
    % break it into smaller chunks that can actually be dealt with
    zRF_1B_0_49 = zRF_1B((zRF_1B.Subject >= 0) & (zRF_1B.Subject <= 49), :);
    save(getFileNameForThisOS('RFAll_1B-0_49-2015_10_29.mat', 'ParsedData'),'zRF_1B_0_49');
    clear zRF_1B_0_49 % delete the chunk, just to keep things running quicker
    zRF_1B_50_99 = zRF_1B((zRF_1B.Subject >= 50) & (zRF_1B.Subject <= 99), :);
    save(getFileNameForThisOS('RFAll_1B-50_99-2015_10_29.mat', 'ParsedData'),'zRF_1B_50_99');
    clear zRF_1B_50_99 % delete the chunk, just to keep things running quicker

    zRF_1B_100_149 = zRF_1B((zRF_1B.Subject >= 100) & (zRF_1B.Subject <= 149), :);
    save(getFileNameForThisOS('RFAll_1B-100_149-2015_10_29.mat', 'ParsedData'),'zRF_1B_100_149');
    clear zRF_1B_100_149 % delete the chunk, just to keep things running quicker
    zRF_1B_150_199 = zRF_1B((zRF_1B.Subject >= 150) & (zRF_1B.Subject <= 199), :);
    save(getFileNameForThisOS('RFAll_1B-150_199-2015_10_29.mat', 'ParsedData'),'zRF_1B_150_199');
    clear zRF_1B_150_199 % delete the chunk, just to keep things running quicker
    
    zRF_1B_200_249 = zRF_1B((zRF_1B.Subject >= 200) & (zRF_1B.Subject <= 249), :);
    save(getFileNameForThisOS('RFAll_1B-200_249-2015_10_29.mat', 'ParsedData'),'zRF_1B_200_249');
    clear zRF_1B_200_249 % delete the chunk, just to keep things running quicker
    zRF_1B_250_299 = zRF_1B((zRF_1B.Subject >= 250) & (zRF_1B.Subject <= 299), :);
    save(getFileNameForThisOS('RFAll_1B-250_299-2015_10_29.mat', 'ParsedData'),'zRF_1B_250_299');
    clear zRF_1B_250_299 % delete the chunk, just to keep things running quicker
    
    zRF_1B_300_349 = zRF_1B((zRF_1B.Subject >= 300) & (zRF_1B.Subject <= 349), :);
    save(getFileNameForThisOS('RFAll_1B-300_349-2015_10_29.mat', 'ParsedData'),'zRF_1B_300_349');
    clear zRF_1B_300_349 % delete the chunk, just to keep things running quicker
    zRF_1B_350_399 = zRF_1B((zRF_1B.Subject >= 350) & (zRF_1B.Subject <= 399), :);
    save(getFileNameForThisOS('RFAll_1B-350_399-2015_10_29.mat', 'ParsedData'),'zRF_1B_350_399');
    clear zRF_1B_350_399 % delete the chunk, just to keep things running quicker

    zRF_1B_400_449 = zRF_1B((zRF_1B.Subject >= 400) & (zRF_1B.Subject <= 449), :);
    save(getFileNameForThisOS('RFAll_1B-400_449-2015_10_29.mat', 'ParsedData'),'zRF_1B_400_449');
    clear zRF_1B_400_449 % delete the chunk, just to keep things running quicker
    zRF_1B_450_499 = zRF_1B((zRF_1B.Subject >= 450) & (zRF_1B.Subject <= 499), :);
    save(getFileNameForThisOS('RFAll_1B-450_499-2015_10_29.mat', 'ParsedData'),'zRF_1B_450_499');
    clear zRF_1B_450_499 % delete the chunk, just to keep things running quicker
    
    zRF_1B_500_549 = zRF_1B((zRF_1B.Subject >= 500) & (zRF_1B.Subject <= 549), :);
    save(getFileNameForThisOS('RFAll_1B-500_549-2015_10_29.mat', 'ParsedData'),'zRF_1B_500_549');
    clear zRF_1B_500_549 % delete the chunk, just to keep things running quicker
    zRF_1B_550_599 = zRF_1B((zRF_1B.Subject >= 550) & (zRF_1B.Subject <= 599), :);
    save(getFileNameForThisOS('RFAll_1B-550_599-2015_10_29.mat', 'ParsedData'),'zRF_1B_550_599');
    clear zRF_1B_550_599 % delete the chunk, just to keep things running quicker
    
    zRF_1B_600_649 = zRF_1B((zRF_1B.Subject >= 600) & (zRF_1B.Subject <= 649), :);
    save(getFileNameForThisOS('RFAll_1B-600_649-2015_10_29.mat', 'ParsedData'),'zRF_1B_600_649');
    clear zRF_1B_600_649 % delete the chunk, just to keep things running quicker
    zRF_1B_650_699 = zRF_1B((zRF_1B.Subject >= 650) & (zRF_1B.Subject <= 699), :);
    save(getFileNameForThisOS('RFAll_1B-650_699-2015_10_29.mat', 'ParsedData'),'zRF_1B_650_699');
    clear zRF_1B_650_699 % delete the chunk, just to keep things running quicker

    zRF_1B_700_749 = zRF_1B((zRF_1B.Subject >= 700) & (zRF_1B.Subject <= 749), :);
    save(getFileNameForThisOS('RFAll_1B-700_749-2015_10_29.mat', 'ParsedData'),'zRF_1B_700_749');
    clear zRF_1B_700_749 % delete the chunk, just to keep things running quicker
    zRF_1B_750_799 = zRF_1B((zRF_1B.Subject >= 750) & (zRF_1B.Subject <= 799), :);
    save(getFileNameForThisOS('RFAll_1B-750_799-2015_10_29.mat', 'ParsedData'),'zRF_1B_750_799');
    clear zRF_1B_750_799 % delete the chunk, just to keep things running quicker

    numberOfShiftsToInclude = 40; % first two days' worth of shifts
    [first_N_RFshifts] = getSomeRFshifts(excludeSubjects_RF_1B(true, true, false, zRF_1B), numberOfShiftsToInclude, 'all', 'first');
    save(getFileNameForThisOS('first_40_RFshifts_1B_final-2015_12_3.mat', 'ParsedData'),'first_N_RFshifts','-v7.3');
    clear first_N_RFshifts % delete the chunk, just to keep things running quicker
    clear numberOfShiftsToInclude % delete the variable, just to keep things cleaner
    
    zRF_1B_SwitchOnly = zRF_1B(strcmpi(zRF_1B.Cluster, 'S'), :);
    save(getFileNameForThisOS('RF_SwitchOnly_1B_final-2015_10_29.mat', 'ParsedData'),'zRF_1B_SwitchOnly');
    clear zRF_1B_SwitchOnly % delete the chunk, just to keep things running quicker
    
    zRF_1B_InhibitOnly = zRF_1B(strcmpi(zRF_1B.Cluster, 'I'), :);
    save(getFileNameForThisOS('RF_InhibitOnly_1B_final-2015_10_29.mat', 'ParsedData'),'zRF_1B_InhibitOnly');
    clear zRF_1B_InhibitOnly % delete the chunk, just to keep things running quicker

    zRF_1B_UpdateOnly = zRF_1B(strcmpi(zRF_1B.Cluster, 'U'), :);
    save(getFileNameForThisOS('RF_UpdateOnly_1B_final-2015_10_29.mat', 'ParsedData'),'zRF_1B_UpdateOnly','-v7.3');
    clear zRF_1B_UpdateOnly % delete the chunk, just to keep things running quicker
    
%    save(getFileNameForThisOS('RFData_1B_final-2015_10_29.mat', 'ParsedData'),'zRFData_1B');
%    clear zRFData_1B % delete the chunk, just to keep things running quicker
%    save(getFileNameForThisOS('RFSum_1B_final-2015_10_29.mat', 'ParsedData'),'zRFSum_1B');
%    clear zRFSum_1B % delete the chunk, just to keep things running quicker

    
% PREP: pre-exclude subjects for speed (use "includedSubjs" for other functions rather than RF_All) 
% Z: even this is too big, now; have to do it in chunks          includedSubjs = excludeSubjects_RF_1B(true, true, false, zRF_1B); 




% GET INFO ABOUT PARTICIPANTS TO DESCRIBE THEM IN A PAPER
% first, ensure that all the groups of subjects we're using are the same
delMe = excludeSubjects_RF_1B(false, true, false, first_N_RFshifts); % make sure we're only dealing with people who Finished (or Finished*)
delMe1 = excludeSubjects_RF_1B(false, true, false, zPPinhibit_1B); % make sure we're only dealing with people who Finished (or Finished*)
delMe2 = excludeSubjects_RF_1B(false, true, false, zPPswitch_1B); % make sure we're only dealing with people who Finished (or Finished*)
delMe3 = excludeSubjects_RF_1B(false, true, false, zPPupdate_1B); % make sure we're only dealing with people who Finished (or Finished*)
[delMe8, delMe9] = removeNonMatchingSubjects(delMe.Subject, delMe, delMe1.Subject, delMe1, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe8.Subject)) % 299     <--- TOTAL PARTICIPANTS
length(unique(delMe9.Subject)) % 299
[delMe8, delMe9] = removeNonMatchingSubjects(delMe.Subject, delMe, delMe2.Subject, delMe2, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe9.Subject)) % sanity check: should also be 299
[delMe8, delMe9] = removeNonMatchingSubjects(delMe.Subject, delMe, delMe3.Subject, delMe3, false, false); % last input is "verbose" - turn it on if something is unexpected
length(unique(delMe9.Subject)) % sanity check: should also be 299
% then, describe them
delMe7 = []; % clear it, then get one line per subject (for demographics)
delMe6 = unique(delMe8.Subject); 
for delMe5 = 1:(length(delMe6))
    delMe4 = delMe9(delMe9.Subject == delMe6(delMe5), :); % subj rows
    delMe7 = [delMe7; delMe4(1,:)]; % single row from this subj
end
height(delMe7) % sanity check: should also be 299
length(unique(delMe7.Subject)) % sanity check: should also be 299
height(delMe7(strcmpi(delMe7.Gender, 'Male'),:)) % 165     <--- MALE PARTICIPANTS
height(delMe7(strcmpi(delMe7.Gender, 'Female'),:)) % 134
min(delMe7.Age) % 18     <--- PARTICIPANTS' AGE RANGE: MIN
max(delMe7.Age) % 65    <--- PARTICIPANTS' AGE RANGE: MAX
mean(delMe7.Age) % 24.53    <--- PARTICIPANTS' AGE RANGE: AVG
std(delMe7.Age) % 6.3    <--- PARTICIPANTS' AGE RANGE: SD
median(delMe7.Age) % 23    <--- PARTICIPANTS' AGE RANGE: MEDIAN
delMe7(strcmpi(delMe7.EduYears,'20+'),:).EduYears = {20}; % some chucklehead wrote a string rather than a number; replace it
delMe7.EduYears = cell2mat(delMe7.EduYears); % now that they're all numbers, we can make it a matrix rather than a cell structure
min(delMe7.EduYears) % 5     <--- PARTICIPANTS' EDUCATION RANGE: MIN
max(delMe7.EduYears) % 24     <--- PARTICIPANTS' EDUCATION RANGE: MAX
mean(delMe7.EduYears) % 16.4     <--- PARTICIPANTS' EDUCATION RANGE: AVG
std(delMe7.EduYears) % 2.7    <--- PARTICIPANTS' EDUCATION RANGE: SD
median(delMe7.EduYears) % 16     <--- PARTICIPANTS' EDUCATION RANGE: MEDIAN
unique(delMe7.Institution)
height(delMe7(strcmpi(delMe7.Institution, 'NEU'),:)) % 83     <--- PARTICIPANTS WHO TRAINED AT NEU
height(delMe7(strcmpi(delMe7.Institution, 'Harvard'),:)) % 74     <--- PARTICIPANTS WHO TRAINED AT HARVARD
height(delMe7(strcmpi(delMe7.Institution, 'Oxford'),:)) % 67     <--- PARTICIPANTS WHO TRAINED AT OXFORD
height(delMe7(strcmpi(delMe7.Institution, 'Honeywell'),:)) % 75     <--- PARTICIPANTS WHO TRAINED AT HONEYWELL

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




% 1B: Compare Switch RF Ability (first two days) (from GLM) with Switch Pretest Ability (from GLM) 
[x_PPSw, y_PPSw] = getDataForPreSwitchGLM(excludeSubjects_RF_1B(true, true, zPPswitch_1B), '1B', false);
PPSwModel = fitglm(x_PPSw,y_PPSw,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount + RT + (Subj*RT)','distr','binomial','Intercept',true,'CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','TrialCount','Correct'})

% check if A_i and Alpha_i coefficients correlate for PP
delPPSubjLen = length(unique(x_PPSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delMe2 = [-20 20]; % X limits; everything outside of this is an outlier, just looking at the graph
%delMe3 = [-5 10]; % Y limits; everything outside of this is an outlier, just looking at the graph
zScatter(PPSwModel.Coefficients.Estimate(2:((2+delPPSubjLen)-1)), PPSwModel.Coefficients.Estimate(((end-delPPSubjLen)+1):end), 'Comparing PP Ability to Reaction Time, per Subj', 'A_i coefficient (excluding values > 20)', 'Alpha_i coefficient', true, '', '', 14, false, delMe2, '')

numberOfShiftsToInclude = 40; % first two days' worth of shifts
[first_N_RFshifts] = getSomeRFshifts(excludeSubjects_RF_1B(true, true, false, zRF_1B), numberOfShiftsToInclude, 'all', 'first');
%half shifts doesnt really help    first2SwShifts = getHalfRFshifts(first2SwShifts, 'last'); % just get the last half of the shifts, to account for switching-shift dip in performance
[~,~,switchDataRF] = getCleanSwitchTrials_RF_1B(true, true, 'both', 'S', first_N_RFshifts);
[x_RFSw, y_RFSw] = getDataForSwitchGLM(switchDataRF, '1B', false, 'TrialCount', 'all', 'single');
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount - Cluster - TrialDur + RT + (Subj*RT)','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})

% check if A_i and Alpha_i coefficients correlate for RF
delRFSubjLen = length(unique(x_RFSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
zScatter(RFSwModel.Coefficients.Estimate(2:((2+delRFSubjLen)-1)), RFSwModel.Coefficients.Estimate(((end-delRFSubjLen)+1):end), 'Comparing RF Ability to Reaction Time, per Subj', 'A_i coefficient', 'Alpha_i coefficient', true, '', '', 14, false, '', '')

% now just graph the Alpha values
zScatter(unique(x_RFSw(:,1)), [0; RFSwModel.Coefficients.Estimate(((end-delRFSubjLen)+1):end)], 'Comparing RF Alpha values', 'Subj', 'Alpha_i coefficient', false, '', '', 14, false, '', '')
zScatter(unique(x_PPSw(:,1)), [0; PPSwModel.Coefficients.Estimate(((end-delPPSubjLen)+1):end)], 'Comparing PP Alpha values', 'Subj', 'Alpha_i coefficient (excluding values <-20)', false, '', '', 14, false, '', [-20 100])

% try putting the subjs in two groups: +/- Alpha coeff for RF (z: never finished this line of thinking...) 
%delMe = transpose(RFSwModel.CoefficientNames(:,RFSwModel.Coefficients.Estimate < 0)) % all coeffs for RF
%delMe2 = delMe(((end-delRFSubjLen)+1):end)


% Z: USE THESE ONLY TO COMPARE MODELS USING ALPHA_i TO MODELS USING JUST ALPHA 
 PPSwModel = fitglm(x_PPSw,y_PPSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount + RT','distr','binomial','Intercept',true,'CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','TrialCount','Correct'})
 RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount - Cluster - TrialDur + RT','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})


% clean up subjects that don't match between the two
delRFSubjLen = length(unique(x_RFSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delPPSubjLen = length(unique(x_PPSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delMe4 = transpose(RFSwModel.CoefficientNames(2:((2+delRFSubjLen)-1))); % just the Ability names (Subj_X)
delMe5 = transpose(PPSwModel.CoefficientNames(2:((2+delPPSubjLen)-1))); % just the Ability names (Subj_X)
delMe = RFSwModel.Coefficients.Estimate((2:((2+delRFSubjLen)-1)),1); % just the Ability estimates
delMe2 = PPSwModel.Coefficients.Estimate((2:((2+delPPSubjLen)-1)),1); % just the Ability estimates
[delMe, delMe2] = removeNonMatchingSubjects(delMe4, delMe, delMe5, delMe2);

zScatter(delMe, delMe2, 'Comparing Switch: Pretest Ability to RF Ability\n(first two days of training)', 'RF Switch Ability (GLM est.)', 'Pretest Switch Ability (excluding values > 15)', true, '', '', 14, true, '', [-15 15])
% zNOTE: THIS IS WRONG! 6 and 7 are excluding the wrong names' indices... I think  
%zScatter(delMe6, delMe7, 'Comparing Switch: Pretest Alphas to RF Alphas\n(first two days of training)', 'RF Switch Alpha_i (GLM est.)', 'Pretest Switch Alpha_i', true, '', '', 14, true, '', '')


% check to see if anything changes in the Ability correlations if we use only Switch or only Repetition trials 
x_PPSw_OnlySw = x_PPSw;
y_PPSw_OnlySw = y_PPSw;
y_PPSw_OnlySw(x_PPSw_OnlySw(:,2) == 2, :) = []; % delete all repetition trials noted in *x_* from *y_*
x_PPSw_OnlySw(x_PPSw_OnlySw(:,2) == 2, :) = []; % delete all repetition trials from x_
x_PPSw_OnlySw(:, 2) = []; % delete the column indicating sw/rep
PPSwModel_OnlySw = fitglm(x_PPSw_OnlySw,y_PPSw_OnlySw,'logit(Correct) ~ 1 + Subj - TrialCount + RT + (Subj*RT)','distr','binomial','Intercept',true,'CategoricalVars',[1],'VarNames',{'Subj','RT','TrialCount','Correct'})

x_RFSw_OnlySw = x_RFSw;
y_RFSw_OnlySw = y_RFSw;
y_RFSw_OnlySw(x_RFSw_OnlySw(:,2) == 2, :) = []; % delete all repetition trials noted in *x_* from *y_*
x_RFSw_OnlySw(x_RFSw_OnlySw(:,2) == 2, :) = []; % delete all repetition trials from x_
x_RFSw_OnlySw(:, 2) = []; % delete the column indicating sw/rep
RFSwModel_OnlySw = fitglm(x_RFSw_OnlySw,y_RFSw_OnlySw,'logit(Correct) ~ 1 + Subj - TrialCount - Cluster - TrialDur + RT + (Subj*RT)','distr','binomial','CategoricalVars',[1,4,5],'VarNames',{'Subj','RT','TrialCount','Cluster','TrialDur','Correct'})

% clean up subjects that don't match between the two
delRFSubjLen = length(unique(x_RFSw_OnlySw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delPPSubjLen = length(unique(x_PPSw_OnlySw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delMe4 = transpose(RFSwModel_OnlySw.CoefficientNames(2:((2+delRFSubjLen)-1))); % just the Ability names (Subj_X)
delMe5 = transpose(PPSwModel_OnlySw.CoefficientNames(2:((2+delPPSubjLen)-1))); % just the Ability names (Subj_X)
delMe = RFSwModel_OnlySw.Coefficients.Estimate((2:((2+delRFSubjLen)-1)),1); % just the Ability estimates
delMe2 = PPSwModel_OnlySw.Coefficients.Estimate((2:((2+delPPSubjLen)-1)),1); % just the Ability estimates
[delMe, delMe2] = removeNonMatchingSubjects(delMe4, delMe, delMe5, delMe2);

zScatter(delMe, delMe2, 'Comparing Switch: Pretest Ability to RF Ability\n(Switch, only first two days of training)', 'RF Switch Ability (GLM est.)', 'Pretest Switch Ability (excluding values > 15)', true, '', '', 14, true, '', [-15 15])


% try comparing the two COSTs (Cost = A_i + (Alpha_i * mean(RT)), per subj)
delRFSubjLen = length(unique(x_RFSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
RFSwTable = [];
delMe2 = unique(x_RFSw(:,1)); % subj list
for delMe = 1:(length(delMe2)) % each subj in RF model
    delMe3 = x_RFSw(x_RFSw(:,1) == delMe2(delMe),:); % all "trials" for this subj
    delMe4 = mean(delMe3(:,3)); % avg RT for this subj
%    delMe4 = mean(delMe3(delMe3(:,2) == 1,3)); % avg Sw RT for this subj
%    delMe4 = mean(delMe3(delMe3(:,2) == 2,3)); % avg Rep RT for this subj
    delMe5 = RFSwModel.Coefficients.Estimate(delMe) + (delMe4 * RFSwModel.Coefficients.Estimate((end-delRFSubjLen)+(delMe-1)));
    RFSwTable(delMe,1:5) = [delMe2(delMe) delMe4 RFSwModel.Coefficients.Estimate(delMe) RFSwModel.Coefficients.Estimate((end-delRFSubjLen)+(delMe-1)) delMe5];
end
RFSwTable(1,3) = 0; % true A_i for the first participant isn't known; estimated to be 0
RFSwTable(1,4) = 0; % true Alpha_i for the first participant isn't known; estimated to be 0
RFSwTable(1,5) = 0 % true ...

delPPSubjLen = length(unique(x_PPSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
PPSwTable = [];
delMe2 = unique(x_PPSw(:,1)); % subj list
for delMe = 1:(length(delMe2)) % each subj in RF model
    delMe3 = x_PPSw(x_PPSw(:,1) == delMe2(delMe),:); % all "trials" for this subj
    delMe4 = mean(delMe3(:,3)); % avg RT for this subj
%    delMe4 = mean(delMe3(delMe3(:,2) == 1,3)); % avg Sw RT for this subj
%    delMe4 = mean(delMe3(delMe3(:,2) == 2,3)); % avg Rep RT for this subj
    delMe5 = PPSwModel.Coefficients.Estimate(delMe) + (delMe4 * PPSwModel.Coefficients.Estimate((end-delPPSubjLen)+(delMe-1)));
    PPSwTable(delMe,1:5) = [delMe2(delMe) delMe4 PPSwModel.Coefficients.Estimate(delMe) PPSwModel.Coefficients.Estimate((end-delPPSubjLen)+(delMe-1)) delMe5];
end
PPSwTable(1,3) = 0; % true A_i for the first participant isn't known; estimated to be 0
PPSwTable(1,4) = 0; % true Alpha_i for the first participant isn't known; estimated to be 0
PPSwTable(1,5) = 0 % true ...

% clean up subjects that don't match between the two
[RFSwTable, PPSwTable] = removeNonMatchingSubjects(RFSwTable(:,1), RFSwTable, PPSwTable(:,1), PPSwTable);

zScatter(RFSwTable(:,5), PPSwTable(:,5), 'Comparing Switch: Pretest AbilityCost to RF AbilityCost\n(Switch, only first two days of training)', 'RF Switch AbilityCost (GLM est.)', 'Pretest Switch AbilityCost (excluding values > 4)', true, '', '', 14, true, '', [-4 4])



% check to see if anything changes in the Ability correlations if we use only single Trial Durations (1, 2, or 3s) 
x_RFSw_Only1s = x_RFSw;
y_RFSw_Only1s = y_RFSw;
y_RFSw_Only1s(x_RFSw_Only1s(:,6) ~= 1, :) = []; % delete all trials from Y where X duration isn't 1
x_RFSw_Only1s(x_RFSw_Only1s(:,6) ~= 1, :) = []; % delete all trials from X where X duration isn't 1
RFSwModel_Only1s = fitglm(x_RFSw_Only1s,y_RFSw_Only1s,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount - Cluster - TrialDur + RT','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})
PPSwModel_OnlyOneDur = fitglm(x_PPSw,y_PPSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount + RT','distr','binomial','Intercept',true,'CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','TrialCount','Correct'})
delRFSubjLen = length(unique(x_RFSw_Only1s(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delPPSubjLen = length(unique(x_PPSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delMe4 = transpose(RFSwModel_Only1s.CoefficientNames(2:((2+delRFSubjLen)-1))); % just the Ability names (Subj_X)
delMe5 = transpose(PPSwModel_OnlyOneDur.CoefficientNames(2:((2+delPPSubjLen)-1))); % just the Ability names (Subj_X)
xVals_Only1s = RFSwModel_Only1s.Coefficients.Estimate((2:((2+delRFSubjLen)-1)),1); % just the Ability estimates
yVals_OnlyOneDur = PPSwModel_OnlyOneDur.Coefficients.Estimate((2:((2+delPPSubjLen)-1)),1); % just the Ability estimates
[xVals_Only1s, yVals_OnlyOneDur1] = removeNonMatchingSubjects(delMe4, xVals_Only1s, delMe5, yVals_OnlyOneDur);
% check 1s only
zScatter(xVals_Only1s, yVals_OnlyOneDur1, 'Comparing Switch: Pretest Ability to RF Ability\n(first two days of training)', 'RF Switch Ability (GLM est.)', 'Pretest Switch Ability (excluding values > 15)', true, '', '', 14, true, '', [-15 15])

x_RFSw_Only2s = x_RFSw;
y_RFSw_Only2s = y_RFSw;
y_RFSw_Only2s(x_RFSw_Only2s(:,6) ~= 2, :) = []; % delete all trials from Y where X duration isn't 2
x_RFSw_Only2s(x_RFSw_Only2s(:,6) ~= 2, :) = []; % delete all trials from X where X duration isn't 2
RFSwModel_Only2s = fitglm(x_RFSw_Only2s,y_RFSw_Only2s,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount - Cluster - TrialDur + RT','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})
%PP model remains the same as above (PPSwModel_OnlyOneDur)
delRFSubjLen = length(unique(x_RFSw_Only2s(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delMe4 = transpose(RFSwModel_Only2s.CoefficientNames(2:((2+delRFSubjLen)-1))); % just the Ability names (Subj_X)
xVals_Only2s = RFSwModel_Only2s.Coefficients.Estimate((2:((2+delRFSubjLen)-1)),1); % just the Ability estimates
[xVals_Only2s, yVals_OnlyOneDur2] = removeNonMatchingSubjects(delMe4, xVals_Only2s, delMe5, yVals_OnlyOneDur);
% check 2s only
zScatter(xVals_Only2s, yVals_OnlyOneDur2, 'Comparing Switch: Pretest Ability to RF Ability\n(first two days of training)', 'RF Switch Ability (GLM est.)', 'Pretest Switch Ability (excluding values > 15)', true, '', '', 14, true, '', [-15 15])

x_RFSw_Only3s = x_RFSw;
y_RFSw_Only3s = y_RFSw;
y_RFSw_Only3s(x_RFSw_Only3s(:,6) ~= 3, :) = []; % delete all trials from Y where X duration isn't 3
x_RFSw_Only3s(x_RFSw_Only3s(:,6) ~= 3, :) = []; % delete all trials from X where X duration isn't 3
RFSwModel_Only3s = fitglm(x_RFSw_Only3s,y_RFSw_Only3s,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount - Cluster - TrialDur + RT','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})
%PP model remains the same as above (PPSwModel_OnlyOneDur)
delRFSubjLen = length(unique(x_RFSw_Only3s(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
delMe4 = transpose(RFSwModel_Only3s.CoefficientNames(2:((2+delRFSubjLen)-1))); % just the Ability names (Subj_X)
xVals_Only3s = RFSwModel_Only3s.Coefficients.Estimate((2:((2+delRFSubjLen)-1)),1); % just the Ability estimates
[xVals_Only3s, yVals_OnlyOneDur3] = removeNonMatchingSubjects(delMe4, xVals_Only3s, delMe5, yVals_OnlyOneDur);
% check 3s only
zScatter(xVals_Only3s, yVals_OnlyOneDur3, 'Comparing Switch: Pretest Ability to RF Ability\n(first two days of training)', 'RF Switch Ability (GLM est.)', 'Pretest Switch Ability (excluding values > 15)', true, '', '', 14, true, '', [-15 15])

% now display them all on one graph
delMe = [xVals_Only1s;xVals_Only2s;xVals_Only3s]; % x values
delMe2 = [yVals_OnlyOneDur1;yVals_OnlyOneDur2;yVals_OnlyOneDur3]; % y values
delMe3 = [ones(length(yVals_OnlyOneDur1),1); ... % grouping values (1, 2, 3)
    (ones(length(yVals_OnlyOneDur2),1) + 1); ...
    (ones(length(yVals_OnlyOneDur3),1) + 2)];
gscatter(delMe, delMe2, delMe3, 'rgb', '...', [15 15 15], 'on', 'RF Switch Ability (colors = different timeouts)', 'Pretest Switch Ability (same for each RF color)')
axis([-3 3 -3 3]); % this seems to be about the right range to remove outliers... should probably do this more programmatically




 
% estimate Switch Ability using Least-Squares method (rather than GLM's Maximum Likelihood) 
% first, make a GLM to estimate the difficulty (or rather: "easiness") of Switch and Rep trials (NOTE: WITH OTHER PARAMETERS???) 
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount - Cluster - TrialDur - RT','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})
Dj_RF = 0.60516; % RF rep "easiness" (RF switch ease = 0); estimated with no RT, no Cluster, and no TrialCount
PPSwModel = fitglm(x_PPSw,y_PPSw,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount - RT','distr','binomial','Intercept',true,'CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','TrialCount','Correct'})
Dj_PP = 0.60791; % PP rep "easiness" (PP switch ease = 0); estimated with no RT and no TrialCount

delMe4 = unique(zPPswitch_1B.Subject); % unique subj numbers
delMe5 = unique(switchDataRF.Subject); % unique subj numbers
[delMe3, ~] = removeNonMatchingSubjects(delMe4, delMe4, delMe5, delMe5); % overlapping subj numbers
[~,~,delMe4] = getCleanSwitchTrials_PP_1A3(true, true, 'both', 'pre', true, zPPswitch_1B); % reuse delMe4 for Pretest switch trials
for subjIndex = 1:length(delMe3) % go through all subj nums
    delMe8 = delMe3(subjIndex); % get the subject number
    
    % first do RF
    delMe9 = switchDataRF(switchDataRF.Subject == delMe8, :); % this subject's "trials"
    delMe10 = delMe9(delMe9.SwitchFlag == 1, :); % this subj's switch trials
    delMe11 = delMe9(delMe9.SwitchFlag == 2, :); % this subj's rep trials
    delMe = height(delMe10(delMe10.Correct == 1, :)) / height(delMe10); % prob of correct on switch
    if (delMe == 1) % they got all of them correct; assume they'd've gotten the next one wrong
        delMe = height(delMe10(delMe10.Correct == 1, :)) / (height(delMe10) + 1); 
    elseif (delMe == 0) % they got all of them wrong; assume they'd've gotten the next one right
        delMe = 1 / (height(delMe10) + 1); 
    end
    delMe2 = height(delMe11(delMe11.Correct == 1, :)) / height(delMe11); % prob of correct on repetition
    if (delMe2 == 1) % they got all of them correct; assume they'd've gotten the next one wrong
        delMe2 = height(delMe11(delMe11.Correct == 1, :)) / (height(delMe11) + 1);
    elseif (delMe2 == 0) % they got all of them wrong; assume they'd've gotten the next one right
        delMe2 = 1 / (height(delMe11) + 1);
    end
    AiSw_RF = cdf('Logistic', delMe) - Dj_RF;
    AiRep_RF = cdf('Logistic', delMe2) - Dj_RF;
    
    % now do the same for Pretest
    delMe9 = delMe4(delMe4.Subject == delMe8, :); % this subject's "trials"
    delMe10 = delMe9(delMe9.IsSwitch == 1, :); % this subj's switch trials
    delMe11 = delMe9(delMe9.IsSwitch == 0, :); % this subj's rep trials
    delMe = height(delMe10(delMe10.Correct == 1, :)) / height(delMe10); % prob of correct on switch
    if (delMe == 1) % they got all of them correct; assume they'd've gotten the next one wrong
        delMe = height(delMe10(delMe10.Correct == 1, :)) / (height(delMe10) + 1); 
    elseif (delMe == 0) % they got all of them wrong; assume they'd've gotten the next one right
        delMe = 1 / (height(delMe10) + 1); 
    end
    delMe2 = height(delMe11(delMe11.Correct == 1, :)) / height(delMe11); % prob of correct on repetition
    if (delMe2 == 1) % they got all of them correct; assume they'd've gotten the next one wrong
        delMe2 = height(delMe11(delMe11.Correct == 1, :)) / (height(delMe11) + 1);
    elseif (delMe2 == 0) % they got all of them wrong; assume they'd've gotten the next one right
        delMe2 = 1 / (height(delMe11) + 1);
    end
    AiSw_PP = cdf('Logistic', delMe) - Dj_PP;
    AiRep_PP = cdf('Logistic', delMe2) - Dj_PP;
    
    Ai_RF_PP(subjIndex, :) = [delMe8 mean([AiSw_RF AiRep_RF]) mean([AiSw_PP AiRep_PP])]; % subj, RF ability, Pretest ability
end
Ai_RF_PP % note that subj 474 has nan in the 3rd col

% compare RF to PP, estimated using least-squares method
zScatter(Ai_RF_PP(:,2), Ai_RF_PP(:,3), 'Comparing Switch: Pretest Ability to RF Ability\n(estimated with Least-Squares method)', 'RF Switch Ability', 'Pretest Switch Ability', true, '', '', 14, true, '', '')
% compare RF estimated via GLM to RF estimated using least-squares method
delMe = Ai_RF_PP(:,2); 
delMe = delMe(2:end); % the GLM doesn't have an estimate for the first one, so have to remove it from this also 
delMe2 = RFSwModel.Coefficients.Estimate(2:end-1,1); % just the Ability estimates
zScatter(delMe, delMe2, 'Comparing Switch: RF Ability\n(estimated two different ways)', 'RF Switch Ability (least squares)', 'RF Switch Ability (GLM)', true, '', '', 14, true, '', '')
% compare Pretest estimated via GLM to RF estimated using least-squares method
delMe = Ai_RF_PP(:,3); 
delMe(isnan(delMe(:,1)),:) = []; % remove nan (subj 474)
delMe = delMe(2:end); % the GLM doesn't have an estimate for the first one, so have to remove it from this also 
delMe2 = PPSwModel.Coefficients.Estimate(2:end-1,1); % just the Ability estimates
zScatter(delMe, delMe2, 'Comparing Switch: Pretest Ability\n(estimated two different ways)', 'Pretest Switch Ability (least squares)', 'Pretest Switch Ability (GLM)', true, '', '', 14, true, '', '')
axis([-2.5 2.5 -2.5 2.5])








% 1B: Compare SwitchCost from Pretest to SwitchAbility (GLM) from RF (first two days) 
[PP_SC_1B] = getSwitchCostRT_PP_1B(includedPPswitch, false); % make this last input "true" if you want this printed out

numberOfShiftsToInclude = 40; % first two days' worth of shifts
[first_N_RFshifts] = getSomeRFshifts(excludeSubjects_RF_1B(true, true, false, zRF_1B), numberOfShiftsToInclude, 'all', 'first');
%half shifts doesnt really help    first2SwShifts = getHalfRFshifts(first2SwShifts, 'last'); % just get the last half of the shifts, to account for switching-shift dip in performance
[~,~,switchDataRF] = getCleanSwitchTrials_RF_1B(true, true, 'both', 'S', first_N_RFshifts, true);
% clean up subjects that don't match between the two, before you even calculate the model 
if (length(unique(switchDataRF.Subject)) ~= height(PP_SC_1B))
    fprintf('We have %d subjects for pretest and %d subjects for RF. Deleting the following subjects (may want to include them in excludeSubjects_RF_1B):\n', height(PP_SC_1B), length(delMe4));
    delMe = setdiff(PP_SC_1B.Subject, unique(switchDataRF.Subject))
    PP_SC_1B(ismember(PP_SC_1B.Subject, delMe), :) = [];
    delMe = setdiff(unique(switchDataRF.Subject), PP_SC_1B.Subject)
    switchDataRF(ismember(switchDataRF.Subject, delMe), :) = [];
end
% clean up subjects that don't have a SwCost for whatever reason
fprintf('We also may have some NaNs which will be deleted from both lists; here is the list:\n');
delMe = table2array([PP_SC_1B(isnan(PP_SC_1B.Pre_SC),'Subject')])
PP_SC_1B(ismember(PP_SC_1B.Subject, delMe), :) = [];
switchDataRF(ismember(switchDataRF.Subject, delMe), :) = [];
% now calculte the model
[x_RFSw, y_RFSw] = getDataForSwitchGLM(switchDataRF, '1B', false, 'TrialCount', 'all', 'single', true);
RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep + TrialCount - Cluster - TrialDur + RT','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'})
delRFcoeffs = RFSwModel.Coefficients.Estimate(:,1);
delRFcoeffs(1,1) = 0; % the first subject is the reference from which the others are estimated; overwrite the Intercept as this subject's coefficient
delRFcoeffs = delRFcoeffs(1:(length(delRFcoeffs)-3)); % remove the three coeffs for SwRep_2, RT, and TotalTrialCount

[PP_SC_1B.Subject PP_SC_1B.Pre_SC delRFcoeffs] % if something went wrong, one of these will be the wrong length and this line will break
scatter(PP_SC_1B.Pre_SC, delRFcoeffs, 'MarkerEdgeColor', 'blue') 
h = lsline; % add a least-squares regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(PP_SC_1B.Pre_SC, delRFcoeffs,1);
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(mean(PP_SC_1B.Pre_SC), mean(delRFcoeffs)-.05, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(PP_SC_1B.Pre_SC, delRFcoeffs,'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(mean(PP_SC_1B.Pre_SC), mean(delRFcoeffs)-.1, delStr, 'FontSize', 14);
str = sprintf('Switch Ability (GLM) from first two days of RF Switch trials compared to Pretest Switch Cost');
title(str)
xlabel('Pretest Switch Cost (ReactionTime)')
ylabel('RF Switch Ability (GLM, first 2 days)')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)





% check to see if different participants have different reactionTimes for different stimulus duration times 
%       NOTE: there are (so far) only 1s and 2s RF trials for Inhibit
checkRTdistributionPerTimeout_1B(first_N_RFshifts, zPPswitch_1B, 'S')


%[355,532,685,691, 634,142,767,2,108,195, 731,764, 763, 380,516,698];
delMe6 = [634,142,2,108,195, 731,764, 763, 380]; % remove these
delMe8 = delMe5;
delMe8(ismember(delMe8(:,1), delMe6), :) = [];
[delMe7, delMe8] = removeNonMatchingSubjects(delMe4(:,1), delMe4, delMe8(:,1), delMe8, false); 
zScatter(delMe7(:,2), delMe8(:,2), 'Inhibit SSRT', 'RF', 'Pretest', true, '', '', 14, false, '', '')






% 1B: Compare SwitchCost (reactionTime) from RF (first few trials) to SwitchCost from Pretest 
numberOfShiftsToInclude = 40; % first two days' worth of shifts
[first_N_RFshifts] = getSomeRFshifts(excludeSubjects_RF_1B(true, true, false, zRF_1B), numberOfShiftsToInclude, 'all', 'first');
% half shifts doesn't actually help     includedRFswitch = getHalfRFshifts(includedRFswitch, 'last'); % just get the last half of the shifts, to account for switching-shift dip in performance
[delMe] = getSwitchCostRT_RF_1B(first_N_RFshifts, 'single', false, true, false);
delMe3 = addPPswitchCols(zPPswitch_1B, false);
[delMe2] = getSwitchCostRT_PP_1B(excludeSubjects_RF_1B(true, true, delMe3), false, false); 

% if you want to remove subjs with >50% errors, run these lines (removes ~10 subjs, doesn't improve correlation) 
delMe(delMe.TotalErrPct > .5, :) = [];
delMe2(delMe2.TotalErrPct > .5, :) = [];

% clean up subjects that don't match between the two
[delMe, delMe2] = removeNonMatchingSubjects(delMe.Subject, delMe, delMe2.Subject, delMe2, true, false);

% clean up subjects that don't have a SwCost for whatever reason
fprintf('We also may have some NaNs which will be deleted from both lists; here is the list:\n');
delMe3 = table2array([delMe2(isnan(delMe2.Pre_SC),'Subject'); delMe(isnan(delMe.SwCost),'Subject')])
delMe2(ismember(delMe2.Subject, delMe3), :) = [];
delMe(ismember(delMe.Subject, delMe3), :) = [];

% Z - remember that zScatter can remove outliers if you want it to (not doing so right now) 
zScatter(delMe.SwCost, delMe2.Pre_SC, 'Switch Cost from first two days of RF Switch trials compared to Pretest Switch Cost', 'RF Switch Cost (RT; first 2 days)', 'Pretest Switch Cost (ReactionTime)', true, '', '', 14, true, '', '')








% Franziska's preTest (zPP_SwCost_Franziska) SwitchCost compared to first-two-days
numberOfShiftsToInclude = 40; % first two days' worth of shifts
[first_N_RFshifts] = getSomeRFshifts(excludeSubjects_RF_1B(true, true, false, zRF_1B), numberOfShiftsToInclude, 'all', 'first');
[RF_SC_1B] = getSwitchCostRT_RF_1B(first_N_RFshifts, 'single', false, true, false);
[~,~,delMe] = xlsread(strcat(getFileNameForThisOS('', 'ParsedData'), '1B-fromFranziska_SwitchCost_150521.xlsx'));
zPP_SwCost_Franziska = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end));
zPP_SwCost_Franziska.Subject = zPP_SwCost_Franziska.SubjNumBlinded; % just to make things simpler
% clean up subjects that don't match between the two
if (height(RF_SC_1B) ~= height(zPP_SwCost_Franziska))
    fprintf('We have %d subjects for pretest and %d subjects for RF. Deleting the following subjects (may want to include them in excludeSubjects_RF_1B):\n', height(PP_SC_1B), height(RF_SC_1B));
    delMe = setdiff(zPP_SwCost_Franziska.Subject, RF_SC_1B.Subject)
    zPP_SwCost_Franziska(ismember(zPP_SwCost_Franziska.Subject, delMe), :) = [];
    delMe = setdiff(RF_SC_1B.Subject, zPP_SwCost_Franziska.Subject)
    RF_SC_1B(ismember(RF_SC_1B.Subject, delMe), :) = [];
end
% clean up subjects that don't have a SwCost for whatever reason
fprintf('We also may have some NaNs which will be deleted from both lists; here is the list:\n');
delMe = table2array([zPP_SwCost_Franziska(isnan(zPP_SwCost_Franziska.TS_RTSC_Pre),'Subject'); RF_SC_1B(isnan(RF_SC_1B.SwCost),'Subject')])
zPP_SwCost_Franziska(ismember(zPP_SwCost_Franziska.Subject, delMe), :) = [];
RF_SC_1B(ismember(RF_SC_1B.Subject, delMe), :) = [];
% remove items that are <>3SDs from the mean
fprintf('We also may have some <>3SDs in the RF data which may be deleted from both lists; here is the list:\n');
delMeLow = mean(RF_SC_1B.SwCost) - (3 * std(RF_SC_1B.SwCost))
delMeHigh = mean(RF_SC_1B.SwCost) + (3 * std(RF_SC_1B.SwCost))
delMe = table2array(RF_SC_1B(((RF_SC_1B.SwCost < delMeLow) | (RF_SC_1B.SwCost > delMeHigh)), 'Subject'))
% Z: uncomment these two lines if you want to delete the outliers!
%PP_SC_1B(ismember(PP_SC_1B.Subject, delMe), :) = [];
%RF_SC_1B(ismember(RF_SC_1B.Subject, delMe), :) = [];
fprintf('We also may have some <>3SDs in the PP data which may be deleted from both lists; here is the list:\n');
delMeLow = mean(PP_SC_1B.Pre_SC) - (3 * std(PP_SC_1B.Pre_SC))
delMeHigh = mean(PP_SC_1B.Pre_SC) + (3 * std(PP_SC_1B.Pre_SC))
delMe = table2array(PP_SC_1B(((PP_SC_1B.Pre_SC < delMeLow) | (PP_SC_1B.Pre_SC > delMeHigh)), 'Subject'))
% Z: uncomment these two lines if you want to delete the outliers!
%PP_SC_1B(ismember(PP_SC_1B.Subject, delMe), :) = [];
%RF_SC_1B(ismember(RF_SC_1B.Subject, delMe), :) = [];

[zPP_SwCost_Franziska.Subject zPP_SwCost_Franziska.TS_RTSC_Pre RF_SC_1B.SwCost]
scatter(zPP_SwCost_Franziska.TS_RTSC_Pre, RF_SC_1B.SwCost, 'MarkerEdgeColor', 'blue') 
h = lsline; % add a least-squares regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(zPP_SwCost_Franziska.TS_RTSC_Pre, RF_SC_1B.SwCost,1);
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(mean(zPP_SwCost_Franziska.TS_RTSC_Pre), mean(RF_SC_1B.SwCost)-.05, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(zPP_SwCost_Franziska.TS_RTSC_Pre, RF_SC_1B.SwCost,'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(mean(zPP_SwCost_Franziska.TS_RTSC_Pre), mean(RF_SC_1B.SwCost)-.1, delStr, 'FontSize', 14);
str = sprintf('Switch Cost from first two days of RF Switch trials compared to Pretest Switch Cost');
title(str)
xlabel('Pretest Switch Cost (Franziska, ReactionTime)')
ylabel('RF Switch Cost (first 2 days)')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)



% 1B: Compare SSRT from RF (first third of trials) to SSRT from Pretest
[inh_go_1B, inh_NonGo_1B] = getCleanInhibitTrials_RF_1A3(true, 'GoBoth', 'correct', 'Go', false, zRFAll_1B);
[inh_SSRT_thirds_RF_1B] = getSSRTthirds_RF_1B(inh_go_1B, inh_NonGo_1B, true, false); % note: make the last "false" a true if you want this printed out

includedPPinhibit = excludeSubjects_RF_1B(true, true, zPPinhibit_1B);
includedPPinhibit(strcmpi(includedPPinhibit.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
[SSRT_PP_table] = getSSRT_PP_1B(includedPPinhibit, false); % make this last input "true" if you want this printed out

if (height(inh_SSRT_thirds_RF_1B) ~= height(SSRT_PP_table))
    fprintf('We have %d subjects for pretest and %d subjects for RF. Deleting the following subjects (may want to include them in excludeSubjects_RF_1B):\n', height(SSRT_PP_table), height(inh_SSRT_thirds_RF_1B));
    delMe = setdiff(SSRT_PP_table.Subject, inh_SSRT_thirds_RF_1B.Subject)
    SSRT_PP_table(ismember(SSRT_PP_table.Subject, delMe), :) = [];
    delMe = setdiff(inh_SSRT_thirds_RF_1B.Subject, SSRT_PP_table.Subject)
    inh_SSRT_thirds_RF_1B(ismember(inh_SSRT_thirds_RF_1B.Subject, delMe), :) = [];
end
CompareSSRT_RF_Pretest = [SSRT_PP_table.Subject inh_SSRT_thirds_RF_1B.FirstThirdSSRT SSRT_PP_table.PreSSRT]; % NOTE: if you look at this, it'll look like the second and third columns are all 0s, but they're not!

scatter(CompareSSRT_RF_Pretest(:,2), CompareSSRT_RF_Pretest(:,3), 'MarkerEdgeColor', 'blue') 
h = lsline; % add a least-squares regression line just for the ability coefficients
set(h,'LineWidth',2);
[delP, delS] = polyfit(CompareSSRT_RF_Pretest(:,2), CompareSSRT_RF_Pretest(:,3),1); % RF has TotalTrialCount, so has one more parameter (hence the -3 rather than -2)
delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));
text(mean(CompareSSRT_RF_Pretest(:,2)), mean(CompareSSRT_RF_Pretest(:,3))-.1, delStr, 'FontSize', 14); % and put it on the graph
delR_Sq = regstats(CompareSSRT_RF_Pretest(:,2),CompareSSRT_RF_Pretest(:,3),'linear',{'rsquare'}); % also the r^2 value
delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
text(mean(CompareSSRT_RF_Pretest(:,2)), mean(CompareSSRT_RF_Pretest(:,3))-.2, delStr, 'FontSize', 14);
str = sprintf('SSRT from first third of RF Inhibit trials compared to Pretest Inhibit');
title(str)
xlabel('RF first-third SSRT')
ylabel('Pretest SSRT')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)


% 1B: Compare SSRT from RF (first two days) to SSRT from Pretest
numberOfShiftsToInclude = 40; % first two days
[first_N_RFshifts] = getSomeRFshifts(excludeSubjects_RF_1B(true, true, zRFAll_1B), numberOfShiftsToInclude, 'all', 'first');
[SSRT_RF_firstShifts_table] = getSSRT_RF_1B(first_N_RFshifts, 'single', false, true, false);  

includedPPinhibit = excludeSubjects_RF_1B(true, true, zPPinhibit_1B);
includedPPinhibit(strcmpi(includedPPinhibit.Period,'0-Pretest') == 0, :) = []; % only grab the pretest data
[SSRT_PP_table] = getSSRT_PP_1B(includedPPinhibit, false, false, false); 

% make sure the two tables only have one set of subjects
[SSRT_RF_firstShifts_table, SSRT_PP_table] = removeNonMatchingSubjects(SSRT_RF_firstShifts_table.Subject, SSRT_RF_firstShifts_table, SSRT_PP_table.Subject, SSRT_PP_table, true, false);

% three cols: subj, RF SSRT, PP SSRT
CompareSSRT_RF_Pretest = [SSRT_PP_table.Subject SSRT_RF_firstShifts_table.SSRT_est SSRT_PP_table.PreSSRT] 
% just to see if the two RF calculations correlate.....    CompareSSRT_RF_Pretest = [SSRT_PP_table.Subject inh_SSRT_thirds_RF_1B.FirstThirdSSRT SSRT_RF_firstShifts_table.SSRT_est]; % NOTE: if you look at this, it'll look like the second and third columns are all 0s, but they're not!

% remove subjs with > mean+2SDs number of responses "before" inhibit cue in Pretest 
delMe3 = [12;157;174;199;220;242;419;562;669;737];
CompareSSRT_RF_Pretest(ismember(CompareSSRT_RF_Pretest(:,1), delMe3),:) = [];

% remove subjs with > half of catch trials failed in Pretest 
delMe3 = [41;134;152;270;496;526;606;607;673;703;707;775;18;90;524;649];
CompareSSRT_RF_Pretest(ismember(CompareSSRT_RF_Pretest(:,1), delMe3),:) = [];

% remove subjs with < 59% (mean-3SDs) of Go trials correct in Pretest 
delMe3 = [10;90;199;435;554;587;663];
CompareSSRT_RF_Pretest(ismember(CompareSSRT_RF_Pretest(:,1), delMe3),:) = [];

% remove subjs with < 40% (mean-2SDs) of catch trials correct in RF 
delMe3 = [41;338;562;707;737;771];
CompareSSRT_RF_Pretest(ismember(CompareSSRT_RF_Pretest(:,1), delMe3),:) = [];

% remove subjs with < 76% (mean-2SDs) of Go trials correct in RF 
delMe3 = [171;199;435;476;496;499;781];
CompareSSRT_RF_Pretest(ismember(CompareSSRT_RF_Pretest(:,1), delMe3),:) = [];

% remove random subjs that seem like outliers (FIND A GOOD REASON OR DON'T DO THIS!) 
delMe3 = [572]; % something about these makes them have a high RF SSRT; look into it
CompareSSRT_RF_Pretest(ismember(CompareSSRT_RF_Pretest(:,1), delMe3),:) = [];


zScatter(CompareSSRT_RF_Pretest(:,2), CompareSSRT_RF_Pretest(:,3), 'SSRT from first two days of RF Inhibit trials compared to Pretest Inhibit', 'RF first-two-days SSRT', 'Pretest SSRT', true, '', '', 14, true, '', '')


% FIGURING OUT WHY SSRT VALUES DON'T CORRELATE WELL
% problematic points on this graph: 
%  pretest SSRT < .01 (note that this is not a reasonable human reaction time) 
%  pretest SSRT > .4 don't seem very well correlated with rf
%  rf > SSRT .45 don't seem very well correlated with pretest

[delMe, delMe2, delMe3, delMe4] = exploreSSRT_1B(includedPPinhibit, SSRT_RF_firstShifts_table)


% check to see if anything changes in the SSRT correlations if we use only single Trial Durations for RF (1, 2, or 3s) (note using same Pretest for all) 
first_N_RFshifts_Only1sDur = first_N_RFshifts(first_N_RFshifts.StimShowTime == 1, :); % just the 1s trials
[SSRT_RF_firstShifts_Only1sDur] = getSSRT_RF_1B(first_N_RFshifts_Only1sDur, 'single', false, true); 
[SSRT_RF_firstShifts_Only1sDur, SSRT_PP_table_Only1sDur] = removeNonMatchingSubjects(SSRT_RF_firstShifts_Only1sDur.Subject, SSRT_RF_firstShifts_Only1sDur, SSRT_PP_table.Subject, SSRT_PP_table); % note we're just using the full pretest table, but renaming it to match
CompareSSRT_Only1sDur = [SSRT_PP_table_Only1sDur.Subject SSRT_RF_firstShifts_Only1sDur.SSRT_est SSRT_PP_table_Only1sDur.PreSSRT] 
% remove subjs known to have problems from previous analyses
delMe3 = [12;157;174;199;220;242;419;562;669;737;41;134;152;270;496;526;606;607;673;703;707;775;18;90;524;649;10;90;199;435;554;587;663;41;338;562;707;737;771;171;199;435;476;496;499;781;572]; 
CompareSSRT_Only1sDur(ismember(CompareSSRT_Only1sDur(:,1), delMe3),:) = [];
% remove subjs noted to have problems in this 1s dur (241 = SSRT < 0, 450 and 701 had no catch trials) 
delMe3 = [241;450;701]; 
CompareSSRT_Only1sDur(ismember(CompareSSRT_Only1sDur(:,1), delMe3),:) = [];
zScatter(CompareSSRT_Only1sDur(:,2), CompareSSRT_Only1sDur(:,3), 'SSRT from first two days of RF Inhibit trials compared to Pretest Inhibit', 'RF first-two-days SSRT (1s trial durations)', 'Pretest SSRT', true, '', '', 14, false, '', '')

first_N_RFshifts_Only2sDur = first_N_RFshifts(first_N_RFshifts.StimShowTime == 2, :); % just the 2s trials
[SSRT_RF_firstShifts_Only2sDur] = getSSRT_RF_1B(first_N_RFshifts_Only2sDur, 'single', false, true);  
[SSRT_RF_firstShifts_Only2sDur, SSRT_PP_table_Only2sDur] = removeNonMatchingSubjects(SSRT_RF_firstShifts_Only2sDur.Subject, SSRT_RF_firstShifts_Only2sDur, SSRT_PP_table.Subject, SSRT_PP_table); % note we're just using the full pretest table, but renaming it to match
CompareSSRT_Only2sDur = [SSRT_PP_table_Only2sDur.Subject SSRT_RF_firstShifts_Only2sDur.SSRT_est SSRT_PP_table_Only2sDur.PreSSRT] 
% remove subjs known to have problems from previous analyses
delMe3 = [12;157;174;199;220;242;419;562;669;737;41;134;152;270;496;526;606;607;673;703;707;775;18;90;524;649;10;90;199;435;554;587;663;41;338;562;707;737;771;171;199;435;476;496;499;781;572]; 
CompareSSRT_Only2sDur(ismember(CompareSSRT_Only2sDur(:,1), delMe3),:) = [];
% remove subjs noted to have problems in this 1s dur (27;90;212;230;338;404;532;649;654;710;781 made no errors) 
delMe3 = [27;90;212;230;338;404;532;649;654;710;781]; 
CompareSSRT_Only2sDur(ismember(CompareSSRT_Only2sDur(:,1), delMe3),:) = [];
zScatter(CompareSSRT_Only2sDur(:,2), CompareSSRT_Only2sDur(:,3), 'SSRT from first two days of RF Inhibit trials compared to Pretest Inhibit', 'RF first-two-days SSRT (2s trial durations)', 'Pretest SSRT', true, '', '', 14, false, '', '')

first_N_RFshifts_Only3sDur = first_N_RFshifts(first_N_RFshifts.StimShowTime == 3, :); % just the 3s trials
% Z: as of 8/11/15, this is ZERO! (We have no one with a 3s trial duration Inhibit-only trial!) 
height(first_N_RFshifts_Only3sDur(strcmpi(first_N_RFshifts_Only3sDur.Cluster,'I'),:))

% now display them all on one graph
delMe = [CompareSSRT_Only1sDur(:,2);CompareSSRT_Only2sDur(:,2)]; % x values
delMe2 = [CompareSSRT_Only1sDur(:,3);CompareSSRT_Only2sDur(:,3)]; % y values
delMe3 = [ones(length(CompareSSRT_Only1sDur(:,3)),1); ... % grouping values (1, 2)
    (ones(length(CompareSSRT_Only2sDur(:,3)),1) + 1)];
gscatter(delMe, delMe2, delMe3, 'rg', '...', [15 15], 'on', 'RF SSRT (colors = different timeouts)', 'Pretest SSRT (same for each RF color)')
axis([-3 3 -3 3]); % this seems to be about the right range to remove outliers... should probably do this more programmatically




% check to see if different participants have different reactionTimes for different stimulus duration times 
%       NOTE: there are (so far) only 1s and 2s RF trials for Inhibit
checkRTdistributionPerTimeout_1B(first_N_RFshifts, zPPinhibit_1B, 'I')





% 1B: Compare Update Ability (GLM) in Pretest and first two days of RF

numberOfShiftsToInclude = 40; % first two days
[first_N_RFshifts] = getSomeRFshifts(excludeSubjects_RF_1B(true, true, false, zRF_1B), numberOfShiftsToInclude, 'all', 'first');
[x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(first_N_RFshifts, false, false, 'TrialCount', 'all', 'single', true);
RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + TrialCount - Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','Nval','RT','TrialCount','Cluster','Correct'})
%printGLMcoeffs(RFUpdModel, true);
Upd_RF_table = table(transpose(RFUpdModel.CoefficientNames(2:(end-6))),RFUpdModel.Coefficients.Estimate(2:(end-6)),'VariableNames', {'Subject','Coefficient'});

zPPupdate_1B_singleTrials = singleArrowPerTrial_PP_1B(zPPupdate_1B, false); % make the usual PPupdate into one-arrow-per-line
y_PPUpd = zeros(height(zPPupdate_1B_singleTrials),1);
y_PPUpd(strcmpi(zPPupdate_1B_singleTrials.ArrScore, 'correct'),1) = 1;
x_PPUpd = table2array(zPPupdate_1B_singleTrials(:,'Subject'));
x_PPUpd(:,2) = table2array(zPPupdate_1B_singleTrials(:,'origArrLettNum'));
x_PPUpd(:,3) = table2array(zPPupdate_1B_singleTrials(:,'SeqLength'));
PPUpdModel = fitglm(x_PPUpd,y_PPUpd,'logit(Correct) ~ 1 + Subj + Narr + SeqLen','distr','binomial','CategoricalVars',[1,2,3],'VarNames',{'Subj','Narr','SeqLen','Correct'})
%printGLMcoeffs(PPUpdModel, true);
Upd_PP_table = table(transpose(PPUpdModel.CoefficientNames(2:(end-7))),PPUpdModel.Coefficients.Estimate(2:(end-7)),'VariableNames', {'Subject','Coefficient'});

if (height(Upd_RF_table) ~= height(Upd_PP_table))
    fprintf('We have %d subjects for pretest and %d subjects for RF. Deleting the following subjects (may want to include them in excludeSubjects_RF_1B):\n', height(Upd_PP_table), height(Upd_RF_table));
    delMe = setdiff(Upd_PP_table.Subject, Upd_RF_table.Subject) % list the subjs in PP that aren't in RF
    Upd_PP_table(ismember(Upd_PP_table.Subject, delMe), :) = []; % and delete them
    delMe = setdiff(Upd_RF_table.Subject, Upd_PP_table.Subject) % list the subjs in RF that aren't in PP
    Upd_RF_table(ismember(Upd_RF_table.Subject, delMe), :) = []; % and delete them
end

zScatter(Upd_RF_table.Coefficient, Upd_PP_table.Coefficient, 'Update Ability from first two days of RF Update trials compared to Pretest Ability\n(both calculated from GLM)', 'RF first-two-days Update Ability', 'Pretest Update Ability (all arrows)', true, '', '', 14, false, '', '')




% 1B: Compare Update Accuracy in Pretest (arrows) and first two days of RF (N-back) 
delMe3 = first_N_RFshifts(strcmpi(first_N_RFshifts.Cluster, 'u'),:);
delMe = table(0,0.0,0.0,'VariableNames', {'Subject','NonNBack_CorrectPct','NBack_CorrectPct'});
delMe5 = unique(delMe3.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = delMe3(delMe3.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe7 = delMe6(delMe6.NbackFlag ~= 1, :); % delMe7 = Non N-back trials
    delMe8 = height(delMe7(delMe7.Correct == true,:)) / height(delMe7);
    delMe9 = delMe6(delMe6.NbackFlag == 1, :); % delMe9 = N-back trials
    delMe10 = height(delMe9(delMe9.Correct == true,:)) / height(delMe9);
    delMe(delMe4,:) = {delMe5(delMe4) delMe8 delMe10};
end

% z: only do this line if you haven't already defined singleTrials; takes a few minutes           zPPupdate_1B_singleTrials = singleArrowPerTrial_PP_1B(zPPupdate_1B, false); % make the usual PPupdate into one-arrow-per-line
includedPPupdate = excludeSubjects_RF_1B(true, true, false, zPPupdate_1B_singleTrials);
delMe2 = table(0,0.0,0.0,'VariableNames', {'Subject','Let_CorrectPct','Arr_CorrectPct'});
delMe5 = unique(includedPPupdate.Subject); % delMe5 = uniqueSubjs
for delMe4 = 1:length(delMe5) % delMe4 = subjIndex
    delMe6 = includedPPupdate(includedPPupdate.Subject == delMe5(delMe4), :); % delMe6 = subjTrials
    delMe8 = height(delMe6(strcmpi(delMe6.LetScore, 'correct'), :)) / height(delMe6);
    delMe10 = height(delMe6(strcmpi(delMe6.ArrScore, 'correct'), :)) / height(delMe6);
    
    delMe2(delMe4,:) = {delMe5(delMe4) delMe8 delMe10};
end

[delMe, delMe2] = removeNonMatchingSubjects(delMe.Subject, delMe, delMe2.Subject, delMe2, true, false);

zScatter(delMe.NBack_CorrectPct, delMe2.Arr_CorrectPct, 'Update Accuracy from first two days of RF N-back trials\ncompared to Pretest Arrow trials', 'RF first-two-days N-back accuracy', 'Pretest arrow rotation accuracy', true, '', '', 14, true, '', '')






% Compare U and S difficulty, for each stimulus duration

delMe = first_N_RFshifts_Only1sDur(strcmpi(first_N_RFshifts_Only1sDur.Cluster, 'U'), :);
delMe2 = first_N_RFshifts_Only1sDur(strcmpi(first_N_RFshifts_Only1sDur.Cluster, 'S'), :);
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
delMe = first_N_RFshifts_Only2sDur(strcmpi(first_N_RFshifts_Only2sDur.Cluster, 'U'), :);
delMe2 = first_N_RFshifts_Only2sDur(strcmpi(first_N_RFshifts_Only2sDur.Cluster, 'S'), :);
% now save it
delMe12 = delMe10; % table for 2s duration
% now re-run the above, with the following delMe and delMe2
delMe = first_N_RFshifts_Only3sDur(strcmpi(first_N_RFshifts_Only3sDur.Cluster, 'U'), :);
delMe2 = first_N_RFshifts_Only3sDur(strcmpi(first_N_RFshifts_Only3sDur.Cluster, 'S'), :);
% now save it
delMe13 = delMe10; % table for 3s duration

% now, compare
mean(delMe11.U_PctCorrect)
mean(delMe11.S_PctCorrect)
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe11.U_PctCorrect, delMe11.S_PctCorrect,'Tail','right')

mean(delMe12.U_PctCorrect)
mean(delMe12.S_PctCorrect)
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe12.U_PctCorrect, delMe12.S_PctCorrect,'Tail','right')

mean(delMe13.U_PctCorrect)
mean(delMe13.S_PctCorrect)
[delMe15, delMe16, delMe17, delMe18] = ttest(delMe13.U_PctCorrect, delMe13.S_PctCorrect,'Tail','right')

