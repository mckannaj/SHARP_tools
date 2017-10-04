% Zephy McKanna
% putNewColsIntoDataTable_1B()
% 5/30/15
% 
% This function takes the "all" data matrix (or any subset of trials) made
% by the formTables_RF_1A3() function. Note that it expects 1B data; for
% 1A-3 data, use putNewColsIntoDataTable_1A3().
%
% It adds more information to each of the trials (rows) by adding the 
% following columns with the following values:
% 
% NbackFlag
%  2 = there is no way to tell if this trial was N-back positive or negative, but the shift has N-back 
%  1 = this trial is a "positive response" trial for N-back 
%  0 = this trial is a "negative response" trial for N-back
% -1 = this trial is in a shift that has no N-back trials
%
% NbackDifficulty
%  0 = this wasn't a trial in an Update shift (NbackFlag = -1) 
%  Otherwise (NbackFlag >= 0), this equals N-back value ("ActualN")
%
% InhibitFlag
%  3 = there was no Inhibit *cue*, but the original stimulus indicated that the subject should inhibit (cannot be used to calculate SSRT) 
%  2 = there was an Inhibit cue on this trial *AND* the underlying task was "NO_RESPONSE" = correct (cannot be used to calculate SSRT) 
%  1 = there was an Inhibit cue on this trial (can be used to calculate SSRT) 
%  0 = there was no Inhibit cue on this trial (though it might still be a no-response trial)
% -1 = there are no Inhibit trials on this shift (though there may still be no-response trials)
%
% InhibitDifficulty
%  0 = this wasn't a SSRT-calculable Inhibit cue on this trial (InhibitFlag ~= 1) 
%  Otherwise (InhibitFlag = 1), this equals SSD ("InhDelayUsed"? I assume this is equivalent to 1A-3 CurrentInhDelta)
%
% SwitchFlag
%  1 = this is a Switch trial (the previous trial was a different task than this task)
%  2 = this is a Repetition trial (the previous trial was the same task as this task)
%  0 = there is no way to determine whether this trial was a Switch or Repetition trial (first trial of the shift, trial after an error, etc.) 
% -1 = there are no Switch trials in this shift
%
% numOfEFsInThisShift
%  0 = shouldn't exist (just a sanity check)
%  1 = this shift has only U/I/S
%  2 = this shift has two EFs
%  3 = this shift has all three of the EFs
%
% numOfEFsInThisTrial
%  0 = there are no EFs in this trial (NbackFlag ~= 1, SwitchFlag < 1, InhibitFlag ~= 1) 
%  1 = this shift has only one of U/I/S
%  2 = this shift has two EFs
%  3 = this shift has all three of the EFs
%
% LogicXorFlag
%  1 = responding correctly to this trial involves Logical(xOR) thought 
%  0 = responding correctly to this trial does not require Logical(xOR) thought 
% -1 = there are no Logical(xOR) trials in this shift
%
% LogicIdFlag
%  1 = responding correctly to this trial involves Logical(identity) thought 
%  0 = responding correctly to this trial does not require Logical(identity) thought 
% -1 = there are no Logical(identity) trials in this shift
%
% RelationalFlag
%  1 = responding correctly to this trial involves Relational thought 
%  0 = responding correctly to this trial does not require Relational thought 
% -1 = there are no Relational trials in this shift
%
% anyLogicFlag
%  1 = (LogicXorFlag | LogicIdFlag | RelationalFlag) = 1
%  0 no logic or relational aspects in this trial
%
% SwitchHandsFlag (note: these are only when we are SURE; if we're not sure, it's 0) 
%  1 = the participant used the Left hand on the last trial and is using the Right hand on this trial 
%  2 = the participant used the Right hand on the last trial and is using the Left hand on this trial 
%  0 = the participant did not respond (use a hand) on either this trial or the last one, OR WE ARE NOT SURE 
% -1 = the participant used the Left hand on the last trial and is using the Left hand again on this trial 
% -2 = the participant used the Right hand on the last trial and is using the Right hand again on this trial 
%
% NonEFFlag
%  1 = this is not an EF trial (NbackFlag, InhibitFlag, SwitchFlag are all 0) 
%  0 = this is an EF trial (at least one of NbackFlag, InhibitFlag, SwitchFlag is 1) 
% 
% IncorrectFlag (use existing column "Correct" for the binary yes/no) 
%  1 = the response to this trial is incorrect, regardless of Inhibit cues 
%  2 = the response to this trial would have been correct, except that it should have been Inhibited 
%  0 = there is no way to tell whether this trial would have been correct "under" the Inhibit 
% -1 = this trial was correct
%
% AfterErrorFlag (for Switch calculations)
%  1 = the previous trial (in this shift, with this participant) was Correct=0
%  0 = the previous trial (in this shift, with this participant) was Correct=1
%
% TotalTrialCount
%  The number of trials (of any sort) that this participant has seen. 
%
% ScenarioCode
%  Numerical code for the scenario:
% 1 = AssemblyLine
% 2 = RobotConstruction
% 3 = NeuralEncoding
% 4 = MonocularInspection
% 5 = OcularInspection
%
function [newDataTable] = putNewColsIntoDataTable_1B(oldDataTable)
    fprintf('WARNING: putNewColsIntoDataTable_1B is NOT OPTIMIZED for 1B data yet!!! Z, please do this soon!\n\n');
    if (nargin ~= nargin('putNewColsIntoDataTable_1B'))
        error('zError: putNewColsIntoDataTable_1B expects %d inputs, but received %d. Please update any calling code.\n', nargin('putNewColsIntoDataTable_1B'), nargin);
    end

    [CheckFor1306, CheckFor1B] = getShiftsNotSeenIn1A3(oldDataTable);
    if (height(CheckFor1B) == 0)
        error('putNewColsIntoDataTable_1B: This function should be used for 1B data; use a different one for 1A-3 data.\n');
    elseif (height(CheckFor1306) > 0)
        fprintf('putNewColsIntoDataTable_1B: This function will not work properly for data from subject 1306. Excluding these shifts from output.\n');
        oldDataTable(oldDataTable.Subject == 1306, :) = [];
    end
    
    fprintf('zNote: not analyzing shift 4b T:2b - For exceptional testers; find out what this is based on!\n');

    % preallocate all new variables to proper default for speed
    allRows = height(oldDataTable);
    NbackFlag = zeros(allRows,1) - 1; % -1 = no N-back in this shift (most likely)
    NbackDifficulty = zeros(allRows,1); % 0 = no N-back in this shift (most likely)
    InhibitFlag = zeros(allRows,1) - 1; % -1 = no Inhibit in this shift (most likely)
    InhibitDifficulty = zeros(allRows,1); % 0 = no SSRT-calculable Inhibit in this shift (most likely)
    SwitchFlag = zeros(allRows,1) - 1; % -1 = no Switch in this shift (most likely)
    numOfEFsInThisShift = zeros(allRows,1); % 0 = sanity check (shouldn't remain 0)
    numOfEFsInThisTrial = zeros(allRows,1); % 0 = default (no EFs is reasonably likely)
    LogicXorFlag = zeros(allRows,1) - 1; % -1 = no xOR in this shift (most likely)
    LogicIdFlag = zeros(allRows,1) - 1; % -1 = no ID in this shift (most likely)
    RelationalFlag = zeros(allRows,1) - 1; % -1 = no Relational in this shift (most likely)
    anyLogicFlag = zeros(allRows,1); % 0 = no logic / relational aspects in this trial
    SwitchHandsFlag = zeros(allRows,1); % 0 = participant didn't respond on this trial or the last one
    NonEFFlag = zeros(allRows,1); % 0 = this is an EF trial (default)
    anyEFFlag = zeros(allRows,1); % 1 = this is an EF trial (default)
    IncorrectFlag = zeros(allRows,1) - 1; % -1 = this trial was correct (default)
    AfterErrorFlag = zeros(allRows,1); % 0 = this trial was not after an error (default)
    TotalTrialCount = zeros(allRows,1) - 1; % -1 = error (sanity check)
    ScenarioCode = zeros(allRows,1) - 1; % -1 = error (sanity check)

    subjTrialCount = 0; % we will increment this before it gets used
    curParticipant = oldDataTable.Subject(1); % start with the first subject
    for row = 1:allRows % loop through all the trials %!!! ZEPHY: IS THERE NO BETTER WAY TO DO THIS? LOOPS ARE REALLY SLOW!
        trial = oldDataTable(row,:);
        
        if (curParticipant ~= oldDataTable.Subject(row)) % different participant; give some "staying alive" output
            curParticipant = oldDataTable.Subject(row);
            subjTrialCount = 0; % we will increment this before it gets used
            fprintf('Adding rows for participant %d.\n', curParticipant);
        end
        
        subjTrialCount = subjTrialCount + 1;
        TotalTrialCount(row) = subjTrialCount;
        
        canCheckPrevRow = 1; % assume we can check the last row/trial
        if (row == 1)
            canCheckPrevRow = 0; % there is no previous row, so can't use it
        elseif (oldDataTable.ShiftNum(row) ~= oldDataTable.ShiftNum(row-1))
            canCheckPrevRow = 0; % previous row is a different shift, so can't use it
        elseif (oldDataTable.Subject(row) ~= oldDataTable.Subject(row-1))
            canCheckPrevRow = 0; % previous row is a different subj, so can't use it
        end
        
        % New default Inhibit: most incorrect trials are incorrect regardless of inhibit; make this the default 
        if (trial.Correct == 0) % trial was incorrect
            IncorrectFlag(row) = 1; % regardless of Inhibit
        end

        % New default Hand switching: most trials indicate if they expect a RIGHT or LEFT response; make this the default 
        if (canCheckPrevRow == 1) % we can actually use the last row
            if (strcmpi(prevTrial.ExpResp, 'LEFT') == 1) % previous trial was LEFT
                if (strcmpi(trial.ExpResp, 'LEFT') == 1) % this trial was LEFT
                    SwitchHandsFlag(row) = -1; % LEFT to LEFT
                elseif (strcmpi(trial.ExpResp, 'RIGHT') == 1) % this trial was RIGHT
                    SwitchHandsFlag(row) = 1; % LEFT to RIGHT
                end
            elseif (strcmpi(prevTrial.ExpResp, 'RIGHT') == 1) % previous trial was RIGHT
                if (strcmpi(trial.ExpResp, 'RIGHT') == 1) % this trial was RIGHT
                    SwitchHandsFlag(row) = -2; % RIGHT to RIGHT
                elseif (strcmpi(trial.ExpResp, 'LEFT') == 1) % this trial was LEFT
                    SwitchHandsFlag(row) = 2; % RIGHT to LEFT
                end
            end
        end
        
        % we have the last row; go ahead and mark AfterErrorFlag
        if (canCheckPrevRow == 1) % we can actually use the last row
            if (prevTrial.Correct == 0) % prev trial was incorrect
                AfterErrorFlag(row) = 1; % this trial is After an incorrect
            end
        end
        
        shift = oldDataTable.Shift{row};
        ScenarioCode(row) = codeScenarioFromShift(shift);
        switch shift
            case {'Color Balancing (U)', 'Duplicate Mitigation (U)', 'Basic Fitting (U)'}
                numOfEFsInThisShift(row) = 1;
                % N-back
                if (strcmpi(trial.NextState, 'ACTION') == 1)
                    NbackFlag(row) = 1; % Should respond to n-back
                else 
                    NbackFlag(row) = 0; % Should not respond to n-back
                end
                % Hand switching
                if (canCheckPrevRow == 1) % we can actually use the last row
                    if ((strcmpi(prevTrial.NextState, 'ACTION') == 1) && (prevTrial.Correct == 1)) % previous trial was LEFT
                        if ((strcmpi(trial.NextState, 'ACTION') == 1) && (trial.Correct == 1)) % this trial was LEFT
                            SwitchHandsFlag(row) = -1; % LEFT to LEFT
                        elseif ((strcmpi(trial.NextState, 'NO_ACTION') == 1) && (trial.Correct == 1)) % this trial was RIGHT
                            SwitchHandsFlag(row) = 1; % LEFT to RIGHT
                        end
                    elseif ((strcmpi(prevTrial.NextState, 'NO_ACTION') == 1) && (prevTrial.Correct == 1)) % previous trial was RIGHT
                        if ((strcmpi(trial.NextState, 'NO_ACTION') == 1) && (trial.Correct == 1)) % this trial was RIGHT
                            SwitchHandsFlag(row) = -2; % RIGHT to RIGHT
                        elseif ((strcmpi(trial.NextState, 'ACTION') == 1) && (trial.Correct == 1)) % this trial was LEFT
                            SwitchHandsFlag(row) = 2; % RIGHT to LEFT
                        end
                    end
                end
            case {'Symbolic Matching (U)', 'Organism Culling (U)', 'Count Quantizing (U)', 'Memory Management(U)'}
                numOfEFsInThisShift(row) = 1;
                % N-back
                if (strcmpi(trial.NextState, 'ACTION') == 1)
                    NbackFlag(row) = 1; % Should respond to n-back
                else 
                    NbackFlag(row) = 0; % Should not respond to n-back
                end
                % Hand switching
                if (canCheckPrevRow == 1) % we can actually use the last row
                    if ((strcmpi(prevTrial.NextState, 'NO_ACTION') == 1) && (prevTrial.Correct == 1)) % previous trial was LEFT
                        if ((strcmpi(trial.NextState, 'NO_ACTION') == 1) && (trial.Correct == 1)) % this trial was LEFT
                            SwitchHandsFlag(row) = -1; % LEFT to LEFT
                        elseif ((strcmpi(trial.NextState, 'ACTION') == 1) && (trial.Correct == 1)) % this trial was RIGHT
                            SwitchHandsFlag(row) = 1; % LEFT to RIGHT
                        end
                    elseif ((strcmpi(prevTrial.NextState, 'ACTION') == 1) && (prevTrial.Correct == 1)) % previous trial was RIGHT
                        if ((strcmpi(trial.NextState, 'ACTION') == 1) && (trial.Correct == 1)) % this trial was RIGHT
                            SwitchHandsFlag(row) = -2; % RIGHT to RIGHT
                        elseif ((strcmpi(trial.NextState, 'NO_ACTION') == 1) && (trial.Correct == 1)) % this trial was LEFT
                            SwitchHandsFlag(row) = 2; % RIGHT to LEFT
                        end
                    end
                end
% not in 1A3 or 1B            case 'Transportationization (I)'
% not in 1A3 or 1B            case 'Gamifying Medicine (I)'
% not in 1A3 or 1B            case 'Colorizing Careers (I)'
% not in 1A3 or 1B            case 'Limb Management (I)'
            case {'Green Synergizing (I)', 'Fault Limitations (I)', 'Snake Identification (I)', ...
                    'Stereoizing (I)', 'Emotional Imprinting (I)', 'Map Orgling (I)'}
                numOfEFsInThisShift(row) = 1;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 1; % there was an Inhibit cue on this trial and it would have been an action
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Hand switching
                if (canCheckPrevRow == 1) % we can actually use the last row
                    if ((strcmpi(prevTrial.NextState, 'INHIBIT') == 0) && (strcmpi(prevTrial.PreInhNextState, 'ACTION') == 1) && (prevTrial.Correct == 1)) % previous trial was LEFT
                        if ((strcmpi(trial.NextState, 'INHIBIT') == 0) && (strcmpi(trial.PreInhNextState, 'ACTION') == 1) && (trial.Correct == 1)) % this trial was LEFT
                            SwitchHandsFlag(row) = -1; % LEFT to LEFT
                        elseif ((strcmpi(trial.NextState, 'INHIBIT') == 0) && (strcmpi(trial.PreInhNextState, 'NO_ACTION') == 1) && (trial.Correct == 1)) % this trial was RIGHT
                            SwitchHandsFlag(row) = 1; % LEFT to RIGHT
                        end
                    elseif ((strcmpi(prevTrial.NextState, 'INHIBIT') == 0) && (strcmpi(prevTrial.PreInhNextState, 'NO_ACTION') == 1) && (prevTrial.Correct == 1)) % previous trial was RIGHT
                        if ((strcmpi(trial.NextState, 'INHIBIT') == 0) && (strcmpi(trial.PreInhNextState, 'NO_ACTION') == 1) && (trial.Correct == 1)) % this trial was RIGHT
                            SwitchHandsFlag(row) = -2; % RIGHT to RIGHT
                        elseif ((strcmpi(trial.NextState, 'INHIBIT') == 0) && (strcmpi(trial.PreInhNextState, 'ACTION') == 1) && (trial.Correct == 1)) % this trial was LEFT
                            SwitchHandsFlag(row) = 2; % RIGHT to LEFT
                        end
                    end
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.NextState, 'INHIBIT') == 1) % inhibit trial
                        IncorrectFlag(row) = 0; % can't tell whether it would have been correct or not
                    end % (non-inhibit trials have the proper value for this flag by default) 
                end
            case {'Locomotive Training (I)', 'Green Synergizing 2 (I)'}
                numOfEFsInThisShift(row) = 1;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 1; % there was an Inhibit cue on this trial
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Hand switching
                if (canCheckPrevRow == 1) % we can actually use the last row
                    if ((strcmpi(prevTrial.NextState, 'INHIBIT') == 0) && (strcmpi(prevTrial.PreInhNextState, 'NO_ACTION') == 1) && (prevTrial.Correct == 1)) % previous trial was LEFT
                        if ((strcmpi(trial.NextState, 'INHIBIT') == 0) && (strcmpi(trial.PreInhNextState, 'NO_ACTION') == 1) && (trial.Correct == 1)) % this trial was LEFT
                            SwitchHandsFlag(row) = -1; % LEFT to LEFT
                        elseif ((strcmpi(trial.NextState, 'INHIBIT') == 0) && (strcmpi(trial.PreInhNextState, 'ACTION') == 1) && (trial.Correct == 1)) % this trial was RIGHT
                            SwitchHandsFlag(row) = 1; % LEFT to RIGHT
                        end
                    elseif ((strcmpi(prevTrial.NextState, 'INHIBIT') == 0) && (strcmpi(prevTrial.PreInhNextState, 'ACTION') == 1) && (prevTrial.Correct == 1)) % previous trial was RIGHT
                        if ((strcmpi(trial.NextState, 'INHIBIT') == 0) && (strcmpi(trial.PreInhNextState, 'ACTION') == 1) && (trial.Correct == 1)) % this trial was RIGHT
                            SwitchHandsFlag(row) = -2; % RIGHT to RIGHT
                        elseif ((strcmpi(trial.NextState, 'INHIBIT') == 0) && (strcmpi(trial.PreInhNextState, 'NO_ACTION') == 1) && (trial.Correct == 1)) % this trial was LEFT
                            SwitchHandsFlag(row) = 2; % RIGHT to LEFT
                        end
                    end
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.NextState, 'INHIBIT') == 1) % inhibit trial
                        IncorrectFlag(row) = 0; % can't tell whether it would have been correct or not
                    end % (non-inhibit trials have the proper value for this flag by default) 
                end
            case {'Special Orders (S)', 'Monocular Inspection (S)', 'Head Hueing (S)', 'Fracture Mitigation (S)', ...
                    'Genderization (S)', 'Lesson Planning (S)', 'Part Number Balancing (S)', 'Altitude Viewing (S)', ...
                    'Chestial Numbering (S)', 'Designation Tinting (S)', 'Job Differentiation (S)'}
                numOfEFsInThisShift(row) = 1;
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
            case {'Eye Inspection (U/I)', 'Head and Shoulders (U/I)', 'Chest Digitizing (U/I)', 'Face Numbering (U/I)', ...
                    'Cranial Equilibrium (U/I)', 'Arm Matching (U/I)', 'Brain Deficiencies (U/I)'}
                numOfEFsInThisShift(row) = 2;
                % N-back
                if (strcmpi(trial.NextState, 'TASK_1_STATE_A') == 1)
                    NbackFlag(row) = 1; % Should respond to n-back
                else 
                    NbackFlag(row) = 0; % Should not respond to n-back
                end
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 1; % there was an Inhibit cue on this trial
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end
            case {'Odditizing (U/I)', 'Limb Reparations (U/I)'}
                numOfEFsInThisShift(row) = 2;
                % N-back
                if (strcmpi(trial.NextState, 'INHIBIT') == 1) % all Inhibit trials are n-back trials
                    NbackFlag(row) = 1; % This is an n-back trial
                else 
                    NbackFlag(row) = 0; % not n-back
                end
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.NextState, 'INHIBIT') == 1) % inhibit trial
                        IncorrectFlag(row) = 0; % can't tell whether it would have been correct or not
                    end % (non-inhibit trials have the proper value for this flag by default) 
                end           
