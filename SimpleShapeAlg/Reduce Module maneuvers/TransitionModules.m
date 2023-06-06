function [WS,Tree, ParentInd,ConfigShift,Task_Queue] = TransitionModules(WS,Tree, ParentInd,ConfigShift,Task_Queue,Plot)
arguments
    WS
    Tree
    ParentInd
    ConfigShift
    Task_Queue
    Plot = false;
end
% if ParentInd >=569
%     d=5
% end
Task = Task_Queue(end,:);
Task = FinishTask(Task);
if Task.Finish
    Task_Queue(end,:) = [];
    return
end
% Line = max(Task{1,["Current_Line_Alpha","Current_Line_Beta"]});
Line = ActiveLine(Task);

%%
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1),Task.Downwards);
% TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};
if (Line > ConfigShift(1,1) + 1 && Task.Downwards) || (Line > ConfigShift(2,1) + 1 && ~Task.Downwards)
    if Line < numel(GroupsInds) && GroupsSizes(Line+1)
        Edges = Get_GroupEdges(GroupsSizes(Line-2:Line+1),GroupIndexes(Line-2:Line+1),GroupsInds(Line-2:Line+1));
    else
        Edges = Get_GroupEdges(GroupsSizes(Line-2:Line),GroupIndexes(Line-2:Line),GroupsInds(Line-2:Line));
    end
else
    Edges = Get_GroupEdges(GroupsSizes(Line-1:Line+1),GroupIndexes(Line-1:Line+1),GroupsInds(Line-1:Line+1),1);
end


[Decision, Direction] = SelectReduceManeuver(Edges); %manuver top to buttom

%%
if Line == numel(GroupsInds) || ~GroupsSizes(Line+1)
    Top_GroupInd = [];
else
    Top_GroupInd = GroupsInds{Line+1}{1};
end
try
Mid_GroupInd = GroupsInds{Line}{1};
catch e_Mid_GroupInd
    e_Mid_GroupInd
end
if Line == numel(GroupsInds) || ~GroupsSizes(Line-1)
    Buttom_GroupInd = [];
else
    Buttom_GroupInd = GroupsInds{Line-1}{1};
end

%%
try
switch Task.Side
    case "Left" % Moving one specific module from a certain side
        [Step, Axis, AllModuleInd, Moving_Log,NewTask] = ComputeManuver(Decision{1}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(1),Task,Tree);
        Decision = func2str(Decision{1});
    case "Right"
        [Step, Axis, AllModuleInd, Moving_Log,NewTask] = ComputeManuver(Decision{2}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(2),Task,Tree);
        Decision = func2str(Decision{2});
    otherwise
        [Step{2}, Axis{2}, AllModuleInd{2}, Moving_Log{2},NewTask{2}] = ComputeManuver(Decision{2}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(2),Task,Tree);
        [Step{1}, Axis{1}, AllModuleInd{1}, Moving_Log{1},NewTask{1}] = ComputeManuver(Decision{1}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(1),Task, Tree);
        
        [Step, Axis,AllModuleInd, Moving_Log,Task.Side,Decision,~,NewTask] = DirectionCostSelection(Step, Axis,AllModuleInd, Moving_Log,Direction,Decision,NewTask);
        % Task{1,"Side"} = Side;
end
if size(NewTask,1)
    Task_Queue(end+1:end+size(NewTask,1),:) = NewTask;
    return
end

[Moving_Log,AllModuleInd] = AddAboveModule(Line+1,AllModuleInd,GroupsInds,Step,Axis, Moving_Log, Task.Downwards);
catch eeee
    throw(eeee)
end
[WS, Tree, ParentInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",Plot);

Tree = AddManuversInfo(Tree,Decision,numel(Step));
% try
Task = Update_CurrentLine_Of_ModuleReduced(Task,Decision);
if Task.Current_Line_Alpha <0 || Task.Current_Line_Beta<0
    d=5
end
Task = FinishTask(Task);
% Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},ConfigShift(:,1));

if Task.Finish
    Task_Queue(end,:) = [];
else
    Task_Queue(end,:) = Task;
end
% catch me2
%     me2
% end

end

function Task = Update_CurrentLine_Of_ModuleReduced(Task,Decision)

switch Decision
    case "Alpha_Alpha"
        Task.Current_Line = Task.Current_Line - 1;
        Task.Current_Line_Alpha = Task.Current_Line_Alpha - 1;
        Task.Current_Line_Beta = Task.Current_Line_Beta - 1;
    case "Alpha_Beta"
        if Task.Downwards
            Task.Current_Line_Alpha = Task.Current_Line_Alpha - 1;
        else
            Task.Current_Line_Beta = Task.Current_Line_Beta - 1;
        end
    case "Beta_Alpha"
        if Task.Downwards
            Task.Current_Line_Beta = Task.Current_Line_Beta - 1;
        else
            Task.Current_Line_Alpha = Task.Current_Line_Alpha - 1;
        end
    case "Beta_Beta"
        Task.Current_Line = Task.Current_Line - 1;
        Task.Current_Line_Alpha = Task.Current_Line_Alpha - 1;
        Task.Current_Line_Beta = Task.Current_Line_Beta - 1;

end
if Task.Current_Line_Alpha < 0
    Task.Current_Line_Alpha = 0;
end
if Task.Current_Line_Beta < 0
    Task.Current_Line_Beta = 0;
end
if Task.Current_Line < 0
    Task.Current_Line = 0;
end
Task.Module_Num = sum([Task.Current_Line_Alpha~=Task.DestenationLine_Alpha,Task.Current_Line_Beta~=Task.DestenationLine_Beta]);

Task.Current_Line = ActiveLine(Task);
end



