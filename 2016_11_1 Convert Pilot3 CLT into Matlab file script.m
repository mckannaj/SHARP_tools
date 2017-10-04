% Zephy McKanna
% Script to convert the parsed Pilot3 CLT data into a form that M&M want 
% 11/2/16



% Convert Pilot2 CLT data into a useful form for Misha and Maciej
[zP3_CLT_sum, zP3_CLT_tasks, zP3_CLT_trials] = formTables_RF_1A3('Pilot3-1026/clt-sum.xlsx','Pilot3-1026/clt-tasks.xlsx', 'Pilot3-1026/clt-trials.xlsx',  true);
[zP3_CLT_trueCats, ~, ~] = formTables_RF_1A3('Pilot3-1026/clt-truthTable.xlsx', '','', true);

% now form these data into a useful whole table
zP3_CLT_forMisha = zP3_CLT_trials;
zP3_CLT_forMisha.Properties.VariableNames{'Status'} = 'Finished';
zP3_CLT_forMisha.Properties.VariableNames{'Training'} = 'TrainingCondition';
zP3_CLT_forMisha.Condition = [];
zP3_CLT_forMisha.Properties.VariableNames{'Version'} = 'CodeVersion';
zP3_CLT_forMisha.Properties.VariableNames{'Task'} = 'TaskNumber';
zP3_CLT_forMisha.Properties.VariableNames{'Trial'} = 'TrialNumber';
zP3_CLT_forMisha.Properties.VariableNames{'Stimulus'} = 'PresentationStim';
zP3_CLT_forMisha.StimDim1 = zeros(height(zP3_CLT_forMisha),1);
zP3_CLT_forMisha.StimDim2 = zeros(height(zP3_CLT_forMisha),1);
zP3_CLT_forMisha.StimDim3 = zeros(height(zP3_CLT_forMisha),1);
zP3_CLT_forMisha.StimDim4 = zeros(height(zP3_CLT_forMisha),1);
delMe = cell(height(zP3_CLT_forMisha),1);
for delMe2 = 1:height(zP3_CLT_forMisha)
    delMe{delMe2} = ['Not yet set'];
end
zP3_CLT_forMisha.IntendedRule = delMe;
zP3_CLT_forMisha.StimDimWord1 = delMe;
zP3_CLT_forMisha.StimDimWord2 = delMe;
zP3_CLT_forMisha.StimDimWord3 = delMe;
zP3_CLT_forMisha.StimDimWord4 = delMe;
zP3_CLT_forMisha.ExpResp = delMe;
zP3_CLT_forMisha.Properties.VariableNames{'Response'} = 'SubjResp';
zP3_CLT_forMisha.TaskInstructTime = zeros(height(zP3_CLT_forMisha),1);
zP3_CLT_forMisha.TaskStartTime = zeros(height(zP3_CLT_forMisha),1);
zP3_CLT_forMisha.TaskEndTime = zeros(height(zP3_CLT_forMisha),1);
zP3_CLT_forMisha.Outcome = [];
zP3_CLT_forMisha.ConsCorrect = [];
zP3_CLT_forMisha.TaskOutcome = [];
zP3_CLT_forMisha.IgnoredResponses = [];
% set the stimulus dimensions in binary
delMe4 = 0;
for delMe2 = 1:height(zP3_CLT_forMisha)
    if (delMe4 ~= zP3_CLT_forMisha.Subject(delMe2))
        delMe4 = zP3_CLT_forMisha.Subject(delMe2);
        fprintf('Now on subject %d.\n', delMe4);
    end
    if ( (zP3_CLT_forMisha.PresentationStim(delMe2) == 1) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 2) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 3) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 4) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 5) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 6) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 7) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 8) )
        zP3_CLT_forMisha.StimDim1(delMe2) = 1;
        
    else
        zP3_CLT_forMisha.StimDim1(delMe2) = 0;
    end
    if ( (zP3_CLT_forMisha.PresentationStim(delMe2) == 1) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 2) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 3) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 4) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 9) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 10) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 11) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 12) )
        zP3_CLT_forMisha.StimDim2(delMe2) = 1;
    else
        zP3_CLT_forMisha.StimDim2(delMe2) = 0;
    end
    if ( (zP3_CLT_forMisha.PresentationStim(delMe2) == 1) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 2) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 5) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 6) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 9) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 10) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 13) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 14) )
        zP3_CLT_forMisha.StimDim3(delMe2) = 1;
    else
        zP3_CLT_forMisha.StimDim3(delMe2) = 0;
    end
    if ( (zP3_CLT_forMisha.PresentationStim(delMe2) == 1) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 3) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 5) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 7) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 9) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 11) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 13) || ...
        (zP3_CLT_forMisha.PresentationStim(delMe2) == 15) )
        zP3_CLT_forMisha.StimDim4(delMe2) = 1;
    else
        zP3_CLT_forMisha.StimDim4(delMe2) = 0;
    end
    
