function [WS,Tree, ParentInd] = RemoveModules(WS,Tree, ParentInd,ConfigShift,Line)
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1));
TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};
% GroupMatrix = GetGroupMatrixFromTree(Tree,ParentInd);
GroupsInLine = GroupsSizes(Line,GroupsSizes(Line,:)>0);
for GroupNum = 1:length(GroupsInLine)
    TopGroupInd = GroupsInds{Line}{GroupNum};

    
    [AlphaDiff, BetaDiff] = GetGroupConfigDiff(GroupsSizes,TargetGroupSize);
    Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
    
    [BaseGroupNum_1st, BaseGroupInd_1st] = GetBasedGroup(WS,GroupsInds{Line-1},TopGroupInd);
    [BaseGroupNum_2nd, BaseGroupInd_2nd] = GetBasedGroup(WS,GroupsInds{Line-2},GroupsInds{Line-1}{BaseGroupNum_1st});

    LineSteps = Get_Step_To_Remove_Module(Edges(Line-2:Line),GroupNum,BaseGroupNum_1st,BaseGroupNum_2nd,"Left");
    
    
    %% movment process
    % move top Group
    [OK, NewWS, Newtree, NewParentInd, GroupsInds{Line}{GroupNum}] =...
            ManeuverStepProcess(WS,tree,ParentInd,GroupsInds{Line}{GroupNum}, 1, LineSteps(3));
        
    if ~ OK
        return
    end
    
    MidGroupInd = [TopGroupInd, GroupsInds{Line-1}{BaseGroupNum_1st}];
    % move mid Group
    [OK, NewWS, Newtree, NewParentInd, GroupsInds{Line}{GroupNum}] =...
            ManeuverStepProcess(WS,tree,ParentInd,GroupsInds{Line}{GroupNum}, 1, LineSteps(3));
        
    if ~ OK
        return
    end

end
