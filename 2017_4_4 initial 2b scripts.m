% Zephy McKanna
% initial scripts to understand the 2b data
% 4/4/17


%if (exist('zPPinhibit_1B', 'var') == 0) % if we don't have this variable, assume we don't have any of them...
%    [zPPinhibit_1B, zPPswitch_1B, zPPupdate_1B] = formTables_RF_1A3('1b-final-Parsed.inhibit.xlsx', '1b-final-Parsed.switch.xlsx', '1b-final-Parsed.rotation.xlsx', true);
%end
%[zRFData_2B, zRFSum_2B, zRFAll_2B] = formTables_RF_1A3('2b-latest-rf-data.xlsx', '2b-latest-rf-sum.xlsx', '2b-latest-rf-trials.00.xlsx', true);
[~, zRFSum_2B, ~] = formTables_RF_1A3('', '2b-latest-rf-sum.xlsx', '', true);
[~, zRFSum_1B, ~] = formTables_RF_1A3('', '1b-final-Parsed.rf-sum.xlsx', '', true);


% zNOTE: LAST TIME (7/31/17) this took FIVE HOURS even before saving!
warning('off','MATLAB:nonIntegerTruncatedInConversionToChar'); % turn the warning off; otherwise we'll see it millions of times
delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '2b-latest-rf-trials.00.xlsx');
[~,~,delMe] = xlsread(delPath); 
length(delMe(:,1)) % should be close to 5000000
delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '2b-latest-rf-trials.01.xlsx');
[~,~,delMe2] = xlsread(delPath); 
delMe = [delMe;delMe2]; % concatenate the new rows onto the end
length(delMe(:,1)) % might as well keep reporting this, since xlsread gives us zero feedback
delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '2b-latest-rf-trials.02.xlsx');
[~,~,delMe2] = xlsread(delPath); 
delMe = [delMe;delMe2]; % concatenate the new rows onto the end
length(delMe(:,1)) % might as well keep reporting this, since xlsread gives us zero feedback
delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '2b-latest-rf-trials.03.xlsx');
[~,~,delMe2] = xlsread(delPath); 
delMe = [delMe;delMe2]; % concatenate the new rows onto the end
length(delMe(:,1)) % might as well keep reporting this, since xlsread gives us zero feedback
delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '2b-latest-rf-trials.04.xlsx');
[~,~,delMe2] = xlsread(delPath); 
delMe = [delMe;delMe2]; % concatenate the new rows onto the end
length(delMe(:,1)) % might as well keep reporting this, since xlsread gives us zero feedback
delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '2b-latest-rf-trials.05.xlsx');
[~,~,delMe2] = xlsread(delPath); 
delMe = [delMe;delMe2]; % concatenate the new rows onto the end
length(delMe(:,1)) % might as well keep reporting this, since xlsread gives us zero feedback
delPath = strcat(getFileNameForThisOS('', 'ParsedData'), '2b-latest-rf-trials.06.xlsx');
[~,~,delMe2] = xlsread(delPath); 
delMe = [delMe;delMe2]; % concatenate the new rows onto the end
length(delMe(:,1)) % might as well keep reporting this, since xlsread gives us zero feedback

fprintf('Done reading in excel files; making it into a table now.\n');
clear delMe2 delPath % for speed

delMe(1,1:end) = strrep(delMe(1,1:end), '-', ''); % remove all hyphens from the first row; table variable names can't have hyphens, apparently
delMe(1,1:end) = strrep(delMe(1,1:end), '#', 'Number'); % remove all # from the first row; table variable names can't have #, apparently
delMe(1,1:end) = strrep(delMe(1,1:end), '(', '_'); % remove all # from the first row; table variable names can't have (), apparently
delMe(1,1:end) = strrep(delMe(1,1:end), ')', ''); % remove all # from the first row; table variable names can't have (), apparently
delMe(1,1:end) = strrep(delMe(1,1:end), '/', ''); % remove all / from the first row; table variable names can't have hyphens, apparently
zRFAll_2B = cell2table(delMe(2:end, 1:end), 'VariableNames', delMe(1,1:end)); % use the first row as the table col (variable) names
zRFAll_2B(isnan(zRFAll_2B.Subject) == true,:) = [];
warning('on','MATLAB:nonIntegerTruncatedInConversionToChar'); % turn the warning back on, in case it's helpful for other functions later
clear delMe % for speed

zNOTE: NEED TO DEAL WITH THIS SHIFT IN putNewColsIntoDataTable_2B:
> In putNewColsIntoDataTable_2B (line 1324) 
Warning: putNewColsIntoDataTable_1B: unexpected shift:
Transportationization (I)

