function output = reversible_actions(n,q,r,varargin)
% Compute the number of states using colors in the set q which are
% reversible to words in r, for the n-network

    p = inputParser;
    p.CaseSensitive = 1;
    addRequired(p,'n',@(X) floor(X) == X & X >= 0); % number of K's
    p.parse(n);
    
    addRequired(p,'q',@(X) all(ismember(q,0:n))); % vector of colors to include
    addRequired(p,'r',@(X) all(cellfun(@(X)...
        all(ismember(X,1:n)),num2cell(r,2)))); % matrix of equal-length...
    % actions to which the state should be reversible; e.g., [1,2,3;2,3,1]
    % signifies reversibility to 123 and 231
    
    parse(p,n,q,r,varargin{:});
    
    A = cellfun(@(X) [X, 0],cellfun(@find,...
        num2cell(fliplr(arrayfun(...
        @str2num,dec2bin(1:2 ^ n - 1))),2),...
        'UniformOutput',false),'UniformOutput',false); % array of possible figures, no restrictions
    
    C = cellfun(@(X) intersect(X,q),A,'UniformOutput',false); % imposed restrictions on colors used
    
    B = A; % intermediate list of available states
    
    for i = 1:size(r,1) % loop through all "words"
        Atemp = A; % Compute restrictions relative to the original list of figures
        for j = 0:size(r,2) % loop through the "letters" of each word
            for k = j + 1:size(r,2) % loop through all letters following the jth
                if j > 0
                    Atemp = cellfun(@(X) setdiff(X,(find(ismember(X,r(i,k))) > 0) * r(i,j)),...
                        Atemp,'UniformOutput',false); ...
                        % remove color of previous action r(i,j) if figure contains
                    % the current action r(i,k), e.g., remove 1 if figure has a 2
                elseif j == 0
                    Atemp = cellfun(@(X) setdiff(X,(find(ismember(X,r(i,k))) > 0) * 0),...
                        Atemp,'UniformOutput',false); ...
                        % remove 0 from figures to be reversible to any of the
                    % actions
                end
            end
        end
        B = transpose(arrayfun(@(X) intersect(B{X},Atemp{X}),1:size(Atemp,1),...
            'UniformOutput',false)); % possible states remaining after each restriction has been applied
    end
    B = transpose(arrayfun(@(X) intersect(B{X},C{X}),1:size(C,1),...
        'UniformOutput',false)); % impose restrictions on colors used
    output = prod(cellfun(@length,B)); % calculate the total number of states remaining

end