function [WS,Tree, ParentInd, ConfigShift,Task_Queue] = CreateLine(WS,Tree, ParentInd,ConfigShift,Task_Queue,Plot)
arguments
    WS
    Tree
    ParentInd
    ConfigShift
    Task_Queue
    Plot = false;
end
Task = Task_Queue(end,:);
% try

[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1),Task.Downwards);


% Line = numel(GroupsSizes) - Task.Current_Line + 1;
Line =  Task.Current_Line ;
% TargetGroup = Tree.EndConfig_IsomorphismMetrices{1}(Line,:,1);

Edges = Get_GroupEdges(GroupsSizes(Line-3:Line-1),GroupIndexes(Line-3:Line-1),GroupsInds(Line-3:Line-1));

    
[Decision, Direction] = CheapCreateManeuver(Edges,Task);




Top_GroupInd = GroupsInds{Line-1}{1};
Mid_GroupInd = [];
Buttom_GroupInd = GroupsInds{Line-2}{1};

[Step, Axis, AllModuleInd, Moving_Log, NewTask] = ComputeManuver(Decision, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction,Task,Tree);

if size(NewTask,1)
    Task_Queue(end+1,:) = NewTask;
    return
end

[WS, Tree, ParentInd , OK] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",Plot);

Tree = AddManuversInfo(Tree,func2str(Decision),numel(Step));

if OK
    if Task.Downwards
        ConfigShift(2,1) = ConfigShift(2,1) - 1;

    else
        ConfigShift(1,1) = ConfigShift(1,1) - 1;
        
    end
    if Task.Downwards
        Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(end,:,:) = [];
    else
        Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(1,:,:) = [];
    end
    Task_Queue(end,:) = [];
else
    error("bad manuvers");
end


end


function [ManeuverRequired, Direction] = CheapCreateManeuver(Three_Line_Edges,Task)



Maneuver_Cost = struct("Create_Alpha_Alpha",1,...
                       ...
                       "Create_Alpha_Beta",2,... 
                       ...% "Create_Alpha_Beta_2",1,...
                       ...
                       "Create_Beta_Alpha",1,...
                        ...
                       "Create_Beta_Beta",1);

LineEdgesLeft = join(string([Three_Line_Edges(3,1,3), ...
                                 Three_Line_Edges(3,1,2)]),"_");
LineEdgesRight = join(string([Three_Line_Edges(3,2,3), ...
                             Three_Line_Edges(3,2,2)]),"_");
Right = join(["Create",LineEdgesRight.replace("-1","Beta").replace("1","Alpha")],"_");
Left = join(["Create",LineEdgesLeft.replace("-1","Beta").replace("1","Alpha")],"_");

switch Task.Side
    case "Left"
        ManeuverRequired = str2func(Left);
        Direction = "Left";
    case "Right"
        ManeuverRequired = str2func(Right);
        Direction = "Right";
    otherwise
        if Maneuver_Cost.(Right) < Maneuver_Cost.(Left)
            ManeuverRequired = str2func(Right);
            Direction = "Right";
        else
            ManeuverRequired = str2func(Left);
            Direction = "Left";
        end
end


end



