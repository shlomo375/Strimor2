%% get shape from user
close all
clear
N = 15;

Size = [ceil(N/2), N];
BasicWS = WorkSpace(Size,"RRT*");

figure(2)
PlotWorkSpace(BasicWS,[]);
[WSStart, ~] = GetAgentFromUser(BasicWS,1);
[WSStart1, ~] = GetAgentFromUser(WSStart,2);
Configuration = GetConfiguration(WSStart1);

WS = SetConfigurationOnSpace(BasicWS,Configuration,2)
PlotWorkSpace(WS,[]);

path = ConfigStruct2Node(Configuration,1,1);
figure
Agent = find(WS.Space.Status)
PlotWorkSpace(WS,[],Agent,1);
hold on
Agent = find(WS.Space.Status==2)
PlotWorkSpace(WS,[],Agent,10);
% MakeVideoOfPath(path,15,120,"Collition_1.avi")