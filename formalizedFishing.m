% Zephy McKanna
% formalizedFishing()
% 8/12/15
%
% This function is intended to take a set of RobotFactory data (presumably 
% produced from the first couple of days, so it's comparable to pretest) and 
% a set of Pre/Posttest data, and compare them using some specified comparison
% function, in order to find the subset of RobotFactory shifts that
% produces the best correlation with Pretest data. 
%
% It uses [all of] the Pretest data, and compares it to every subset of RF
% shifts.
%
% If you set the "graphBest" flag, it will create a scatterplot of the
% highest-correlation subset compared to the pretest data.
%
% If you set the "extraClean" flag, it will clean the data in extra ways
% before attempting to correlate; for example, removing values that are <>
% 3 SDs from the mean, or removing subjects that made > 50% errors.
% 
% Set "verbose" to "true" to get all output from all used functions. Note
% that this is likely a large amount of output, probably only useful for
% debugging.
%
% It outputs details of the best subset of RF shifts.
%
function [bestShiftSet, bestR_Sq, allR_Sq, bestRFdataset, bestPPdataset] = formalizedFishing(allRFData, PPdata, EF, comparisonMethod, extraClean, graphBest, verbose)
    bestR_Sq = 0;
    bestShiftSet = [];
    if (strcmpi(EF, 'S'))
        fprintf('formalizedFishing: fishing for Switch-only RF shifts.\n');
    elseif (strcmpi(EF, 'I'))
        fprintf('formalizedFishing: fishing for Inhibit-only RF shifts.\n');
    elseif (strcmpi(EF, 'U'))
        fprintf('formalizedFishing: fishing for Update-only RF shifts.\n');
    else
        error('formalizedFishing: EF must be S, I, or U.'); % we're only doing single-EF shifts at the moment
    end
    
    % first clean the pretest data
    PretestData = PPdata(strcmpi(PPdata.Period, '0-PreTest'), :); % select only pretest data
    pretestDataToCompare = []; % this should eventually be two columns: subj, numberToCompare
    if (strcmpi(comparisonMethod,'SSRT'))
        if (strcmpi(EF, 'I') == 0)
            error('Trying to do SSRT with EF = %s; should be I.', EF);
        end

        PP_SSRT = getSSRT_PP_1B(PretestData, false, true, extraClean); % z: made this verbose just to know it's working at the start
        pretestDataToCompare = [PP_SSRT.Subject PP_SSRT.PreSSRT];
        pretestDataToCompare(pretestDataToCompare(:,2) == -888,:) = []; % special code: SSRT uncalculable, subj made no errors on Inhibit during these trials
        if (extraClean == true)
            % preemptively clean up pretest data
            pretestDataToCompare(pretestDataToCompare(:,2) < 0.01,:) = []; % remove any subjects faster than 10ms; inhumanly fast
%            pretestDataToCompare(pretestDataToCompare(:,2) > 0.9,:) = []; % remove any subjects slower than 900ms; inhumanly slow
            [failedBeforeCount, failedCatchCount, failedGoCount] = exploreSSRT_PP_1B(PretestData);
            pretestDataToCompare(ismember(pretestDataToCompare(:,1), failedBeforeCount.Subject), :) = []; % remove subjs who behaved oddly, somehow answering a lot of inhibit trials before the inhibit cue
            pretestDataToCompare(ismember(pretestDataToCompare(:,1), failedCatchCount.Subject), :) = []; % remove subjs who failed a lot of Catch trials
            pretestDataToCompare(ismember(pretestDataToCompare(:,1), failedGoCount.Subject), :) = []; % remove subjs who failed a lot of Go trials            
                        
%            meanPretest_SSRT = mean(pretestDataToCompare(:,2));
%            absMeanDiff = abs(pretestDataToCompare(:,2) - meanPretest_SSRT);
%            meanDiff = pretestDataToCompare(:,2) - meanPretest_SSRT;
%            pretestDataToCompare(:,2) = pretestDataToCompare(:,2) + (2 * meanDiff);
%            pretestDataToCompare(pretestDataToCompare(:,2) < meanPretest_SSRT, 2) = pretestDataToCompare(pretestDataToCompare(:,2) < meanPretest_SSRT, 2) - (absMeanDiff(pretestDataToCompare(:,2) > meanPretest_SSRT, 1));
%            pretestDataToCompare(pretestDataToCompare(:,2) > meanPretest_SSRT, 2) = pretestDataToCompare(pretestDataToCompare(:,2) > meanPretest_SSRT, 2) + (absMeanDiff(pretestDataToCompare(:,2) > meanPretest_SSRT, 1));
        end
    elseif (strcmpi(comparisonMethod,'switchCost_RT'))
        if (strcmpi(EF, 'S') == 0)
            error('Trying to do switchCost_RT with EF = %s; should be S.', EF);
        end
        if ( ~ismember('afterError',PretestData.Properties.VariableNames) ) % we haven't added the needed extra columns yet
            PretestData = addPPswitchCols(PretestData, verbose);
        end
        PP_SC = getSwitchCostRT_PP_1B(PretestData, false, verbose);
        
        if (extraClean == true)
            % remove/ignore subjects with too many errors
            PP_SC(PP_SC.TotalErrPct > .5, :) = [];
        end
        pretestDataToCompare = [PP_SC.Subject PP_SC.Pre_SC];
        
        % also, preprocess the RF data the way that getSwitchCostRT_RF_1B() would, for efficiency
        allRFData = allRFData(strcmpi(allRFData.Cluster, EF), :); % delete everything that isn't the proper EF
        allRFData.deleteThis = zeros(height(allRFData), 1); % create a new variable to mark which trials need to be deleted
        allRFData.errors = zeros(height(allRFData), 1); % create a new variable to mark errors, since mixing "timeout" and 0/1 is hard for matlab

        allSubjects = unique(allRFData.Subject);
        for sc_subjIndex = 1:length(allSubjects) 
            sc_subj = allSubjects(sc_subjIndex); % get the subject number
            sc_subjTrials = allRFData(allRFData.Subject == sc_subj, :);

            sc_subjTrials.deleteThis(1) = 1; % the first trial is by definition the first trial of a shift; mark it for deletion
            for trial = 1:height(sc_subjTrials)
                if ( (trial > 1) && (sc_subjTrials.ShiftNum(trial-1) ~= sc_subjTrials.ShiftNum(trial)) ) % this is the first trial of a shift
                    sc_subjTrials.deleteThis(trial) = 1; % mark it for deletion
                end
                if (strcmpi(sc_subjTrials.GivenResp(trial), 'NO_ACTION')) % this was a timeout; response time isn't relevant, so delete it
                    sc_subjTrials.deleteThis(trial) = 1; % mark it for deletion
                end
                if (sc_subjTrials.Correct(trial) == 0) % this is an error
                    sc_subjTrials.errors(trial) = 1; % note that it's an error
                    sc_subjTrials.deleteThis(trial) = 1; % mark it for deletion
                    if (trial < (height(sc_subjTrials))) % we're not at the very last one yet
                        sc_subjTrials.deleteThis(trial+1) = 1; % mark the next one for deletion (note that if it spans two shifts, then this is the first trial of the next shift and should be deleted anyway)
                    end
                end
            end
        end    
    elseif (strcmpi(comparisonMethod,'switchCost_ErrRate'))
        if (strcmpi(EF, 'S') == 0)
            error('Trying to do switchCost_ErrRate with EF = %s; should be S.', EF);
        end
        error('SwitchCost for ErrorRate not yet implemented.');
    elseif (strcmpi(comparisonMethod,'GLM_Ability'))
        if (strcmpi(EF, 'I'))
            error('Trying to do GLM_Ability with EF = I; use SSRT instead.');
        elseif (strcmpi(EF, 'S'))
            [x_PPSw, y_PPSw] = getDataForPreSwitchGLM(excludeSubjects_RF_1B(true, true, PPdata), '1B', false);
            PPSwModel = fitglm(x_PPSw,y_PPSw,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount + RT + (Subj*RT)','distr','binomial','Intercept',true,'CategoricalVars',[1,2],'VarNames',{'Subj','SwRep','RT','TrialCount','Correct'});
            fprintf('formalizedFishing: Pretest model including Ability, SwRep, RT and RT*Subj (not TrialCount).\n');
            PPSubjLen = length(unique(x_PPSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
            PP_subjList = glmLabelsToNumbers(transpose(PPSwModel.CoefficientNames(2:((2+PPSubjLen)-1))));
            PP_abilityList = PPSwModel.Coefficients.Estimate(2:((2+PPSubjLen)-1));
            pretestDataToCompare = [PP_subjList PP_abilityList];
        elseif (strcmpi(EF, 'U')) % assume we're doing Update ability
            if ( ~ismember('origTrialNum',PPdata.Properties.VariableNames) ) % make sure we have the extra rows/cols we need for Pretest Update
                error('FormalizedFishing for Update GLM_Ability requires Pretest data to have single rows per arrow. Use singleArrowPerTrial_PP_1B() on the data first.');
            end
            y_PPUpd = zeros(height(PPdata),1);
            y_PPUpd(strcmpi(PPdata.ArrScore, 'correct'),1) = 1;
            x_PPUpd = table2array(PPdata(:,'Subject'));
            x_PPUpd(:,2) = table2array(PPdata(:,'origArrLettNum'));
            x_PPUpd(:,3) = table2array(PPdata(:,'SeqLength'));
            PPUpdModel = fitglm(x_PPUpd,y_PPUpd,'logit(Correct) ~ 1 + Subj + Narr + SeqLen','distr','binomial','CategoricalVars',[1,2,3],'VarNames',{'Subj','Narr','SeqLen','Correct'});
            fprintf('formalizedFishing: Pretest model including Ability, ArrowNum, and SeqLength.\n');
            PP_subjList = glmLabelsToNumbers(transpose(PPUpdModel.CoefficientNames(2:(end-7))));
            PP_abilityList = PPUpdModel.Coefficients.Estimate(2:(end-7));
            pretestDataToCompare = [PP_subjList PP_abilityList];
        else
            error('Trying to do GLM_Ability with EF = %s; should be S or U.', EF);
        end
    end

    pretestDataToCompare(isnan(pretestDataToCompare(:,2)),:) = []; % remove any subjs that don't have the values we're trying to compare
    if (isempty(pretestDataToCompare))
        error('formalizedFishing: failed to create appropriate pretest data; EF = %s, compMethod = %s\n', EF, comparisonMethod);
    end
    rSqIndex = 1;
    % now grab every combination of the proper EF shifts from RFdata    
    allRFData = allRFData(strcmpi(allRFData.Cluster, EF), :); % delete everything that isn't the proper EF
    RFshifts = unique(allRFData.Shift);
    % ZNOTE: There are 11 unique 'S' shifts in the first two days of
    %        training. This means 2048 different ways of combining these shifts!!!!!!!!
    shiftIndex = 1:1:(length(RFshifts)); % numbers from 1 to the number of unique shifts we have
    allR_Sq = [zeros(2^(length(RFshifts)),1) zeros(2^(length(RFshifts)),1)]; % prealloc for speed - Z: technically I think we need one less than this...
    for k = 1:(length(RFshifts)) % we'll have as many n-choose-k combinations as the number of unique shifts we have
        fprintf('Selecting %d shifts out of %d. This will be %d total attempts.\n', k, length(RFshifts), nchoosek(length(RFshifts),k)); % just "still alive" feedback
        combosOfThisManyShifts = nchoosek(shiftIndex,k); % this gives a matrix of the selected shift indices, one row per combo
        for comboNum = 1:(length(combosOfThisManyShifts(:,1))) % enumerate through the combos for this k
            shiftsToUse = []; % clear out the previous shifts - zNOTE: opportunity for some clever efficiency grab here, to re-use what's already in there...
            shiftIndicesToUse = combosOfThisManyShifts(comboNum,:); % the numbers of the specific shifts to use
            for addThisShift = 1:length(shiftIndicesToUse)
                shiftsToUse = [shiftsToUse; allRFData(strcmpi(allRFData.Shift, RFshifts(shiftIndicesToUse(addThisShift))), :)];
            end
            
            % now that we have the proper shifts, compare them as requested 
            if (strcmpi(comparisonMethod,'SSRT'))
                RF_SSRT = getSSRT_RF_1B(shiftsToUse, 'single', false, verbose, false); % change this last to true (or extraClean) to clean via shifts
%                RF_SSRT = getSSRT_RF_1B(shiftsToUse, 'single', false, verbose, extraClean);
                RFDataToCompare = [RF_SSRT.Subject RF_SSRT.SSRT_est];
                RFDataToCompare(RFDataToCompare(:,2) == -888,:) = []; % special code: SSRT uncalculable, subj made no errors on Inhibit during these trials
                if (extraClean == true)
                    % preemptively clean up RF data
                    RFDataToCompare(RFDataToCompare(:,2) < 0.01,:) = []; % remove any subjects faster than 10ms; inhumanly fast
%                    RFDataToCompare(RFDataToCompare(:,2) > 0.9,:) = []; % remove any subjects slower than 900ms; inhumanly slow
                    [RF_FailedCatchTable, RF_FailedGoTable] = exploreSSRT_RF_1B(RF_SSRT);
                    RFDataToCompare(ismember(RFDataToCompare(:,1), RF_FailedCatchTable.Subject), :) = []; % remove subjs who failed a lot of Catch trials
                    RFDataToCompare(ismember(RFDataToCompare(:,1), RF_FailedGoTable.Subject), :) = []; % remove subjs who failed a lot of Go trials
                    
%                    meanRF_SSRT = mean(RFDataToCompare(:,2));
%                    RFDataToCompare(RFDataToCompare(:,2) < meanRF_SSRT, 2) = RFDataToCompare(RFDataToCompare(:,2) < meanRF_SSRT, 2) * 2;
%                    RFDataToCompare(RFDataToCompare(:,2) > meanRF_SSRT, 2) = RFDataToCompare(RFDataToCompare(:,2) > meanRF_SSRT, 2) * .5;
                end
            elseif (strcmpi(comparisonMethod,'switchCost_RT'))
                RF_SC = getSwitchCostRT_RF_1B(shiftsToUse, 'single', false, verbose, true);
                if (extraClean == true)
                    % remove/ignore subjects with too many errors
                    RF_SC(RF_SC.TotalErrPct > .5, :) = [];
                end
                RFDataToCompare = [RF_SC.Subject RF_SC.SwCost];
            elseif ( (strcmpi(comparisonMethod,'GLM_Ability')) && (strcmpi(EF, 'U')) ) % Update Ability
                [x_RFUpd, y_RFUpd] = getDataForUpdateGLM_1A3(shiftsToUse, false, false, 'TrialCount', 'all', 'single', verbose);
                RFUpdModel = fitglm(x_RFUpd,y_RFUpd,'logit(Correct) ~ 1 + Subj + Nval + TrialCount - Cluster + RT','distr','binomial','CategoricalVars',[1,2,5],'VarNames',{'Subj','Nval','RT','TrialCount','Cluster','Correct'});
                
                RF_subjList = glmLabelsToNumbers(transpose(RFUpdModel.CoefficientNames(2:(end-6))));
                RF_abilityList = RFUpdModel.Coefficients.Estimate(2:(end-6));
                RFDataToCompare = [RF_subjList RF_abilityList];
            elseif ( (strcmpi(comparisonMethod,'GLM_Ability')) && (strcmpi(EF, 'S')) ) % Switch Ability
                [~,~,switchDataRF] = getCleanSwitchTrials_RF_1B(true, true, 'both', 'S', shiftsToUse, verbose); 
                [x_RFSw, y_RFSw] = getDataForSwitchGLM(switchDataRF, false, false, 'TrialCount', 'all', 'single', verbose);
                RFSwModel = fitglm(x_RFSw,y_RFSw,'logit(Correct) ~ 1 + Subj + SwRep - TrialCount - Cluster - TrialDur + RT + (Subj*RT)','distr','binomial','CategoricalVars',[1,2,5,6],'VarNames',{'Subj','SwRep','RT','TrialCount','Cluster','TrialDur','Correct'});

                RFSubjLen = length(unique(x_RFSw(:,1))) - 1; % number of subjects - 1 (first is always estimated to be zero)
                RF_subjList = glmLabelsToNumbers(transpose(RFSwModel.CoefficientNames(2:((2+RFSubjLen)-1))));
                RF_abilityList = RFSwModel.Coefficients.Estimate(2:((2+RFSubjLen)-1));
                RFDataToCompare = [RF_subjList RF_abilityList];
            end 

            % clean the RF data and make sure the subjs match
            RFDataToCompare(isnan(RFDataToCompare(:,2)),:) = []; % remove any subjs that don't have the values we're trying to compare
            [RFDataToCompare_MatchedSubjs, pretestDataToCompare_MatchedSubjs] = removeNonMatchingSubjects(RFDataToCompare(:,1), RFDataToCompare, pretestDataToCompare(:,1), pretestDataToCompare, false); 

            if (length(RFDataToCompare(:,1)) > 1) % we actually have more than one subject so we can calculate a correlation
                % regardless of the method, we're looking for the best r-squared value 
                R_Sq = regstats(RFDataToCompare_MatchedSubjs(:,2),pretestDataToCompare_MatchedSubjs(:,2),'linear',{'rsquare'});
                allR_Sq(rSqIndex, 1:2) = [R_Sq.rsquare length(RFDataToCompare(:,1))];
                
                if ((R_Sq.rsquare > bestR_Sq) && (length(RFDataToCompare(:,1)) > 50)) % arbitrarily say you have to have at least 50 subjs
                    bestR_Sq = R_Sq.rsquare % output every time we have a new best
                    bestShiftSet = unique(shiftsToUse.Shift) % output every time we have a new best
                    bestRFdataset = RFDataToCompare;
                    bestPPdataset = pretestDataToCompare;

                    if (graphBest == true) % graph every time we have a new best (NOTE: only the last one will actually display)
                        titleStr = sprintf('Comparing RF %s to Pretest %s\n(selected RF shifts)', comparisonMethod, comparisonMethod);
                        xAxisStr = sprintf('RF %s', comparisonMethod);
                        yAxisStr = sprintf('Pretest %s', comparisonMethod);

                        zScatter(RFDataToCompare_MatchedSubjs(:,2), pretestDataToCompare_MatchedSubjs(:,2), titleStr, xAxisStr, yAxisStr, true, '', '', 14, false, '', '')
                    end
                end
                
                
                % zNOTE: JUST FOR TESTING!!! DELETE THESE LINES; THEY RETURN THE LAST DATASET RATHER THAN THE BEST 
                bestRFdataset = RFDataToCompare;
                bestPPdataset = shiftsToUse;

            else % no data to compare
                allR_Sq(rSqIndex, 1:2) = [-99 0];
            end
            rSqIndex = rSqIndex + 1; % regardless, inc the rSqIndex
            
         end
    end
    
end
