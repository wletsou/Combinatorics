function output = find_origins3(n,varargin)
    % Find the number of n-colored (or m < n-colored) origins that can reach 1-colored states
    % by reversible actions; subtract from the answer n * (n - 1)! * (the
    % number of unallowed 1-colorings) to get the convergence of allowed
    % 1-colorings

    p = inputParser;
    p.CaseSensitive = 1;
    addRequired(p,'n',@(X) floor(X) == X & X >= 0); % number of K's
    p.parse(n);

    addParameter(p,'m',n,@(X) floor(X) == X & X <= n); % number of colors in origin
    % addParameter(p,'l',n - 1,@(X) floor(X) == X & X <= n);...
        % number of consecutive steps to which the origin should not be
    % reversible

    digits(100);
    
    parse(p,n,varargin{:});
    m = p.Results.m; % number of colors used in the n-network
    % l = p.Results.l;
    l = m - 1; % length of sequence from an m-coloring to a 1-coloring

    total = vpa(reversible_actions(n,0:m,[]));
    
    % Compute total number of states w/ a 0 using exactly m colors
    for i = 1:m
        colors_excluded = nchoosek(1:m,i);
        for j = 1:nchoosek(m,i)
            total = vpa(total + (-1) ^ i * reversible_actions(n,setdiff(0:m,colors_excluded(j,:)),[]));
        end
    end

    % l = n - 1; % length of action
    Actions = nchoosek(1:m,l);

    subtotal = vpa((reversible_actions(n,0:m,Actions(1,:)) ...
        - reversible_actions(n,0:(m - 1),Actions(1,:))) ...
        * nchoosek(nchoosek(m,m - 1),1) * factorial(m - 1)); ...
        % all ways of being reversible to one sequence of length m - 1

    for k = 2:m
        if k == 2
            for j = 1:l
                B = [repmat(1:l - j,[2,1]),[l - j + 1:m - 1;l - j + 2:m]]; ...
                    % protypical two-row matrix sharing the first l - j
                % letters
                subtotal = vpa(subtotal + (-1) ^ (k - 1) * ...
                    (j * factorial(m) - nchoosek(m,m - 2) * factorial(m - 2) ) ...
                    * reversible_actions(n,0:m,B)); ...
                    % all k-by-l matrices of actions whose first j columns
                % are the same give a characteristic number of reversible
                % states.  There j * m! ways to create subch matrices, but
                % m-choose-2 * (m - 2)! of them result in redundant
                % permutations
            end
        else
            subtotal = vpa(subtotal + (-1) ^ (k - 1) * ...
                nchoosek(m,k) * factorial(m) * reversible_actions(n,0:m,Actions(1:k,:))); ...
                % for k > 2, each unique matrix of actions results in the
            % same number of reversible states

        end
    end

    % output = subtotal;  % number of n-colored states that can reversibly reach 1-colorings
    if m == 1 && n > 1
        % subtotal = reversible_actions(n,0:m,[]); % all 1-colorings are by definition able to reach a 1-coloring
        subtotal = vpa(total);
    end
    output = nchoosek(n,m) * ...
        (subtotal - nchoosek(m,1) * factorial(m - 1) * (2 ^ (2 ^ (n - 1)) - 1 - connected_states(n)));
    % output = {num2str(subtotal,100),...
    %     num2str(nchoosek(n,m) * ...
    %     (subtotal - nchoosek(m,1) * factorial(m - 1) * (2 ^ (2 ^ (n - 1)) - 1 - connected_states(n))),100)};
    % Print also the convergence of 1-colorings onto m-colorings
end


