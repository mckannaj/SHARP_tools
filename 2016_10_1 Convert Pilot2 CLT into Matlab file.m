% Zephy McKanna
% Script to convert the parsed Pilot2 CLT data into a form that M&M want 
% 10/1/16



% Convert Pilot2 CLT data into a useful form for Misha and Maciej
[zP2_CLT_sum, zP2_CLT_tasks, zP2_CLT_trials] = formTables_RF_1A3('Pilot2-1028/clt-sum.xlsx','Pilot2-1028/clt-tasks.xlsx', 'Pilot2-1028/clt-trials.xlsx',  true);
[zP2_CLT_trueCats, ~, ~] = formTables_RF_1A3('Pilot2-1028/clt-truthTable.xlsx', '','', true);

% now form these data into a useful whole table
zP2_CLT_forMisha = zP2_CLT_trials;
zP2_CLT_forMisha.Properties.VariableNames{'Status'} = 'Finished';
zP2_CLT_forMisha.Properties.VariableNames{'Visit'} = 'TrainingDay';
zP2_CLT_forMisha.Properties.VariableNames{'Version'} = 'CodeVersion';
zP2_CLT_forMisha.Properties.VariableNames{'Task'} = 'TaskNumber';
zP2_CLT_forMisha.Properties.VariableNames{'Trial'} = 'TrialNumber';
zP2_CLT_forMisha.Properties.VariableNames{'Stimulus'} = 'PresentationStim';
zP2_CLT_forMisha.StimDim1 = zeros(height(zP2_CLT_forMisha),1);
zP2_CLT_forMisha.StimDim2 = zeros(height(zP2_CLT_forMisha),1);
zP2_CLT_forMisha.StimDim3 = zeros(height(zP2_CLT_forMisha),1);
zP2_CLT_forMisha.StimDim4 = zeros(height(zP2_CLT_forMisha),1);
delMe = cell(height(zP2_CLT_forMisha),1);
for delMe2 = 1:height(zP2_CLT_forMisha)
    delMe{delMe2} = ['Not yet set'];
