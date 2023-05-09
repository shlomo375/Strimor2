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
    GroupSizeRequired = [3,4];
    [OK, Task] = GroupSizeAsNeeded(GroupsSizes,TargetGroupSize,GroupSizeRequired,Line,Task.Downwards);
    if ~OK
        Task_Queue(end+1,:) = Task;
        return
    end
    
    %% algorithm
    
    Top_GroupInd = GroupsInds{Line}{1};
    Buttom_GroupInd = GroupsInds{Line-1}{1};
    All_MovingModule = [Top_GroupInd,Buttom_GroupInd];

    if GroupsSizes(Line) < 0
        BaseSide = "Right";
        
        MAX_StepLeft = Edges(2,2,Line-1) - Edges(2,1,Line-2)
        Step = [Step, 1];
        Axis = [Axis, 2];
        
        Moving_Log_Top(4,1) = true;
        Moving_Log_Mid(4,1:2) = true;

    else
        BaseSide = "Left";
    end
    
   

    ScannedAgent = ~WS.Space.Status;
    ScannedAgent(GroupInd1{1}{1}) = true;
    [~, StraightLineModulesInd] = ScanningAgentsFast(WS, ScannedAgent, ModulesGroupInd(3),true);
    
    
    % load("Switch.mat")
[GroupsSizes,GroupIndexes, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);

% Temp = 1:numel(BottomModuleInd);
if FirstIsAlpha(GroupsSizes(1,:))
    % Swapping occurs on the right side of a configuration
    TopModuleInd = GroupInd{2}{1};
    BottomModuleInd = flip(GroupInd{1}{1}(end-5:end));
    AllModuleInd = [BottomModuleInd; TopModuleInd];
    
    FirstStep = (GroupIndexes{1}{1}(end)-GroupIndexes{2}{1}(end)-4)/2;
    Steps = [FirstStep,-1,-1,-1,-1,1,-1,-1,1];
    Axis = [1,2,1,2,3,2,3,2,3];

else
    TopModuleInd = GroupInd{2}{1};
    BottomModuleInd = GroupInd{1}{1}(1:6);
    AllModuleInd = [BottomModuleInd; TopModuleInd];

    FirstStep = -(GroupIndexes{2}{1}(1)-GroupIndexes{1}{1}(1)-4)/2;
    Steps = [FirstStep,1,1,1,1,-1,1,1,-1];
    Axis = [1,3,1,3,2,3,2,3,2];
end
% figure(1)
% PlotWorkSpace(WS,[],[]);
%% swap group adges algorithm

% The six modules at the end of the bottom row are numbered from the end
% inward, 1,2,3,4,5,6.
%%
% 1) Moving the top row to the end with the beta module, 2 steps before the
% end of the row.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd(7)] =...
    ManeuverStepProcess(WS,tree,ParentInd,AllModuleInd(7), Axis(1), Steps(1));

    if ~ OK
        return
    end
% figure(2)
% PlotWorkSpace(NewWS,[],[]);
%%
% 2) uploading modules 1,2,3 from the bottom row.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3]), Axis(2), Steps(2));

    if ~ OK
        return
    end
% figure(3)
% PlotWorkSpace(NewWS,[],[]);
%%
% 3) moving the top row one step in the other direction (top row + modules
% 1,2,3).

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3,7])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3,7]), Axis(3), Steps(3));

    if ~ OK
        return
    end
% figure(4)
% PlotWorkSpace(NewWS,[],[]);    
%%
% 4) Upload modules 1-5 one line up.
    
    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3,4,5])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3,4,5]), Axis(4), Steps(4));

    if ~ OK
        return
    end
% figure(5)
% PlotWorkSpace(NewWS,[],[]);    
%%
% 5) Download module 3 one step.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd(3)] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd(3), Axis(5), Steps(5));

    if ~ OK
        return
    end
% figure(6)
% PlotWorkSpace(NewWS,[],[]);
%%
% 6) Downloading modules 1,2,4,5 one row in the other axis back to the
% previous place.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,4,5])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,4,5]), Axis(6), Steps(6));

    if ~ OK
        return
    end
% figure(7)
% PlotWorkSpace(NewWS,[],[]);
%%
% 7) Download modules 1,2,4,5,6 line down in the first axis.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,4,5,6])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,4,5,6]), Axis(7), Steps(7));

    if ~ OK
        return
    end
% figure(8)
% PlotWorkSpace(NewWS,[],[]);
%%
% 8) Upload module 1 row up.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd(1)] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd(1), Axis(8), Steps(8));

    if ~ OK
        return
    end
% figure(9)
% PlotWorkSpace(NewWS,[],[]);
%%
% 9) Upload modules 2,4,5,6 one line up.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([2,4,5,6])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([2,4,5,6]), Axis(9), Steps(9));

    if ~ OK
        return
    end
% figure(10)
% PlotWorkSpace(NewWS,[],[]);

WS = NewWS;
tree = Newtree;
ParentInd = NewParentInd;

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
    BetaDiff_Override = 1;
    AlphaDiff_Override = -1;
else
    BetaDiff_Override = -1;
    AlphaDiff_Override = 1;
end

Task_Queue(end+1,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override=AlphaDiff_Override,BetaDiff_Override= 0, Side = "Left",WS=WS,ConfigShift=ConfigShift);
Task_Queue(end+1,:) = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, AlphaDiff_Override= 0, BetaDiff_Override=BetaDiff_Override, Side = "Right",WS=WS,ConfigShift=ConfigShift);

end