% not in 1A3 or 1B            case 'Terrestrial Tiering (U/I)'
            case {'Arm Prioritization (S/I)', 'Part Calculation (S/I)', 'Iconography (S/I)', ...
                    'Failure Drilling (S/I)', 'Aeronautical Categorization (S/I)', 'Craftsmans Critiquing (S/I)'}
                numOfEFsInThisShift(row) = 2;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    if (strcmpi(trial.PreInhExpResp, 'NO_ACTION') == 1)
                        InhibitFlag(row) = 2; % there was an Inhibit cue on this trial, but they wouldn't have responded anyway
                    else
                        InhibitFlag(row) = 1; % there was an Inhibit cue on this trial, and they otherwise would have responded
                    end
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1_ACTION'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1_ACTION'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2_ACTION'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2_ACTION'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2_ACTION'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1_ACTION'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end    
            case {'Head Removal (S/I)', 'Chromatic Manipulation (S/I)', 'Dangerous Gaming (S/I)', 'Battlefield Medicine (S/I)' }
                numOfEFsInThisShift(row) = 2;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 1; % there was an Inhibit cue on this trial
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end    
% not in 1A3 or 1B            case 'Avoidance Training (S/I)'
            case {'Part ID Gleaning (U/S)', 'Eye Scrobbling (U/S)', 'Cross Checking (U/S)', ...
                    'Naturalized Decommissioning (U/S)', 'Aviation Aspectizing (U/S)', 'Intent Estimation (U/S)'}
                numOfEFsInThisShift(row) = 2;
                % N-back
                if (strcmpi(trial.ExpResp, 'LEFT') == 1)
                    NbackFlag(row) = 1; % Should respond to n-back
                else 
                    NbackFlag(row) = 0; % Should not respond to n-back
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
            case {'Optical Positioning (U/S)', 'Achievement Hunting (U/S)'}
                numOfEFsInThisShift(row) = 2;
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % N-back
                if (SwitchFlag(row) == 1) % switch is n-back
                    NbackFlag(row) = 1; % yes switch, yes n-back
                else
                    NbackFlag(row) = 0; % no switch, no n-back
                end