[zRF_2B] = putNewColsIntoDataTable_2B(zRFAll_2B); % add the extra columns
clear zRFAll_2B % for speed
save(getFileNameForThisOS('RFAll_2B_2017_month_day.mat', 'ParsedData'), 'zRF_2B','-v7.3'); % THIS TAKES HOURS BY ITSELF

% might be useful to save this as tables of a size we can handle
zRF_2B_T1 = zRF_2B(zRF_2B.RfTNumber == 1, :);
save(getFileNameForThisOS('RF_2B_T1_2017_7_31.mat', 'ParsedData'), 'zRF_2B_T1');
clear zRF_2B_T1
% repeat for all training days (should just be 1-11, but might want to make sure)
zRF_2B_T11 = zRF_2B(zRF_2B.RfTNumber == 11, :);
save(getFileNameForThisOS('RF_2B_T11_2017_7_31.mat', 'ParsedData'), 'zRF_2B_T11');
clear zRF_2B_T11

zRF_2B_T12 = zRF_2B(zRF_2B.RfTNumber == 12, :);
height(zRF_2B_T12) % check to make sure there are none of these


delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
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

delMe2.AvgCompleted = delMe2.NumberCompleted / length(unique(delMe.Subject)); 
delMe2
writetable(delMe2, getFileNameForThisOS('avgClustersCompleted_2B-output.csv', 'IntResults'));

length(unique(delMe.Subject)) % get the number of subjects finished or in retention

% now get the min, max, and average number of shifts per subject
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
shiftCount = table(0,0,'VariableNames',{'Subject','ShiftCount'});
subjs = unique(delMe.Subject);
for i = 1:length(subjs)
    subj = subjs(i);
    subjShifts = delMe(delMe.Subject == subj,:);
    shiftCount(i,:) = table(subj,height(subjShifts),'VariableNames',{'Subject','ShiftCount'});
end
shiftCount 
max(shiftCount.ShiftCount)
min(shiftCount.ShiftCount) 
mean(shiftCount.ShiftCount) 
clear shiftCount subjs subj i subjShifts


% check out 1B for comparison
[zRFData_1B, zRFSum_1B, ~] = formTables_RF_1A3('1b-final-Parsed.rf-data.xlsx', '1b-final-Parsed.rf-sum.xlsx', '', true);
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
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

delMe2.AvgCompleted = delMe2.NumberCompleted / length(unique(delMe.Subject)); 
delMe2
writetable(delMe2, getFileNameForThisOS('avgClustersCompleted_1B-output.csv', 'IntResults'));


% now get the min, max, and average number of shifts per subject (1B)
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
shiftCount = table(0,0,'VariableNames',{'Subject','ShiftCount'});
subjs = unique(delMe.Subject);
for i = 1:length(subjs)
    subj = subjs(i);
    subjShifts = delMe(delMe.Subject == subj,:);
    shiftCount(i,:) = table(subj,height(subjShifts),'VariableNames',{'Subject','ShiftCount'});
end
shiftCount 
max(shiftCount.ShiftCount)
min(shiftCount.ShiftCount) 
mean(shiftCount.ShiftCount) 
clear shiftCount subjs subj i subjShifts



% check the clusters completed from 2B
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded

% and compare to the clusters completed from 1B
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded




% check highly-educated people from 2B
delMe4 = [5001 3003 3016 4017 5008 5010 5013 4004 4007 4008 4009 4019 4020 4022 4025 4030 4036 4037 5012];
delMe = zRFSum_2B(ismember(zRFSum_2B.Subject,delMe4),:);
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
delMe2.AvgCompleted = delMe2.NumberCompleted / length(unique(delMe.Subject)); 
delMe2
writetable(delMe2, getFileNameForThisOS('avgClustersCompleted_2B-output.csv', 'IntResults'));
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded


% and the less-educated oned (someBach and someHS) from 1B
delMe4 = [716 5 7 9 21 23 40 42 54 59 69 82 108 114 125 247 248 300 353 410 455 602 612 613 618 624 632 657 675 700 707 719 13 24 36  119 126 244 260 270 278 350 619 663 676 705 720 721 726 4 8 10 16 22 27 63 70 74 84 124 128 132 214 232 337 413 415 423 426 476 486 604 626 649 664 709 715 722 11 17 37 48 88 105 206 240 253 276 320 429 456 474 481 608 614 627 633 668 711 717 430 81];
delMe = zRFSum_1B(ismember(zRFSum_1B.Subject,delMe4),:);
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
delMe2.AvgCompleted = delMe2.NumberCompleted / length(unique(delMe.Subject)); 
delMe2
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded


clear zRFData_2B zRFSum_2B zRFAll_2B % when we don't need them anymore...






