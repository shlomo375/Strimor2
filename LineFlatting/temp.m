function temp(WS,LeftGroupRightInd)
[Row,~] = find(WS.R2 == LeftGroupRightInd,1);
LeftFrontLineInd = WS.R2(Row,:);
LeftFrontLineInd(LeftFrontLineInd==0) =[];
LeftFrontLineInd(WS.Space.Status(LeftFrontLineInd)==0) = [];

% q =cellfun(@(x) find(x{1}==4650,1),GroupInd2,'UniformOutput',false)
% a = cell2mat(q)
end
