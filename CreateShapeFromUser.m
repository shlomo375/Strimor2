%% create new Shape

N = 30;
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");
figure(1233);
PlotWorkSpace(BasicWS,"Plot_FullWorkSpace",true);
[WSStart, ~] = GetAgentFromUser(BasicWS,1);
% [WSStart1, ~] = GetAgentFromUser(WSStart,2);
Configuration = GetConfiguration(WSStart);
% 
WS = SetConfigurationOnSpace(BasicWS,Configuration,2);
PlotWorkSpace(WS,"Plot_CellInd",true);
%% add manualy
Configuration = GetConfiguration(WS);
WS = SetConfigurationOnSpace(BasicWS,Configuration,2);
PlotWorkSpace(WS,"Plot_CellInd",true);
ConfigurationNode = ConfigStruct2Node(Configuration);
ConfigurationNode = AddIsomorphismMatToConfig(ConfigurationNode,false);
% save("Strimor2\SimpleShapeAlg\Shapes\Configs.mat","Config_A","Config_B");
% 
