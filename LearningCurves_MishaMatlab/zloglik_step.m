function [lnlik] = zloglik_step(limitsAndGuessParams, trialNumbers, correctResp)
% Computes the log of negative likelihood to be minimized for a step
% function
% a(1) = cg;
% a(2) = Th;
% a(3) = cl;
% global t X     % Trial no,  response {0,1}
% Number of trials
n = max(trialNumbers);
% Check for out of bounds parameters, i.e.,  0 < a(i) < 1
lnmax = 100000;
penalty = 0;
emin = 0.5/n;
amax = max(limitsAndGuessParams); amin = min(limitsAndGuessParams);
if (amax > (1-emin))
    penalty = lnmax*abs(amax - 1 + emin);
elseif (amin < emin)
    penalty = lnmax*abs(emin - amin);
end
if penalty > 0
    lnlik =  penalty;
    return;
end
pstep = limitsAndGuessParams(1)+(1-limitsAndGuessParams(1))*limitsAndGuessParams(3).*double(trialNumbers > limitsAndGuessParams(2)*n); %mplot(pstep)
lnlik = correctResp.*log(pstep) + (1-correctResp).*log(1-pstep);    %mplot(lnlik)
lnlik = -sum(lnlik);  % Negative to minimize rather than maximize
% Anonymous version for a GLM
%lnlik = @(a,b,X,t)sum((-1)*X.*log(1./(1+exp(-(a + b*t)))) + (1-X).*log(1-1./(1+exp(-(a + b*t)))));
% Introduce penalty if approaching the limits of prob {0, 1}
