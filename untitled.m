%% Simple Shape Algorithm

load("Problems18.mat","TotalProblem","Solutions","Flat");
N = sum(logical(Config.ConfigMat{:}),"all");

ConfigStruct = Node2ConfigStruct(Config);
% PlotWorkSpace(WS);
WsSize = [N, 4*N];
BasicWS = WorkSpace(WsSize,"RRT*");
WS = SetConfigurationOnSpace(BasicWS,ConfigStruct);
%%

Tree = TreeClass("", N, 1e3, Config,Flat);

% figure(1)
% PlotWorkSpace(WS,[]);
%%
SpreadingDir = "Left_Right";
ParentInd = 1;
OldWS = WS;
Break = 0;

TimeOut_Clock = tic;
while 1
try
if toc(TimeOut_Clock) > TimeOut && TimerON
    Sucsses = false;
    Path = Tree.Data(1:Tree.LastIndex,:);
    return
end
% figure(3)
% PlotWorkSpace(WS,[]);
[WS,Tree, ParentInd] = SpreadAndReduce(WS,Tree, ParentInd,SpreadingDir);
% PlotWorkSpace(WS,"Plot_CellInd",true)
[WS,Tree, ParentInd] = Expend(WS,Tree, ParentInd,SpreadingDir);

[WS,Tree, ParentInd] = FlatteningSpecialLines(WS,Tree, ParentInd);

% figure(4)
% PlotWorkSpace(WS,[]);

[WS,Tree, ParentInd] =  GroupsUnification(WS, Tree, ParentInd);

[WS,Tree, ParentInd] =  BaseUnification(WS, Tree, ParentInd);
% figure(5)
% PlotWorkSpace(WS,[]);

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
% PlotWorkSpace(WS,[]);
SpreadingDir = setdiff(["Left_Right","Right_Left"],SpreadingDir);
catch eee
    eee
end
end

Path = Tree.Data(1:Tree.LastIndex,:);