% delve into S/I/Logic: almost everybody completes this in 1B and almost nobody in 2B
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
delMe2 = delMe(strcmpi(delMe.Cluster,'S'),:);
height(delMe2) % 941
length(unique(delMe2.Subject)) % 60 (everybody)
height(delMe2) / length(unique(delMe2.Subject)) % 15.68 - took 15 shifts to beat S, on average
delMe3 = delMe(strcmpi(delMe.Cluster,'S/I/Logic'),:);
height(delMe3) % 1330
length(unique(delMe3.Subject)) % 60 (everybody)
height(delMe3) / length(unique(delMe3.Subject)) % 22 - saw 22 shifts of S/I/Logic, on average
delMe3.ClusterComplete % 4 people completed it
delMe3.Accuracy % 4 people completed it
writetable(delMe3, getFileNameForThisOS('2017_4_25-2B_S-I-Logic.csv', 'IntResults'));

delMe5 = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
delMe7 = delMe5(strcmpi(delMe5.Cluster,'S/I/Logic'),:);
height(delMe7) % 1748
length(unique(delMe7.Subject)) % 300 (everybody)
height(delMe7) / length(unique(delMe7.Subject)) % 5.8 - saw 5.8 shifts of S/I/Logic, on average
writetable(delMe7, getFileNameForThisOS('2017_4_25-1B_S-I-Logic.csv', 'IntResults'));


% notes from call:
 - figure out how much more time people are spending on the U/I/Logic and S/I/Logic in this phase than last phase
 - (su) look into just people who got 220 shifts
 - (su) look into the free text on the engagement questionnaire
 - (su) perhaps the RAs can look into where people actually get on the last day
 - (su) look into per-site differences
 
 

% look at the distributions of the RespTime for S/I/Logic for 1B and 2B
delMe = zRFAll_2B(strcmpi(zRFAll_2B.Cluster, 'S/I/Logic'),:);
load('/Users/Shared/SHARP/ParsedData/RFAll_1B-650_699-2015_10_29.mat')
delMe2 = zRF_1B_650_699(strcmpi(zRF_1B_650_699.Cluster, 'S/I/Logic'),:);
[delMe3, delMe4] = ttest2(delMe.RespTime, delMe2.RespTime) % t-test says they're significantly different, but that's just because of so many trials

figure
histogram(delMe.RespTime)
hold on
histogram(delMe2.RespTime) % they don't look very different
hold off
title(sprintf('Distribution of RespTime for S-I-Logic (1B and 2B)'));
legend('2B','1B')
xlabel('Response Time')
ylabel('Count of trials')

figure
histogram(delMe.StimTime)
hold on
histogram(delMe2.StimTime)
hold off
title(sprintf('Distribution of StimTime for S-I-Logic (1B and 2B)'));
legend('2B','1B')
xlabel('Duration of stimulus')
ylabel('Count of trials')

delMe = zRFSum_2B(strcmpi(zRFSum_2B.Cluster, 'S/I/Logic'),:);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'S/I/Logic'),:);
figure
histogram(delMe.Accuracy)
hold on
histogram(delMe2.Accuracy)
hold off
title(sprintf('Distribution of Accuracy for S-I-Logic (1B and 2B)'));
legend('2B','1B')
xlabel('Accuracy')
ylabel('Count of shifts')
 
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Cluster, 'S/I/Logic'),:);
delMe = delMe(delMe.StimTime == 1, :);
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'S/I/Logic'),:);
delMe2 = delMe2(delMe2.StimTime == 1, :);
figure
histogram(delMe.Accuracy)
hold on
histogram(delMe2.Accuracy)
hold off
title(sprintf('Distribution of Accuracy for S-I-Logic (StimTime = 1)'));
legend('2B','1B')
xlabel('Accuracy')
ylabel('Count of shifts where StimTime = 1')

