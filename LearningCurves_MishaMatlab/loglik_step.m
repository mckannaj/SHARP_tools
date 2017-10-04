function lnlik = loglik_step(a)
% Computes the log of negative likelihood to be minimized for a step
% function
% a(1) = cg;
% a(2) = Th;
% a(3) = cl;
global t X     % Trial no,  response {0,1}
% Number of trials
n = max(t);
% Check for out of bounds parameters, i.e.,  0 < a(i) < 1
lnmax = 100000;
penalty = 0;
emin = 0.5/n;
amax = max(a); amin = min(a);
if (amax > (1-emin))
    penalty = lnmax*abs(amax - 1 + emin);
elseif (amin < emin)
    penalty = lnmax*abs(emin - amin);
end
if penalty > 0
    lnlik =  penalty;
    return;
end
pstep = a(1)+(1-a(1))*a(3).*double(t > a(2)*n); %mplot(pstep)
lnlik = X.*log(pstep) + (1-X).*log(1-pstep);    %mplot(lnlik)
lnlik = -sum(lnlik);  % Negative to minimize rather than maximize
% Anonymous version for a GLM
%lnlik = @(a,b,X,t)sum((-1)*X.*log(1./(1+exp(-(a + b*t)))) + (1-X).*log(1-1./(1+exp(-(a + b*t)))));
% Introduce penalty if approaching the limits of prob {0, 1}
