%  function  D = estimateDifficulty3(C,TD,D0)
%  Estimates difficulty of each cluster (node) 
% Inputs
%  C is a square matrix of connections from row i to col j  (d_row > d_col)
%  TD is a matrix of the transition edge values in difficulty increase 
%  (deltas from i to j, i.e., d(j) - d(i)
%  D0 a row vector with initial difficulty  of each starting node
% Method
%  Solve set of linear equations of the form $$D = C*D + TD*I$$
% 
function D = estimateDifficulty5(C,TD,D0,Nrc)
    % % Check adjacency and difficulty matrices are square, same size
    N=size(C,1);
    assert(N==size(C,2),'Adjacency matrix has to be square');
    assert(N==size(TD,1)&&N==size(TD,2),...
        'Transtition matrix must have the same dimensions as A');
    TD(isnan(TD)) = 0;      % Eliminate NaN
    C = C';   % Covert to transitions from col to row
    TD = TD';
    
    % z addition 12/19/15: normalize estimates by the number of observations of that transition 
    W = zeros(N, N); % this will become the weighting matrix
    Nrc = Nrc';
    Nrc = Nrc .* C; % make sure we're only weighting transitions that we'll actually use (all others, e.g. diagonals, should be 0)
    for r = 1:length(Nrc) % this can probably be done by matrix multiplication rather than a loop - figure it out 
        rowSum = sum(Nrc(r,1:end)); % total number of transitions to this 
        for c = 1:length(Nrc) % this can probably be done by matrix multiplication rather than a loop - figure it out 
            W(r,c) = (Nrc(r,c) / rowSum); % weight each transition
        end
    end
    W(isnan(W)) = 0; % Any orphaned nodes with have NaNs here; remove them
    
    % Assure that TD contains only the valid transitions from C
    % Compute vector of constants (summing delta difficulty for incoming
    % nodes
    S = (TD.*W) * ones(N,1);   % First weight all transition observations, then sum all inputs to each node
    % Gain vector to normalize inputs (now used only to initialize orphan nodes) 
    G = C*ones(N,1);	% Number of parent nodes for each node
    ix = find(G==0);    % Find all starting nodes
    S(ix) = D0(ix);     % Initialize orphan nodes (starting)

    C = C .* W; % weight the connectivity matrix as well as transitions
    % Add initial conditions: Difficulty of starting nodes
    I = eye(N);
    %D = (I-C)\(S);     % If C has a full rank
    D = pinv(I-C)*S; % Z: we should type out the algebra to get here; right now it's just on paper
end



