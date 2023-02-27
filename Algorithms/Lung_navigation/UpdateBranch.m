function TreeData = UpdateBranch(Param,Parent,TreeData)

while ~isempty(Parent)
    [ChildPointAxistInTree,ChildPointLocInTree] = ismember(TreeData(:,Param.PerentInd),Parent(:,Param.Ind)); 
    
    if any(ChildPointAxistInTree)
        ParentPathLength = Parent(ChildPointLocInTree(ChildPointAxistInTree),Param.PathLength);
        
        TreeData(ChildPointAxistInTree,Param.PathLength) = ParentPathLength + abs((TreeData(ChildPointAxistInTree,Param.Sub) - Parent(ChildPointLocInTree(ChildPointAxistInTree),Param.Sub))*ones(3,1));
        
        TreeData(ChildPointAxistInTree,Param.Cost) = TreeData(ChildPointAxistInTree,Param.PathLength) + Param.CostRatio .* TreeData(ChildPointAxistInTree,Param.TargetDis);

        Parent = TreeData(ChildPointAxistInTree,:);
    else
        break
    end
end
end
