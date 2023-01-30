%% Line flattening algorithm


function [Sucsses, Path] = OneGroupLineFlatteningAlgorithm(Config,Flat)
%%
Sucsses = true;
N = sum(logical(Config.ConfigMat{:}),"all");

ConfigStruct = Node2ConfigStruct(Config);
% PlotWorkSpace(WS,[]);
WsSize = [N, 2*N];
BasicWS = WorkSpace(WsSize,"RRT*");
WS = SetConfigurationOnSpace(BasicWS,ConfigStruct);
%%

Tree = TreeClass("", N, 1e3, Config,Flat);

% figure(1)
% PlotWorkSpace(WS,[],[]);
%%
SpreadingDir = -1;
ParentInd = 1;
OldWS = WS;
Break = 0;
while 1

[WS, Tree,  ParentInd] = SpreadingAllAtOnes(WS,Tree,ParentInd,SpreadingDir);
% figure(2)
% PlotWorkSpace(WS,[],[]);
% [tree,WS, GroupInd] = SpreadingOneGroupInLine(WS,Tree,GroupInd,1,1,1);
% PlotWorkSpace(WS,[],[]);

[WS,Tree, ParentInd] = ReducingRowsOneGroupInLine(WS, Tree, ParentInd, SpreadingDir);
% figure(3)
% PlotWorkSpace(WS,[],[]);

[WS,Tree, ParentInd] = FlatteningSpecialLines(WS,Tree, ParentInd);
% figure(4)
% PlotWorkSpace(WS,[],[]);

[WS,Tree, ParentInd] =  GroupsUnification(WS, Tree, ParentInd);
% figure(5)
% PlotWorkSpace(WS,[],[]);

[WS,Tree, ParentInd] =  DualModuleOnly(WS, Tree, ParentInd);

[WS,Tree, ParentInd, Finish] = FlatCompare(Flat, WS,Tree, ParentInd);
if Finish
    break
end
if isequal(WS.Space.Status,OldWS.Space.Status)
    Break = Break+1;
    if Break > 5
        Sucsses = false;
        break
    end
end
% figure(6)
% PlotWorkSpace(WS,[],[]);
SpreadingDir = -SpreadingDir;
end

Path = Tree.Data(1:Tree.LastIndex,:);
