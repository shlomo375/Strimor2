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
TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};

Line = Task.Current_Line;

FirstConfigLine = find(GroupsSizes,1,"first");

Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
if Line ~= FirstConfigLine
    %% Middle line switch
    
    Task_Queue = MiddleLineSwitch(GroupsSizes, TargetGroupSize, Task.Downwards, Line,Edges,WS,ConfigShift,Task_Queue);
    return
else
    %% Bottom line switch
    GroupSizeRequired = [4,3];
    [OK, NewTask] = GroupSizeAsNeeded(GroupsSizes,TargetGroupSize,GroupSizeRequired,Line,Task.Downwards);
    if ~OK
        Task_Queue(end+1,:) = NewTask;
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


RemoveStep = ~Step;
Step(RemoveStep) = [];
Axis(RemoveStep) = [];
Moving_Log(RemoveStep,:) = [];

[WS, Tree, ParentInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",Plot);

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
    Task = Module_Task_Allocation(GroupSize, TargetGroupSize, ~Downwards, SwitchLine, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);
    return 

elseif abs(GroupSize(SwitchLine+1)) < abs(GroupSizeRequired(2)) || GroupSize(SwitchLine+1) == -GroupSizeRequired(2) 
    
    Addition = abs(GroupSizeRequired(2)) - abs(GroupSize(SwitchLine+1));
    if Addition >= 2
        AlphaDiff = 1;
        BetaDiff = 1;
    elseif EndIsAlpha(GroupSize(SwitchLine+1))
        BetaDiff = 1;
        AlphaDiff = 0;
    else
        AlphaDiff = 1;
        BetaDiff = 0;
    end
    OK = false;
    Task = Module_Task_Allocation(GroupSize, TargetGroupSize, ~Downwards, SwitchLine+1, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);
    return

end
end



function Task_Queue = MiddleLineSwitch(StartConfig, TargetConfig, Downwards, Line,Edge,WS,ConfigShift,Task_Queue)

LeftEdgeType = Edge(3,1,Line);
% RightEdgeType = Edge(2,2,Line);

if LeftEdgeType == 1
    % BetaDiff_Override = 1;
    % AlphaDiff_Override = -1;

    Task_Queue(end,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0 ,BetaDiff_Override= 1, Side = "Left",WS=WS,ConfigShift=ConfigShift);
    Task_Queue(end+1,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0, BetaDiff_Override= -1, Side = "Right",WS=WS,ConfigShift=ConfigShift);
else
    % BetaDiff_Override = -1;
    % AlphaDiff_Override = 1;

    Task_Queue(end,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0 ,BetaDiff_Override= -1, Side = "Left",WS=WS,ConfigShift=ConfigShift);
    Task_Queue(end+1,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0, BetaDiff_Override= 1, Side = "Right",WS=WS,ConfigShift=ConfigShift);
end

% Task_Queue(end,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override=AlphaDiff_Override,BetaDiff_Override= 0, Side = "Left",WS=WS,ConfigShift=ConfigShift);
% Task_Queue(end+1,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0, BetaDiff_Override=BetaDiff_Override, Side = "Right",WS=WS,ConfigShift=ConfigShift);

end
