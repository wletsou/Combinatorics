function output = k_from_above1(k,varargin)
% output a table of the number of k-colorings reachable from above from old
% one-colorings

    p = inputParser;
    p.CaseSensitive = 1;
    addRequired(p,'k',@(X) floor(X) == X & X >= 0); % k - coloring
    p.parse(k);

    addParameter(p,'n',k,@(X) floor(X) == X & X >= k); % number of states in network
    addParameter(p,'j',0,@(X) floor(X) == X); % 1-colorings reach n' = n - j-colorings in the n network
    
    parse(p,k,varargin{:});
    n = p.Results.n; % number of colors used in the n-network
    % j = p.Results.j; %
   
    digits(100)
    
    % j = p.Results.j; %
    % B = find_origins3(n - j,'m',k);
    % output = nchoosek(n, - j) * str2double(B{2});

    A = zeros(n);
    for r = 1:k
        for s = 0:n - r
            B = find_origins3(n - s,'m',r);
            A(r,n - s) = nchoosek(n,s) * B; % = A'_{1,j}^n(k)
        end
    end

    output = A;

end