% INTERESTING... there's no big difference between 1B and 2B accuracy for the fixed U/I shifts... 
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Odditizing (U/I)'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Limb Reparations (U/I)'),:)];
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Odditizing (U/I)'),:);
delMe2 = [delMe2; zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Limb Reparations (U/I)'),:)];
figure
histogram(delMe.Accuracy)
hold on
histogram(delMe2.Accuracy)
hold off
title(sprintf('Distribution of Accuracy for fixed U-I shifts'));
legend('2B','1B')
xlabel('Accuracy')
ylabel('Count of shifts (Odditizing and Limb Reparations)')

% massive difference for fixed I/Logic shifts
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Braincase Downsizing (I)'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'ATC Prioritizing (I)'),:)];
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Flipper Exception (I)'),:)];
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Braincase Downsizing (I)'),:);
delMe2 = [delMe2; zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'ATC Prioritizing (I)'),:)];
delMe2 = [delMe2; zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Flipper Exception (I)'),:)];
figure
histogram(delMe.Accuracy)
hold on
histogram(delMe2.Accuracy)
hold off
title(sprintf('Distribution of Accuracy for fixed I-Logic shifts'));
legend('2B','1B')
xlabel('Accuracy')
ylabel('Count of shifts (3 fixed I-Logic)')

% clear, though not as massive, difference in fixed U/I/Logic shifts
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Digit Arrangement (U/I)'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'PI Memorization (U/I)'),:)];
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Language Crunching (U/I)'),:)];
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Digit Arrangement (U/I)'),:);
delMe2 = [delMe2; zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'PI Memorization (U/I)'),:)];
delMe2 = [delMe2; zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Language Crunching (U/I)'),:)];
figure
histogram(delMe.Accuracy)
hold on
histogram(delMe2.Accuracy)
hold off
title(sprintf('Distribution of Accuracy for fixed U-I-Logic shifts'));
legend('2B','1B')
xlabel('Accuracy')
ylabel('Count of shifts (3 fixed U-I-Logic)')

% massive difference for fixed S/I/Logic shifts
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Ocular Orientation (S/I)'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Cartography Catharsis (S/I)'),:)];
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Shift, 'Generational Gapping  (S/I)'),:)];
delMe2 = zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Ocular Orientation (S/I)'),:);
delMe2 = [delMe2; zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Cartography Catharsis (S/I)'),:)];
delMe2 = [delMe2; zRFSum_1B(strcmpi(zRFSum_1B.Shift, 'Generational Gapping  (S/I)'),:)];
figure
histogram(delMe.Accuracy)
hold on
histogram(delMe2.Accuracy)
hold off
title(sprintf('Distribution of Accuracy for fixed S-I-Logic shifts'));
legend('2B','1B')
xlabel('Accuracy')
ylabel('Count of shifts (3 fixed S-I-Logic)')

probDist2B = fitdist(delMe.Accuracy,'Normal')
probDist1B = fitdist(delMe2.Accuracy,'Normal')
percentages = 0:1:100;
accuracyDist2B = pdf(probDist2B,percentages);
accuracyDist1B = pdf(probDist1B,percentages);
plot(percentages,accuracyDist2B,'LineWidth',2)
hold on
plot(percentages,accuracyDist1B,'LineWidth',2)
hold off
title(sprintf('Distribution of Accuracy for fixed S-I-Logic shifts'));
legend('2B','1B')
xlabel('Accuracy')
ylabel('Probability density (over all participants)')
set(findall(gca,'type','text'),'FontSize',22)
set(findall(gca,'type','axes'),'FontSize',18)

clear probDist2B probDist1B percentages accuracyDist2B accuracyDist1B

%{ 
These were the Inhibit shifts that were fixed (no longer single-stim):
32: Odditizing U/I
34: Limb Reparations U/I
66: Braincase Downsizing I/Logic
67: ATC Prioritizing I/Logic
68: Flipper Exception I/Logic
78: Digit Arrangement U/I/Logic
79: PI Memorization U/I/Logic
80: Language Crunching U/I/Logic
82: Ocular Orientation S/I/Logic
83: Cartography Catharsis S/I/Logic
84: Generational Gapping S/I/Logic
%}

% if we remove all of these clusters, what does clusters completed look like? 
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
delMe(strcmpi(delMe.Cluster, 'S/I/Logic'),:) = [];
delMe(strcmpi(delMe.Cluster, 'U/I/Logic'),:) = [];
delMe(strcmpi(delMe.Cluster, 'U/I'),:) = [];
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded

% and compare to the clusters completed from 1B
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
delMe(strcmpi(delMe.Cluster, 'S/I/Logic'),:) = [];
delMe(strcmpi(delMe.Cluster, 'U/I/Logic'),:) = [];
delMe(strcmpi(delMe.Cluster, 'U/I'),:) = [];
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded


% what percentage of people passed S/I/Logic in 1B from fixed shifts?
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
delMe = delMe(strcmpi(delMe.Cluster, 'S/I/Logic'),:);
delMe2 = delMe(strcmpi(delMe.Shift, 'Ocular Orientation (S/I)'),:);
delMe2 = [delMe2; delMe(strcmpi(delMe.Shift, 'Cartography Catharsis (S/I)'),:)];
delMe2 = [delMe2; delMe(strcmpi(delMe.Shift, 'Generational Gapping  (S/I)'),:)];
delMe3 = delMe(strcmpi(delMe.ClusterComplete, 'S/I/Logic'),:);
delMe4 = delMe2(strcmpi(delMe2.ClusterComplete, 'S/I/Logic'),:);
height(delMe4) / height(delMe3) % 100%!

% How about U/I/Logic?
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
delMe = delMe(strcmpi(delMe.Cluster, 'U/I/Logic'),:);
delMe2 = delMe(strcmpi(delMe.Shift, 'Digit Arrangement (U/I)'),:);
delMe2 = [delMe2; delMe(strcmpi(delMe.Shift, 'PI Memorization (U/I)'),:)];
delMe2 = [delMe2; delMe(strcmpi(delMe.Shift, 'Language Crunching (U/I)'),:)];
delMe3 = delMe(strcmpi(delMe.ClusterComplete, 'U/I/Logic'),:);
delMe4 = delMe2(strcmpi(delMe2.ClusterComplete, 'U/I/Logic'),:);
height(delMe4) / height(delMe3) % 57%

% How about U/I?
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
delMe = delMe(strcmpi(delMe.Cluster, 'U/I'),:);
delMe2 = delMe(strcmpi(delMe.Shift, 'Odditizing (U/I)'),:);
delMe2 = [delMe2; delMe(strcmpi(delMe.Shift, 'Limb Reparations (U/I)'),:)];
delMe3 = delMe(strcmpi(delMe.ClusterComplete, 'U/I'),:);
delMe4 = delMe2(strcmpi(delMe2.ClusterComplete, 'U/I'),:);
height(delMe4) / height(delMe3) % 90%!

% how much time are people spending in Lv4a?
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Cluster, 'L4aV1'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Cluster, 'L4aV2'),:)];
minuteCount2B = table(0,0,'VariableNames',{'Subject','MinInCluster'});
delMe2 = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe2 = [delMe2; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
subjects = unique(delMe2.Subject); % just grab the subjects who are done
for i=1:length(subjects)
    subj = subjects(i);
    subjShifts = delMe(delMe.Subject == subj,:);
    minuteCount2B(i,:) = table(subj,2*height(subjShifts),'VariableNames',{'Subject','MinInCluster'});
end
delMe3 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'L4aV1'),:);
delMe3 = [delMe3; zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 'L4aV2'),:)];
minuteCount1B = table(0,0,'VariableNames',{'Subject','MinInCluster'});
delMe4 = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
subjects = unique(delMe4.Subject); % just grab the subjects who are done
for i=1:length(subjects)
    subj = subjects(i);
    subjShifts = delMe3(delMe3.Subject == subj,:);
    minuteCount1B(i,:) = table(subj,2*height(subjShifts),'VariableNames',{'Subject','MinInCluster'});
