function GroupMatrix = GetGroupMatrixFromTree(Tree,Ind)

GroupMatrix = Tree.Data{Ind,"IsomorphismMatrices1"}{1}(:,:,1);

end
