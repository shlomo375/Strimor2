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
% try

[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1),Task.Downwards);
TargetGroupSize = Tree.EndConfig.IsomorphismMatrices1{1};
NumLine = nnz(GroupsSizes);

Line = Task.Current_Line;

FirstConfigLine = find(GroupsSizes,1,"first");
LastConfigLine = find(GroupsSizes,1,"last");


Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
if (Line ~= FirstConfigLine && Task.Downwards) || (Line ~= LastConfigLine && ~Task.Downwards)
    %% Middle line switch
    
    Task_Queue = MiddleLineSwitch(GroupsSizes, TargetGroupSize, Task.Downwards, Line,Edges,WS,ConfigShift,Task_Queue);
    return
else
    %% Bottom line switch
    GroupSizeRequired = [4,3];
    [OK, NewTask] = GroupSizeAsNeeded(GroupsSizes,TargetGroupSize,GroupSizeRequired,Line,Task.Downwards);
    if ~OK
        Task_Queue((end+1):(end+size(NewTask,1)),:) = NewTask;
        return
    end
    Step = zeros(1,11);
    Axis = zeros(1,11);
    %% algorithm
    
    Bottom_GroupInd = GroupsInds{Line}{1};
    Top_GroupInd = GroupsInds{Line+1}{1};
    AllModuleInd = [Bottom_GroupInd,Top_GroupInd];
    
    Moving_Log_Bottom = false(1,size(Bottom_GroupInd,2));
    Moving_Log_Top = false(1,size(Top_GroupInd,2));
    if GroupsSizes(Line) < 0
        BaseSide = "Left";
        
        Top_Step = floor(((Edges(2,1,Line+1)+(Edges(3,1,Line+1)==-1)) - (Edges(2,1,Line)+(Edges(3,1,Line)==1)))/2);
        TopBottom_Step = floor(((Edges(2,2,Line+2)-(Edges(3,2,Line+2)==-1)) - (Edges(2,1,Line+1)+(Edges(3,1,Line+1)==1)))/2);
        Step(1:2) = [Top_Step,TopBottom_Step];
        Axis(1:2) = [1,1];

       
        %%
        Step(3) = -1;
        Axis(3) = 3;
        %%
        Step(4) = -1;
        Axis(4) = 2;  
        %%
        Step(5) = 1;
        Axis(5) = 3;
        %% 
        Step(6) = -(Base_Num(GroupsSizes(Line+1),-1) + Base_Num(GroupsSizes(Line+2),1)-2);
        Axis(6) = 1;
        %%
        Step(7) = 1;
        Axis(7) = 2;
        %%
        Step(8) = (Base_Num(GroupsSizes(Line),1)-2);
        Axis(8) = 1;
        %%
        Step(9) = -1;
        Axis(9) = 3;
        %%
        Step(10) = -(Base_Num(GroupsSizes(Line),1)-2);
        Axis(10) = 1;
        %%
        Step(11) = -1;
        Axis(11) = 2;
       

    else
        BaseSide = "Right";

        Top_Step = floor(((Edges(2,2,Line+1)-(Edges(3,2,Line+1)==-1)) - (Edges(2,2,Line)-(Edges(3,2,Line)==1)))/2);
        TopBottom_Step = floor(((Edges(2,1,Line+2)+(Edges(3,1,Line+2)==-1)) - (Edges(2,2,Line+1)-(Edges(3,2,Line+1)==1)))/2);     
        Step(1:2) = [Top_Step,TopBottom_Step];
        Axis(1:2) = [1,1];
        
        
        %%
        Step(3) = 1;
        Axis(3) = 2;
        %%
        Step(4) = 1;
        Axis(4) = 3;
        %%
        Step(5) = -1;
        Axis(5) = 2;
        %% 
        Step(6) = Base_Num(GroupsSizes(Line+1),-1) + Base_Num(GroupsSizes(Line+2),1)-2;
        Axis(6) = 1;
        %%
        Step(7) = -1;
        Axis(7) = 3;
        %%
        Step(8) = -(Base_Num(GroupsSizes(Line),1)-2);
        Axis(8) = 1;
        %%
        Step(9) = 1;
        Axis(9) = 2;
        %%
        Step(10) = (Base_Num(GroupsSizes(Line),1)-2);
        Axis(10) = 1;
        %%
        Step(11) = 1;
        Axis(11) = 3;
    end

