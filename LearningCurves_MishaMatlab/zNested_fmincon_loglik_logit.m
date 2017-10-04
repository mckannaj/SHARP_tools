function [lnlik_out, a,fval,exitflag,output,lambda,grad,hessian] = zNested_fmincon_loglik_logit(a0, trialNums, correctResp)
    % Computes the log of negative likelihood to be minimized
    % a(1) = alpha
    % a(2) = beta
    % a(3) = gamma
    % a(4) = lambda
    % global t X     % Trial no,  response {0,1}
    %   trialNumbers = t
    %   correctResp = X
    options=optimset('DerivativeCheck','off','Display','off','TolX',1e-6,'TolFun',1e-6,...
        'Diagnostics','off','MaxIter', 200, 'LargeScale','off');
    llow = [-30, -2, 0, 0];
    luper = [30,  4, 1, 1];
    [a,fval,exitflag,output,lambda,grad,hessian] = fmincon(@nestedfun,a0,[],[],[],[],llow,luper,[],options); 
%    lnlik_out = -sum( correctResp.*log(pl(trialNums,a)) + (1-correctResp).*log(1-pl(trialNums,a)) );
    lnlik_out = nestedfun(a);
    
    function lnlik_rep = nestedfun(a)
        pl = @(trialNumbers,a)a(3) + (1 - a(3))*a(4)./(1+exp(-(a(1) + a(2)*trialNumbers))); %mplot(pl)
        lnlik_rep = correctResp.*log(pl(trialNums,a)) + (1-correctResp).*log(1-pl(trialNums,a));
        lnlik_rep = -sum(lnlik_rep);  % Negative to minimize rather than maximize
    end
end
