function [y stats] = misha_isorp(x,wt,xo)
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

x = double(x); % if x comes in as a "logical" this code won't work, so make sure it's a double
n = length(x);
% just for debugging...          fprintf('z got here 1\n');
if n <= 1
% just for debugging...          fprintf('z got here 2\n');
    y = x;
    stats = [];
    return
else
% just for debugging...          fprintf('z got here 3\n');
    x = x(:); % Convert to columns
end

[r c] = size(x);
if nargin<2
% just for debugging...          fprintf('z got here 4\n');
    wt = ones(r,c);
elseif length(wt) == 1  % Then wt is really xo
% just for debugging...          fprintf('z got here 5\n');
    xo = wt;
    wt = ones(r,c);
else
% just for debugging...          fprintf('z got here 6\n');
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
% just for debugging...          fprintf('z got here 7\n');
    x = [xo; x];
    wt = [10*sum(wt); wt]; % increasing the weight of the starting poing
                            % Should be an input  variable in the weight 
end
xin = x; % store for computing statistics
lvlsets = 1:length(x);

while(1)
% just for debugging...          fprintf('z got here 8\n');
    vi = find(diff(x)<0);
    if (~any(vi))
% just for debugging...          fprintf('z got here 9\n');
        break
    end
    
    iterator = min(vi);
    lvl1 = lvlsets(iterator);
    lvl2 = lvlsets(iterator+1);
    ilvl = find((lvlsets == lvl1  | lvlsets == lvl2)); 
%{ 
just for debugging...
    zTmp1 = x(ilvl); % same on first iteration (1;0)
    zTmp2 = wt(ilvl); % same on first iteration (1;1)
    zTmp3 = zTmp1 .* zTmp2; % same on first iteration (1;0)
    zTmp4 = sum(zTmp3); % same on first iteration (1)
    zTmp5 = sum(zTmp2); % same on first iteration (2)
    %ilvl  % (remains 8 9)
    %x(ilvl)   % (1;0, as it should be)
    x(ilvl) = zTmp4 / zTmp5; % NOT THE SAME ON FIRST ITERATION (turns out: x was a "logical") 
%}
    x(ilvl) = sum(x(ilvl) .* wt(ilvl)) / sum(wt(ilvl));
    lvlsets(ilvl) = lvl1; 
end

if exist('xo')
% just for debugging...          fprintf('z got here 10\n');
    x = x(2:end); % remove the fixed starting point
    xin = xin(2:end);
    wt = wt(2:end);
end

if isempty(ixn) % No NaN in the input
% just for debugging...          fprintf('z got here 11\n');
y = x;
else
% just for debugging...          fprintf('z got here 12\n');
    y(ix) = x;
    y(ixn) = NaN;
end
% for strictly monotonic regression
%Find knots points
lvls = unique(lvlsets);

%plot(y); hold on; plot(xin);  % Debug
if nargout > 1
% just for debugging...          fprintf('z got here 13\n');
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