end

figure
histogram(minuteCount2B.MinInCluster)
hold on
histogram(minuteCount1B.MinInCluster)
hold off
title(sprintf('Distribution of time in Lv4a shifts'));
legend('2B','1B')
xlabel('Minutes')
ylabel('Count of subjects')

probDist2B = fitdist(minuteCount2B.MinInCluster,'Normal')
probDist1B = fitdist(minuteCount1B.MinInCluster,'Normal')
minutes = 0:1:120;
timeDist2B = pdf(probDist2B,minutes);
timeDist1B = pdf(probDist1B,minutes);
plot(minutes,timeDist2B,'LineWidth',2)
hold on
plot(minutes,timeDist1B,'LineWidth',2)
hold off
title(sprintf('Distribution of time in Lv4a shifts'));
legend('2B','1B')
xlabel('Minutes')
ylabel('Probability density (over all participants)')
set(findall(gca,'type','text'),'FontSize',22)
set(findall(gca,'type','axes'),'FontSize',18)

clear probDist2B probDist1B minutes timeDist2B timeDist1B


% how much time are people spending in Switch (should be the same)?
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Cluster, 's'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Cluster, 's'),:)];
minuteCount2B = table(0,0,'VariableNames',{'Subject','MinInCluster'});
delMe2 = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe2 = [delMe2; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
subjects = unique(delMe2.Subject); % just grab the subjects who are done
for i=1:length(subjects)
    subj = subjects(i);
    subjShifts = delMe(delMe.Subject == subj,:);
    minuteCount2B(i,:) = table(subj,2*height(subjShifts),'VariableNames',{'Subject','MinInCluster'});
end
delMe3 = zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 's'),:);
delMe3 = [delMe3; zRFSum_1B(strcmpi(zRFSum_1B.Cluster, 's'),:)];
minuteCount1B = table(0,0,'VariableNames',{'Subject','MinInCluster'});
delMe4 = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);
subjects = unique(delMe4.Subject); % just grab the subjects who are done
for i=1:length(subjects)
    subj = subjects(i);
    subjShifts = delMe3(delMe3.Subject == subj,:);
    minuteCount1B(i,:) = table(subj,2*height(subjShifts),'VariableNames',{'Subject','MinInCluster'});
end

