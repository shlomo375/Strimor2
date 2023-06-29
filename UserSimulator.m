SoftwareLocation = pwd;
AddDirToPath();
% clear
% Path = TargetConfig;
% load('CompletePath.mat', 'Path');
% Path = P;
% Path = flip(Path);
close all
Agent2move = [];
N = 10;
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");
figure(2)
path =table;
% PlotWorkSpace(BasicWS,[]);
FirstConfig = true;
while true
%     for ii = 1:size(Path,1)
%         figure(ii)
% [Config,Movement] = Node2ConfigStruct(Path(ii,:));
% Config.Status = logical(Config.Status);
% [WS,MovingAgent] = SetConfigurationOnSpace(BasicWS,Config,2);
% Agent = find(WS.Space.Status);
% PlotWorkSpace(WS,[],Agent,1);
% 
%     end
% PlotWorkSpace(WS,[]);

% Parts =  AllSlidingParts(WS);
% [~, Agent2move] = GetAgentFromUser(WS,1);

% prompt = {'Enter axis:','Enter number of steps:'};
% dlgtitle = 'Input';
% dims = [1 35];
% definput = {'1','1'};
% answer = inputdlg(prompt,dlgtitle,dims,definput);
% dir = str2num(answer{1});
% step = str2num(answer{2});
% 
% for ii_Parts = 1:numel(Parts{dir})
%     Group = Parts{dir}{ii_Parts};
%     if any(ismember(Agent2move,Group))
%         Agent2move = unique([Agent2move(:);Group(:)]);
%     end
% end
% 
% [OK, Config, Movment, CollidingAgent] = MakeAMove(WS,dir,step, Agent2move);
% if OK
%     Node = ConfigStruct2Node(Config,Movment.dir,Movment.step);
%     WS = SetConfigurationOnSpace(BasicWS,Config,2);
%     Agent = find(WS.Space.Status);
%     figure(2)
%     PlotWorkSpace(WS,[],Agent,1);
% 
%     Path = [Path;Node];
% else
%     fprintf("wrong move...")
% end



% Node = ConfigStruct2Node(Config,dir,step)
if FirstConfig
    PlotWorkSpace(BasicWS,"Plot_FullWorkSpace",true)
    [WSStart, ~] = GetAgentFromUser(BasicWS,1);
    FirstConfig = false;
else
    WSStart1.Space.Status(WSStart1.Space.Status~=0) = 1;
    PlotWorkSpace(WSStart1,"Plot_FullWorkSpace",true)
    [WSStart1, ~] = GetAgentFromUser(WSStart1,0);
    PlotWorkSpace(WSStart1,"Plot_FullWorkSpace",true)
    [WSStart, ~] = GetAgentFromUser(WSStart1,1);
end
PlotWorkSpace(WSStart,"Plot_FullWorkSpace",false);
[WSStart1, ~] = GetAgentFromUser(WSStart,10);
PlotWorkSpace(WSStart1,"Plot_FullWorkSpace",false,"Set_SpecificAgentInd",1,"Plot_FullWorkSpace_NoLattice",true);
Configuration = GetConfiguration(WSStart1);

% 
WS = SetConfigurationOnSpace(BasicWS,Configuration,2);
txt  =input("img name:","s");
exportgraphics(gcf,fullfile("SimpleShapeAlg","Media","ManuversImg",join([txt,".png"],"")),"Resolution",1200)
% 
Node = CreateNode(1);
path(end+1,:) = ConfigStruct2Node(Node,Configuration);
% pause
% figure
% Agent = find(WS.Space.Status)
% PlotWorkSpace(WS,[],Agent,1);
% hold on
% Agent = find(WS.Space.Status==10)
% PlotWorkSpace(WS,[],Agent,10);
    

end

