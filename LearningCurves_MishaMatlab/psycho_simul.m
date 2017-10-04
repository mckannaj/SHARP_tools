% >>>>>>>>>>>>>>>>>>   PSYCHO_SIMUL   <<<<<<<<<<<<<<<<<<<<
%

%function [] = simul_psycho(ntrials, ptype, 
% psychMLEfitSimul   Simulates a GLM for Psychometric functions and then fits using  using LSE and MLE
% function psychfit(xdata,ydata,plotflag)
%
global t X     % Arrays of Trial numbers,  and X = responses {0,1}

%% Simulate  Learning - Psychometric functions
% insght learning function
if strcmp(ptype,'insight')
    Th = 0.4;   % Proportion of trials before insigth learning occurs
    pstep = cg+(1-cg)*cl.*double(t0 > Th*n);
    psychom = pstep;
elseif strcmp(ptype,'logit')
    % Simulate IRT/logistic psychometric function where y in [-3 +3]
    ca = -3.0;  % Offset
    cb = 3.0/(n*0.5);% Slope (beta) to reach 3 after n/2 trials
    prlogit = cg+(1-cg)*cl./(1+exp(-(ca + cb*t0)));  % Y = ca + t*cb
    %prlogit = cg+(1-cg-cl)./(1+exp(-(ca) + t*cb));
    psychom = prlogit;
end
if verbose, mplot(t0, psychom), hold on, end

%% Generate binary responses from the psychom function
% Simulate responses
t = repmat(t0,[Nr,1]);
rsp = double((rand(Nr,n) < psychom));
avgrsp = mean(rsp,1); % Average resp[onse for each trial number
if verbose, plot(t0,avgrsp,'*r'); end
t = reshape(t,[1,Nr*n]);    % Convert matrix to a single array
X = reshape(rsp,[1,Nr*n]);  % Convert matrix to a single array