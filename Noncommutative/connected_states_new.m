function output = connected_states_new(n,varargin)
% Compute the number of NEW connected 1-colorings in the n-network

    p = inputParser;
    p.CaseSensitive = 1;
    addRequired(p,'n',@(X) floor(X) == X & X >= 0); % number of K's
    p.parse(n);

    addParameter(p,'m',n,@(X) floor(X) == X & X <= n); % number of colors in origin
    
    parse(p,n,varargin{:});
    m = p.Results.m; % 1-colorings should span at least m arms

    digits(100);

    subtotal = connected_states(n);
    for i = (m - 1):-1:1
        subtotal = vpa(subtotal + (-1) ^ (m - i) * nchoosek(n - 1,n - i) * connected_states(i));
        % subtotal = subtotal - connected_states(i);
    end

    output = subtotal;
end
