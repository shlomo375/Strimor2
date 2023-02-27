function [Point, ItsParentPoint] = SelectPointToScan(Param, Tree)
if rand(1)<0.5
    Prob = Tree.Scan(:,Param.Cost); %- min(Tree.Scan(:,Param.Cost))+2;
    
    Probability = (1./Prob).^8;
    Probability = Probability./sum(Probability);
    
    PointLocInScanList = randsrc(1,1,[1:numel(Probability);Probability']);
else

    [~,PointLocInScanList] = min(Tree.Scan(:,Param.Cost));
end

Point = Tree.Data(Tree.Data(:,Param.Ind) == Tree.Scan(PointLocInScanList,Param.Ind),:);

ItsParentPoint = Tree.Data(Tree.Data(:,Param.Ind) == Point(1,Param.PerentInd),:);


end
