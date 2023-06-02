%% Simple Shape Algorithm

% clear
% close all
% AddDirToPath()

% %% init
% load;

function [Tree,error] = SimpleShapeAlgorithm(BasicWS,N,StartNode,TargetNode)
dbstop in NotTested at 12
dbstop if error
close all
% dbstop if caught error
% N = sum(logical(StartNode{1,"ConfigMat"}{:}),'all');
% Size = [N, 2*N];
% BasicWS = WorkSpace(Size,"RRT*");
error = false;
Ploting = 1;
try
ConfigStruct_A = Node2ConfigStruct(StartNode);
Start_WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_A);


% 
ConfigStruct_B = Node2ConfigStruct(TargetNode);
Target_WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_B);

if Ploting
    figure("Name","StartConfig","Position",[769.8000 49.8000 766.4000 732.8000])
    PlotWorkSpace(Start_WS,"Plot_CellInd",false)
    figure("Name","TargetConfig","Position",[1.8000 49.8000 766.4000 732.8000])
    PlotWorkSpace(Target_WS,"Plot_CellInd",false)
end

% [StartConfig, TargetConfig,ConfigShift] = GroupMatrixMatching(StartConfig,Start_WS,TargetConfig,Target_WS,"Start_Shift",7);
[StartNode, TargetNode,ConfigShift] = GroupMatrixMatching(StartNode,Start_WS,TargetNode,Target_WS);

Tree = TreeClass("", N, 1000, StartNode,"EndConfig",TargetNode,"ZoneMatrix",false,"WSEndConfig",Start_WS);

Downwards = true;
Tree.Total_Downwards = true; %very importent value
WS.DoSplittingCheck = false;

%% start algorithm
ParentInd = 1;

% for Line = size(StartNode.IsomorphismMatrices1{1},1):-1:1
while any(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1) ~= TargetNode.IsomorphismMatrices1{1}(:,:))
    Line = find(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1) ~= TargetNode.IsomorphismMatrices1{1}(:,:),1,"last");
    if Line ==3
        d=5;
    end
    while any(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(Line,:,1) ~= TargetNode.IsomorphismMatrices1{1}(Line,:)) 
        [Start_WS,Tree, ParentInd,ConfigShift] = Module_to_Destination(Start_WS,Tree, ParentInd,TargetNode,ConfigShift,Line,Downwards,Ploting);
%         close all
    end
end


[Start_WS,Tree, ParentInd,ConfigShift] = MatchingStage(Start_WS,Target_WS,Tree, ParentInd,ConfigShift,Ploting);
catch e
    error = true;
end

end

function [WS,Tree, ParentInd,ConfigShift] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,Line,Downwards,Ploting)

arguments
    WS
    Tree
    ParentInd
    TargetConfig
    ConfigShift
    Line = [];
    Downwards = [];
    Ploting = false;
end
% Ploting = false;
% Ploting = true;

    StartConfig_GroupMatrix = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1);
    TargetConfig_GroupMatrix = TargetConfig.IsomorphismMatrices1{1}(:,:,1);
    try
    if ParentInd >= 150
            d=5;
    end    
    Task_Queue = Module_Task_Allocation(StartConfig_GroupMatrix, TargetConfig_GroupMatrix,Downwards, Line,WS=WS,ConfigShift=ConfigShift);
    catch me
        me
    end
    % end
while size(Task_Queue,1) > 0
    if ParentInd >= 162
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
    end
    ParentInd
    catch memanuvers
        
    % Task_Queue(end,:).Current_Line     
    end
end
d=5;
end



