function [WS,tree, ParentInd, Finish] = FlatCompare(FlatConfig, WS,tree, ParentInd)
Finish = false;
% more that one group in the second row, more tham one module in the first
% group of the second row.
if ~(size(tree.Data(ParentInd,:).IsomorphismMatrices1{1},2) == 1 && abs(tree.Data(ParentInd,:).IsomorphismMatrices1{1}(2,1,1)) == 1)
    return
end

% Checking whether the sides of the baseline should be replaced with each
% other.
if tree.Data(ParentInd,:).IsomorphismMatrices1{1}(1,1,1) ~= FlatConfig.IsomorphismMatrices1{1}(1,1,1)

    [WS,tree, ParentInd] = SwitchGroupSides(WS,tree, ParentInd);
    return
end

if ~strcmp(tree.Data(ParentInd,:).ConfigStr, FlatConfig.ConfigStr)
    SpreadingDir = "Left";
    [TempWS,TempTree, TempParentInd] = SpreadAndReduce(WS,tree, ParentInd,SpreadingDir);
%     [TempWS,TempTree, TempParentInd] = SpreadingAllAtOnes(WS,tree, ParentInd, SpreadingDir);
    if ~strcmp(TempTree.Data(TempParentInd,:).ConfigStr, FlatConfig.ConfigStr)
        SpreadingDir = "Right";
        [WS,tree, ParentInd] = SpreadAndReduce(WS,tree, ParentInd,SpreadingDir);
%         [WS,tree, ParentInd] = SpreadingAllAtOnes(WS,tree, ParentInd, SpreadingDir); 
    else
        WS = TempWS;
        tree = TempTree;
        ParentInd = TempParentInd;
    end

end

if strcmp(tree.Data(ParentInd,:).ConfigStr, FlatConfig.ConfigStr)
    Finish = true;
end

end
