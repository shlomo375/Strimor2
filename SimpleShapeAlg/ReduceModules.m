function [WS,Tree, ParentInd,ConfigShift,ModuleTransitionData_Table] = ReduceModules(WS,Tree, ParentInd,ConfigShift, Line, Downwards,ModuleTransitionData_Table)
ModuleTransitionData = ModuleTransitionData_Table(end,:);

Line = max(ModuleTransitionData{1,["Current_Line","Current_Line_Alpha","Current_Line_Beta"]});


%%
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1),ModuleTransitionData.Downwards);
TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};

if Line < numel(GroupsInds) && GroupsSizes(Line+1)
    Edges = Get_GroupEdges(GroupsSizes(Line-2:Line+1),GroupIndexes(Line-2:Line+1),GroupsInds(Line-2:Line+1));
else
    Edges = Get_GroupEdges(GroupsSizes(Line-2:Line),GroupIndexes(Line-2:Line),GroupsInds(Line-2:Line));
end

[Decision, Direction] = SelectReduceManeuver(Edges);
% [Decision, Direction] = RemoveModule_ActionSelection(GroupsSizes(Line), Edges);

%%
if Line == numel(GroupsInds) || ~GroupsSizes(Line+1)
    Top_GroupInd = [];
else
    Top_GroupInd = GroupsInds{Line+1}{1};
end
Mid_GroupInd = GroupsInds{Line}{1};
Buttom_GroupInd = GroupsInds{Line-1}{1};

%%
switch ModuleTransitionData.Side
    case "Left" % Moving one specific module from a certain side
        [Step, Axis, AllModuleInd, Moving_Log,ReducedModuleNum] = ComputeManuver(Decision{1}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(1),ModuleTransitionData.Downwards);
        ModuleTransitionData.Side = ModuleTransitionData.Side;
        Decision = func2str(Decision{1});
    case "Right"
        [Step, Axis, AllModuleInd, Moving_Log,ReducedModuleNum] = ComputeManuver(Decision{2}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(2),ModuleTransitionData.Downwards);
        ModuleTransitionData.Side = ModuleTransitionData.Side;
        Decision = func2str(Decision{2});
    otherwise
        [Step{2}, Axis{2}, AllModuleInd{2}, Moving_Log{2}] = ComputeManuver(Decision{2}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(2),ModuleTransitionData.Downwards);
        [Step{1}, Axis{1}, AllModuleInd{1}, Moving_Log{1}] = ComputeManuver(Decision{1}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(1),ModuleTransitionData.Downwards);
        
        [Step, Axis,AllModuleInd, Moving_Log,ModuleTransitionData.Side,Decision, ReducedModuleNum] = DirectionCostSelection(Step, Axis,AllModuleInd, Moving_Log,Direction,Decision);
end


[Moving_Log,AllModuleInd] = AddAboveModule(Line+1,AllModuleInd,GroupsInds,Step,Axis, Moving_Log, ModuleTransitionData.Downwards);
PlotStep = false;
[WS, Tree, ParentInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",true);

 
ModuleTransitionData = Update_CurrentLine_Of_ModuleReduced(ModuleTransitionData,Decision);
ModuleTransitionData = FinishTask(ModuleTransitionData);


ModuleTransitionData_Table(end,:) = ModuleTransitionData;
% if ReducedModuleNum == 1 && ~ModuleTransitionData.Sequence && ~ModuleTransitionData.DestenationLine
%     ModuleTransitionData = CreatTaskAllocationTable(ModuleTransitionData,"Current_Line",Line,"Side",Direction,"Downwards",Downwards,"Module_Num",ReducedModuleNum,"Finish",Finish,"Sequence",true);
% else
%     ModuleTransitionData = CreatTaskAllocationTable(ModuleTransitionData,"Current_Line",Line-Downwards+(~Downwards),"Side",Direction,"Module_Num",ReducedModuleNum,"Finish",Finish);
% end
end

function ModuleTransitionData = Update_CurrentLine_Of_ModuleReduced(ModuleTransitionData,Decision)

switch Decision
    case "Alpha_Alpha"
        ModuleTransitionData.Current_Line = ModuleTransitionData.Current_Line - 1;
        ModuleTransitionData.Current_Line_Alpha = ModuleTransitionData.Current_Line_Alpha - 1;
        ModuleTransitionData.Current_Line_Beta = ModuleTransitionData.Current_Line_Beta - 1;
    case "Alpha_Beta"
        ModuleTransitionData.Current_Line_Alpha = ModuleTransitionData.Current_Line_Alpha - 1;
    case "Beta_Alpha"
        ModuleTransitionData.Current_Line_Beta = ModuleTransitionData.Current_Line_Beta - 1;
    case "Beta_Beta"
        ModuleTransitionData.Current_Line = ModuleTransitionData.Current_Line - 1;
        ModuleTransitionData.Current_Line_Alpha = ModuleTransitionData.Current_Line_Alpha - 1;
        ModuleTransitionData.Current_Line_Beta = ModuleTransitionData.Current_Line_Beta - 1;

end

end