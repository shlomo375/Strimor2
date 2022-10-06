function [Tree, ind] = SaveNode(Node, Tree, ind, FileName)
%     [] = CheckIfConfigExistConfig(Node);
    if ind >= 100000
        Tree = SaveTree(FileName, Tree);
        ind = 2;
    end
    Tree(ind) = Node;
    ind = ind +1;
end
