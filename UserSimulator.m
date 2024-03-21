SoftwareLocation = pwd;
AddDirToPath();
clear
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

folderName = uigetdir;
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

if FirstConfig
    PlotWorkSpace(BasicWS,"Plot_FullWorkSpace",true)
    [WS, ~] = GetAgentFromUser(BasicWS,1);
    
    Config = GetConfiguration(WS);
    Path = CreateNode(1);
    Path = ConfigStruct2Node(Path,Config);
    
    Path.ConfigMat{1} = cat(3,Path.ConfigMat{1});

    FirstConfig = false;
    PlotWorkSpace(WS,"Plot_FullWorkSpace",true)
    % PlotWorkSpace(WS,"Set_SpecificAgentInd",find(WS.Space.Status))
% else
%     WSStart1.Space.Status(WSStart1.Space.Status~=0) = 1;
%     PlotWorkSpace(WSStart1,"Plot_FullWorkSpace",true)
%     [WSStart1, ~] = GetAgentFromUser(WSStart1,0);
%     PlotWorkSpace(WSStart1,"Plot_FullWorkSpace",true)
%     [WS, ~] = GetAgentFromUser(WSStart1,1);
end

figure(2)
Parts =  AllSlidingParts(WS);
[~, Agent2move] = GetAgentFromUser(WS,1);
figure(123);close(123);ff = figure(123); PlotWorkSpace(WS,"Plot_FullWorkSpace_NoLattice",true,"Set_SpecificAgentInd",Agent2move)

saveFigureAxes(ff, folderName)
pause
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
%%
[OK, Config, Movment, CollidingAgent] = MakeAMove(WS,dir,step, Agent2move);
%%
if OK
    Node = CreateNode(1);
    Node = ConfigStruct2Node(Node,Config,Movment.dir,Movment.step);
    
    Node.ConfigMat{1} = cat(3,Node.ConfigMat{1},Config.AgentID);

    WS = SetConfigurationOnSpace(BasicWS,Config,2);
    Agent = find(WS.Space.Status);
    figure(2)
    PlotWorkSpace(WS,"Plot_FullWorkSpace",true);

    Path = [Path;Node];
    WS.Space.Status(WS.Space.Status>1) = 1;
    WS.Space.AgentID(logical(WS.Space.Status)) = Config.AgentID(logical(Config.AgentID));
    figure(123); PlotWorkSpace(WS,"Plot_FullWorkSpace_NoLattice",true,"Set_SpecificAgentInd",Agent2move)
else
    fprintf("wrong move...")
end



% % Node = ConfigStruct2Node(Config,dir,step)
% if FirstConfig
%     PlotWorkSpace(BasicWS,"Plot_FullWorkSpace",true)
%     [WS, ~] = GetAgentFromUser(BasicWS,1);
%     FirstConfig = false;
% else
%     WSStart1.Space.Status(WSStart1.Space.Status~=0) = 1;
%     PlotWorkSpace(WSStart1,"Plot_FullWorkSpace",true)
%     [WSStart1, ~] = GetAgentFromUser(WSStart1,0);
%     PlotWorkSpace(WSStart1,"Plot_FullWorkSpace",true)
%     [WS, ~] = GetAgentFromUser(WSStart1,1);
% end
% PlotWorkSpace(WS,"Plot_FullWorkSpace",false);
% [WSStart1, ~] = GetAgentFromUser(WS,10);
% PlotWorkSpace(WSStart1,"Plot_FullWorkSpace",false,"Set_SpecificAgentInd",1,"Plot_FullWorkSpace_NoLattice",true);
% Configuration = GetConfiguration(WSStart1);
% 
% % 
% WS = SetConfigurationOnSpace(BasicWS,Configuration,2);
% txt  =input("img name:","s");
% exportgraphics(gcf,fullfile("SimpleShapeAlg","Media","ManuversImg",join([txt,".png"],"")),"Resolution",1200)
% % 
% Node = CreateNode(1);
% path(end+1,:) = ConfigStruct2Node(Node,Configuration);
% pause
% figure
% Agent = find(WS.Space.Status)
% PlotWorkSpace(WS,[],Agent,1);
% hold on
% Agent = find(WS.Space.Status==10)
% PlotWorkSpace(WS,[],Agent,10);
    

end


function saveFigureAxes(figureHandle, folderName)
    % Check if the input is a valid figure handle
    if ~ishandle(figureHandle) || ~strcmp(get(figureHandle, 'Type'), 'figure')
        error('Input must be a valid figure handle.');
    end

    % Check if the folder exists
    if ~exist(folderName, 'dir')
        error('The specified folder does not exist.');
    end

    % Get the file name from the user using a UI text box
    prompt = {'Enter the file name:'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'MyFigure'};
    fileName = inputdlg(prompt, dlgtitle, dims, definput);

    % Check if the user canceled the operation
    if isempty(fileName)
        disp('User canceled the operation.');
        return;
    end

    % Resize patch line widths to 2 if any patch objects are found
    patches = findobj(figureHandle, 'Type', 'patch');
    for i = 1:length(patches)
        patches(i).LineWidth = 1;
    end

    % Construct the full file paths
    pngFile = fullfile(folderName, [fileName{1}, '.png']);
    figFile = fullfile(folderName, [fileName{1}, '.fig']);

    % Save the axes to a PNG file
    ax = findobj(figureHandle, 'Type', 'axes');
    if ~isempty(ax)
        exportgraphics(ax, pngFile, 'Resolution', 300);
        disp(['Axes saved to PNG file: ', pngFile]);
    else
        disp('No axes found in the figure.');
    end

    % Save the figure to a FIG file
    savefig(figureHandle, figFile);
    disp(['Figure saved to FIG file: ', figFile]);
end

