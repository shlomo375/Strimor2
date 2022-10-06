function Comb = OneRowCombination2Move(WS,dir)
t = tic ;   
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
Space = reshape([WS.Space(R).Status],size(R));
R(R==1) = 0;
R(tempInd) = 1;
Space(R==0) = 0;    

Config = Space(any(Space,2),any(Space));
ShiftConfig = find(any(Space,2),1)-1;


AgentInRow = sum(Config,2);
AgentInRow = permute(AgentInRow, [4 2 3 1]);
Comb = (1:max(AgentInRow)).*ones(max(AgentInRow),1,1,size(AgentInRow,4));
Comb = Comb + permute(0:max(AgentInRow),[1 3 2]);
Comb = tril(ones(size(Comb,[1 2]))).*Comb;

Comb(Comb>max(AgentInRow)) = 0;
Comb = num2cell(permute(Comb,[1 2 4 3]),[1 2 3]);
Comb = vertcat(Comb{:});

[HoleRow, HoleCol] = find(~Config);
Hole = num2cell(zeros(size(Config,1),1));
Hole(1:max(HoleRow)) = accumarray(HoleRow,HoleCol,[],@(x) {x});

for row = 1:size(Comb,3)
    logi = ismember(Comb(:,:,row),Hole{row});
    if row ~= 1
        logi(:,:,row) = logi;
        logi(:,:,1) = zeros(size(logi,[1 2]));
    end
    [Comb(logi)] = deal(0);
end
RelevantComb = logical(Comb);
Comb = Comb + find(any(Space),1) -1;
RowComb = ones(size(Comb,1:3)).*permute(find(any(Space,2)),[3 2 1]);
Comb = sub2ind(size(R),RowComb,Comb);
Comb = R(Comb);
Comb(~RelevantComb) = 0;
Comb = num2cell(Comb,[1 2]);

Comb = cellfun(@(x) num2cell(unique(x,'rows'),2),Comb,'UniformOutput', false);

Comb = reshape(Comb,[],sum(any(Space,2)));
Comb = cellfun(@(x) cellfun(@(y) y(y~=0),x,'UniformOutput',false),Comb,'UniformOutput',false);
toc(t);
end
