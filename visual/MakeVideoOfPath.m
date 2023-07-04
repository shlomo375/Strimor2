function frames = MakeVideoOfPath(Path, FPS, PathName,stills,Background)
tic
close all
N = nnz(Path.ConfigMat{1});
MovingAgentIndex = 10;
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");

Path = flip(Path,1);
NumberOfMove = size(Path,1);

MoveNumber = zeros(1,NumberOfMove*2*FPS);
Loc = zeros(N,NumberOfMove*2*FPS,2);
C = zeros(N,NumberOfMove*2*FPS); 
Type = zeros(N,NumberOfMove*2*FPS);
k=1;
t= tic
for ii = 1:NumberOfMove
    Config.Status = Path.ConfigMat{ii};
    Config.Type = Path.Type(ii);
    [WS,MovingAgent] = SetConfigurationOnSpace(BasicWS,Config,10);

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
    
    FramePerStep = linspace(0,1,FPS*mean(abs(step)));
%     FramePerStep = linspace(0,1,FPS*abs(step));

    
%     ds = [dx;dy].*FramePerStep.*ones(1,1,sum(MovingAgentLoc));
    ds = permute([dx;dy],[1,3,2]).*FramePerStep;

    try
    CenterLoc(MovingAgentLoc,:,:) = CenterLoc(MovingAgentLoc,:,:) + permute(ds,[3 2 1]);
    catch e
        e
    end
    
    Color = ones(size(CenterLoc,1),1);
    Color(MovingAgentLoc,:) = MovingAgentIndex .* ones(sum(MovingAgentLoc),1);
    
    MoveNumber(k:k-1+numel(FramePerStep)) = (NumberOfMove-ii).*ones(1,numel(FramePerStep));
%     MoveNumber = [MoveNumber, (ii+1).*ones(1,numel(FramePerStep))];
    AgentType = WS.Space.Type(Agent);
    Loc(:,k:k-1+numel(FramePerStep),:) = CenterLoc;
    C(:,k:k-1+numel(FramePerStep)) = Color.*ones(1,size(CenterLoc,2));
    Type(:,k:k-1+numel(FramePerStep)) = AgentType.*ones(1,size(CenterLoc,2));
    k = k + numel(FramePerStep);
    fprintf("Step: %d/%d, time: %s",ii,NumberOfMove,toc(t))
    toc
end
Delete_Col = all(~C,1);
C(:,Delete_Col) = [];
Loc(:,Delete_Col,:) = [];
Type(:,Delete_Col,:) = [];
save("SimpleShapeAlg\Shapes\LocFile.mat");
%%
% MoveNumber = MoveNumber-1;
C(:,1) = deal(1);
C(:,end) = deal(1);

%% keep central mass
% ShapeCenter = (max(Loc)+min(Loc))/2;
% ShapeCenter(:,:,1) = 0;
% Loc = Loc - ShapeCenter;
Loc(:,1:1+FPS-1,:) = Loc(:,1:1+FPS-1,:) - repmat(((max(Loc(:,1,:))+min(Loc(:,1,:)))/2),[size(Loc,1),FPS]);
for jj = 1+FPS:FPS:size(Loc,2)
    Loc(:,jj:jj+FPS-1,:) = Loc(:,jj:jj+FPS-1,:) - repmat(((max(Loc(:,jj,:))+min(Loc(:,jj,:)))/2) - ((max(Loc(:,jj-1,:))+min(Loc(:,jj-1,:)))/2),[size(Loc,1),FPS]);
end

StartShapeCenter = (max(Loc(:,1,:))+min(Loc(:,1,:)))/2;
EndShapeCenter = (max(Loc(:,end,:))+min(Loc(:,end,:)))/2;

Displacment = EndShapeCenter-StartShapeCenter;
d_CM = Displacment.*linspace(0,1,size(Loc,2));
% Loc = Loc - d_CM;
%%

video = VideoWriter(PathName);
video.Quality = 100;
video.FrameRate = 60;

figure(100)
% figure("Name","video","Position",[1	49	1536	740.800000000000])%
cla;
xlimit = [min(Loc(:,:,1),[],'all')-7-sqrt(3)/2, max(Loc(:,:,1),[],'all')+7+sqrt(3)/2];
ylimit = [min(Loc(:,:,2),[],'all')-7-sqrt(3)/2, max(Loc(:,:,2),[],'all')+7+sqrt(3)/2];
% axis([xlimit,ylimit])
plot([xlimit';xlimit'],[ylimit(1);ylimit(1);ylimit(2);ylimit(2)],".r");
axis equal
MoveNumText.x = xlimit(1)+6;
MoveNumText.y = ylimit(2)-5;
MoveNumText.value = MoveNumber(1);
MoveNumText.handel = [];