probDist2B = fitdist(minuteCount2B.MinInCluster,'Normal')
probDist1B = fitdist(minuteCount1B.MinInCluster,'Normal')
minutes = 0:1:200;
timeDist2B = pdf(probDist2B,minutes);
timeDist1B = pdf(probDist1B,minutes);
plot(minutes,timeDist2B,'LineWidth',2)
hold on
plot(minutes,timeDist1B,'LineWidth',2)
hold off
title(sprintf('Distribution of time in Single-EF switching shifts'));
legend('2B','1B')
xlabel('Minutes')
ylabel('Probability density (over all participants)')
set(findall(gca,'type','text'),'FontSize',22)
set(findall(gca,'type','axes'),'FontSize',18)



clear i subjects subj subjShifts minuteCount2B minuteCount1B


% how much time are people spending in each cluster?
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
finishedSubjects = unique(delMe.Subject); % just grab the subjects who are done
clusters = unique(zRFSum_2B.Cluster);
clustersMinutesTable2B = table({'Temp'},0,0,'VariableNames',{'Cluster','AvgMin','SD'});
for c = 1:length(clusters)
    cluster = clusters(c);
    tableForThisCluster = table(0,0,'VariableNames',{'Subject','MinInCluster'});
    for i = 1:length(finishedSubjects)
        subj = finishedSubjects(i);
        subjShifts = delMe(delMe.Subject == subj,:);
        subjShifts = subjShifts(strcmpi(subjShifts.Cluster,cluster),:);
        tableForThisCluster(i,:) = table(subj,2*height(subjShifts),'VariableNames',{'Subject','MinInCluster'});
    end
    clustersMinutesTable2B(c,:) = table(cluster, ...
        mean(tableForThisCluster.MinInCluster), std(tableForThisCluster.MinInCluster), ...
        'VariableNames',{'Cluster','AvgMin','SD'});
end
writetable(clustersMinutesTable2B, getFileNameForThisOS('2017_4_27-2B_clustersMinutesTable2B.csv', 'IntResults'));
    
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'finished'),:);
finishedSubjects = unique(delMe.Subject); % just grab the subjects who are done
clusters = unique(zRFSum_1B.Cluster);
clustersMinutesTable1B = table({'Temp'},0,0,'VariableNames',{'Cluster','AvgMin','SD'});
for c = 1:length(clusters)
    cluster = clusters(c);
    tableForThisCluster = table(0,0,'VariableNames',{'Subject','MinInCluster'});
    for i = 1:length(finishedSubjects)
        subj = finishedSubjects(i);
        subjShifts = delMe(delMe.Subject == subj,:);
        subjShifts = subjShifts(strcmpi(subjShifts.Cluster,cluster),:);
        tableForThisCluster(i,:) = table(subj,2*height(subjShifts),'VariableNames',{'Subject','MinInCluster'});
    end
    clustersMinutesTable1B(c,:) = table(cluster, ...
        mean(tableForThisCluster.MinInCluster), std(tableForThisCluster.MinInCluster), ...
        'VariableNames',{'Cluster','AvgMin','SD'});
end
writetable(clustersMinutesTable1B, getFileNameForThisOS('2017_4_27-2B_clustersMinutesTable1B.csv', 'IntResults'));
  
clear finishedSubjects clusters c cluster tableForThisCluster i subjShifts
clear clustersMinutesTable2B clustersMinutesTable1B

    %[zRFData_2B, zRFSum_2B, ~] = formTables_RF_1A3('2b-latest-rf-data.xlsx', '2b-latest-rf-sum.xlsx', '', true);

    
    
% figure out the mean and SD number of times people saw problem clusters and changed shifts  
[zRFData_1B, zRFSum_1B, ~] = formTables_RF_1A3('1b-final-Parsed.rf-data.xlsx', '1b-final-Parsed.rf-sum.xlsx', '', true);
delMe = zRFSum_1B(strcmpi(zRFSum_1B.Status,'Finished'),:);

delMe2 = table({'placeholder'},0,0,'VariableNames',{'ClusterOrShift','AvgAttempts','SDAttempts'});

insertThisRow = 1;
clusterString = 'U/I/Logic'; % have to change this manually, but the below should work the same regardless
clusterString = 'S/I/Logic'; % have to change this manually, but the below should work the same regardless
clusterString = 'U/I'; % have to change this manually, but the below should work the same regardless
completedPeople = unique(delMe(strcmpi(delMe.ClusterComplete,clusterString),:).Subject);
totalAttempts = table(0,0,'VariableNames',{'Subject','Attempts'});
for i = 1:length(completedPeople)
    subj = completedPeople(i);
    subjShifts = delMe(delMe.Subject==subj,:);
    subjRelevantShifts = subjShifts(strcmpi(subjShifts.Cluster,clusterString),:);
    totalAttempts(i,:) = table(subj,height(subjRelevantShifts),'VariableNames',{'Subject','Attempts'});
