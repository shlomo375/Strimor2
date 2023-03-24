%% Simple Shape Algorithm

clear
close all

%% init
load("SimpleShapeAlg\Shapes\Configs.mat","StartConfig","TargetConfig");

N = sum(logical(StartConfig{1,"ConfigMat"}{:}),'all');
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");

ConfigStruct_A = Node2ConfigStruct(StartConfig);
WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_A);
figure(1)
PlotWorkSpace(WS,"Plot_CellInd",true)

ConfigStruct_B = Node2ConfigStruct(TargetConfig);
WS_B = SetConfigurationOnSpace(BasicWS,ConfigStruct_B);
figure(2)
PlotWorkSpace(WS_B,"Plot_CellInd",true)

[StartConfig, TargetConfig] = GroupMatrixMatching(StartConfig,TargetConfig);

Tree = TreeClass("", N, 1e3, StartConfig,"EndConfig",TargetConfig,"ZoneMatrix",false);

%% start algorithm

for Line = 1:size(StartConfig.IsomorphismMatrices1{1},1)
    while any(StartConfig.IsomorphismMatrices1{1}(Line,:) ~= TargetConfig.IsomorphismMatrices1{1}(Line,:)) 
        StartLine = StartConfig.IsomorphismMatrices1{1}(Line,:);
        TargetLine = TargetConfig.IsomorphismMatrices1{1}(Line,:);
        
        Action = LineDifferenceAnalysis(StartLine,TargetLine);

    end
end