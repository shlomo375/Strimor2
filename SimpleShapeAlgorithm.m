%% Simple Shape Algorithm

clear
close all

%% init
load("SimpleShapeAlg\Shapes\Configs.mat","Config_A","Config_B");

N = sum(logical(Config_A{1,"ConfigMat"}{:}),'all');
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");

ConfigStruct_A = Node2ConfigStruct(Config_A);
WS = SetConfigurationOnSpace(BasicWS,ConfigStruct_A);
figure(1)
% PlotWorkSpace(WS,"Plot_CellInd",true)

ConfigStruct_B = Node2ConfigStruct(Config_B);
WS_B = SetConfigurationOnSpace(BasicWS,ConfigStruct_B);
figure(2)
% PlotWorkSpace(WS_B,"Plot_CellInd",true)

[Config_A, Config_B] = GroupMatrixMatching(Config_A,Config_B);

Tree = TreeClass("", N, 1e3, Config_A,"EndConfig",Config_B,"ZoneMatrix",false);

%% start algorithm