Moving_Log_Bottom(1:2,:) = true;
Moving_Log_Top(2,:) = true;
%%
Moving_Log_Bottom(3,1:end-1) = true;
if (EndIsAlpha(GroupsSizes(Line+1)) && matches(BaseSide,"Right")) || (GroupsSizes(Line+1) > 0 && matches(BaseSide,"Left"))
    Moving_Log_Top(3,1:end-2) = true;
else
    Moving_Log_Top(3,1:end-3) = true;
end

Moving_Log_Bottom(4,end-1) = true;
%%        
Moving_Log_Bottom(5,1:end-2) = true;
if (EndIsAlpha(GroupsSizes(Line+1)) && matches(BaseSide,"Right")) || (GroupsSizes(Line+1) > 0 && matches(BaseSide,"Left"))
    Moving_Log_Top(5,1:end-2) = true;
else
    Moving_Log_Top(5,1:end-3) = true;
end

%% 
Moving_Log_Bottom(6,:) = true;
Moving_Log_Top(6,:) = true;

%%
Moving_Log_Bottom(7,end-1:end) = true;
if (EndIsAlpha(GroupsSizes(Line+1)) && matches(BaseSide,"Right")) || (GroupsSizes(Line+1) > 0 && matches(BaseSide,"Left"))
    Moving_Log_Top(7,end) = true;
else
    Moving_Log_Top(7,end-1:end) = true;
end

%%
Moving_Log_Bottom(8,end-1:end) = true;

%%
Moving_Log_Bottom(9,1) = true;

%%
Moving_Log_Bottom(10,[1,end-1:end]) = true;

%%
Moving_Log_Bottom(11,[1,end-1:end]) = true;
if (EndIsAlpha(GroupsSizes(Line+1)) && matches(BaseSide,"Right")) || (GroupsSizes(Line+1) > 0 && matches(BaseSide,"Left"))
    Moving_Log_Top(11,end) = true;
else
    Moving_Log_Top(11,end-1:end) = true;
end

if matches(BaseSide,"Left")
    Moving_Log_Top = flip(Moving_Log_Top,2);
    Moving_Log_Bottom = flip(Moving_Log_Bottom,2);
end

if ~Task.Downwards
    NewAxis = Axis;
    NewAxis(Axis==2) = 3;
    NewAxis(Axis==3) = 2;
    Axis = NewAxis;
end
Moving_Log = [Moving_Log_Bottom, Moving_Log_Top];

if NumLine<=2
    Step(2) = 0;
    Step(6) = 0;
end
RemoveStep = ~Step;
Step(RemoveStep) = [];
Axis(RemoveStep) = [];
Moving_Log(RemoveStep,:) = [];

