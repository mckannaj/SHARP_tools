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
function D = estimateDifficulty3(C,TD,D0)
    % % Check adjacency and difficulty matrices are square, same size
    N=size(C,1);
    assert(N==size(C,2),'Adjacency matrix has to be square');
    assert(N==size(TD,1)&&N==size(TD,2),...
        'Transtition matris must have the same dimensions as A');
    TD(isnan(TD)) = 0;      % Eliminate NaN
    C = C';   % Covert to transitions from col to row;
    TD = TD';
    % Assure that TD contains only the valid transitions from C
    % Compute vector of constants (summing delta difficulty for incoming
    % nodes
    S = TD*ones(N,1);   % Compute sum of all inputs to all nodes
    % Gain vector to normalize inputs
    G = C*ones(N,1);	% Number of parent nodes for each node
    ix = find(G==0);    % Find all starting nodes
    S(ix) = D0(ix);     % Initialize orphant nodes (starting)
    G(ix)= 1;           % Set the gain of orphant nodes to 1 (no incoming edges)
    G = 1./G;
    S = S.*G;
    GM = repmat(G,[1,N]);
    C = C.*GM;
    % Add initial conditions: Difficulty of starting nodes
    I = eye(N);
    %D = (I-C)\(S);     % If C has a full rank
    D = pinv(I-C)*S;
end



