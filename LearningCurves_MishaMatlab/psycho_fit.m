% psychMLEfitSimul   Simulates a GLM for Psychometric functions and then fits using  using LSE and MLE
isoraw = isor(avgrsp);
if verbose, plot(t0, isoraw, '--k','LineWidth',2); end

%% >>>>>>  MLE - Insight (Step) learning  <<<<<<<<
a0 = [0.25, 0.5, 0.9];
fun = @loglik_step;
as = fminsearch(fun,a0);
phat = as(1)+(1-as(1))*as(3).*double(t0 > as(2)*n);
if verbose, plot(t0, phat,'m','LineWidth',2); end
likmax_step = -loglik_step(as);
%cdfraw = cumsum(avgrsp);
%plot(t0, cdfraw/cdfraw(end), 'g','LineWidth',2);
% Plot the step likelihood as a function of the threshold
figh = gcf;
i=0;
for pt=0.1:0.05:0.9
    as(2) = pt;
    i = i+1;
    lxx(i) = loglik_step(as);
    Threshold(i) = pt;
end
if verbose, mplot(Threshold, lxx); end

%% >>>>>>>>> MLE- IRT learning <<<<<<<<<<<<<<<
ca0 = -3.0;  % Offset
cb0 = 3.0/(n*0.5);
a0 = [ca0, cb0, 0.25, 0.9];  % a0 = [-3.0,0.20, 0.25,1]
options=optimset('DerivativeCheck','off','Display','off','TolX',1e-6,'TolFun',1e-6,...
    'Diagnostics','off','MaxIter', 200, 'LargeScale','off');
fun = @loglik_logit;
llow = [-30, -2, 0, 0];
luper = [30,  4, 1, 1];
[a,fval,exitflag,output,lambda,grad,hessian] = fmincon(fun,a0,[],[],[],[],llow,luper,[],options); 
% fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)

% a = fminsearch(fun,a0);
%[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(fun,00,A,b,Aeq,beq,lb,ub,nonlcon,options)
phat = a(3) + (1 - a(3))* a(4)./(1+exp(-(a(1) + a(2)*t0)));
set(0, 'currentfigure', figh);
likmax_irt = -loglik_logit(a)
if verbose
    plot(t0, phat,'c','LineWidth',2);
    legend('PsychMetric', 'Raw Responses','Isotonic','Step Estimate',...
        'IRT Estimate', 'Location','SouthEast');
end
%cdfraw = cumsum(avgrsp);
% plot(t0, cdfraw/cdfraw(end), 'g','LineWidth',2); % cumulative