[WS, Tree, ParentInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",Plot);

Tree = AddManuversInfo(Tree,"Switch",numel(Step));

Task_Queue(end,:) = [];
end

    



end

function [OK, Task] = GroupSizeAsNeeded(GroupSize,TargetGroupSize,GroupSizeRequired,SwitchLine,Downwards)
OK = true;
Task = [];
if abs(GroupSize(SwitchLine)) < abs(GroupSizeRequired(1))
    Addition = abs(GroupSizeRequired(1)) - abs(GroupSize(SwitchLine));
    if Addition >= 2
        AlphaDiff = 1;
        BetaDiff = 1;
    elseif EndIsAlpha(GroupSize(SwitchLine))
        BetaDiff = 1;
        AlphaDiff = 0;
    else
        AlphaDiff = 1;
        BetaDiff = 0;
    end
    OK = false;
    Task = Module_Task_Allocation(GroupSize, TargetGroupSize, Downwards, SwitchLine, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);
    return 

elseif abs(GroupSize(SwitchLine+1-2*(~Downwards))) < abs(GroupSizeRequired(2)) || GroupSize(SwitchLine+1-2*(~Downwards)) == -GroupSizeRequired(2) 
    
    Addition = abs(GroupSizeRequired(2)) - abs(GroupSize(SwitchLine+1-2*(~Downwards)));
    if Addition >= 2
        AlphaDiff = 1;
        BetaDiff = 1;
    elseif EndIsAlpha(GroupSize(SwitchLine+1-2*(~Downwards)))
        BetaDiff = 1;
        AlphaDiff = 0;
    else
        AlphaDiff = 1;
        BetaDiff = 0;
    end
    OK = false;
    Task = Module_Task_Allocation(GroupSize, TargetGroupSize, ~Downwards, SwitchLine+1-2*(~Downwards), "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);
    return

end
end



function Task_Queue = MiddleLineSwitch(StartConfig, TargetConfig, Downwards, Line,Edge,WS,ConfigShift,Task_Queue)

RightEdgeRequred = -Edge(3,2,Line);
LeftEdgeRequred  = -Edge(3,1,Line);
if ~isempty(find(Edge(3,1,1:Line-1)==LeftEdgeRequred,1)) && ~isempty(find(Edge(3,2,1:Line-1)==RightEdgeRequred,1)) %there is a module in the same side
    
    LeftEdgeType = Edge(3,1,Line);
    
    if LeftEdgeType == 1
        % BetaDiff_Override = 1;
        % AlphaDiff_Override = -1;
        
        TasksUp = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0, BetaDiff_Override= -1, Side = "Right",WS=WS,ConfigShift=ConfigShift);
        Task_Queue(end:end+size(TasksUp,1)-1,:) = TasksUp;
        
        if size(TasksUp,1) == 1
            TasksDown = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0 ,BetaDiff_Override= 1, Side = "Left",WS=WS,ConfigShift=ConfigShift);
            Task_Queue(end+1:end+size(TasksDown,1),:) = TasksDown;
        end
    else
        % BetaDiff_Override = -1;
        % AlphaDiff_Override = 1;
        
        TasksUp = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0, BetaDiff_Override= 1, Side = "Right",WS=WS,ConfigShift=ConfigShift);
        Task_Queue(end:end+size(TasksUp,1)-1,:) = TasksUp;
        
        if size(TasksUp,1) == 1
            TasksDown = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0 ,BetaDiff_Override= -1, Side = "Left",WS=WS,ConfigShift=ConfigShift);
            Task_Queue(end+1:end+size(TasksDown,1),:) = TasksDown;
        end 
    end
else % there isnt module in the same side
    [BaseGroupLoc,~,BaseGroupSize] = find(StartConfig,1,"first");
    if ~mod(BaseGroupSize,2) %base group are even: made switch first
        Task_Queue = CreatTaskAllocationTable([],"ActionType","Switch","Current_Line",BaseGroupLoc,"Downwards",Downwards,"Type",0);
    else %base group are odd: download module, than switch group
        
        if abs(StartConfig(Line)) < 4
            Task_Queue(end+1,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 1 ,BetaDiff_Override= 1,WS=WS,ConfigShift=ConfigShift);
            return
        end


        if BaseGroupSize>0
            if StartConfig(Line) > 0
                Side = "Right";
            else
                Side = "Left";
            end
            Task_Queue(2,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0 ,BetaDiff_Override= -1, Side = Side,WS=WS,ConfigShift=ConfigShift);
        else
            if StartConfig(Line) > 0
                Side = "Left";
            else
                Side = "Right";
            end
            % BaseGroupLoc = size(StartConfig,1) - (BaseGroupLoc-1);
            Task_Queue(2,:) = Module_Task_Allocation(StartConfig, TargetConfig, ~Downwards, BaseGroupLoc, AlphaDiff_Override= 1 ,BetaDiff_Override= 0, Side = Side,WS=WS,ConfigShift=ConfigShift);
        end
        % Task_Queue(2,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0 ,BetaDiff_Override= -1, Side = "Left",WS=WS,ConfigShift=ConfigShift);
        Task_Queue(1,:) = CreatTaskAllocationTable([],"ActionType","Switch","Current_Line",BaseGroupLoc,"Downwards",Downwards,"Type",0);
    end
end
end
