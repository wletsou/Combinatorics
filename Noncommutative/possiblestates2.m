function output = possiblestates2(n,varargin)
% Generate the connected 1-colorings of each color (1,..,n)

p = inputParser;
p.CaseSensitive = 1;
addRequired(p,'n'); 

parse(p,n,varargin{:});

A = arrayfun(@str2num,dec2bin((0:2 ^ (2 ^ (n - 1) - 1) - 1) + 2 ^ (2 ^ (n - 1) - 1))); % 8-15 for n = 3
A; % 8-15 in binary

i = 0;
for k = 3:n % loop run one time only with k = 3
    B = nchoosek(1:n,k);
    B = B(B(:,1) == 1,:); % B has only one combination: [1 2 3]
    for j = 1:size(B,1) % loop run one time only with j = 1
        i = i + 1;
        C = nchoosek(B(j,:),2); % C has three combinations: [1 2], [1 3], [2 3]
        %C(C(:,1) == 1,2)'
        A_temp = A(sum(A(:,C(C(:,1) == 1,2)'),2) == 0 & A(:,1 + nchoosek(n - 1,2 - 1) + i) == 1,:); % A_temp is [1 0 0 1]
        A = setdiff(A,A_temp,'rows'); % removes [1 0 0 1] row from A.

    end

end
% output = A; % uncomment to list only 1-colorings of 1
A; % A has 7 elements: [1 0 0 0; 1 0 1 0; 1 0 1 1; 1 1 0 0; 1 1 0 1; 1 1 1 0; 1 1 1 1]

E = [];

for k = 1:n % loop runs three times with k = 1, 2, 3
    i = 0;
    ind = [];
    E_temp = zeros(size(A,1),2 ^ n - 1); % 7 by 7 matrix with all zeros 
    for j = 1:n % loop runs three times with j = 1, 2, 3
        F = nchoosek(1:n,j);
        ind = cat(2,ind,find(sum(F == k,2))' + i);
        i = i + nchoosek(n,j);
    end
    E_temp(:,ind) = A * k ;
    E = cat(1,E,E_temp);
end

output = E;