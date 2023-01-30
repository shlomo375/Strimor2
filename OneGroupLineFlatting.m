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

ConfigStruct = Node2ConfigStruct(Config);
% PlotWorkSpace(WS,[]);
WsSize = [N, 2*N];
BasicWS = WorkSpace(WsSize,"RRT*");
WS = SetConfigurationOnSpace(BasicWS,ConfigStruct);
%%

tree = TreeClass("", N, 1e3, Config,Flat);

% figure(1)
% PlotWorkSpace(WS,[],[]);
%%
SpreadingDir = -1;
ParentInd = 1;
while 1

[WS, tree,  ParentInd, GroupsSizes, GroupInd] = SpreadingAllAtOnes(WS,tree,ParentInd,SpreadingDir);
% figure(2)
% PlotWorkSpace(WS,[],[]);
% [tree,WS, GroupInd] = SpreadingOneGroupInLine(WS,Tree,GroupInd,1,1,1);
% PlotWorkSpace(WS,[],[]);

[WS,tree, ParentInd] = ReducingRowsOneGroupInLine(WS, tree, ParentInd, SpreadingDir, GroupsSizes, GroupInd);
% figure(3)
% PlotWorkSpace(WS,[],[]);

[WS,tree, ParentInd] = FlatteningSpecialLines(WS,tree, ParentInd);
% figure(4)
% PlotWorkSpace(WS,[],[]);

[WS,tree, ParentInd] =  GroupsUnification(WS, tree, ParentInd);
% figure(5)
% PlotWorkSpace(WS,[],[]);

[WS,tree, ParentInd, Finish] = FlatCompare(Flat, WS,tree, ParentInd);
if Finish
    break
end
% figure(6)
% PlotWorkSpace(WS,[],[]);
SpreadingDir = -SpreadingDir;
end                     
% figure(2)
% PlotWorkSpace(WS,[],[]);