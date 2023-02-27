function Tree = UpdateTree(Param, Tree,Point, NewPoints)
Tree.Data(Tree.Data(:,Param.Ind) == Point(1,Param.Ind),:) = Point;

[PointAxistInTree,PointLocInTree] = ismember(NewPoints(:,Param.Ind),Tree.Data(:,Param.Ind)); 

if any(PointAxistInTree)
    PointsCost = NewPoints(PointAxistInTree,Param.Cost);
    
    TreeLoc = nonzeros(PointLocInTree(PointAxistInTree));
    TreeCost = Tree.Data(TreeLoc,Param.Cost);
    UpdateCost = PointsCost < TreeCost;
    if any(UpdateCost)
        PointToUpdateLoc = find(PointAxistInTree);
        Tree.Data(TreeLoc(UpdateCost),Param.Cost) = NewPoints(PointToUpdateLoc(UpdateCost),Param.Cost);
        
        UpdateBranch(Param,NewPoints(PointToUpdateLoc(UpdateCost),:),Tree.Data);
    end
end

Tree.Data(Tree.LastIndex+1:Tree.LastIndex+sum(~PointAxistInTree),:) = NewPoints(~PointAxistInTree,:);

Tree.LastIndex = Tree.LastIndex+sum(~PointAxistInTree);



end
