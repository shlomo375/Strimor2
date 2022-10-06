function MakeVideoOfPath(Path, N, FPS, PathName,stills)
MovingAgentIndex = 10;
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");
MoveNumber = [];
Loc = [];
C = [];
Type = [];
Path = flip(Path,1);
NumberOfMove = size(Path,1);


for ii = 1:NumberOfMove
    Config.Status = Path.ConfigMat{ii};
    Config.Type = Path.Type(ii);
    [WS,MovingAgent] = SetConfigurationOnSpace(BasicWS,Config);
%     figure(ii)
%     PlotWorkSpace(WS,1);
%     Agent = find(WS.Space.Status)';
    PlotWorkSpace(WS,[],MovingAgent,2);
%     MovingAgent = ismember(Agent, Path(ii+1).Movment.Agent);
    
    
    step = -Path.Step(ii);
    dir = Path.Dir(ii);
    switch dir
        case 1
            dx = 2 * step;
            dy = 0;
        case 2
            dx = step;
            dy = -step;
        case 3
            dx = step;
            dy = step;
    end

    [y,x] = find(Config.Status);
    Agent = find(WS.Space.Status);
    MovingAgentLoc = ismember(Agent,MovingAgent);
    CenterLoc = permute([x,y],[1 3 2]);
    CenterLoc = CenterLoc + zeros(size(CenterLoc,1),FPS*abs(step),2);
    
    FramePerStep = linspace(0,1,FPS*abs(step));
    
    ds = [dx;dy].*FramePerStep.*ones(1,1,sum(MovingAgentLoc));

    try
    CenterLoc(MovingAgentLoc,:,:) = CenterLoc(MovingAgentLoc,:,:) + permute(ds,[3 2 1]);
    catch e
        e
    end
    
    Color = ones(size(CenterLoc,1),1);
    Color(MovingAgentLoc,:) = MovingAgentIndex .* ones(sum(MovingAgentLoc),1);
    
    MoveNumber = [MoveNumber, ii.*ones(1,numel(FramePerStep))];
    AgentType = WS.Space.Type(Agent);
    Loc = [Loc , CenterLoc];
    C = [C, Color.*ones(1,size(CenterLoc,2))];
    Type = [Type, AgentType.*ones(1,size(CenterLoc,2))];
end
MoveNumber = MoveNumber-1;
C(:,1) = deal(1);
C(:,end) = deal(1);
ShapeCenter = (max(Loc)+min(Loc))/2;
ShapeCenter(:,:,1) = 0;
Loc = Loc - ShapeCenter;
%frames = 

video = VideoWriter(PathName);
video.Quality = 100;
video.FrameRate = 30;


figure(100)%
cla;
xlimit = [min(Loc(:,:,1),[],'all')-5-sqrt(3)/2, max(Loc(:,:,1),[],'all')+5+sqrt(3)/2];
ylimit = [min(Loc(:,:,2),[],'all')-5-sqrt(3)/2, max(Loc(:,:,2),[],'all')+5+sqrt(3)/2];
axis([xlimit,ylimit])
MoveNumText.x = xlimit(1)+4;
MoveNumText.y = ylimit(2)-3;
MoveNumText.value = MoveNumber(1);
MoveNumText.handel = [];

[p] = PlotTriangle(permute(Loc(:,1,:),[1 3 2]), Type(:,1), C(:,1));

if nargin > 4
    saveas(p,stills+"1"+".png");
end
ImgIdx = 1;
exportgraphics(gca,string(ImgIdx)+".jpg","Resolution",300)
ImgIdx = ImgIdx +1;
% I = imread("Plot.jpg");
% frames = zeros([size(I),size(Loc,2)+2*video.FrameRate]);
% frames(:,:,:,1:video.FrameRate) = repmat(imread("Plot.jpg"),[1,1,1,video.FrameRate]);
% frames(1:video.FrameRate) = deal(getframe);
% for kk = 1:10
%     exportgraphics(gca,extractBefore(PathName,".")+".gif","Append",true);
% end
for j = 2:size(Loc,2)
%     xlim([min(Loc(:,:,1),[],'all')-1-sqrt(3)/2, max(Loc(:,:,1),[],'all')+1+sqrt(3)/2]);
%     ylim([min(Loc(:,:,2),[],'all')-1-sqrt(3)/2, max(Loc(:,:,2),[],'all')+1+sqrt(3)/2]);
    MoveNumText.value = MoveNumber(j);
    [p] = PlotTriangle(permute(Loc(:,j,:),[1 3 2]), Type(:,j), C(:,j),[],p);
%     drawnow
%     frames(j+video.FrameRate-1) = getframe;
    exportgraphics(gca,string(ImgIdx)+".jpg","Resolution",300)
    ImgIdx = ImgIdx +1;
%     frames(:,:,:,j+video.FrameRate-1) = imread("Plot.jpg");
%     exportgraphics(gca,extractBefore(PathName,".")+".gif","Append",true);
%     pause(0.1)
if j==12
    d=5
end
    if nargin > 4
        saveas(p,stills+string(j)+".png");
        
    end
end
exportgraphics(gca,string(ImgIdx)+".jpg","Resolution",300)
    ImgIdx = ImgIdx +1;

% frames(:,:,:,end+1:end+video.FrameRate) = repmat(imread("Plot.jpg"),[1,1,1,video.FrameRate]);

% frames(end:end+video.FrameRate) = deal(getframe);
% for kk = 1:10
%     exportgraphics(gca,"Media\"+extractBefore(PathName,".")+".gif","Append",true);
% end

open(video);
writeVideo(video,frames);
close(video);

end

