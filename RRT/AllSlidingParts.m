function Parts = AllSlidingParts(WS)
% tic
for dir = 3:-1:1
    switch abs(dir)
        case 1
            R = WS.R1;
        case 2
            R = WS.R2;
        case 3
            R = WS.R3;     
    end
    %     find number of row is chosen dir
    tempInd = (R==1);
    R(R==0) = 1;
    Space = WS.Space.Status(R);
    R(R==1) = 0;
    R(tempInd) = 1;
    Space(R==0) = 0;    
    
    Config = Space(any(Space,2),any(Space));
    ShiftRow = find(any(Space,2),1)-1;
    ShiftCol = find(any(Space),1)-1;

    [row,col] = find(Config);
    try
    Comb = accumarray(row,col,[],@(x) {x});
    catch e
        e
        d=5;
    end
    func = @(x) accumarray(1+cumsum([0; (diff(x)~=1)]),x,[],@(y) {y});
    
    Comb = cellfun(func,Comb,'UniformOutput',false)';
    
    for Row = 1:size(Comb,2)
        Comb(Row) = {cellfun( ...
            @(Col) R(sub2ind(size(R),(ShiftRow+Row)*ones(size(Col)),ShiftCol+Col)), ...
            Comb{Row},'UniformOutput',false)};
    end
    Parts(dir) = {cat(1,Comb{:})};

end
end
