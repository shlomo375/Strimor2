%% Simple Shape Algorithm

% clear
% close all
% AddDirToPath()

% %% init
% load;

function [Tree,Error,msg] = SimpleShapeAlgorithm(BasicWS,N,StartNode,TargetNode)
% dbstop in NotTested at 12
% dbstop if error
% close all
% dbstop if caught error
% N = sum(logical(StartNode{1,"ConfigMat"}{:}),'all');
% Size = [N, 2*N];
% BasicWS = WorkSpace(Size,"RRT*");
Error = false;
Ploting = 1;
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

while any(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1) ~= TargetNode.IsomorphismMatrices1{1}(:,:))
    Line = find(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1) ~= TargetNode.IsomorphismMatrices1{1}(:,:),1,"last");
    % if Line ==3
    %     d=5;
    % end
    while any(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(Line,:,1) ~= TargetNode.IsomorphismMatrices1{1}(Line,:)) 
        [Start_WS,Tree, ParentInd,ConfigShift,LineCreated,Error,msg] = Module_to_Destination(Start_WS,Tree, ParentInd,TargetNode,ConfigShift,Line,Downwards,Ploting);
        if LineCreated
            break
        end
        if Error
            return
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

function [WS,Tree, ParentInd,ConfigShift,LineCreated,Error,msg] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,Line,Downwards,Ploting,KillSwitch)

arguments
    WS
    Tree
    ParentInd
    TargetConfig
    ConfigShift
    Line = [];
    Downwards = [];
    Ploting = false;
    KillSwitch = inf;
end


LastTreeInd = Tree.LastIndex;
    Error = false;
    msg = "";
    LineCreated = false;
    StartConfig_GroupMatrix = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1);
    TargetConfig_GroupMatrix = TargetConfig.IsomorphismMatrices1{1}(:,:,1);
    try
    if ParentInd >= 318
            d=5;
    end    
    Task_Queue = Module_Task_Allocation(StartConfig_GroupMatrix, TargetConfig_GroupMatrix,Downwards, Line,WS=WS,ConfigShift=ConfigShift);
    catch me
        me
        Error = true;
        msg = me;
        return
    end
    % end
KillSwitch = tic;
while size(Task_Queue,1) > 0
    if LastTreeInd == Tree.LastIndex
        if toc(KillSwitch) > 10
            Error = true;
            msg = "TimeOut";
            % return
        end
    else
        LastTreeInd = Tree.LastIndex;
        KillSwitch = tic;
    end
    if ParentInd >= 110
            d=5;
    end    
  
    % if ~Task_Queue{end,"Downwards"}
    %     d=5
    % end
    try
        % Line
        % l=find(Tree.Data.IsomorphismMatrices1{Tree.LastIndex}~=TargetConfig_GroupMatrix,1,"Last")
        % if Line~=l
        %     d=4
        % end
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

    % fprintf("Config number: %d\n",ParentInd)
    NewCA = centerOfArea(WS);
    CorrectionSteps = fix((WS.Center_Of_Area - NewCA)/4);
    if CorrectionSteps >= Tree.N/5
        [WS,Tree, ParentInd,ConfigShift] = MoveTo(WS, Tree, ParentInd, ConfigShift,1,CorrectionSteps,Ploting);[WS,Tree, ParentInd,ConfigShift] = MoveTo(WS, Tree, ParentInd, ConfigShift,1,CorrectionSteps,Ploting);
    end
    catch memanuvers
        memanuvers
        Error = true;
        msg = memanuvers;
        return
    % Task_Queue(end,:).Current_Line     
    end

    %%
    % if toc(KillSwitch) > 5
    %     Error = true;
    %     msg = "TimeOut";
    %     return
    % end
end
% d=5;
end



