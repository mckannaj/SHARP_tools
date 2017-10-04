% psychMLEfitSimul   Simulates a GLM for Psychometric functions and then fits using  using LSE and MLE
% function psychfit(xdata,ydata,plotflag)
%
global t X     % Trial no,  response {0,1}
%addpath('C:\Users\pavelm\Documents\Matlab_local\tools_local');
addpath('/Users/z_home/Downloads/LearningCurves_MishaMatlab');
if ~exist('plotflag','var') plotflag = false; end  % plotflag = 1;
rseed = 38714;  % rng('default');
rng(rseed);     % rng('default');
ptype = 'insight';  
%ptype = 'logit';
% Learning block parameters
n = 30;
t0 = 1:n;   % Trial number
cg = 0.25;  % Guessing baseline
cl = 0.9;   % 1 - P{Errors} after completed learning
Nr = 1;    % Number of repetitions for simulation  Nr = 1;

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
mplot(t0, psychom), hold on

%% Generate binary responses from the psychom function
% Simulate responses
t = repmat(t0,[Nr,1]);
rsp = double((rand(Nr,n) < psychom));
avgrsp = mean(rsp,1); % Average resp[onse for each trial number
plot(t0,avgrsp,'*r');
t = reshape(t,[1,Nr*n]);    % Convert matrix to a single array
X = reshape(rsp,[1,Nr*n]);  % Convert matrix to a single array


%% MLE - Insight (Step) learning
if strcmp(ptype,'insight')
    a0 = [cg, Th, cl];
    a0 = [0.25, 0.1, 0.9];
    fun = @loglik_step;
    a = fminsearch(fun,a0);
    phat = a(1)+(1-a(1))*a(3).*double(t0 > a(2)*n);
    plot(t0, phat,'m','LineWidth',2)
    likmax = -loglik_step(a)
    a
    cdfraw = cumsum(avgrsp);
    plot(t0, cdfraw/cdfraw(end), 'g','LineWidth',2);
    legend('PsychMetric', 'Raw Responses','PM Estimate','CDF-Raw', 'Isotonic',...
        'Location','SouthEast');
    isoraw = isor(avgrsp);
    plot(t0, isoraw, '--k','LineWidth',2);
    hold off
    i=0;
    % Plot the likelihood as a function of the threshold
    for pt=0.1:0.05:0.9
        a(2) = pt;
        i = i+1;
        lxx(i) = loglik_step(a);
        Threshold(i) = pt;
    end
    mplot(Threshold, lxx)
end

%% MLE- IRT learning
if strcmp(ptype,'logit')
    a0 = [ca, cb, cg, cl];  % a0 = [-3.0,0.20, 0.25,1]
    fun = @loglik_logit;
    a = fminsearch(fun,a0);
    phat = a(3) + (1 - a(3))* a(4)./(1+exp(-(a(1) + a(2)*t0)));
    plot(t0, phat,'m','LineWidth',2)
    likmax = -loglik_logit(a);
    %cdfraw = cumsum(avgrsp);
    plot(t0, cdfraw/cdfraw(end), 'g','LineWidth',2);
    legend('PsychMetric', 'Raw Responses','PM Estimate','CDF-Raw', 'Isotonic',...
        'Location','SouthEast');
    isoraw = isor(avgrsp);
    plot(t0, isoraw, '--k','LineWidth',2);
    hold off
     i=0;
    % Plot the likelihood as a function of the threshold
    for pt=0.05:0.05:0.95
        a(2) = pt;
        i = i+1;
        lxx(i) = loglik_logit(a);
        Threshold(i) = pt;
    end
    mplot(Threshold, lxx)
end
% a0(1) = 0;  % alpha
% a0(2) = 0.2; % beta
% a0(3) = 0.1; % gamma
% a0(4) = 1.0; % lambda
%loglik(a)
%loglik=(-1)*(x.*log(p)+(n-x).*log(1-p));
%lnlik = @(a,b,X,t)sum((-1)*X.*log(1./(1+exp(-(a + b*t)))) + (1-X).*log(1-1./(1+exp(-(a + b*t)))));


options=optimset('DerivativeCheck','off','Display','off','TolX',1e-6,'TolFun',1e-6,...
   'Diagnostics','off','MaxIter', 200, 'LargeScale','off');
fun = @loglik_logit;
llow = [-30, -2, 0, 0];
luper = [30,  4, 1, 1];
%[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(fun,00,A,b,Aeq,beq,lb,ub,nonlcon,options)
[a,fval,exitflag,output,lambda,grad,hessian] = fmincon(fun,a0,[],[],[],[],llow,luper,[],options);
yhat = a(3) + (1 - a(3))* a(4)./(1+exp(-(a(1) + a(2)*t)));   %gam+(1-gam-lam)./(1+exp(-(alp + t*bet)));
%figure( 'Name', 'Simulate ML Psychophysical Function Fitting' );    
plot(t0, yhat) 
hold off

