% Zephy McKanna
% checkRTdistPerTimeout_1B()
% 8/20/15
%
% This function takes either a set of RobotFactory trials or a set of
% Pre/Posttest files, or both, and plots the reaction time distributions 
% on a per-timeout basis using ksdensity().
% Note that it assumes the timeout for Pretest is 1500ms (true for Inhibit
% and Switch in 1B).
%
% The EF flag should either be 'S' or 'I' depending on whether we're
% looking for Switch or Inhibit data.
%
function [] = checkRTdistributionPerTimeout_1B(RFtrials, PPtrials, EF, do1sRF, do2sRF, do3sRF, doPretest)
    if (strcmpi(EF, 'I') || strcmpi(EF, 'S'))
        RFtrials = RFtrials(strcmpi(RFtrials.Cluster, EF),:);
    else
        error('checkRTdistPerTimeout_1B is only set up to handle Inhibit and Switch data; EF should be I or S.');
    end
    
    % first, grab the different durations and the common subjects 
    if (height(RFtrials) > 0)
        if (do1sRF == true)
            RFshifts_Only1sDur = RFtrials(RFtrials.StimShowTime == 1, :); % just the 1s trials
        end
        if (do2sRF == true)
            RFshifts_Only2sDur = RFtrials(RFtrials.StimShowTime == 2, :); % just the 2s trials
        end
        if (do3sRF == true)
            RFshifts_Only3sDur = RFtrials(RFtrials.StimShowTime == 3, :); % just the 3s trials
        end
        
        RFsubjs = unique(RFtrials(RFtrials.StimShowTime == 2, 'Subject')); % unique subj numbers (everybody sees the 2s first)
        RFsubjs = RFsubjs.Subject; % this just turns it from a table to a matrix
    end
    if (height(PPtrials) > 0)
        PPsubjs = unique(PPtrials.Subject); % unique subj numbers
    end
    if ( (length(PPsubjs) > 0) && (length(RFsubjs) > 0) )
        [commonSubjs, ~] = removeNonMatchingSubjects(PPsubjs, PPsubjs, RFsubjs, RFsubjs, false); % overlapping subj numbers
    elseif (length(PPsubjs) > 0)
        commonSubjs = PPsubjs;
    else
        commonSubjs = RFsubjs;
    end

    
    % now clean up and specify the data you want to plot
    if (strcmpi(EF, 'I'))
        if (height(RFtrials) > 0)
            % check to see if different participants have different reactionTimes for different stimulus duration times 
            % there are (so far) only 1s and 2s RF trials for Inhibit
            if (do1sRF == true)
                allGo1s = RFshifts_Only1sDur(RFshifts_Only1sDur.InhibitFlag == 0, :); % all Go trials (note: COULD STILL BE TIMEOUTS!)
                allCorrectGo1s = allGo1s(allGo1s.Correct == 1, :); % all correct Go trials (note: COULD STILL BE TIMEOUTS!)
                allCorrectGo1s(strcmpi(allCorrectGo1s.GivenResp, 'NO_ACTION'), :) = []; % remove timeouts
            end
            if (do2sRF == true)
                allGo2s = RFshifts_Only2sDur(RFshifts_Only2sDur.InhibitFlag == 0, :); % all Go trials (note: COULD STILL BE TIMEOUTS!)
                allCorrectGo2s = allGo2s(allGo2s.Correct == 1, :); % all correct Go trials (note: COULD STILL BE TIMEOUTS!)
                allCorrectGo2s(strcmpi(allCorrectGo2s.GivenResp, 'NO_ACTION'), :) = []; % remove timeouts
            end
        end
        if (height(PPtrials) > 0)
            if (doPretest == true)
                pretestInhibit = PPtrials(strcmpi(PPtrials.Period,'0-PreTest'),:); % start with all Pretest
                pretestInhibit(strcmpi(pretestInhibit.Block,'Train_wo_Inh'),:) = []; % delete all training trials
                pretestInhibit(strcmpi(pretestInhibit.Block,'Train_w_Inh'),:) = []; % delete all training trials
                pretestInhibit(strcmpi(pretestInhibit.Block,'Calibrate'),:) = []; % delete all calibration trials
                respBeforeCueTrials = pretestInhibit(strcmpi(pretestInhibit.InhCorr,'before'),'Inhibit'); % identify the Inhibit trials where the participant responded before the cue (should be treated as Go trials)
                respBeforeCueTrials.Inhibit(:) = {NaN}; % mark the correct length with NaNs
                pretestInhibit(strcmpi(pretestInhibit.InhCorr,'before'),'Inhibit') = respBeforeCueTrials; % save the NaNs to the cells marking this as an Inhibit trial
                pretestInhibit(strcmpi(pretestInhibit.InhCorr,'before'),'InhCorr') = respBeforeCueTrials; % save the NaNs to the cells marking this as an Inhibit trial
                findNANsFunction = @(x) all(isnan(x(:))); % this function will find NaNs in cells
                pretestGoTrials = pretestInhibit(cellfun(findNANsFunction, pretestInhibit.Inhibit),:); % get all the rows that have [NaN] in the Inhibit col (Go trials)
                correctPretestGo = pretestGoTrials; % start out with all Go trials, then delete the errors
                correctPretestGo(cellfun(findNANsFunction, correctPretestGo.Response),:) = []; % delete all the errors where they didn't respond
                correctPretestGo((correctPretestGo.Animal == 1)&(strcmpi(correctPretestGo.Response,'right')), :) = []; % delete the errors where Animal = TRUE
                correctPretestGo((correctPretestGo.Animal == 0)&(strcmpi(correctPretestGo.Response,'left')), :) = []; % delete the errors where Animal = FALSE
                correctPretestGo.newRT = ((correctPretestGo.RespTime - correctPretestGo.StimTime) / 10000); % get the response time (resp - stim) and put it in seconds (/ 10,000)
            end
        end
    elseif (strcmpi(EF, 'S'))
        if (height(RFtrials) > 0)
            if (do1sRF == true)
                RF_switch_1s = addRFswitchCols(RFshifts_Only1sDur, true); % verbose, just for 
                RF_switch_1s(RF_switch_1s.deleteThis == 1,:) = []; % delete all trials that would be deleted before calculating SwitchCost (NOTE: includes all errors, just-after-errors, timeouts, and first-of-shifts)
                RF_switchTrials_1s = RF_switch_1s(RF_switch_1s.SwitchFlag == 1,:);
                RF_repetitionTrials_1s = RF_switch_1s(RF_switch_1s.SwitchFlag == 2,:);
            end
            if (do2sRF == true)            
                RF_switch_2s = addRFswitchCols(RFshifts_Only2sDur, true);
                RF_switch_2s(RF_switch_2s.deleteThis == 1,:) = []; % delete all trials that would be deleted before calculating SwitchCost (NOTE: includes all errors, just-after-errors, timeouts, and first-of-shifts)
                RF_switchTrials_2s = RF_switch_2s(RF_switch_2s.SwitchFlag == 1,:);
                RF_repetitionTrials_2s = RF_switch_2s(RF_switch_2s.SwitchFlag == 2,:);
            end
            if (do3sRF == true)            
                RF_switch_3s = addRFswitchCols(RFshifts_Only3sDur, true);
                RF_switch_3s(RF_switch_3s.deleteThis == 1,:) = []; % delete all trials that would be deleted before calculating SwitchCost (NOTE: includes all errors, just-after-errors, timeouts, and first-of-shifts)
                RF_switchTrials_3s = RF_switch_3s(RF_switch_3s.SwitchFlag == 1,:);
                RF_repetitionTrials_3s = RF_switch_3s(RF_switch_3s.SwitchFlag == 2,:);
            end
        end
        if (height(PPtrials) > 0)
            if (doPretest == true)
                PP_switchTrials = addPPswitchCols(PPtrials, true);
                pretestSwitch = PP_switchTrials(strcmpi(PP_switchTrials.Period,'0-PreTest'),:); % start with all Pretest
                pretestSwitch(pretestSwitch.deleteThis == 1,:) = []; % delete all trials that would be deleted before calculating SwitchCost (NOTE: includes all errors, just-after-errors, timeouts, and first-of-blocks)
                pretestSwitchTrials = pretestSwitch(pretestSwitch.IsSwitch == 1,:);
                pretestRepetitionTrials = pretestSwitch;
                pretestRepetitionTrials(pretestRepetitionTrials.IsSwitch == 1, :) = []; % delete all the switch trials, leaving just repetition
            end
        end
    end
    
    figure % create a figure that we can then populate with distribution curves
    if (strcmpi(EF, 'I'))
        str = sprintf('ReactionTime density estimation (ksDensity)\nRed = 1s RF; Green = 2s RF; Blue = 1.5s Pretest');
    elseif (strcmpi(EF, 'S'))
        str = sprintf('ReactionTime density estimation (ksDensity); light=Repetition, dark=Switch\nRed = 1s RF; Green = 2s RF; Purple = 3s RF; Blue = 1.5s Pretest');
    end
    title(str)
    xlabel('100 evenly spaced points for each subj at each trial duration')
    ylabel('Density estimation at each point')
    set(findall(gca,'type','text'),'FontSize',14)
    set(findall(gca,'type','axes'),'FontSize',14)
    hold on;
    for subjIndex = 1:length(commonSubjs) % go through all subj nums
        subjNum = commonSubjs(subjIndex); % get the subject number

        if (strcmpi(EF, 'I')) % doing Inhibit
            if (do1sRF == true)
                subjTrials1s = allCorrectGo1s(allCorrectGo1s.Subject == subjNum, :); % this subject's 1s RF trials
                if (height(subjTrials1s) > 0)
                    subjTrials1s = subjTrials1s.RespTime; % just RTs
        %            min(subjTrials1s)
        %            max(subjTrials1s)
                    [f,xi] = ksdensity(subjTrials1s, 'support', [0 1.04]); % zNOTE: the RF timeouts are actually a little longer than requested (e.g., 1.0149s, for a 1s timeout)
                    plot(xi,f,'Color',[0.9,0.3,0.3]);
                end
            end
            if (do2sRF == true)
                subjTrials2s = allCorrectGo2s(allCorrectGo2s.Subject == subjNum, :); % this subject's 2s RF trials
                if (height(subjTrials2s) > 0)
                    subjTrials2s = subjTrials2s.RespTime; % just RTs
        %            min(subjTrials2s)
        %            max(subjTrials2s)
                    [f,xi] = ksdensity(subjTrials2s, 'support', [0 2.04]); % zNOTE: the RF timeouts are actually a little longer than requested (e.g., 2.0329s, for a 2s timeout)
                    plot(xi,f,'Color',[.3,0.7,0.3]);
                end
            end
            if (doPretest == true)
                subjTrials1500ms = correctPretestGo(correctPretestGo.Subject == subjNum, :); % this subject's Pretest trials
                if (height(subjTrials1500ms) > 0)
                    subjTrials1500ms = subjTrials1500ms.newRT; % just RTs
                    [f,xi] = ksdensity(subjTrials1500ms, 'support', [0 1.5]);
                    plot(xi,f,'Color',[0,0.7,0.9]);
                end
            end
        elseif (strcmpi(EF, 'S')) % doing Switch
            % first do RF Sw/Rep for each of the trial durations
            if (do1sRF == true)
                subjTrialsRep1s = RF_repetitionTrials_1s(RF_repetitionTrials_1s.Subject == subjNum, :); % this subject's RF 1s Rep trials
                if (height(subjTrialsRep1s) > 0)
                    subjTrialsRep1s = subjTrialsRep1s.RespTime; % just RTs
                    [f,xi] = ksdensity(subjTrialsRep1s, 'support', [0 1.04]); % zNOTE: the RF timeouts are actually a little longer than requested (e.g., 1.0149s, for a 1s timeout)
                    plot(xi,f,'Color',[0.9,0.3,0.3]);
                end
                subjTrialsSw1s = RF_switchTrials_1s(RF_switchTrials_1s.Subject == subjNum, :); % this subject's RF 1s Rep trials
                if (height(subjTrialsSw1s) > 0)
                    subjTrialsSw1s = subjTrialsSw1s.RespTime; % just RTs
                    [f,xi] = ksdensity(subjTrialsSw1s, 'support', [0 1.04]); % zNOTE: the RF timeouts are actually a little longer than requested (e.g., 1.0149s, for a 1s timeout)
                    plot(xi,f,'Color',[0.6,0.0,0.0]);
                end
            end
            if (do2sRF == true)            
                subjTrialsRep2s = RF_repetitionTrials_2s(RF_repetitionTrials_2s.Subject == subjNum, :); % this subject's RF 2s Rep trials
                if (height(subjTrialsRep2s) > 0)
                    subjTrialsRep2s = subjTrialsRep2s.RespTime; % just RTs
                    [f,xi] = ksdensity(subjTrialsRep2s, 'support', [0 2.04]); % zNOTE: the RF timeouts are actually a little longer than requested (e.g., 2.0329s, for a 2s timeout)
                    plot(xi,f,'Color',[.3,0.7,0.3]);
                end
                subjTrialsSw2s = RF_switchTrials_2s(RF_switchTrials_2s.Subject == subjNum, :); % this subject's RF 2s Rep trials
                if (height(subjTrialsSw2s) > 0)
                    subjTrialsSw2s = subjTrialsSw2s.RespTime; % just RTs
                    [f,xi] = ksdensity(subjTrialsSw2s, 'support', [0 2.04]); % zNOTE: the RF timeouts are actually a little longer than requested (e.g., 2.0329s, for a 2s timeout)
                    plot(xi,f,'Color',[0.0,0.4,0.0]);
                end
            end            
            if (do3sRF == true)
                subjTrialsRep3s = RF_repetitionTrials_3s(RF_repetitionTrials_3s.Subject == subjNum, :); % this subject's RF 3s Rep trials
                if (height(subjTrialsRep3s) > 0)
                    subjTrialsRep3s = subjTrialsRep3s.RespTime; % just RTs
                    [f,xi] = ksdensity(subjTrialsRep3s, 'support', [0 3.04]); % zNOTE: the RF timeouts are actually a little longer than requested 
                    plot(xi,f,'Color',[0.9,0.3,0.9]);
                end
                subjTrialsSw3s = RF_switchTrials_3s(RF_switchTrials_3s.Subject == subjNum, :); % this subject's RF 3s Rep trials
                if (height(subjTrialsSw3s) > 0)
                    subjTrialsSw3s = subjTrialsSw3s.RespTime; % just RTs
                    [f,xi] = ksdensity(subjTrialsSw3s, 'support', [0 3.04]); % zNOTE: the RF timeouts are actually a little longer than requested 
                    plot(xi,f,'Color',[0.6,0.0,0.6]);
                end
            end
            
            % now do the pretest Sw/Rep
            if (doPretest == true)
                subjTrialsRep1500ms = pretestRepetitionTrials(pretestRepetitionTrials.Subject == subjNum, :); % this subject's Pretest Rep trials
                if (height(subjTrialsRep1500ms) > 0)
                    subjTrialsRep1500ms = subjTrialsRep1500ms.newRT; % just RTs
                    [f,xi] = ksdensity(subjTrialsRep1500ms, 'support', [0 1.5]);
                    plot(xi,f,'Color',[0,0.7,0.9]);
                end
                subjTrialsSw1500ms = pretestSwitchTrials(pretestSwitchTrials.Subject == subjNum, :); % this subject's Pretest Rep trials
                if (height(subjTrialsSw1500ms) > 0)
                    subjTrialsSw1500ms = subjTrialsSw1500ms.newRT; % just RTs
                    [f,xi] = ksdensity(subjTrialsSw1500ms, 'support', [0 1.5]);
                    plot(xi,f,'Color',[0,0.4,0.6]);
                end
            end
        end
        pause(.2);
    end
    hold off;

end