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
        StartLine = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(Line,:,1);
        TargetLine = TargetConfig.IsomorphismMatrices1{1}(Line,:,1);
        
        [WS,Tree, ParentInd] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,Line,Downwards);
%         close all
    end
end

function [WS,Tree, ParentInd] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,Line,Downwards,ModuleTransitionData)

arguments
    WS
    Tree
    ParentInd
    TargetConfig
    ConfigShift
    Line
    Downwards
    ModuleTransitionData = CreatTaskAllocationTable([],"Sequence",false,"Current_Line",0,"Downwards",Downwards);
end

StartLine = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(Line,:,1);
TargetLine = TargetConfig.IsomorphismMatrices1{1}(Line,:,1);


if abs(StartLine) > abs(TargetLine) || ModuleTransitionData.DestenationLine % Translate module to spacifice line
    try
    %% Remove modules
    if ModuleTransitionData.DestenationLine
        d=5;
    end
    [WS,Tree, ParentInd,ConfigShift,ModuleTransitionData] = RemoveModules(WS,Tree, ParentInd,ConfigShift, Line, Downwards,ModuleTransitionData);
    

    
    catch ee
        ee
    end
elseif abs(StartLine) == abs(TargetLine)
    if sign(StartLine) ~= sign(TargetLine)
        if  isempty(ModuleTransitionData)
            ActionFuncHandle = @SwitchEdges;
            ActionName = "Switch edges";

            % temp
            ModuleTransitionData.Finish = true;
        else
            return
        end
    else
        ActionFuncHandle = [];
        ActionName = "Line are the same";

        % temp
        ModuleTransitionData.Finish = true;
    end
else % StartLine < TargetLine
    ActionFuncHandle = @AddingModules;
    ActionName = "Adding modules";

    % temp
    ModuleTransitionData.Finish = true;
end

ModuleTransitionData.Current_Line
if ModuleTransitionData.Finish
    return
else
   [WS,Tree, ParentInd] = Module_to_Destination(WS,Tree, ParentInd,TargetConfig,ConfigShift,ModuleTransitionData.Current_Line,Downwards,ModuleTransitionData);
end

end