end
zP2_CLT_forMisha.IntendedRule = delMe;
zP2_CLT_forMisha.Background = delMe;
zP2_CLT_forMisha.StimDimWord1 = delMe;
zP2_CLT_forMisha.StimDimWord2 = delMe;
zP2_CLT_forMisha.StimDimWord3 = delMe;
zP2_CLT_forMisha.StimDimWord4 = delMe;
zP2_CLT_forMisha.ExpResp = delMe;
zP2_CLT_forMisha.Properties.VariableNames{'Response'} = 'SubjResp';
zP2_CLT_forMisha.TaskInstructTime = zeros(height(zP2_CLT_forMisha),1);
zP2_CLT_forMisha.TaskStartTime = zeros(height(zP2_CLT_forMisha),1);
zP2_CLT_forMisha.TaskEndTime = zeros(height(zP2_CLT_forMisha),1);
zP2_CLT_forMisha.Outcome = [];
zP2_CLT_forMisha.ConsCorrect = [];
zP2_CLT_forMisha.StimsSolved = [];
zP2_CLT_forMisha.TaskOutcome = [];
zP2_CLT_forMisha.IgnoredResponses = [];
% set the stimulus dimensions in binary
delMe4 = 0;
for delMe2 = 1:height(zP2_CLT_forMisha)
    if (delMe4 ~= zP2_CLT_forMisha.Subject(delMe2))
        delMe4 = zP2_CLT_forMisha.Subject(delMe2);
        fprintf('Now on subject %d.\n', delMe4);
    end
    if ( (zP2_CLT_forMisha.PresentationStim(delMe2) == 1) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 2) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 3) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 4) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 5) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 6) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 7) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 8) )
        zP2_CLT_forMisha.StimDim1(delMe2) = 1;
        
    else
        zP2_CLT_forMisha.StimDim1(delMe2) = 0;
    end
    if ( (zP2_CLT_forMisha.PresentationStim(delMe2) == 1) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 2) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 3) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 4) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 9) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 10) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 11) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 12) )
        zP2_CLT_forMisha.StimDim2(delMe2) = 1;
    else
        zP2_CLT_forMisha.StimDim2(delMe2) = 0;
    end
    if ( (zP2_CLT_forMisha.PresentationStim(delMe2) == 1) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 2) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 5) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 6) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 9) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 10) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 13) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 14) )
        zP2_CLT_forMisha.StimDim3(delMe2) = 1;
    else
        zP2_CLT_forMisha.StimDim3(delMe2) = 0;
    end
    if ( (zP2_CLT_forMisha.PresentationStim(delMe2) == 1) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 3) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 5) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 7) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 9) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 11) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 13) || ...
        (zP2_CLT_forMisha.PresentationStim(delMe2) == 15) )
        zP2_CLT_forMisha.StimDim4(delMe2) = 1;
    else
        zP2_CLT_forMisha.StimDim4(delMe2) = 0;
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
for delMe2 = 1:height(zP2_CLT_forMisha)
    if (delMe4 ~= zP2_CLT_forMisha.Subject(delMe2))
        delMe4 = zP2_CLT_forMisha.Subject(delMe2);
        fprintf('Now on subject %d.\n', delMe4);
    end
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 2) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 21) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 42) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 45) )
        zP2_CLT_forMisha.Background(delMe2) = {'AL'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Arm'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Leg'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Red'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Blue'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Humanoid'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Bot'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Yellow light'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No light'};
        end
    end

    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 15) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 27) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 33) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 54) )
        zP2_CLT_forMisha.Background(delMe2) = {'AL'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Arm'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Head'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Purple'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Green'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
                zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Wavy'};
            else
                zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Swoop'};
            end
        else
            if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
                zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Hook'};
            else
                zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Round'};
            end
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Blue ring'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Red ring'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 4) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 22) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 37) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 49) )
        zP2_CLT_forMisha.Background(delMe2) = {'RC'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Full robot'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Torso'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Red'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'White'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Peace sign'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Tree'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Yellow light'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No light'};
        end
    end
            
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 12) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 26) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 41) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 53) )
        zP2_CLT_forMisha.Background(delMe2) = {'RC'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Torso and arms'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Torso and legs'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Brown'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Blue'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Shock symbol'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Syringe'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Yellow light'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No light'};
        end
    end
        
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 10) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 29) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 40) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 52) )
        zP2_CLT_forMisha.Background(delMe2) = {'MI'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Red'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Blue'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Top'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Bottom'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Left'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Right'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Cyan overlay'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No overlay'};
        end
    end
       
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 8) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 23) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 38) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 50) )
        zP2_CLT_forMisha.Background(delMe2) = {'MI'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Orange'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Purple'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Top'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Bottom'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Left'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Right'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Magenta ring'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No ring'};
        end
    end

    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 5) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 19) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 35) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 47) )
        zP2_CLT_forMisha.Background(delMe2) = {'NE'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Female'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Male'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Happy'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Sad'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Jeep'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Boat'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Caution sign'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No sign'};
        end
    end

    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 16) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 32) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 44) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 56) )
        zP2_CLT_forMisha.Background(delMe2) = {'NE'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Living'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Nonliving'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Wings'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'No wings'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'3'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'7'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Red light'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Blue light'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 7) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 18) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 43) )
        zP2_CLT_forMisha.Background(delMe2) = {'NE'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Square'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Triangle'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Black'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'White'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Large'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Small'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Caution sign'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No sign'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 13) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 30) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 55) )
        zP2_CLT_forMisha.Background(delMe2) = {'NE'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Square'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Triangle'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Black'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'White'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Large'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Small'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Red light'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Blue light'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 1) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 24) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 34) )
        zP2_CLT_forMisha.Background(delMe2) = {'MI'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Square'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Triangle'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Black'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'White'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Large'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Small'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Magenta ring'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No ring'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 14) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 28) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 46) )
        zP2_CLT_forMisha.Background(delMe2) = {'MI'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Square'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Triangle'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Black'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'White'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Large'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Small'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Cyan overlay'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No overlay'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 3) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 20) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 36) )
        zP2_CLT_forMisha.Background(delMe2) = {'NE'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Tense muscles'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Relaxed muscled'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'High insulin'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Low insulin'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Swollen glands'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Recessed glands'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Caution sign'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No sign'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 9) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 25) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 48) )
        zP2_CLT_forMisha.Background(delMe2) = {'NE'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Tense muscles'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Relaxed muscled'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'High insulin'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Low insulin'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Swollen glands'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Recessed glands'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Red light'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Blue light'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 6) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 17) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 39) )
        zP2_CLT_forMisha.Background(delMe2) = {'MI'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Tense muscles'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Relaxed muscled'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'High insulin'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Low insulin'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Swollen glands'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Recessed glands'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Magenta ring'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No ring'};
        end
    end
    
    if ( (zP2_CLT_forMisha.TaskNumber(delMe2) == 11) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 31) || ...
        (zP2_CLT_forMisha.TaskNumber(delMe2) == 51) )
        zP2_CLT_forMisha.Background(delMe2) = {'MI'};
        if (zP2_CLT_forMisha.StimDim1(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Tense muscles'};
        else
            zP2_CLT_forMisha.StimDimWord1(delMe2) = {'Relaxed muscled'};
        end
        if (zP2_CLT_forMisha.StimDim2(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'High insulin'};
        else
            zP2_CLT_forMisha.StimDimWord2(delMe2) = {'Low insulin'};
        end
        if (zP2_CLT_forMisha.StimDim3(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Swollen glands'};
        else
            zP2_CLT_forMisha.StimDimWord3(delMe2) = {'Recessed glands'};
        end
        if (zP2_CLT_forMisha.StimDim4(delMe2) == 1)
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'Cyan overlay'};
        else
            zP2_CLT_forMisha.StimDimWord4(delMe2) = {'No overlay'};
        end
    end
    
    
    
end

delMe4 = 0;
for delMe2 = 1:height(zP2_CLT_forMisha)
    if (delMe4 ~= zP2_CLT_forMisha.Subject(delMe2))
        delMe4 = zP2_CLT_forMisha.Subject(delMe2);
        fprintf('Now on subject %d.\n', delMe4);
    end

    if (zP2_CLT_forMisha.TaskNumber(delMe2) < 9)
        zP2_CLT_forMisha.IntendedRule(delMe2) = {'SingleDimension'};
    elseif (zP2_CLT_forMisha.TaskNumber(delMe2) < 13)
        zP2_CLT_forMisha.IntendedRule(delMe2) = {'AND'};
    elseif (zP2_CLT_forMisha.TaskNumber(delMe2) < 21)
        zP2_CLT_forMisha.IntendedRule(delMe2) = {'OR'};
    elseif (zP2_CLT_forMisha.TaskNumber(delMe2) < 29)
        zP2_CLT_forMisha.IntendedRule(delMe2) = {'xOR'};
    elseif (zP2_CLT_forMisha.TaskNumber(delMe2) < 45)
        zP2_CLT_forMisha.IntendedRule(delMe2) = {'ShepV'};
    elseif (zP2_CLT_forMisha.TaskNumber(delMe2) < 57)
        zP2_CLT_forMisha.IntendedRule(delMe2) = {'ShepVplus'};
    end
    
    delMe5 = zP2_CLT_trueCats(zP2_CLT_trueCats.TaskNum == zP2_CLT_forMisha.TaskNumber(delMe2), :);
    delMe6 = delMe5(delMe5.StimNum == zP2_CLT_forMisha.PresentationStim(delMe2), :);
    if (delMe6.InCat == true)
        zP2_CLT_forMisha.ExpResp(delMe2) = {'LEFT_SHIFT'};
    else
        zP2_CLT_forMisha.ExpResp(delMe2) = {'RIGHT_SHIFT'};
    end
    
    delMe7 = zP2_CLT_tasks(zP2_CLT_tasks.Subject == zP2_CLT_forMisha.Subject(delMe2), :);
    delMe8 = delMe7(strcmpi(delMe7.Visit, zP2_CLT_forMisha.TrainingDay(delMe2)), :);
    delMe9 = delMe8(delMe8.Task == zP2_CLT_forMisha.TaskNumber(delMe2), :);
    if (height(delMe9) == 1)
        zP2_CLT_forMisha.TaskInstructTime(delMe2) = delMe9.TimeInstructions;
        zP2_CLT_forMisha.TaskStartTime(delMe2) = delMe9.TimeStart;
        zP2_CLT_forMisha.TaskEndTime(delMe2) = delMe9.TimeEnd;
    else
        zP2_CLT_forMisha.TaskInstructTime(delMe2) = -1;
        zP2_CLT_forMisha.TaskStartTime(delMe2) = -1;
        zP2_CLT_forMisha.TaskEndTime(delMe2) = -1;
    end
    
end

clear delMe delMe2 delMe3 delMe4 delMe5 delMe6 delMe7 delMe8 delMe9 
clear zP2_CLT_sum zP2_CLT_tasks zP2_CLT_trials zP2_CLT_trueCats

save(getFileNameForThisOS('2016_11_1-zP2_CLT_forMisha.mat', 'IntResults'), 'zP2_CLT_forMisha')
writetable(zP2_CLT_forMisha, getFileNameForThisOS('2016_11_1-zP2_CLT_forMisha.csv', 'IntResults'),'WriteRowNames',false);