end

% Mapping from PresentationStim to StimDims1-4
%{ 
4	1	1	0	0
11	0	1	0	1
15	0	0	0	1
8	1	0	0	0
2	1	1	1	0
9	0	1	1	1
13	0	0	1	1
6	1	0	1	0
14	0	0	1	0
16	0	0	0	0
5	1	0	1	1
12	0	1	0	0
3	1	1	0	1
1	1	1	1	1
7	1	0	0	1
10	0	1	1	0
%}

delMe4 = 0;
for delMe2 = 1:height(zP3_CLT_forMisha)
    if (delMe4 ~= zP3_CLT_forMisha.Subject(delMe2))
        delMe4 = zP3_CLT_forMisha.Subject(delMe2);
        fprintf('Now on subject %d.\n', delMe4);
    end
    if (strcmpi(zP3_CLT_forMisha.Visit(delMe2), 'baseline') == 1) % baseline tasks (since task number is repeated)
        if ( (zP3_CLT_forMisha.TaskNumber(delMe2) == 2) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 4) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 6) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 8) )
                if (zP3_CLT_forMisha.StimDim1(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord1(delMe2) = {'Square'};
                else
                    zP3_CLT_forMisha.StimDimWord1(delMe2) = {'Triangle'};
                end
                if (zP3_CLT_forMisha.StimDim2(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord2(delMe2) = {'Black'};
                else
                    zP3_CLT_forMisha.StimDimWord2(delMe2) = {'White'};
                end
                if (zP3_CLT_forMisha.StimDim3(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord3(delMe2) = {'Large'};
                else
                    zP3_CLT_forMisha.StimDimWord3(delMe2) = {'Small'};
                end
                if (zP3_CLT_forMisha.StimDim4(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord4(delMe2) = {'Single'};
                else
                    zP3_CLT_forMisha.StimDimWord4(delMe2) = {'Double'};
                end
        end
        if ( (zP3_CLT_forMisha.TaskNumber(delMe2) == 1) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 3) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 5) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 7) )
                if (zP3_CLT_forMisha.StimDim1(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord1(delMe2) = {'Tense muscles'};
                else
                    zP3_CLT_forMisha.StimDimWord1(delMe2) = {'Relaxed muscled'};
                end
                if (zP3_CLT_forMisha.StimDim2(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord2(delMe2) = {'High insulin'};
                else
                    zP3_CLT_forMisha.StimDimWord2(delMe2) = {'Low insulin'};
                end
                if (zP3_CLT_forMisha.StimDim3(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord3(delMe2) = {'Swollen glands'};
                else
                    zP3_CLT_forMisha.StimDimWord3(delMe2) = {'Recessed glands'};
                end
                if (zP3_CLT_forMisha.StimDim4(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord4(delMe2) = {'Stuffy sinus'};
                else
                    zP3_CLT_forMisha.StimDimWord4(delMe2) = {'Runny sinus'};
                end
        end
    elseif (strcmpi(zP3_CLT_forMisha.Visit(delMe2), 'followup') == 1) % baseline tasks (since task number is repeated)
        if ( (zP3_CLT_forMisha.TaskNumber(delMe2) == 1) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 3) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 5) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 7) )
                if (zP3_CLT_forMisha.StimDim1(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord1(delMe2) = {'Square'};
                else
                    zP3_CLT_forMisha.StimDimWord1(delMe2) = {'Triangle'};
                end
                if (zP3_CLT_forMisha.StimDim2(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord2(delMe2) = {'Black'};
                else
                    zP3_CLT_forMisha.StimDimWord2(delMe2) = {'White'};
                end
                if (zP3_CLT_forMisha.StimDim3(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord3(delMe2) = {'Large'};
                else
                    zP3_CLT_forMisha.StimDimWord3(delMe2) = {'Small'};
                end
                if (zP3_CLT_forMisha.StimDim4(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord4(delMe2) = {'Single'};
                else
                    zP3_CLT_forMisha.StimDimWord4(delMe2) = {'Double'};
                end
        end
        if ( (zP3_CLT_forMisha.TaskNumber(delMe2) == 2) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 4) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 6) || ...
            (zP3_CLT_forMisha.TaskNumber(delMe2) == 8) )
                if (zP3_CLT_forMisha.StimDim1(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord1(delMe2) = {'Tense muscles'};
                else
                    zP3_CLT_forMisha.StimDimWord1(delMe2) = {'Relaxed muscled'};
                end
                if (zP3_CLT_forMisha.StimDim2(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord2(delMe2) = {'High insulin'};
                else
                    zP3_CLT_forMisha.StimDimWord2(delMe2) = {'Low insulin'};
                end
                if (zP3_CLT_forMisha.StimDim3(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord3(delMe2) = {'Swollen glands'};
                else
                    zP3_CLT_forMisha.StimDimWord3(delMe2) = {'Recessed glands'};
                end
                if (zP3_CLT_forMisha.StimDim4(delMe2) == 1)
                    zP3_CLT_forMisha.StimDimWord4(delMe2) = {'Stuffy sinus'};
                else
                    zP3_CLT_forMisha.StimDimWord4(delMe2) = {'Runny sinus'};
                end
        end
    else 
        error('Visit that isnt baseline or followup...?')
    end
    
end

delMe4 = 0;
for delMe2 = 1:height(zP3_CLT_forMisha)
    if (delMe4 ~= zP3_CLT_forMisha.Subject(delMe2))
        delMe4 = zP3_CLT_forMisha.Subject(delMe2);
        fprintf('Now on subject %d.\n', delMe4);
    end
    % tasks follow the same rule order on baseline and followup
    if (zP3_CLT_forMisha.TaskNumber(delMe2) == 1)
        zP3_CLT_forMisha.IntendedRule(delMe2) = {'SingleDimension'};
    elseif (zP3_CLT_forMisha.TaskNumber(delMe2) <= 3)
        zP3_CLT_forMisha.IntendedRule(delMe2) = {'AND'};
    elseif (zP3_CLT_forMisha.TaskNumber(delMe2) <= 5)
        zP3_CLT_forMisha.IntendedRule(delMe2) = {'OR'};
    elseif (zP3_CLT_forMisha.TaskNumber(delMe2) <= 7)
        zP3_CLT_forMisha.IntendedRule(delMe2) = {'xOR'};
    elseif (zP3_CLT_forMisha.TaskNumber(delMe2) == 8)
        zP3_CLT_forMisha.IntendedRule(delMe2) = {'ShepV'};
    else
        error ('Unknown task number... %d', zP3_CLT_forMisha.TaskNumber(delMe2));
    end
    
    delMe10 = zP3_CLT_trueCats(strcmpi(zP3_CLT_trueCats.PreOrPost, zP3_CLT_forMisha.Visit(delMe2)), :); % get the right day
    delMe5 = delMe10(delMe10.TaskNum == zP3_CLT_forMisha.TaskNumber(delMe2), :); % get the right task
    delMe6 = delMe5(delMe5.StimNum == zP3_CLT_forMisha.PresentationStim(delMe2), :); % get the right stimulus
    if (delMe6.InCat == true)
        zP3_CLT_forMisha.ExpResp(delMe2) = {'LEFT_SHIFT'};
    else
        zP3_CLT_forMisha.ExpResp(delMe2) = {'RIGHT_SHIFT'};
    end
    
    delMe7 = zP3_CLT_tasks(zP3_CLT_tasks.Subject == zP3_CLT_forMisha.Subject(delMe2), :);
    delMe8 = delMe7(strcmpi(delMe7.Visit, zP3_CLT_forMisha.Visit(delMe2)), :);
    delMe9 = delMe8(delMe8.Task == zP3_CLT_forMisha.TaskNumber(delMe2), :);
    if (height(delMe9) == 1)
        zP3_CLT_forMisha.TaskInstructTime(delMe2) = delMe9.TimeInstructions;
        zP3_CLT_forMisha.TaskStartTime(delMe2) = delMe9.TimeStart;
        zP3_CLT_forMisha.TaskEndTime(delMe2) = delMe9.TimeEnd;
    else
        zP3_CLT_forMisha.TaskInstructTime(delMe2) = -1;
        zP3_CLT_forMisha.TaskStartTime(delMe2) = -1;
        zP3_CLT_forMisha.TaskEndTime(delMe2) = -1;
    end
    
end

clear delMe delMe2 delMe3 delMe4 delMe5 delMe6 delMe7 delMe8 delMe9 delMe10
clear zP3_CLT_sum zP3_CLT_tasks zP3_CLT_trials zP3_CLT_trueCats

save(getFileNameForThisOS('2016_11_1-zP3_PrePostCLT_forMisha.mat', 'IntResults'), 'zP2_CLT_forMisha')
writetable(zP3_CLT_forMisha, getFileNameForThisOS('2016_11_1-zP3_PrePostCLT_forMisha.csv', 'IntResults'),'WriteRowNames',false);