% not in 1A3 or 1B            case 'Advanced Categorization (U/S)'
            case {'Eye Symmetrizing (U)', 'Verbal Repetition (U)', 'Localized Vision (U)'}
                numOfEFsInThisShift(row) = 1;
                NbackFlag(row) = 1; % all of these trials are N-back
                LogicXorFlag(row) = 1; % all of these trials are xOR
            case {'Hand Exemption (U)', 'Primetizing (U)'}
                numOfEFsInThisShift(row) = 1;
                % N-back
                if (strcmpi(trial.ExpResp, 'LEFT') == 1)
                    NbackFlag(row) = 1; % Should respond to n-back
                else 
                    NbackFlag(row) = 0; % Should not respond to n-back
                end
                % Logic(ID)
                if (NbackFlag(row) == 1) % n-back = ID
                    LogicIdFlag(row) = 1; % yes n-back, yes ID
                else
                    LogicIdFlag(row) = 0; % no n-back, no ID
                end                
% not in 1A3 or 1B            case 'Spatial Troning (U)'
            case 'Braincase Downsizing (I)'
                numOfEFsInThisShift(row) = 1;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Hand "switching"
                if (canCheckPrevRow == 1) % we can actually use the last row
                    if (strcmpi(prevTrial.ExpResp, 'ACTION') == 1) % previous trial was LEFT
                        if (strcmpi(trial.ExpResp, 'ACTION') == 1) % this trial was LEFT
                            SwitchHandsFlag(row) = -1; % LEFT to LEFT (one-handed shift)
                        end
                    end
                end
            case 'Flipper Exception (I)'
                numOfEFsInThisShift(row) = 1;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
            case 'ATC Prioritizing (I)'
                numOfEFsInThisShift(row) = 1;
                % Inhibit and Logic(ID)
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                    LogicIdFlag(row) = 1; % yes Inhibit, yes ID
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                    LogicIdFlag(row) = 0; % no Inhibit, no ID
                end
                % Hand "switching"
                if (canCheckPrevRow == 1) % we can actually use the last row
                    if (strcmpi(prevTrial.ExpResp, 'ACTION') == 1) % previous trial was LEFT
                        if (strcmpi(trial.ExpResp, 'ACTION') == 1) % this trial was LEFT
                            SwitchHandsFlag(row) = -1; % LEFT to LEFT (one-handed shift)
                        end
                    end
                end
            case {'Eye Intermediation (I)', 'Serpentinian Exclusion (I)' }
                numOfEFsInThisShift(row) = 1;
                % Inhibit and Logic(xOR)
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    LogicXorFlag(row) = 1; % yes Inhibit, yes xOR
                    if (strcmpi(trial.PreInhExpResp, 'NO_ACTION') == 1)
                        InhibitFlag(row) = 2; % this was an Inhibit trial, but it would've been NO_ACTION anyway
                    else
                        InhibitFlag(row) = 1; % this was an Inhibit trial, and they would've responded otherwise
                    end                    
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                    LogicXorFlag(row) = 0; % no Inhibit, no xOR
                end
                % Hand "switching"
                if (canCheckPrevRow == 1) % we can actually use the last row
                    if (strcmpi(prevTrial.ExpResp, 'ACTION') == 1) % previous trial was LEFT
                        if (strcmpi(trial.ExpResp, 'ACTION') == 1) % this trial was LEFT
                            SwitchHandsFlag(row) = -1; % LEFT to LEFT (one-handed shift)
                        end
                    end
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end    
% not in 1A3 or 1B            case 'Complex Biodigitizing (I)'
            case {'Sensor Peripheralizing (S)', 'Emotionalizing Literature (S)', 'Area Allocation (S)'}
                numOfEFsInThisShift(row) = 1;
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Logic(ID)
                if (SwitchFlag(row) == 1)
                    LogicIdFlag(row) = 1; % yes Switch, yes ID
                else
                    LogicIdFlag(row) = 0; % no Switch, no ID
                end
            case {'Head Heuristics (S)', 'Avionic Sequentializing (S)', 'Conveyance Arithmetic (S)'}
                numOfEFsInThisShift(row) = 1;
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Logic(ID)
                LogicXorFlag(row) = 1; % all trials are xOR trials
            case {'Digit Arrangment (U/I)', 'PI Memorization (U/I)', 'Language Crunching (U/I)'}
                numOfEFsInThisShift(row) = 2;
                % N-back
                if (strcmpi(trial.ExpResp, 'LEFT') == 1)
                    NbackFlag(row) = 1; % Should respond to n-back
                else 
                    NbackFlag(row) = 0; % Should not respond to n-back
                end
                % Inhibit and Logic(ID)
                if (strcmpi(trial.ExpResp, 'NO_ACTION') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                    LogicIdFlag(row) = 1; % yes inhibit, yes ID
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                    LogicIdFlag(row) = 0; % no inhibit, no ID
                end
% not in 1A3 or 1B            case 'PIN Defraudment (U/I)'
            case {'Ocular Orientation (S/I)', 'Cartography Catharsis (S/I)'}
                numOfEFsInThisShift(row) = 2;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                    LogicIdFlag(row) = 1; % yes Inhibit, yes ID
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                    LogicIdFlag(row) = 0; % no Inhibit, no ID
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
% not in 1A3 or 1B            case 'Generational Gapping  (S/I)'
            case {'Limb Chromatizing (U/S)', 'Genus Logistics (U/S)', 'Organizational Balancing (U/S)', 'Organism Grading (U/S)'}
                numOfEFsInThisShift(row) = 2;
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % N-back and Logic(ID)
                if (SwitchFlag(row) == 1)
                    NbackFlag(row) = 1; % yes Switch, yes N-back
                    LogicIdFlag(row) = 1; % yes Switch, yes ID
                else
                    NbackFlag(row) = 0; % no Switch, no N-back
                    LogicIdFlag(row) = 0; % no Switch, no ID
                end
            case {'Serial Verification (U/S)', 'Culinary Itemization (U/S)'}
                numOfEFsInThisShift(row) = 2;
                % N-back 
                NbackFlag(row) = 2; % no way to tell without sigma decoding
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Logic(xOR)
                if (SwitchFlag(row) == 1)
                    LogicXorFlag(row) = 1; % yes Switch, yes xOr
                else
                    LogicXorFlag(row) = 0; % no Switch, no xOr
                end
% not in 1A3 or 1B            case 'Recognition Profiling (U/S)'
            case {'Uniqueness Justification (U/S)', 'Arithmetic Training (U/S)'}
                numOfEFsInThisShift(row) = 2;
                % N-back 
                if (any(~cellfun('isempty',strfind(trial.NextState, 'MATCH'))) == 0) % trial includes MATCH
                    NbackFlag(row) = 1; 
                else
                    NbackFlag(row) = 0; 
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Relational
                RelationalFlag(row) = 1; % all these trials are relational
% not in 1A3 or 1B            case 'Adv. Arithmetic Training (U/S)'
% only 1306            case '4a Update Switch V1 (U/S)'
% only 1306            case '4a Update Switch V1 - 2 (U/S)'
            case {'Biological Itemizing (U/S)', 'Reptile Plotting (U/S)'}
                numOfEFsInThisShift(row) = 3;
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % N-back
                if ((InhibitFlag(row) == 3) || (SwitchFlag(row) == 1))
                    NbackFlag(row) = 1; % if inhibit or switch, the n-back
                else
                    NbackFlag(row) = 0; % no inhibit or switch, no n-back
                end
            case 'Algorithmic Comprehension (S/I)'
                numOfEFsInThisShift(row) = 3;
                % N-back
                if ((strcmpi(trial.NextState, 'PURPLE_LEFT_MATCH') == 1) || (strcmpi(trial.NextState, 'PURPLE_RIGHT_MATCH') == 1))
                    NbackFlag(row) = 1; % this is an n-back match
                else
                    NbackFlag(row) = 0; % no n-back match
                end
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 1; % there was an Inhibit cue on this trial, and they otherwise would have responded
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif ( (any(~cellfun('isempty',strfind(prevTrial.NextState, 'RED'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(prevTrial.NextState, 'BLUE'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(prevTrial.NextState, 'PURPLE_RIGHT'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(prevTrial.NextState, 'PURPLE_LEFT'))) == 0) ) % prev trial has BLUE/RED/PURPLE_LEFT/PURPLE_RIGHT
                    if ( (any(~cellfun('isempty',strfind(trial.NextState, 'RED'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(trial.NextState, 'BLUE'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(trial.NextState, 'PURPLE_RIGHT'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(trial.NextState, 'PURPLE_LEFT'))) == 0) ) % this trial also has BLUE/RED/PURPLE_LEFT/PURPLE_RIGHT
                        if (strcmpi(prevTrial.NextState, trial.NextState) == 1) % both of these are the same
                            SwitchFlag(row) = 2; % this was a repetition trial
                        else % nextState of this trial and last trial were different
                            SwitchFlag(row) = 1; % this was a switch trial
                        end
                    end
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end
            case {'Typographic Trigonometry (U/I)', 'Theoretical Aerodynamics (U/I)'}
                numOfEFsInThisShift(row) = 3;
                % Inhibit and N-back
                if ((strcmpi(trial.NextState, 'TASK_1_INHIBIT') == 1) || (strcmpi(trial.NextState, 'TASK_2_INHIBIT') == 1))
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                    NbackFlag(row) = 1; % if inhibit, then n-back
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                    NbackFlag(row) = 0; % no inhibit, no n-back
                end
                % Switch
                if (InhibitFlag(row) == 0) % not an Inhibit trial
                    if (canCheckPrevRow == 0) % we can not use the last row
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    elseif (prevTrial.Correct == 0) % previous trial was incorrect
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                        if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                            SwitchFlag(row) = 2; % this was a repetition trial
                        elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                            SwitchFlag(row) = 1; % this was a switch trial
                        end
                    elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                        if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                            SwitchFlag(row) = 2; % this was a repetition trial
                        elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                            SwitchFlag(row) = 1; % this was a switch trial
                        end
                    else % some condition we haven't thought of??
                        frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    end
                end
% not in 1A3 or 1B            case 'Mammalian Maneuvering (U/I)'
% only 1306            case '4a Update Switch V2 (U/S)'
% only 1306            case '4a Update Switch V2 - 2 (U/S)'
            case {'Dimensional Jargonization (U/S)', 'Proportional Sympathizing (U/S)'}
                numOfEFsInThisShift(row) = 3;
                % N-back
                if ((strcmpi(trial.NextState, 'TASK_1_LEFT_MATCH') == 1) || (strcmpi(trial.NextState, 'TASK_1_RIGHT_MATCH') == 1) || ...
                        (strcmpi(trial.NextState, 'TASK_2_LEFT_MATCH') == 1) || (strcmpi(trial.NextState, 'TASK_2_RIGHT_MATCH') == 1))
                    NbackFlag(row) = 1; % this was an n-back match
                else 
                    NbackFlag(row) = 0; % no n-back match
                end
                % Inhibit and N-back (inhibit=n-back, as we as n-back's other trials) 
                if ((strcmpi(trial.NextState, 'TASK_1_INHIBIT') == 1) || (strcmpi(trial.NextState, 'TASK_2_INHIBIT') == 1))
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                    NbackFlag(row) = 1; % if inhibit, then n-back
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                    NbackFlag(row) = 0; % no inhibit, no n-back
                end
                % Switch
                if (InhibitFlag(row) == 0) % not an Inhibit trial
                    if (canCheckPrevRow == 0) % we can not use the last row
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    elseif (prevTrial.Correct == 0) % previous trial was incorrect
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                        if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                            SwitchFlag(row) = 2; % this was a repetition trial
                        elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                            SwitchFlag(row) = 1; % this was a switch trial
                        end
                    elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                        if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                            SwitchFlag(row) = 2; % this was a repetition trial
                        elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                            SwitchFlag(row) = 1; % this was a switch trial
                        end
                    else % some condition we haven't thought of??
                        frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    end
                end             
            case 'Computational Vocalizations (S/I)'
                numOfEFsInThisShift(row) = 3;
                % N-back
                if ((strcmpi(trial.NextState, 'PURPLE_LEFT_MATCH') == 1) || (strcmpi(trial.NextState, 'PURPLE_RIGHT_MATCH') == 1))
                    NbackFlag(row) = 1; % this was an n-back match
                else 
                    NbackFlag(row) = 0; % no n-back match
                end
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 1; % there was an Inhibit cue on this trial, and they otherwise would have responded
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif ( (any(~cellfun('isempty',strfind(prevTrial.NextState, 'RED'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(prevTrial.NextState, 'BLUE'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(prevTrial.NextState, 'PURPLE_RIGHT'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(prevTrial.NextState, 'PURPLE_LEFT'))) == 0) ) % prev trial has BLUE/RED/PURPLE_LEFT/PURPLE_RIGHT
                    if ( (any(~cellfun('isempty',strfind(trial.NextState, 'RED'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(trial.NextState, 'BLUE'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(trial.NextState, 'PURPLE_RIGHT'))) == 0) || ...
                        (any(~cellfun('isempty',strfind(trial.NextState, 'PURPLE_LEFT'))) == 0) ) % this trial also has BLUE/RED/PURPLE_LEFT/PURPLE_RIGHT
                        if (strcmpi(prevTrial.NextState, trial.NextState) == 1) % both of these are the same
                            SwitchFlag(row) = 2; % this was a repetition trial
                        else % nextState of this trial and last trial were different
                            SwitchFlag(row) = 1; % this was a switch trial
                        end
                    end
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end
            case 'Tetromino Groking (U/I)'
                numOfEFsInThisShift(row) = 3;
                % N-back
                if ((strcmpi(trial.NextState, 'PURPLE_LEFT_MATCH') == 1) || (strcmpi(trial.NextState, 'PURPLE_RIGHT_MATCH') == 1))
                    NbackFlag(row) = 1; % this was an n-back match
                else 
                    NbackFlag(row) = 0; % no n-back match
                end
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    if (strcmpi(trial.PreInhExpResp, 'NO_ACTION') == 1)
                        InhibitFlag(row) = 2; % this was an Inhibit trial, but it would've been NO_ACTION anyway
                    else
                        InhibitFlag(row) = 1; % this was an Inhibit trial, and they would've responded otherwise
                    end                    
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Switch
                if (InhibitFlag(row) == 0) % not an Inhibit trial
                    if (canCheckPrevRow == 0) % we can not use the last row
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    elseif (prevTrial.Correct == 0) % previous trial was incorrect
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                        if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                            SwitchFlag(row) = 2; % this was a repetition trial
                        elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                            SwitchFlag(row) = 1; % this was a switch trial
                        end
                    elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                        if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                            SwitchFlag(row) = 2; % this was a repetition trial
                        elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                            SwitchFlag(row) = 1; % this was a switch trial
                        end
                    else % some condition we haven't thought of??
                        frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                        SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                    end
                end             
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end
% not in 1A3 or 1B            case 'Word/Number Partitioning (U/S)'
            case {'4b T:1a - rm Prrtzng', '4b T:1b - O_gan Failure?'} % based on Arm Prioritizing
                numOfEFsInThisShift(row) = 2;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    if (strcmpi(trial.PreInhExpResp, 'NO_ACTION') == 1)
                        InhibitFlag(row) = 2; % there was an Inhibit cue on this trial, but they wouldn't have responded anyway
                    else
                        InhibitFlag(row) = 1; % there was an Inhibit cue on this trial, and they otherwise would have responded
                    end
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1_ACTION'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1_ACTION'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2_ACTION'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2_ACTION'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2_ACTION'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1_ACTION'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end    
            case {'4b T:1c - AAAAAAAA', '4b T:2a - Meat-Bag Edition'} % based on Odditizing
                numOfEFsInThisShift(row) = 2;
                % N-back
                if (strcmpi(trial.NextState, 'INHIBIT') == 1) % all Inhibit trials are n-back trials
                    NbackFlag(row) = 1; % This is an n-back trial
                else 
                    NbackFlag(row) = 0; % not n-back
                end
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.NextState, 'INHIBIT') == 1) % inhibit trial
                        IncorrectFlag(row) = 0; % can't tell whether it would have been correct or not
                    end % (non-inhibit trials have the proper value for this flag by default) 
                end
            case '4b T:3a - Specializations' % based on Verbal Repetition
                numOfEFsInThisShift(row) = 1;
                NbackFlag(row) = 1; % all of these trials are N-back
                LogicXorFlag(row) = 1; % all of these trials are xOR
            case '4b T:3c - Penultimations'
                numOfEFsInThisShift(row) = 1;
                % Inhibit and Logic(ID)
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    InhibitFlag(row) = 3; % this was an Inhibit trial, but the "cue" was just the original stimulus
                    LogicIdFlag(row) = 1; % yes Inhibit, yes ID
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                    LogicIdFlag(row) = 0; % no Inhibit, no ID
                end
                % Hand "switching"
                if (canCheckPrevRow == 1) % we can actually use the last row
                    if (strcmpi(prevTrial.ExpResp, 'ACTION') == 1) % previous trial was LEFT
                        if (strcmpi(trial.ExpResp, 'ACTION') == 1) % this trial was LEFT
                            SwitchHandsFlag(row) = -1; % LEFT to LEFT (one-handed shift)
                        end
                    end
                end
            case '4b T:2b - For exceptional testers' % WHAT IS THIS BASED ON???
            case '4b T:2c - Extended training' % Based on Aeronautical Categorization
                numOfEFsInThisShift(row) = 2;
                % Inhibit
                if (strcmpi(trial.NextState, 'INHIBIT') == 1)
                    if (strcmpi(trial.PreInhExpResp, 'NO_ACTION') == 1)
                        InhibitFlag(row) = 2; % there was an Inhibit cue on this trial, but they wouldn't have responded anyway
                    else
                        InhibitFlag(row) = 1; % there was an Inhibit cue on this trial, and they otherwise would have responded
                    end
                else 
                    InhibitFlag(row) = 0; % there was no Inhibit cue on this trial
                end
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1_ACTION'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1_ACTION'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2_ACTION'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2_ACTION'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2_ACTION'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1_ACTION'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Incorrectness
                if (trial.Correct == 0) % trial was incorrect
                    if (strcmpi(trial.GivenResp, trial.PreInhExpResp) == 1) % response is what we expected before inhibit cue
                        IncorrectFlag(row) = 2; % would have been correct but for inhibit
                    else % in addition to not inhibiting, response is not what we expected before inhibit cue
                        IncorrectFlag(row) = 1; % would have been incorrect regardless of inhibit
                    end 
                end    
            case '4b T:3b - Extreme Categorizing'
                numOfEFsInThisShift(row) = 1;
                % Switch
                if (canCheckPrevRow == 0) % we can not use the last row
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (prevTrial.Correct == 0) % previous trial was incorrect
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_1'))) == 0) % previous trial was TASK_1
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                elseif (any(~cellfun('isempty',strfind(prevTrial.NextState, 'TASK_2'))) == 0) % previous trial was TASK_2
                    if (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_2'))) == 0) % this trial was TASK_2
                        SwitchFlag(row) = 2; % this was a repetition trial
                    elseif (any(~cellfun('isempty',strfind(trial.NextState, 'TASK_1'))) == 0) % this trial was TASK_1
                        SwitchFlag(row) = 1; % this was a switch trial
                    end
                else % some condition we haven't thought of??
                    frpintf('putNewColsIntoDataTable_1B: Some odd Switch condition - subj=%d, shift=%s, prevTrial=%s, thisTrial=%s.\n', trial.Subject, trial.Shift, prevTrial.NextState, trial.NextState);
                    SwitchFlag(row) = 0; % there is no way to determine if this was a switch or repetition trial
                end
                % Logic(ID)
                LogicXorFlag(row) = 1; % all trials are xOR trials
            otherwise
                warning('putNewColsIntoDataTable_1B: unexpected shift: %s\n', shift);
        end
    
        if ((NbackFlag(row) > 0) || (InhibitFlag(row) > 0) || (SwitchFlag(row) > 0)) % at least one of the EFs is present
            NonEFFlag(row) = 0; % this is an EF trial
            anyEFFlag(row) = 1; % this is an EF trial
        else
            NonEFFlag(row) = 1; % this is a non-EF trial
            anyEFFlag(row) = 0; % this is a non-EF trial
        end
        if ((LogicXorFlag(row) > 0) || (LogicIdFlag(row) > 0) || (RelationalFlag(row) > 0)) % at least one type of logic/relation in this trial
            anyLogicFlag(row) = 1; % this trial has logic or relational aspects
        else
            anyLogicFlag(row) = 0;
        end
        if (InhibitFlag(row) == 1)
            InhibitDifficulty(row) = trial.InhDelayUsed;
        end
        if (NbackFlag(row) >= 0)
            NbackDifficulty(row) = trial.ActualN;
        end
        if ((NbackFlag(row) == 1) || (InhibitFlag(row) == 1) || (SwitchFlag(row) == 1)) % at least one EFs has to be dealt with in this trial
            if ((NbackFlag(row) == 1) && (InhibitFlag(row) == 1) && (SwitchFlag(row) == 1)) 
            	numOfEFsInThisTrial(row) = 3;
            elseif ((NbackFlag(row) == 1) && (InhibitFlag(row) == 1))
            	numOfEFsInThisTrial(row) = 2;
            elseif ((NbackFlag(row) == 1) && (SwitchFlag(row) == 1))
            	numOfEFsInThisTrial(row) = 2;
            elseif ((SwitchFlag(row) == 1) && (InhibitFlag(row) == 1))
            	numOfEFsInThisTrial(row) = 2;
            else % not 0 or 3 or 2; must be 1
            	numOfEFsInThisTrial(row) = 1;
            end
        else
            numOfEFsInThisTrial(row) = 0; % no EFs have to be actively dealt with in this trial
        end
        
        prevTrial = trial; % store the previous trial in case we want to use it next iteration 
    end
    
    newDataTable = oldDataTable;
    newDataTable.NbackFlag = NbackFlag;
    newDataTable.NbackDifficulty = NbackDifficulty;
    newDataTable.InhibitFlag = InhibitFlag;
    newDataTable.InhibitDifficulty = InhibitDifficulty;
    newDataTable.SwitchFlag = SwitchFlag;
    newDataTable.numOfEFsInThisShift = numOfEFsInThisShift;
    newDataTable.numOfEFsInThisTrial = numOfEFsInThisTrial;
    newDataTable.LogicXorFlag = LogicXorFlag;
    newDataTable.LogicIdFlag = LogicIdFlag;
    newDataTable.RelationalFlag = RelationalFlag;
    newDataTable.anyLogicFlag = anyLogicFlag;
    newDataTable.SwitchHandsFlag = SwitchHandsFlag;
    newDataTable.NonEFFlag = NonEFFlag;
    newDataTable.anyEFFlag = anyEFFlag;
    newDataTable.IncorrectFlag = IncorrectFlag;
    newDataTable.AfterErrorFlag = AfterErrorFlag;
    newDataTable.TotalTrialCount = TotalTrialCount;
    newDataTable.ScenarioCode = ScenarioCode;
    newDataTable.Problem = newDataTable.Problem + 1; % Problem is currently 0-based for some reason, whereas everything else is 1-based
    
    newDataTable = insertTotalTrialCount(newDataTable);
end

