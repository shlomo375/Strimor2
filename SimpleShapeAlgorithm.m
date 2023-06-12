%% Simple Shape Algorithm

% clear
% close all
% AddDirToPath()

% %% init
% load;

function [Tree,Error,msg] = SimpleShapeAlgorithm(N,BasicWS,StartNode,TargetNode,Ploting)

arguments
    N
    BasicWS
    StartNode
    TargetNode
    Ploting
end
% dbstop in NotTested at 12
% dbstop if error
% close all
% dbstop if caught error
if isempty(BasicWS)
    AddDirToPath()
    N = sum(logical(StartNode{1,"ConfigMat"}{:}),'all');
    Size = [N, 2*N];
    BasicWS = WorkSpace(2*Size,"RRT*");
end
Error = false;
% Ploting = 1;
try
ConfigStruct_A = Node2ConfigStruct(StartNode);
Start_WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_A);


% 
ConfigStruct_B = Node2ConfigStruct(TargetNode);
Target_WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_B);

if Ploting
    figure("Name","StartConfig","Position",[769.8000 49.8000 766.4000 732.8000]);
    PlotWorkSpace(Start_WS,"Plot_CellInd",false);
    figure("Name","TargetConfig","Position",[1.8000 49.8000 766.4000 732.8000]);
    PlotWorkSpace(Target_WS,"Plot_CellInd",false);
end

% [StartConfig, TargetConfig,ConfigShift] = GroupMatrixMatching(StartConfig,Start_WS,TargetConfig,Target_WS,"Start_Shift",7);
[StartNode, TargetNode,ConfigShift] = GroupMatrixMatching(StartNode,Start_WS,TargetNode,Target_WS);

Tree = TreeClass("", N, 1000, StartNode,"EndConfig",TargetNode,"ZoneMatrix",false,"WSEndConfig",Start_WS);

Downwards = true;
Tree.Total_Downwards = true; %very importent value
WS.DoSplittingCheck = false;

%% start algorithm
ParentInd = 1;

Start_WS.Center_Of_Area = centerOfArea(Start_WS);
MaxTotalTime = N*1.5;
TotalTime = tic;
while any(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1) ~= TargetNode.IsomorphismMatrices1{1}(:,:))
    Line = find(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1) ~= TargetNode.IsomorphismMatrices1{1}(:,:),1,"last");
    % if Line ==3
    %     d=5;
    % end
    while any(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(Line,:,1) ~= TargetNode.IsomorphismMatrices1{1}(Line,:)) 
        [Start_WS,Tree, ParentInd,ConfigShift,LineCreated,Error,msg] = Module_to_Destination(Start_WS,Tree, ParentInd,TargetNode,ConfigShift,Line,Downwards,Ploting,TotalTime,MaxTotalTime);
        if LineCreated
            break
        end
        if Error
            return
        end
        NewCA = centerOfArea(Start_WS);
        CorrectionSteps = fix((Start_WS.Center_Of_Area - NewCA)/4);
        if CorrectionSteps >= Tree.N/6
            ConfigStruct = Node2ConfigStruct(Tree.Data(Tree.LastIndex,:));
            Start_WS = SetConfigurationOnSpace(BasicWS,ConfigStruct);
            Start_WS.Center_Of_Area = centerOfArea(Start_WS);
        end

        
    end
end
% if ParentInd == 377
%     d=4;
% end

[Start_WS,Tree, ParentInd,ConfigShift] = MatchingStage(Start_WS,Target_WS,Tree, ParentInd,ConfigShift,Ploting);
catch e
    Error = true;
    msg = e;
end

end

function [WS,Tree, ParentInd,ConfigShift,LineCreated,Error,msg] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,Line,Downwards,Ploting,TotalTime,MaxTotalTime,KillSwitch)

arguments
    WS
    Tree
    ParentInd
    TargetConfig
    ConfigShift
    Line = [];
    Downwards = [];
    Ploting = false;
    
    TotalTime = 0;
    MaxTotalTime = 0;
    KillSwitch = inf;
end


LastTreeInd = Tree.LastIndex;
    Error = false;
    msg = "";
    LineCreated = false;
    StartConfig_GroupMatrix = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1);
    TargetConfig_GroupMatrix = TargetConfig.IsomorphismMatrices1{1}(:,:,1);
    try
    % if ParentInd >= 282
    %         d=5;
    % end    
    Task_Queue = Module_Task_Allocation(StartConfig_GroupMatrix, TargetConfig_GroupMatrix,Downwards, Line,WS=WS,ConfigShift=ConfigShift);
    catch me
        me
        Error = true;
        msg = me;
        if ~Ploting
            return
        end
    end
    % end
KillSwitch = tic;
while size(Task_Queue,1) > 0
    if LastTreeInd == Tree.LastIndex 
        if toc(KillSwitch) > 10 && ~Ploting
            Error = true;
            msg = "TimeOut";
             
            return
            
        end
    else
        LastTreeInd = Tree.LastIndex;
        KillSwitch = tic;
    end
    if toc(TotalTime)>MaxTotalTime
        Error = true;
            msg = "TotalTimeOut";
             
            return
    end
    if ParentInd >= 284
            d=5;
    end    
  
    % if ~Task_Queue{end,"Downwards"}
    %     d=5
    % end
    try
    switch Task_Queue(end,:).ActionType
    
        case "TransitionModules"
            [WS,Tree, ParentInd,ConfigShift,Task_Queue] = TransitionModules(WS, Tree, ParentInd, ConfigShift, Task_Queue,Ploting);
        case "DeleteLine"
            [WS,Tree, ParentInd,ConfigShift,Task_Queue] = DeleteLine(   WS, Tree, ParentInd, ConfigShift, Task_Queue,Ploting);
        case "Switch"
            [WS,Tree, ParentInd,ConfigShift,Task_Queue] = SwitchLine(   WS, Tree, ParentInd, ConfigShift, Task_Queue,Ploting);
        case "CreateLine"
            [WS,Tree, ParentInd,ConfigShift,Task_Queue] = CreateLine(   WS, Tree, ParentInd, ConfigShift, Task_Queue,Ploting);
            LineCreated = true;
    end

    % NewCA = centerOfArea(WS);
    % CorrectionSteps = fix((WS.Center_Of_Area - NewCA)/4);
    % if CorrectionSteps >= Tree.N/6
    %     [WS,Tree, ParentInd,ConfigShift] = MoveTo(WS, Tree, ParentInd, ConfigShift,1,2*CorrectionSteps,Ploting);
    %     KillSwitch = tic;
    % end
    catch memanuvers
        memanuvers
        Error = true;
        msg = memanuvers;
        return
        
    end

    
end

end



