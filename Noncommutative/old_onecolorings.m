function output = old_onecolorings(n,varargin)
    % find the number of 1-colorings spanning only n - 1 arms needed to
    % reach n-colorings, also an upper bound (* (n - 1)) for number of
    % not-strongly-connected 1-colorings in n - 1-network 
    p = inputParser;
    p.CaseSensitive = 1;
    addRequired(p,'n');
    
    parse(p,n,varargin{:});

    c = zeros(1,n - 1);

    for i = 5:n     
        B = find_origins3(i,'m',i - 1);
        % B = str2double(B{2}); % states reachable from below in n-network

        % c(i - 1) = (B - (connected_states_new(i) + ...
        %     sum(arrayfun(@(X) nchoosek(n,0) * c(n - X) * nchoosek(n - 1,X),2:n - 1))) * factorial(i)) ... 
        %     /  factorial(i); % new number of 1-colorings spanning i - 1 arms ...
        % needed in the n-network in order to reach n-colorings from below
        c(i - 1) = vpa(B /  factorial(i - 1) / (i - 1) - i * (connected_states_new(i) + ...
            sum(arrayfun(@(X) c(i - X) * nchoosek(i - 1,X),2:i - 1))) / (i - 1)) ... 
            ; % new number of 1-colorings spanning i - 1 arms ...
        % needed in the n-network in order to reach n-colorings from below
    end
    arrayfun(@(X) num2str(X,100),c,'UniformOutput',0)
    arrayfun(@(X) num2str(c(X) * nchoosek(n - 1,n - X),100),1:length(c),'UniformOutput',0)
    output = num2str(c(n - 1) * (n - 1),100); 

end

