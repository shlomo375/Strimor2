SoftwareLocation = pwd;
AddDirToPath();
% clear
% Path = TargetConfig;
% load('CompletePath.mat', 'Path');
% Path = P;
% Path = flip(Path);
close all
Agent2move = [];
N = 15;
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");
figure(2)

% PlotWorkSpace(BasicWS,[]);
while true
    for ii = 1:size(Path,1)
        figure(ii)
[Config,Movement] = Node2ConfigStruct(Path(ii,:));
Config.Status = logical(Config.Status);
[WS,MovingAgent] = SetConfigurationOnSpace(BasicWS,Config,2);
Agent = find(WS.Space.Status);
PlotWorkSpace(WS,[],Agent,1);

    end
% PlotWorkSpace(WS,[]);

Parts =  AllSlidingParts(WS);
[~, Agent2move] = GetAgentFromUser(WS,1);

prompt = {'Enter axis:','Enter number of steps:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'1','1'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
dir = str2num(answer{1});
step = str2num(answer{2});

for ii_Parts = 1:numel(Parts{dir})
    Group = Parts{dir}{ii_Parts};
    if any(ismember(Agent2move,Group))
        Agent2move = unique([Agent2move(:);Group(:)]);
    end
end

[OK, Config, Movment, CollidingAgent] = MakeAMove(WS,dir,step, Agent2move);
if OK
    Node = ConfigStruct2Node(Config,Movment.dir,Movment.step);
    WS = SetConfigurationOnSpace(BasicWS,Config,2);
    Agent = find(WS.Space.Status);
    figure(2)
    PlotWorkSpace(WS,[],Agent,1);

    Path = [Path;Node];
else
    fprintf("wrong move...")
end


% Node = ConfigStruct2Node(Config,dir,step)
% [WSStart, ~] = GetAgentFromUser(BasicWS,1);
% [WSStart1, ~] = GetAgentFromUser(WSStart,2);
% Configuration = GetConfiguration(WSStart1);
% 
% WS = SetConfigurationOnSpace(BasicWS,Configuration,2)
% PlotWorkSpace(WS,[]);
% 
% path = ConfigStruct2Node(Configuration,1,1);
% figure
% Agent = find(WS.Space.Status)
% PlotWorkSpace(WS,[],Agent,1);
% hold on
% Agent = find(WS.Space.Status==2)
% PlotWorkSpace(WS,[],Agent,10);
    

end

