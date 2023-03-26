function [WS,Tree, ParentInd] = RemoveModules(WS,Tree, ParentInd,ConfigShift,Line)
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1));

% GroupMatrix = GetGroupMatrixFromTree(Tree,ParentInd);
GroupsInLine = GroupsSizes(Line,GroupsSizes(Line,:)>0);
for GroupNum = 1:length(GroupsInLine)
    GroupInd = GroupsInds{Line}{GroupNum};
    BaseGroupsInds = GroupsInds{Line-1};
%     BaseGroupsCols = BaseGroupsInds{Line-1};
    
    [BaseGroupNum_1st, BaseGroupInd_1st] = GetBasedGroup(WS,GroupsInds{Line-1},GroupsInds{Line}{GroupNum});
    [BaseGroupNum_2nd, BaseGroupInd_2nd] = GetBasedGroup(WS,GroupsInds{Line-2},GroupsInds{Line-1}{BaseGroupNum_1st});
    
    
end
