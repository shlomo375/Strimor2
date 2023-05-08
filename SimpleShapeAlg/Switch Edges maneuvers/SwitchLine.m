function [WS,Tree, ParentInd,ConfigShift,Task_Queue] = SwitchLine(   WS, Tree, ParentInd, ConfigShift, Task_Queue,Plot)

arguments
    WS
    Tree
    ParentInd
    ConfigShift
    Task_Queue
    Plot = false;
end
Task = Task_Queue(end,:);
try

[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1),Task.Downwards);
TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};

Line = Task.Current_Line;

FirstConfigLine = find(GroupsSizes,1,"first");

if Line ~= FirstConfigLine
    Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
    Task_Queue = MiddleLineSwitch(GroupsSizes, TargetGroupSize, Task.Downwards, Line,Edges,WS,ConfigShift,Task_Queue);
    return
else
    
end

    
[Decision, Direction] = CheapRemoveManeuver(Edges,abs(GroupsSizes(Line)));


try
if matches(func2str(Decision),["Alpha_Alpha_Alpha__1","Beta_Beta_Beta__3"])
    Task_Queue(end+1,:) = Decision(WS,GroupsSizes,Tree.EndConfig.IsomorphismMatrices1{:,:,1},ConfigShift,Task.Downwards, Line);
    return
end

Top_GroupInd = GroupsInds{Line}{1};
Mid_GroupInd = GroupsInds{Line-1}{1};
Buttom_GroupInd = GroupsInds{Line-2}{1};

[Step, Axis, AllModuleInd, Moving_Log, NewTask] = ComputeManuver(Decision, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction,Task,Tree);

if size(NewTask,1)
    Task_Queue(end+1,:) = NewTask;
    return
end

[WS, Tree, ParentInd , OK] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",Plot);

if OK
    if Task.Downwards
        ConfigShift(2,1) = ConfigShift(2,1) + 1;

    else
        ConfigShift(1,1) = ConfigShift(1,1) + 1;
        
    end
    if Task.Downwards
        Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},[0;1]);
    else
        Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},[1;0]);
    end
    Task_Queue(end,:) = [];
else
    error("bad manuvers");
end
catch eer
    eer
end

% ModuleTransitionData_Table = FinishTask(ModuleTransitionData_Table);
% Finish = CheckFinished(ModuleTransitionData_Table,Line-Downwards+(~Downwards), numel(Top_GroupInd), GroupsSizes, TargetGroupSize);
% ModuleTransitionData_Table = CreatTaskAllocationTable([],"Current_Line",Line-Downwards+(~Downwards),"Module_Num",numel(Top_GroupInd),"Side",Direction,"Downwards",Downwards,"Finish",Finish);
catch Remove_e
    Remove_e
end


end

function Task_Queue = MiddleLineSwitch(StartConfig, TargetConfig, Downwards, Line,Edge,WS,ConfigShift,Task_Queue)

LeftEdgeType = Edge(3,1,Line);
% RightEdgeType = Edge(2,2,Line);

if LeftEdgeType == 1
    BetaDiff_Override = 1;
    AlphaDiff_Override = -1;
else
    BetaDiff_Override = -1;
    AlphaDiff_Override = 1;
end

Task_Queue(end+1,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override=AlphaDiff_Override,BetaDiff_Override= 0, Side = "Left",WS=WS,ConfigShift=ConfigShift);
Task_Queue(end+1,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0, BetaDiff_Override=BetaDiff_Override, Side = "Right",WS=WS,ConfigShift=ConfigShift);

end
