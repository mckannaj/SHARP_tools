
% Z: Attempting to figure out whether GLMs deal appropriately with
% ANCOVA-like covariates (Categorical * Non-categorical).
% After some analysis, seems like it does work as expected.


ai = [1:4]; % simulate some abilities
alphai = (.2 * ai); % simulated response time coefficients
T = .1 * [1:20]; % simulated response times
ySingleColumn = [ai(1) + (transpose(T) * alphai(1));ai(2) + (transpose(T) * alphai(2));ai(3) + (transpose(T) * alphai(3)); ai(4) + (transpose(T) * alphai(4))]; % also make a single-column version to get min, max, etc.
ySingleColumn = 5 * ( (ySingleColumn - mean(ySingleColumn)) / (max(ySingleColumn) - min(ySingleColumn)) ); % scale

% zNOTE: HAVE TO LOOP, SO YOU GET DIFFERENT RANDS; ALSO: DO MORE THAN 20
% TRIALS
resp = (rand() < cdf('Logistic', ySingleColumn));

% delMe = ai 
% delMe2 = alpha
% delMe3 = T
% delMe4 = yi
% delMe5 = resp

delMe = [1:4]; % simulate some abilities
%delMe2 = (.2 * delMe); % simulated response time coefficients
delMe2 = [.5 .5 .5 .5]; % simulated response time coefficients
delMe3 = .001 * [1:2000]; % simulated response times from .1s to 2s
delMe3 = transpose([delMe3 delMe3 delMe3 delMe3 delMe3]); % make it 10000 trials/participant instead of just 2000
delMe4a = [delMe(1) + (delMe3 * delMe2(1)); ...
    delMe(2) + (delMe3 * delMe2(2)); ...
    delMe(3) + (delMe3 * delMe2(3)); ...
    delMe(4) + (delMe3 * delMe2(4))];

delMean = mean(delMe4a);
delRange = (max(delMe4a) - min(delMe4a));
delScale = 5; % just to make the logistic range wide enough

delMe4 = delScale * ( (delMe4a - delMean) / delRange ); % scale for logistic function
delMe5 = []; % clear the variable
for trial = 1:length(delMe4)
    delMe5(trial,1) = (rand() < cdf('Logistic', delMe4(trial))); % generate 0/1 responses based on the logistic function
end

testYs = delMe5;
totTrials = length(testYs);
testXs = []; % clear the variable
testXs(1:(totTrials/4),1) = delMe(1); % first quarter are subj #1
testXs(((totTrials/4) + 1):(totTrials/2),1) = delMe(2); % second quarter are subj #2
testXs(((totTrials/2) + 1):(totTrials * .75),1) = delMe(3); % third quarter are subj #3
testXs(((totTrials * .75) + 1):totTrials,1) = delMe(4); % fourth quarter are subj #4
testXs(:,2) = [delMe3;delMe3;delMe3;delMe3];

testModel = fitglm(testXs,testYs,'logit(Correct) ~ 1 + Subj + RT','distr','binomial','CategoricalVars',[1],'VarNames',{'Subj','RT','Correct'})

% now, (delRange / delScale) * alphaCoeff should equal original alpha (delMe2) 
(delRange / delScale) * testModel.Coefficients.Estimate(5)
% now, ((delRange / delScale) * (interceptCoeff + aiCoeff)) + delMean should equal original ai (delMe) 
(delRange / delScale) * (testModel.Coefficients.Estimate(1) + testModel.Coefficients.Estimate(2:4)) + delMean
% also: ((delRange / delScale) * (interceptCoeff + 0)) + delMean should equal original a0 (delMe(1)) 
(delRange / delScale) * (testModel.Coefficients.Estimate(1) + 0) + delMean

testModel = fitglm(testXs,testYs,'logit(Correct) ~ 1 + Subj + (Subj*RT)','distr','binomial','CategoricalVars',[1],'VarNames',{'Subj','RT','Correct'})
% now, (delRange / delScale) * alphaCoeff should equal original alpha (delMe2) 
(delRange / delScale) * testModel.Coefficients.Estimate(5:8)