end
delMe2(insertThisRow,:) = table({clusterString},...
    mean(totalAttempts.Attempts),std(totalAttempts.Attempts),...
    'VariableNames',{'ClusterOrShift','AvgAttempts','SDAttempts'});
insertThisRow = insertThisRow + 1;
delMe2(insertThisRow,:) = table({'PlaceholderBetweenCandS'},...
    0,0,'VariableNames',{'ClusterOrShift','AvgAttempts','SDAttempts'});
insertThisRow = insertThisRow + 1;
clusterString = 'U/I/Logic'; % have to change this manually, but the below should work the same regardless
shiftString = 'Digit Arrangement (U/I)'; % have to change this manually, but the below should work the same regardless
shiftString = 'PI Memorization (U/I)'; % have to change this manually, but the below should work the same regardless
shiftString = 'Language Crunching (U/I)'; % have to change this manually, but the below should work the same regardless
clusterString = 'S/I/Logic'; % have to change this manually, but the below should work the same regardless
shiftString = 'Ocular Orientation (S/I)'; % have to change this manually, but the below should work the same regardless
shiftString = 'Cartography Catharsis (S/I)'; % have to change this manually, but the below should work the same regardless
shiftString = 'Generational Gapping (S/I)'; % have to change this manually, but the below should work the same regardless
clusterString = 'U/I'; % have to change this manually, but the below should work the same regardless
shiftString = 'Odditizing (U/I)'; % have to change this manually, but the below should work the same regardless
shiftString = 'Limb Reparations (U/I)'; % have to change this manually, but the below should work the same regardless
completedPeople = unique(delMe(strcmpi(delMe.ClusterComplete,clusterString),:).Subject);
totalAttempts = table(0,0,'VariableNames',{'Subject','Attempts'});
for i = 1:length(completedPeople)
    subj = completedPeople(i);
    subjShifts = delMe(delMe.Subject==subj,:);
    subjRelevantShifts = subjShifts(strcmpi(subjShifts.Shift,shiftString),:);
    totalAttempts(i,:) = table(subj,height(subjRelevantShifts),'VariableNames',{'Subject','Attempts'});
end
delMe2(insertThisRow,:) = table({shiftString},...
    mean(totalAttempts.Attempts),std(totalAttempts.Attempts),...
    'VariableNames',{'ClusterOrShift','AvgAttempts','SDAttempts'});
insertThisRow = insertThisRow + 1;
delMe2

   

% look into per-site data
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
delMe = delMe(strcmpi(delMe.Site,'NEU'),:);
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded

delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
delMe = delMe(strcmpi(delMe.Site,'Honeywell'),:);
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded

delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
delMe = delMe(strcmpi(delMe.Site,'Harvard'),:);
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded

delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
delMe = delMe(strcmpi(delMe.Site,'Honeywell'),:);
getClustersCompleted_2A(delMe, true, true); % now look at this printed-out table and see how many should be excluded



% figure out the average number of minutes in "training" for AC subjects
[zACvis_2B, zACthumb_2B, zACsilo_2B] = formTables_RF_1A3('2b-latest-ac-visual-sum.xlsx', '2b-latest-ac-thumb-sum.xlsx', '2b-latest-ac-silo-sum.xlsx', true);
delMe = zACvis_2B(strcmpi(zACvis_2B.Status,'finished'),:);
delMe = [delMe; zACvis_2B(strcmpi(zACvis_2B.Status,'retention'),:)];
delMe2 = zACthumb_2B(strcmpi(zACthumb_2B.Status,'finished'),:);
delMe2 = [delMe2; zACthumb_2B(strcmpi(zACthumb_2B.Status,'retention'),:)];
delMe3 = zACsilo_2B(strcmpi(zACsilo_2B.Status,'finished'),:);
delMe3 = [delMe3; zACsilo_2B(strcmpi(zACsilo_2B.Status,'retention'),:)];

minuteCount2B_AC = table(0,0,0,0,'VariableNames',{'Subject','MinInAC_Vis','MinInAC_Thumb','MinInAC_Silo'});
subjects = unique(delMe.Subject);
for i=1:length(subjects)
    subj = subjects(i);
    subjRowsV = delMe(delMe.Subject == subj,:);
    subjRowsT = delMe2(delMe2.Subject == subj,:);
    subjRowsS = delMe3(delMe3.Subject == subj,:);
    minuteCount2B_AC(i,:) = table(subj,(sum(subjRowsV.Duration_sec))/60,...
        (sum(subjRowsT.Duration_sec))/60,(sum(subjRowsS.Duration_sec))/60,...
        'VariableNames',{'Subject','MinInAC_Vis','MinInAC_Thumb','MinInAC_Silo'});
