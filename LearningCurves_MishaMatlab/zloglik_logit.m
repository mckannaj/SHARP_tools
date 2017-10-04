function [lnlik] = zloglik_logit(limitsAndGuessParams, trialNumbers, correctResp)
% Computes the log of negative likelihood to be minimized
% a(1) = alpha
% a(2) = beta
% a(3) = gamma
% a(4) = lambda
% global t X     % Trial no,  response {0,1}
pl = @(t,a)a(3) + (1 - a(3))*a(4)./(1+exp(-(a(1) + a(2)*t))); %mplot(pl)
lnlik = correctResp.*log(pl(trialNumbers,limitsAndGuessParams)) + (1-correctResp).*log(1-pl(trialNumbers,limitsAndGuessParams));
lnlik = -sum(lnlik);  % Negative to minimize rather than maximize
% Anonymous version for a GLM
%lnlik = @(a,b,X,t)sum((-1)*X.*log(1./(1+exp(-(a + b*t)))) + (1-X).*log(1-1./(1+exp(-(a + b*t)))));
