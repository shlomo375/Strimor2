%RRT*
clear

load('CarConfig_50N.mat');

algorithm ="RRT*"; 
N = sum([StartConfig.Status],'all');
Size = [N, 2*N];

% TreeLength = 1e6 + 1000;
FileName = "N"+num2str(N)+...
        "_StartConfig_" + StartConfig.Dec +...
        "_EndConfig_" + EndConfig.Dec +"_";
tree = TreeClass(FileName, N, StartConfig, EndConfig);

% tree = LoadTree(tree, FileName);

BasicWS = WorkSpace(Size,algorithm);


WS = SetConfigurationOnSpace(BasicWS,StartConfig);

NodeIndex = 1;
% [tree, Config.Status, Config.Type] = Get(tree,NodeIndex,"Config","Type");
% WS = SetConfigurationOnSpace(BasicWS,Config);

LastNodeIndex = 2;


SaveFlag = 0;
ConfigFromCombination = 0;
TimeFromStart = tic;
flag = [];
while(isempty(flag))
% for q=1:1e6
    
    [~, ParentInd] = Get(tree,NodeIndex,"Index");
  
    Parts =  AllSlidingParts(WS);
    [tree, flag] = MovingEachIndividualPart(WS, Parts, ParentInd, tree);

    if ~isempty(flag)
        break
    end
    temp = tree.LastIndex;
    [Combinations, NumOfCombinations] = MakeRandomPartsCombinations(Parts,(1+ConfigFromCombination)*N);
    [tree, flag] = MovingEachIndividualPart(WS, Combinations, ParentInd, tree);
    ConfigFromCombination = tree.LastIndex - temp;


    NodeIndex = RandConfig(tree,1);
    [tree, Config.Status, Config.Type] = Get(tree,NodeIndex,"Config","Type");
    if isempty(Config.Status)
        d=5;
    end
    WS = SetConfigurationOnSpace(BasicWS, Config);

    if toc(TimeFromStart)>7000
        break
    end
    fprintf('%s\n',"Time from the start: "+toc(TimeFromStart), ...
                    "num of all config found: "+tree.LastIndex, ...
                    "config per second: "+ tree.LastIndex/toc(TimeFromStart), ...
                    "number of Parts was try: "+ (numel(Parts{1})+numel(Parts{2})+numel(Parts{3})),...
                    "number of Combinations was try: "+ NumOfCombinations+ " config found: "+ConfigFromCombination,"");
end

fprintf('%s\n',flag);

