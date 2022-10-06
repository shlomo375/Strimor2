close all;
clear;
load('RRTtree\30N\StartConfig.mat');

FileName = "N12";
ArrayLength = 100000;
N = 19;
% Size = [round((N-1)/2) N-1];
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");

% figure(1)
% PlotWorkSpace(BasicWS);
% [WSStart, ~] = GetAgentFromUser(BasicWS,1);
% Configuration = GetConfiguration(WSStart);
load("Car36.mat");
TreeArray = CreatTreeArray(ArrayLength);
% node = CreatRRT_Node(-1, -1, Configuration, []);
TreeArray(1) = node; 


% figure(2)
% PlotWorkSpace(BasicWS);
% [WSTarget, ~] = GetAgentFromUser(BasicWS,1);
% ConfigTarget = GetConfiguration(WSTarget);

%   status == , ampty=0, occupied=1
% WS = SetConfiguration(BasicWS,1,[170:175 185:190 200:205 215:220 230:235] )
WS = SetConfigurationOnSpace(BasicWS,Configuration);
% PlotWorkSpace(WS);
% [WS, Agent] = SpaceCentering(WS);

% PlotWorkSpace(WS);

% for i=1:1000000
LastNodeIndex = 2;
NodeIndex = 1;
TimeFromStart = tic;
TimePrint = tic;
Success = 0;
while(~Success)
    LoopTime = tic;
    ParentInd = TreeArray(NodeIndex).Index;
    
    Parts =  AllSlidingParts(WS);
    NumNodeAdded = LastNodeIndex;
    [TreeArray, LastNodeIndex, Success] = MovingEachIndividualPart(WS, Parts, LastNodeIndex, ParentInd, TreeArray, FileName, ArrayLength, ConfigTarget);
    NumNodeAdded = LastNodeIndex - NumNodeAdded;
    fprintf('%s\n',"num of Node added: "+NumNodeAdded);
    
    if Success
        break
    end

    NumNodeAdded = LastNodeIndex;
    [Combinations, NumOfCombinations] = MakeRandomPartsCombinations(Parts,0.001*NumNodeAdded);
    fprintf('%s\n',"num of comb was make: "+NumOfCombinations);
    [TreeArray, LastNodeIndex, Success] = MovingEachIndividualPart(WS, Combinations, LastNodeIndex, ParentInd, TreeArray, FileName, ArrayLength, ConfigTarget);
    NumNodeAdded = LastNodeIndex - NumNodeAdded;
    fprintf('%s\n',"num of comb was Added: "+NumNodeAdded);


    fprintf('%s\n',"Time from the start: "+toc(TimeFromStart), ...
                   "Time for this config: "+toc(LoopTime), ...
                    "num of all config found: "+LastNodeIndex);
    fprintf('%s\n\n',"");
    try
        NodeIndex = randi(sum([TreeArray.Index]~=0));
        ParentInd = TreeArray(NodeIndex).Index;
        WS = SetConfigurationOnSpace(BasicWS, TreeArray(NodeIndex).Config);
    catch e
        fprintf(e.identifier);
    end
    
    if toc(TimePrint)>30
        TimePrint = tic;
        PlotWorkSpace(WS);
        plotIndex = NodeIndex;
        drawnow;
    end
end

if Success
    fprintf('%s\n\n\n\n',"Success");
end