TargetLoc = Loc(:,end,:)  +d_CM;
% [p.S,~,MoveNumText] = PlotTriangle(permute(Loc(:,1,:),[1 3 2]), Type(:,1), C(:,1),[],[],[],MoveNumText);
[p.S,~,MoveNumText] = PlotTriangle(permute(Loc(:,1,:),[1 3 2]), Type(:,1), C(:,1),[],[],[],[]);
if exist("Background","var")
    [p.T] = PlotTriangle(permute(TargetLoc(:,end,:),[1 3 2]), Type(:,end), 11*ones(N,1),[],[],[],[]);
end

if exist("stills","var")
    if ~isempty(stills)
        saveas(p,stills+"1"+".png");
    end
end

drawnow
pause(2);

% exportgraphics(gcf,"ArticleMovie\Plot.png","Resolution",600)

% I = imread("Plot.png");
% frames = zeros([size(I),size(Loc,2)+2*video.FrameRate]);
% frames(:,:,:,1:video.FrameRate) = repmat(imread("ArticleMovie\Plot.png"),[1,1,1,video.FrameRate]);
% frames(1:video.FrameRate) = deal(getframe);
% for kk = 1:10
%     exportgraphics(gca,extractBefore(PathName,".")+".gif","Append",true);
% end
FigureHandels = cell(1,size(Loc,2));
Lastjj = 1;
close all
% frames= uint8()
for jj = 1:size(Loc,2)
    FigureHandels{jj} = figure(jj);
    hold on
    fprintf("progress: "+string(jj)+"/"+string(size(Loc,2))+"time: "+string(toc)+"\n");
%     xlim([min(Loc(:,:,1),[],'all')-1-sqrt(3)/2, max(Loc(:,:,1),[],'all')+1+sqrt(3)/2]);
%     ylim([min(Loc(:,:,2),[],'all')-1-sqrt(3)/2, max(Loc(:,:,2),[],'all')+1+sqrt(3)/2]);
    MoveNumText.value = MoveNumber(jj);
%     [p.S,~,MoveNumText] = PlotTriangle(permute(Loc(:,j,:),[1 3 2]), Type(:,j), C(:,j),[],p.S,[],MoveNumText);
%     if exist("Background","var")
%         [p.T] = PlotTriangle(permute(TargetLoc(:,end-j+1,:),[1 3 2]), Type(:,end), 11*ones(N,1),[],p.T,[],[]);
%     end
plot([xlimit';xlimit'],[ylimit(1);ylimit(1);ylimit(2);ylimit(2)],".r");
%     [p.S,~,MoveNumText] = PlotTriangle(permute(Loc(:,jj,:),[1 3 2]), Type(:,jj), C(:,jj),[],[],[],MoveNumText);
[p.S,~,MoveNumText] = PlotTriangle(permute(Loc(:,jj,:),[1 3 2]), Type(:,jj), C(:,jj),[],[],[],[]);    
if exist("Background","var")
        [p.T] = PlotTriangle(permute(TargetLoc(:,end-jj+1,:),[1 3 2]), Type(:,end), 11*ones(N,1),[],[],[],[]);
end
        drawnow
%     frames(j+video.FrameRate-1) = getframe;
axis equal


    % exportgraphics(gcf,"ArticleMovie\Plot.png","Resolution",600)

    % frames(:,:,:,jj) = imread("ArticleMovie\Plot.png");

% SaveEvery = 100;
% if ~mod(jj,SaveEvery) || jj==size(Loc,2)
%     drawnow
%     CellFrames = cell(1,size(Loc,2));
%     End = Lastjj+SaveEvery-1;
%     if End>size(Loc,2)
%         End = size(Loc,2);
%     end
% 
%     parfor kk = Lastjj:End
%     
%         exportgraphics(FigureHandels{kk},"ArticleMovie\Plot"+string(kk)+".png","Resolution",600)
%         CellFrames{kk} = imread("ArticleMovie\Plot"+string(kk)+".png");
%         
%         disp(kk)
%     end
%     Lastjj = jj+1;
%     close all
% end

%     exportgraphics(gca,extractBefore(PathName,".")+".gif","Append",true);
%     pause(0.1)
 
    % if exist("stills","var")
    %     if ~isempty(stills)
    %         saveas(p,stills+string(jj)+".png");
    %     end
    % end
end
drawnow
pause(2)


% exportgraphics(gcf,"ArticleMovie\Plot.png","Resolution",600)


% frames(:,:,:,end+1:end+video.FrameRate) = repmat(imread("ArticleMovie\Plot.png"),[1,1,1,video.FrameRate]);
% frames = cat(4,CellFrames{:});
frames = flip(frames,4);
open(video);
writeVideo(video,frames);
close(video);
close all
end

