%% Line flattening algorithm
clear
close all
SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);

%%
% N = 15;
% Size = [N, 2*N];
% BasicWS = WorkSpace(Size,"RRT*");
% 
% 
% [WSTarget, ~] = GetAgentFromUser(BasicWS,1);
% UserConfig = GetConfiguration(WSTarget);
% 
% WS = SetConfigurationOnSpace(BasicWS,UserConfig);
% PlotWorkSpace(WS,[]);
% 
% Config = ConfigStruct2Node(UserConfig);

% save(fullfile("TestCase","OneGroupInRow.mat"),"Config");
%%

load(fullfile('TestCase','OneGroupInRow.mat'),"Config","Flat");
N = sum(logical(Config.ConfigMat{:}),"all");

ConfigStruct.Status = Config.ConfigMat{:};
ConfigStruct.Type = Config.Type;

WsSize = size(Config.ConfigMat{:})+[5,9];
BasicWS = WorkSpace(WsSize,"RRT*");

WS = SetConfigurationOnSpace(BasicWS,ConfigStruct);
% PlotWorkSpace(WS,[]);
WsSize = [N, 2*N];
BasicWS = WorkSpace(WsSize,"RRT*");
WS = SetConfigurationOnSpace(BasicWS,ConfigStruct);
%%

Tree = TreeClass("", N, 1e3, Config,Flat);

figure(1)
PlotWorkSpace(WS,[],[]);
%%
while 1
% [GroupInd, GroupIndexes] = ModuleIndSortByRow(WS.Space.Status);

SpreadingDir = 1;
ParentInd = 1;
[tree, WS, ParentInd, GroupsSizes, GroupInd] = SpreadingAllAtOnes(WS,Tree,ParentInd,SpreadingDir);
figure(2)
PlotWorkSpace(WS,[],[]);
% [tree,WS, GroupInd] = SpreadingOneGroupInLine(WS,Tree,GroupInd,1,1,1);
% PlotWorkSpace(WS,[],[]);

[WS,tree, ParentInd] = ReducingRowsOneGroupInLine(WS, tree, ParentInd, SpreadingDir, GroupsSizes, GroupInd);
figure(3)
PlotWorkSpace(WS,[],[]);

[WS,tree, ParentInd] = FlatteningSpecialLines(WS,tree, ParentInd);
figure(4)
PlotWorkSpace(WS,[],[]);
[WS,tree, ParentInd] =  GroupsUnification(WS, tree, ParentInd);
figure(5)
PlotWorkSpace(WS,[],[]);
end
 f=5                          
