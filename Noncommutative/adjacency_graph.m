function output = adjacency_graph(n,varargin)

    p = inputParser; 
    p.CaseSensitive = 1;
    addRequired(p,'n');
    addParameter(p,'save',false,@islogical)
    parse(p,n,varargin{:});

    save = p.Results.save;

    % generate actions K's and P's
    A = arrayfun(@str2num,dec2bin(1:2 ^ n - 1));
    [~,I] = sort(sum(A,2));
    A = transpose(A(I,:));
    
    B = mat2cell(A,size(A,1),ones(1,size(A,2)));
    J = cell2mat(cellfun(@(X) size(X,1) + 1 - find(X,1,'last'),B,'UniformOutput',0));
    for i = 1:n
        B = A(:,sum(A,1) == i);
        x = J(sum(A,1) == i);
        [~,x] = sort(x);
        B = B(:,x);
        A(:,sum(A,1) == i) = B;
    end
    A = cat(1,A,ones(1,size(A,2)));
    A = cat(2,A,cat(1,ones(size(A,1) - 1,1),1));
    
    [row,col] = size(A);
    ind = repmat(transpose(row - 1:-1:0),[1,col]);
    
    K = (A ./ A) .* ind;
    K(isnan(K)) = 0;
    K(end,:) = 0;
    K(:,end) = []; % delete first column of all 0's
    % K(n - d + 1,:) = []; % delete Kd
    
    P = zeros(size(A));
    P(A == 1) = -A(A == 1);
    P = P .* ind;
    P(end,:) = 0;
    P(:,end) = []; % delete first column of all 0's
    % P(n - d + 1,:) = []; % delete Pd
    
    M = cat(3,K,P);

    A = zeros([1,2 ^ n - 1]); % initial state
    [~,col] = size(A);
    Anew = A;

    operation = {@Kmat, @Pmat, @Kmatw, @Pmatw};
    % statel = zeros([1,col]);
    statel = Anew; % 
    wordsnew = zeros([size(statel,1),2 * col + 1]);
    
    i = 0;
    while ~isempty(Anew)
        i = i + 1;
        disp(i);
        g = @(myfunction) myfunction(statel,M,col);
        result = cellfun(g,operation,'UniformOutput',0);
        
        
        letters = cell2mat({vertcat((result{1,3}),(result{1,4}))}); % joins a column of the last completed action to results
        result = {vertcat((result{1,1}),(result{1,2}))}; % results of applying all actions
    
        [~,iresult] = setdiff(letters(:,1:col),A,'rows','stable'); % positions of new states
    
        words = letters(iresult,col + 1:end); % words that accomplish the new states
        h = @(X)unique(X,'rows','stable');
        result = cellfun(h,result,'UniformOutput',0);
        f = @(X)setdiff(X,A,'rows','stable');
        result = cellfun(f,result,'UniformOutput',0);
    
        Anew = unique(cell2mat(result),'rows','stable');
        A = vertcat(A,Anew);
    
        state = Anew;
        statel = horzcat(state,words); % reached states with words reaching them adjoined
    
        wordsnew_temp = padarray(statel(:,col+1:end),[0, 2 * col + 1 - size(statel(:,col + 1:end),2)],'post');
        wordsnew = vertcat(wordsnew,wordsnew_temp);
    
    end

    
    colors = cell2mat((arrayfun(@(X) (length(setdiff(A(X,:),0)) == 1) * [1,0,0] +...
        (1 - (length(setdiff(A(X,:),0)) == 1)) * [0,0,1],1:size(A,1),'UniformOutput',false))');...
        % color states that are 1-colorings
    sizes = arrayfun(@(X) (length(setdiff(A(X,:),0)) == 1) * 6 +...
        (1 - (length(setdiff(A(X,:),0)) == 1)) * 2,1:size(A,1));...
        % make 1-colorings larger
    names = (arrayfun(@(X) num2str(A(X,:)),1:size(A,1),'UniformOutput',false));
    names(sizes == 2) = {''};
    names = (arrayfun(@(X) '',1:size(A,1),'UniformOutput',false));
 

    % Apply all K actions to each row of A
    M1 = M(:,:,1);
    row2 = size(M1,1);
    A1 = sortrows(repmat(A,[row2,1])); % duplicates rows
    row1 = size(A1,1);
    K = repmat(M1,[row1 / row2,1]);
    V1 = A1 + K;
    V1(A1 ~= 0) = A1(A1 ~= 0);

    % Apply all K actions to each row of A
    M2 = M(:,:,2);
    row2 = size(M2,1);
    A1 = sortrows(repmat(A,[row2,1]));
    row1 = size(A1,1);
    P = repmat(M2,[row1 / row2,1]);
    V2 = A1 + P;
    V2(V2 ~= 0) = A1(V2 ~= 0);

    A1 = repmat(sortrows(repmat(A,[row2,1])),[2,1]); % duplicated matrix before actions were applied
    A2 = cat(1,V1,V2); % result of applying all K's and all P's to A1

    A3 = A2(1:row1,:); % only the first half of the result
    V3 = A3 + P;
    V3(V3 ~= 0) = A3(V3 ~= 0); % apply P's to states that were reached from K
    

    A4 = A2(row1 + 1:2 * row1,:); % only the second half of the result
    V4 = A4 + K;
    V4(A4 ~= 0) = A4(A4 ~= 0); % apply K's to states that were reached from P

    A5 = cat(1,V3,V4); % result of applying all P's and all K's to A2
    
    reversible = arrayfun(@(X) all(A5(X,:) == A1(X,:)),1:size(A1,1) ); ...
        % indicates which sequences of Ki,Pi and Pi,Ki were reversible
 
    [~,ind1] = ismember(A1(reversible,:),A,'rows'); % positions of starting states in list
    [~,ind2] = ismember(A2(reversible,:),A,'rows'); % positions of end states in list
    



    G = graph(sparse(ind1,ind2,ones(size(ind1))) - 2 * speye(size(A,1))); % graph (with no self edges) from adjacency matrix
    [bins,binsize] = conncomp(G); % connected components

    figs = findobj('Type','Figure');
    if ~isempty(figs)
        ord = cell2mat({figs.Number});
        [~,ind] = sort(ord);
        figs = figs(ind);
    end
    figidx = 1;

    if figidx > length(figs)
        figure
    else
        set(0,'CurrentFigure',figs(figidx))
        figidx = figidx + 1;
    end

    plot(G,'NodeColor',colors,'MarkerSize',sizes,'NodeLabel',names,'Layout','auto')
    set(gca,"DataAspectRatio",[1,1,1])
    axis off
    if save
        print(gcf,'-dpng',sprintf('AdjacencyGraph_%d.png',n),'-r300')
    end
    

    % graph of largest connected component
    if figidx > length(figs)
        figure
    else
        set(0,'CurrentFigure',figs(figidx))
    end
    idx = binsize(bins) == max(binsize);
    SG = subgraph(G, idx);
    plot(SG) 
    set(gca,"DataAspectRatio",[1,1,1])

    
    

end


function V = Kmat(statel,M,col)
    M = M(:,:,1);
    row2 = size(M,1);
    state = statel(:,1:col);
    A = sortrows(repmat(state,[row2,1]));
    row1 = size(A,1);
    K = repmat(M,[row1 / row2,1]);
    V = A + K;
    V(A ~= 0) = A(A ~= 0);
end

function Kmatw = Kmatw(statel,M,col)
    M8 = M(:,col,1);
    M = M(:,:,1);
    [row2, ~] = size(M);
    A = sortrows(repmat(statel,[row2,1]));
    [row1,col1] = size(A);
    L = zeros([row2,col1 - col],class(A));
    M = horzcat(M,L);
    K = repmat(M,[row1 / row2,1]);
    V = (A + K);
    V(A ~= 0) = A(A ~= 0);
    % if row1/row2<40
    %     unique(V,'rows')
    %     size(unique(V,'rows'))
    % end
    Kmatw = horzcat(V,repmat(M8,[row1 / row2,1]));
end


function V = Pmat(statel,M,col)
    M = M(:,:,2);
    row2 = size(M,1);
    state = statel(:,1:col);
    A = sortrows(repmat(state,[row2,1]));
    row1 = size(A,1);
    P = repmat(M,[row1 / row2,1]);
    V = A + P;
    V(V ~= 0) = A(V ~= 0);
end

function Pmatw = Pmatw(statel,M,col)
    M8 = M(:,end,1);
    M = M(:,:,2);
    [row2, ~] = size(M);
    A = sortrows(repmat(statel,[row2,1]));
    [row1,col1] = size(A);
    L = zeros([row2,col1-col],class(A));
    M = horzcat(M,L);
    P = repmat(M,[row1/row2,1]);
    V = (A + P);
    V(V ~= 0) = A(V ~= 0);
    % if row1/row2<40
    %     unique(V,'rows','stable')
    %     size(unique(V,'rows','stable'))
    % end
    Pmatw = horzcat(V,-repmat(M8,[row1/row2,1]));
end