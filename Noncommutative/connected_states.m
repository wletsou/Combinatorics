function output = connected_states(n,varargin)
% Compute the number of connected 1-colorings in the n-network

    p = inputParser;
    p.CaseSensitive = 1;
    addRequired(p,'n',@(X) floor(X) == X & X >= 0); % number of K's
    p.parse(n);

    digits(100);

    subtotal = 0;
    for m = 2:(n - 1)
        A = 0;
        B = 0;
        for k = 2:m
            A = A + nchoosek(m,k);
        end
        for k = 2:(n - 1)
            B = B + nchoosek(n - 1,k);
        end
        subtotal = vpa(subtotal + nchoosek(n - 1,m) * (2 ^ A - 1) * 2 ^ (B - A)); % number of unallowed 1-colorings
    end
    
    output = vpa(2 ^ (2 ^ (n - 1) - 1) - subtotal);
end