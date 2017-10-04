
% test the nested fmincon function, see if it comes up with the expected estimate for continuous learning 
%zNested_fmincon_loglik_logit(a0, trialNumbers, correctResp)
randomTestingT = [1:20];
randomTestingResp = [0 0 0 0 1 0 1 0 1 0 1 1 1 0 1 0 1 1 0 1];
ca0 = -3.0;  % Offset
cb0 = 3.0/(max(randomTestingT)*0.5);
a0_logit = [ca0, cb0, 0.25, 0.9];  % starting place for alpha, beta, gamma, lambda
[negLogLik, a_output,~,~,~,~,~,~] = zNested_fmincon_loglik_logit(a0_logit, randomTestingT, randomTestingResp)

% test the nested fminsearch function, see if it comes up with the expected estimate for step learning 
%[lnlik_out, a] = zNested_fminsearch_loglik_step(a0, trialNums, correctResp)
a0_step = [0.25, 0.7, 0.9]; % starting place for gamma, threshold, lambda
[negLogLik, a_output] = zNested_fminsearch_loglik_step(a0_step, randomTestingT, randomTestingResp)



% this is the actual script that compares insight to continuous learning
% run a likelihood for each trial of each shift; take the min (best) for each shift 
learningTypePerShift = table(0,0,0,{'None'},0,0,0,0,0,0,0,0,0,0,0,0,0,0,...
    'VariableNames',{'Subject','ShiftNum','ShiftID','Cluster','TrialCount',...
    'loglik_logit','log_Alpha','log_Beta','log_Gamma','log_Lambda',...
    'loglik_insight','insight_thresh','insight_Gamma','insight_Lambda',...
    'likelyInsight','LogRegIterLimit','LogRegInfCoeff','fminIterLimit'});
rowNum = 1;
for trialDataNum = 1:13 % there are 13 sets of 50-subject trials data
    % first, we care about a very limited number of columns; remove all others 
    trialData = get50subjsTrialData_1B(trialDataNum);
    subjs = unique(trialData.Subject);
    for i = 1:length(subjs)
        subj = subjs(i);
        fprintf('Analyzing subject %d.\n', subj); % staying alive feedback
        subjData = trialData(trialData.Subject == subj,:);
        shifts = unique(subjData.ShiftNum);
        for j = 1:length(shifts)
            shift = shifts(j);
            shiftTrials = subjData(subjData.ShiftNum == shift, :);
            trialNums = transpose(1:height(shiftTrials));
            isoraw = isor(shiftTrials.Correct);
            gamma = max(min(isoraw),0.1); % make sure guessing param is at least 0.1
            lambda = min(max(isoraw),0.9); % make sure upper limit is at most 0.9
            logisticStats = glmfit(trialNums,shiftTrials.Correct,'binomial','link','logit');
            glmIterationLimit = 0;
            glmInfiniteCoeffs = 0;
            [~, msgidlast] = lastwarn;
            if (strcmpi(msgidlast, 'stats:glmfit:IterationLimit'))
                glmIterationLimit = 1; % make a note that logistic regression failed on this shift
                lastwarn(''); % clear the last warning
            elseif (strcmpi(msgidlast, 'stats:glmfit:PerfectSeparation'))
                glmInfiniteCoeffs = 1; % make a note that logistic regression failed on this shift
                lastwarn(''); % clear the last warning
            end
            a0_logit = [logisticStats(1), logisticStats(2), gamma, lambda];
            [lnlik_logit, a_log,~,~,~,~,~,~] = zNested_fmincon_loglik_logit(a0_logit, trialNums, shiftTrials.Correct);
            bestGamma = 9999;
            bestThreshold = 9999;
            bestLambda = 9999;
            bestStepLnlik = 9999;
            fminIterationLimit = 0;
            for k = 1:length(trialNums)
                thresh = k / length(trialNums); % go through each trial, by percentage
% just for testing                thresh = 65 / length(trialNums); % close to the end 
                a0_step = [gamma, thresh, lambda];
                [lnlik_step, a_step, limitReached] = zNested_fminsearch_loglik_step(a0_step, trialNums, shiftTrials.Correct);
                if (limitReached == 1)
                    fminIterationLimit = 1; % note it in the matrix
                    fprintf('zNote: the preceding warning came from fminsearch_step.\n')
                end
                if (lnlik_step < bestStepLnlik) % we found a better likelihood
                    bestGamma = a_step(1);
                    bestThreshold = a_step(2);
                    bestLambda = a_step(3);
                    bestStepLnlik = lnlik_step;
                end
            end
            likelyInsight = 0; % assume it's not insight learning
            if (bestStepLnlik < lnlik_logit) % but if insight is more likely...
                likelyInsight = 1;
            end
                
            learningTypePerShift(rowNum,:) = table(subj,shift,...
                shiftTrials.ShiftID(1),shiftTrials.Cluster(1),trialNums(end),...
                lnlik_logit,a_log(1),a_log(2),a_log(3),a_log(4),...
                bestStepLnlik,bestThreshold,bestGamma,bestLambda,...
                likelyInsight,glmIterationLimit,glmInfiniteCoeffs,fminIterationLimit,...
                'VariableNames',{'Subject','ShiftNum','ShiftID','Cluster','TrialCount',...
                'loglik_logit','log_Alpha','log_Beta','log_Gamma','log_Lambda',...
                'loglik_insight','insight_thresh','insight_Gamma','insight_Lambda',...
                'likelyInsight','LogRegIterLimit','LogRegInfCoeff','fminIterLimit'});
            rowNum = rowNum + 1;
        end
    end
end
writetable(learningTypePerShift, getFileNameForThisOS('2017_8_1-LearningTypePerShift_1B.csv', 'IntResults'));
save(getFileNameForThisOS('2017_8_1-LearningTypePerShift_1B.mat', 'IntResults'), 'learningTypePerShift');
% now clear out the ridiculous number of variables we created
clear rowNum trialDataNum trialData subjs i subj subjData shifts j shift
clear shiftTrials trialNums isoraw gamma lambda logisticStats
clear glmIterationLimit glmInfiniteCoeffs msgidlast a0_logit lnlik_logit
clear a_log bestGamma bestThreshold bestLambda bestStepLnlik fminIterationLimit
clear k thresh a0_step lnlik_step a_step limitReached likelyInsight
clear learningTypePerShift % only when we're done using it



% for testing purposes, if/when the above fails
% some plots to figure out what's going on when the above fails weirdly
pstep = gamma+(1-gamma)*lambda.*double(trialNums > bestThreshold*n);
%pstep = cg+(1-cg)*cl.*double(t0 > Th*n);
mplot(trialNums, pstep); hold on % plot the step function
plot(trialNums,shiftTrials.Correct,'*r');
%prlogit = cg+(1-cg)*cl./(1+exp(-(ca + cb*t0)));  % Y = ca + t*cb
prlogit = gamma+(1-gamma)*lambda./(1+exp(-(a0_logit(1) + a0_logit(2)*trialNums)));  % Y = ca + t*cb
mplot(trialNums, prlogit); hold on % plot the continuous function
plot(trialNums,shiftTrials.Correct,'*r'); % plot the responses
%phat = a(1)+(1-a(1))*a(3).*double(t0 > a(2)*n);
phat = gamma+(1-gamma)*lambda.*double(trialNums > bestThreshold*n);
plot(trialNums, phat,'m','LineWidth',2);  % plot the step function
plot(trialNums, isoraw, '--k','LineWidth',2); % isotonic regression




