function [WS,tree, ParentInd] = SpreadAndReduce(WS,tree, ParentInd,SpreadingDir)

arguments
    WS
    tree
    ParentInd
    SpreadingDir (1,1) {mustBeTextScalar,matches(SpreadingDir,["Left","Right","Left_Right","Right_Left"])} = "Left_Right";
end

[~,~, GroupsInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
row = numel(GroupsInd);
while row > 1
% for row = numel(GroupsInd):-1:2
    
%     if strcmp(SpreadingDir,"Left")
%         ColNum = 1:numel(GroupsInd{row});
%     else
%         ColNum = numel(GroupsInd{row}):-1:1;
%     end
    OldWS = WS;
    
    for col = 1:numel(GroupsInd{row})
%         if col==1 & row == 2
%             d=5
%         end
        switch SpreadingDir
            case "Left"
                [WS,tree, ParentInd, GroupsInd] = SpreadAndReduce_SingleGroup(WS, ...
                    tree, ParentInd, ...
                    GroupsInd, ...
                    [row,col], ...
                    "Left");
            case "Right"
                [WS,tree, ParentInd, GroupsInd] = SpreadAndReduce_SingleGroup(WS, ...
                    tree, ParentInd, ...
                    GroupsInd, ...
                    [row,col], ...
                "Right");
            case "Left_Right"
                [WS,tree, ParentInd, GroupsInd] = SpreadAndReduce_SingleGroup(WS, ...
                    tree, ParentInd, ...
                    GroupsInd, ...
                    [row,col], ...
                    "Left");
                [WS,tree, ParentInd, GroupsInd] = SpreadAndReduce_SingleGroup(WS, ...
                    tree, ParentInd, ...
                    GroupsInd, ...
                    [row,col], ...
                    "Right");
            case "Right_Left"
                [WS,tree, ParentInd, GroupsInd] = SpreadAndReduce_SingleGroup(WS, ...
                    tree, ParentInd, ...
                    GroupsInd, ...
                    [row,col], ...
                    "Right");
                [WS,tree, ParentInd, GroupsInd] = SpreadAndReduce_SingleGroup(WS, ...
                    tree, ParentInd, ...
                    GroupsInd, ...
                    [row,col], ...
                    "Left");
        end
        
    end
    if isequal(OldWS,WS)
        row = row-1;
    end
end

end



function [WS,tree, ParentInd, GroupsIndexes] = SpreadAndReduce_SingleGroup(WS,tree, ParentInd,GroupsIndexes,GroupSubLoc, SpreadingDir)
% Output_WS.Space.Status = [];
OnlySpread = true;
while OnlySpread%isequal(logical(Output_WS.Space.Status),logical(WS.Space.Status))
    try
    OneModuleInd = GroupsIndexes{GroupSubLoc(1)}{GroupSubLoc(2)}(1);
    [MoveingModules, Max_Step, ReduceModuleInd, ReduceAxis] = Get_BranchModuleInd(WS,GroupsIndexes,OneModuleInd,GroupSubLoc(1),"BRANCH_MAX_STEP_REDUCE",Dir=SpreadingDir);
    catch me2
        me2
    end

    if isempty(ReduceModuleInd) && ~Max_Step
        return
    end
    
    Step = Max_Step;
    OK_Reduce = false;
    OnlySpread = false;
    while ~OK_Reduce
    
        Axis = 1;
        [OK_Spread, TempWS, Temptree, TempParentInd, TempMoveingModules] =...
        ManeuverStepProcess(WS,tree,ParentInd,MoveingModules, Axis, Step);
        
        if ~OK_Spread
            Step = (abs(Step) - 1)*sign(Step);
            continue
        else
            if ~OnlySpread
                OnlySpread = true;
                Spread_WS = TempWS;
                Spread_tree = Temptree;
                Spread_ParentInd = TempParentInd;
            end
        end
        
        NewReduceModuleInd = UpdateLinearIndex(WS.SpaceSize,ReduceModuleInd,1,Step-Max_Step);
        RelevantModuleInd = NewReduceModuleInd(ismember(NewReduceModuleInd,ReduceModuleInd));
        if ~isempty(RelevantModuleInd)
            [OK_Reduce, TempWS, Temptree, TempParentInd, TempMoveingModules] =...
            ManeuverStepProcess(TempWS,Temptree,TempParentInd,RelevantModuleInd, ReduceAxis, (ReduceAxis==2)-1*(ReduceAxis==3));
            
            if ~OK_Reduce
                if ~Step
                    break
                else
                    Step = (abs(Step) - 1)*sign(Step);
                    continue
                end
            end
        else
            break
        end
        
    end
    
    if OK_Reduce 
        WS = TempWS;
        tree = Temptree;
        ParentInd = TempParentInd;
    else
        WS = Spread_WS;
        tree = Spread_tree;
        ParentInd = Spread_ParentInd;
        if ~Step
            [~,~, GroupsIndexes] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
            break
        end
    end
    [~,~, GroupsIndexes] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
end

% PlotWorkSpace(WS,[],[]);
end
