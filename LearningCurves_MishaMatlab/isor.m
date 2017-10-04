function [y stats] = isorp(x,wt,xo)
% [y stats] = isorp(x,wt,xo)
% Computing isotonic regression to estimate psychometric function
% x is a column or a row  vector of input values
% wt is a vector of the same size as x with positive weights,
%       Default is equal weights
% x0 is the first value if known to be fixed initial condition
% This should be modified to include the weight of the first point
% Works with NaN by ignoring NaNs but keeping them in the output
% Output:
% y predicted values 
% stats(:) = LikeRatio DF  p
% The goodness of fit is evaluated by likelihood ratio where the degrees of
% friedom of the isotonic regression are given by the number of levels of the
% isotonic fit   - should be revisited because this is not quite right and
% the test should be explored
% For strictly monotonic regression find knots points
%  M. Pavel 07/15/2014

n = length(x);

if n <= 1
    y = x;
    stats = [];
    return
else
    x = x(:); % Convert to columns
end

[r c] = size(x);
if nargin<2
    wt = ones(r,c);
elseif length(wt) == 1  % Then wt is really xo
    xo = wt;
    wt = ones(r,c);
else
    wt = wt(:);
end

% Remove NaN from the data
ixn = find(isnan(x));
ix = find(~isnan(x));
wt = wt(ix);
x = x(ix);
% if (any(isnan(x)) | any(isnan(wt)))
%     error('Missing values are not allowed')
% end
if exist('xo')
    x = [xo; x];
    wt = [10*sum(wt); wt]; % increasing the weight of the starting poing
                            % Should be an input  variable in the weight 
end
xin = x; % store for computing statistics
lvlsets = 1:length(x);
while(1)
    vi = find(diff(x)<0);
    if (~any(vi))
        break
    end
    
    i = min(vi);
    lvl1 = lvlsets(i);
    lvl2 = lvlsets(i+1);
    ilvl = find((lvlsets == lvl1  | lvlsets == lvl2));
    x(ilvl) = sum(x(ilvl).*wt(ilvl)) / sum(wt(ilvl));
    lvlsets(ilvl) = lvl1;
end
if exist('xo')
    x = x(2:end); % remove the fixed starting point
    xin = xin(2:end);
    wt = wt(2:end);
end

if isempty(ixn) % No NaN in the input
y = x;
else
    y(ix) = x;
    y(ixn) = NaN;
end
% for strictly monotonic regression
%Find knots points
lvls = unique(lvlsets);

%plot(y); hold on; plot(xin);  % Debug
if nargout > 1
    mu = sum(x.*wt)/sum(wt);
    S1 = sum(wt.*(xin - x).^2);
    S0 = sum(wt.*(xin - mu).^2);
    LR = S0/S1;
    DF = length(lvls) - 1;   % DF(model) - DF(constant)
    stats(1) = LR;
    stats(2) = DF;
    stats(3)= chi2cdf(LR,DF,'upper');
end
end
