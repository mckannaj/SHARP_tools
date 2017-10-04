function [lnlik_out, a, limitReached] = zNested_fminsearch_loglik_step(a0, trialNums, correctResp)
    % Computes the log of negative likelihood to be minimized for a step
    % function
    % a(1) = cg;
    % a(2) = Th;
    % a(3) = cl;
    % global t X     % Trial no,  response {0,1}
    [a, ~, exitFlag] = fminsearch(@nestedfun,a0);
    limitReached = 0; % assume no limit reached
    if (exitFlag == 0)
        limitReached = 1; % we reached the iteration limit
    end
%    lnlik_out = -sum( correctResp.*log(pstep) + (1-correctResp).*log(1-pstep) );
    lnlik_out = nestedfun(a);

    function lnlik_rep = nestedfun(a)
        % Number of trials
        n = max(trialNums);
        % Check for out of bounds parameters, i.e.,  0 < a(i) < 1
        lnmax = 100000;
        penalty = 0;
        emin = 0.5/n;
        amax = max(a); amin = min(a);
        if (amax > (1-emin))
%testing            fprintf('first penalty')
            penalty = lnmax*abs(amax - 1 + emin);
%testing            amax
%testing            emin
%testing            abs(amax - 1 + emin)
        elseif (amin < emin)
%testing            fprintf('second penalty')
            penalty = lnmax*abs(emin - amin);
        end
        pstep = a(1)+(1-a(1))*a(3).*double(trialNums > a(2)*n); %mplot(pstep)
        lnlik_rep = correctResp.*log(pstep) + (1-correctResp).*log(1-pstep);    %mplot(lnlik)
        lnlik_rep = -sum(lnlik_rep) + penalty;  % Negative to minimize rather than maximize
    end
end