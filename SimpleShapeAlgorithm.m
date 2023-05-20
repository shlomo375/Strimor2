%% Simple Shape Algorithm

% clear
close all
AddDirToPath()
dbstop in NotTested at 12
dbstop if error
%% init
load("SimpleShapeAlg\Shapes\Configs.mat","StartConfig","TargetConfig");

N = sum(logical(StartConfig{1,"ConfigMat"}{:}),'all');
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");

ConfigStruct_A = Node2ConfigStruct(StartConfig);
Start_WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_A);
figure("Name","StartConfig","Position",[-1.1502e+03 265.8000 766.4000 732.8000])
PlotWorkSpace(Start_WS,"Plot_CellInd",false)
% 
ConfigStruct_B = Node2ConfigStruct(TargetConfig);
Target_WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_B);
figure("Name","TargetConfig","Position",[-1.9182e+03 265.8000 766.4000 732.8000])
PlotWorkSpace(Target_WS,"Plot_CellInd",false)

[StartConfig, TargetConfig,ConfigShift] = GroupMatrixMatching(StartConfig,Start_WS,TargetConfig,Target_WS,"Start_Shift",9);
% [StartConfig, TargetConfig,ConfigShift] = GroupMatrixMatching(StartConfig,Start_WS,TargetConfig,Target_WS);

Tree = TreeClass("", N, 1000, StartConfig,"EndConfig",TargetConfig,"ZoneMatrix",false);

Downwards = true;
Tree.Total_Downwards = true; %very importent value
Ploting = 1;
%% start algorithm
ParentInd = 1;
% Module_Task_Allocation(WS, Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}, TargetConfig.IsomorphismMatrices1{1}, ConfigShift,13)


for Line = size(StartConfig.IsomorphismMatrices1{1},1):-1:1
    while any(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(Line,:,1) ~= TargetConfig.IsomorphismMatrices1{1}(Line,:)) 
        [Start_WS,Tree, ParentInd,ConfigShift] = Module_to_Destination(Start_WS,Tree, ParentInd,TargetConfig,ConfigShift,Line,Downwards,Ploting);
%         close all
    end
end


[Start_WS,Tree, ParentInd,ConfigShift] = MatchingStage(Start_WS,Target_WS,Tree, ParentInd,ConfigShift,Ploting);


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
        
    Task_Queue = Module_Task_Allocation(StartConfig_GroupMatrix, TargetConfig_GroupMatrix,Downwards, Line,WS=WS,ConfigShift=ConfigShift);
    catch me
        me
    end
    % end
while size(Task_Queue,1) > 0

    % if ~Task_Queue{end,"Downwards"}
    %     d=5
    % end
    if ParentInd >= 819
            d=5
    end
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
    
    try
    Task_Queue(end,:).Current_Line     
    end
end
d=5;
end



