function output = count_origins(n,varargin)
% Find the number of 1- to n-colored origins in the n-network

    p = inputParser;
    p.CaseSensitive = 1;
    addRequired(p,'n',@(X) floor(X) == X & X >= 0); % number of K's
    p.parse(n);

    output = zeros(1,n);

    digits(100);

    for k = n:-1:1
        Phi = zeros(1,n + 1);
        Phi(1) = reversible_actions(n,0:k,[]);
        for j = 1:k
            Phi(1) = Phi(1) + (-1) ^ j * nchoosek(k,j) * reversible_actions(n,0:k-j,[]);
        end % Computes the number of k-colorings using exaclty k-colors

        for i = 1:k % Loop through number of actions for state to be reversible to
            Phi(i + 1) = reversible_actions(n,0:k,transpose(1:i));
            for j = 1:k % Loop through colors to be excluded from state
                colors_excluded = nchoosek(1:k,j);
                colors_included = arrayfun(@(X) setdiff(0:k,colors_excluded(X,:)),1:nchoosek(k,j),'UniformOutput',0);
                for l = 1:nchoosek(k,j)
                    Phi(i + 1) = vpa(Phi(i + 1) + (-1) ^ j * reversible_actions(n,colors_included{l},transpose(1:i)));
                end % Computes the number of k-colorings not reversibile to the actions 1 through i
            end
        end
        % Phi
        output_temp = Phi(1);
        for i = 1:k
            output_temp = vpa(output_temp + (-1) ^ i * nchoosek(k,i) * Phi(i + 1));
        end % Computes the number of k-colorings not reversible to any action
        output(k) = vpa(nchoosek(n,k) * output_temp); % Accounts for all ways of choosing k colors
        sprintf('%d-colored origins: %s',k,num2str(output(k),100))% Print output as string, from n down to 1
    end
end