end
minuteCount2B_AC.Total = minuteCount2B_AC.MinInAC_Vis+minuteCount2B_AC.MinInAC_Thumb+minuteCount2B_AC.MinInAC_Silo;
minuteCount2B_AC
writetable(minuteCount2B_AC, getFileNameForThisOS('2017_5_25 AC minutes 2B.csv', 'IntResults'));

[zACvis_1B, zACthumb_1B, zACsilo_1B] = formTables_RF_1A3('1b-final-Parsed-AC.visualsearch-sum.xlsx', '1b-final-Parsed-AC.thumbprint-sum.xlsx', '1b-final-Parsed-AC.silo-sum.xlsx', true);
delMe = zACvis_1B(strcmpi(zACvis_1B.Status,'finished'),:);
delMe = [delMe; zACvis_1B(strcmpi(zACvis_1B.Status,'finished*'),:)];
delMe2 = zACthumb_1B(strcmpi(zACthumb_1B.Status,'finished'),:);
delMe2 = [delMe2; zACthumb_1B(strcmpi(zACthumb_1B.Status,'finished*'),:)];
delMe3 = zACsilo_1B(strcmpi(zACsilo_1B.Status,'finished'),:);
delMe3 = [delMe3; zACsilo_1B(strcmpi(zACsilo_1B.Status,'finished*'),:)];

minuteCount1B_AC = table(0,0,0,0,'VariableNames',{'Subject','MinInAC_Vis','MinInAC_Thumb','MinInAC_Silo'});
subjects = unique(delMe.Subject);
for i=1:length(subjects)
    subj = subjects(i);
    subjRowsV = delMe(delMe.Subject == subj,:);
    subjRowsT = delMe2(delMe2.Subject == subj,:);
    subjRowsS = delMe3(delMe3.Subject == subj,:);
    minuteCount1B_AC(i,:) = table(subj,(sum(subjRowsV.Duration_sec))/60,...
        (sum(subjRowsT.Duration_sec))/60,(sum(subjRowsS.Duration_sec))/60,...
        'VariableNames',{'Subject','MinInAC_Vis','MinInAC_Thumb','MinInAC_Silo'});
end
minuteCount1B_AC.Total = minuteCount1B_AC.MinInAC_Vis+minuteCount1B_AC.MinInAC_Thumb+minuteCount1B_AC.MinInAC_Silo;
minuteCount1B_AC
writetable(minuteCount1B_AC, getFileNameForThisOS('2017_5_25 AC minutes 1B.csv', 'IntResults'));



% look into the folks who started after 5/13/17 
%   These include, from NEU: subj 4074 and above
delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'finished'),:);
delMe = [delMe; zRFSum_2B(strcmpi(zRFSum_2B.Status,'retention'),:)];
    % just use this if you want the current ones instead...   delMe = zRFSum_2B(strcmpi(zRFSum_2B.Status,'active'),:);
% find the right date range
delMe2 = delMe((delMe.Subject >= 4074) & (delMe.Subject < 5000),:); % 4074 and above, but just NEU
minDate = min(delMe2.Date) % 42872 - so I guess anything after this is ok??? (BUT for some reason actually using the number doesn't work... so save to a variable and use that)

delMe2 = delMe(strcmpi(delMe.Visit,'training01'),:); % start with the first training
delMe3 = delMe2(delMe2.Date >= minDate,:); % just take the people who started after that date
delMe4 = delMe(ismember(delMe.Subject,unique(delMe3.Subject)),:); % but take all of their dates, not just T1
clear minDate;

getClustersCompleted_2A(delMe4, true, true); % this should output the average and StDev of clusters completed

% also look into per-site differences for the last few subjs finished
delMe2 = delMe4(strcmpi(delMe4.Site,'Harvard'),:); length(unique(delMe2.Subject)) % 7.9 (30 people)
delMe2 = delMe4(strcmpi(delMe4.Site,'Honeywell'),:); length(unique(delMe2.Subject)) % 9.7 (35 people)
delMe2 = delMe4(strcmpi(delMe4.Site,'NEU'),:); length(unique(delMe2.Subject)) % 9.3 (8 people)
delMe2 = delMe4(strcmpi(delMe4.Site,'Oxford'),:); length(unique(delMe2.Subject)) % 11.5 (2 people)
getClustersCompleted_2A(delMe2, true, false); % this should output the average and StDev of clusters completed

delMe = delMe4;
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

delMe2.AvgCompleted = delMe2.NumberCompleted / length(unique(delMe.Subject)); 
delMe2
writetable(delMe2, getFileNameForThisOS('avgClustersCompleted_2B_after5-13-output.csv', 'IntResults'));

length(unique(delMe.Subject)) % get the number of subjects finished or in retention


