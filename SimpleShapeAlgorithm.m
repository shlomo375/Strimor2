%% Simple Shape Algorithm

% clear
close all
% AddDirToPath()
%% init
load("SimpleShapeAlg\Shapes\Configs.mat","StartConfig","TargetConfig");

N = sum(logical(StartConfig{1,"ConfigMat"}{:}),'all');
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");

ConfigStruct_A = Node2ConfigStruct(StartConfig);
WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_A);
figure(1)
PlotWorkSpace(WS,"Plot_CellInd",true)
% 
ConfigStruct_B = Node2ConfigStruct(TargetConfig);
WS_B = SetConfigurationOnSpace(BasicWS,ConfigStruct_B);
% figure(2)
% PlotWorkSpace(WS_B,"Plot_CellInd",true)

[StartConfig, TargetConfig,ConfigShift] = GroupMatrixMatching(StartConfig,WS,TargetConfig,WS_B);

Tree = TreeClass("", N, 1000, StartConfig,"EndConfig",TargetConfig,"ZoneMatrix",false);

%% start algorithm
ParentInd = 1;
for Line = size(StartConfig.IsomorphismMatrices1{1},1):-1:1
    while any(StartConfig.IsomorphismMatrices1{1}(Line,:) ~= TargetConfig.IsomorphismMatrices1{1}(Line,:)) 
        StartLine = StartConfig.IsomorphismMatrices1{1}(Line,:);
        TargetLine = TargetConfig.IsomorphismMatrices1{1}(Line,:);
        
        [Action, ActionName] = LineDifferenceAnalysis(StartLine,TargetLine);
        
        [WS,Tree, ParentInd] = Action(WS,Tree, ParentInd,ConfigShift, Line);
    end
end