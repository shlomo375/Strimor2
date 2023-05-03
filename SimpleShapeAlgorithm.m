%% Simple Shape Algorithm

% clear
close all
AddDirToPath()
%% init
load("SimpleShapeAlg\Shapes\Configs.mat","StartConfig","TargetConfig");

N = sum(logical(StartConfig{1,"ConfigMat"}{:}),'all');
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");

ConfigStruct_A = Node2ConfigStruct(StartConfig);
WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_A);
figure("Name","StartConfig","Position",[-1919 265 1536 739])
PlotWorkSpace(WS,"Plot_CellInd",true)
% 
ConfigStruct_B = Node2ConfigStruct(TargetConfig);
WS_B = SetConfigurationOnSpace(BasicWS,ConfigStruct_B);
% figure(2)
% PlotWorkSpace(WS_B,"Plot_CellInd",true)

[StartConfig, TargetConfig,ConfigShift] = GroupMatrixMatching(StartConfig,WS,TargetConfig,WS_B);

Tree = TreeClass("", N, 1000, StartConfig,"EndConfig",TargetConfig,"ZoneMatrix",false);

Downwards = true;
%% start algorithm
ParentInd = 1;
% Module_Task_Allocation(WS, Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}, TargetConfig.IsomorphismMatrices1{1}, ConfigShift,13)
for Line = size(StartConfig.IsomorphismMatrices1{1},1):-1:1
    while any(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(Line,:,1) ~= TargetConfig.IsomorphismMatrices1{1}(Line,:)) 
        [WS,Tree, ParentInd,ConfigShift] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,Line,Downwards);
%         close all
    end
end

function [WS,Tree, ParentInd,ConfigShift] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,Line,Downwards)

arguments
    WS
    Tree
    ParentInd
    TargetConfig
    ConfigShift
    Line = [];
    Downwards = [];

%     T.Task_Queue = [];%= CreatTaskAllocationTable([],"Sequence",false,"Current_Line",0,"Downwards",Downwards);
end
Ploting = false;
% Ploting = true;

% StartLine = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(Line,:,1);
% TargetLine = TargetConfig.IsomorphismMatrices1{1}(Line,:,1);
% if size(Task_Queue,1) == 0
    StartConfig_GroupMatrix = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1);
    TargetConfig_GroupMatrix = TargetConfig.IsomorphismMatrices1{1}(:,:,1);
    try
        if ParentInd == 325
            d=5
        end
    Task_Queue = Module_Task_Allocation(StartConfig_GroupMatrix, TargetConfig_GroupMatrix,Downwards, Line,WS=WS,ConfigShift=ConfigShift);
    catch me
        me
    end
    % end
while size(Task_Queue,1) > 0

    if ~Task_Queue{end,"Downwards"}
        d=5
    end

    switch Task_Queue(end,:).ActionType
    
        case "TransitionModules"
            try
            [WS,Tree, ParentInd,ConfigShift,Task_Queue] = TransitionModules(WS, Tree, ParentInd, ConfigShift, Task_Queue,Ploting);
            catch me1
                me1
            end
        case "DeleteLine"
            [WS,Tree, ParentInd,ConfigShift,Task_Queue] = DeleteLine(   WS, Tree, ParentInd, ConfigShift, Task_Queue,Ploting);
        case "Switch"
            d=5
    end
    
    try
    Task_Queue(end,:).Current_Line     
    end
    % if Task_Queue(end,:).Finish
    %     return
    % else
    %    [WS,Tree, ParentInd] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,Task_Queue=T.Task_Queue);
    % end
end
d=5;
end



