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


%%
SpreadingOneGroupInLine(WS,1,1,Tree,1)
Parts =  AllSlidingParts(WS,N);
        
Combinations = MakeRandomPartsCombinations(Parts,ConfigVisits,"Partial");  

[TreeProperty.tree,success] = MovingEachIndividualPartPCDepth(TreeProperty.tree, WS, Combinations, NodeIndex);
                           
