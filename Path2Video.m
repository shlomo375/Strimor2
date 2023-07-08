function Path2Video(Path, FPS, PathName,BasicWS)
% mkdir(PathName);

N = nnz(Path.ConfigMat{1}(:,:,1));

Size = [N, 2*N];

%% add agant ID for the first config
BasicWS = WorkSpace(Size,"RRT*");
Config = Node2ConfigStruct(Path(1,:));
WS = SetConfigurationOnSpace(BasicWS,Config);

if size(Path.ConfigMat{1},3)==1
    Config = GetConfiguration(WS);
    Path.ConfigMat{1} = cat(3,Config.Status,Config.AgentID);
end

%% arrange all config path 
% into one matrix described the location of each module at after full step.
% also, create vector of step size
Locations = zeros(N,1,2);


[Loc(:,2),Loc(:,1),ID] = find(Path.ConfigMat{1}(:,:,2));
    [~,Sorted_Loc] = sort(ID);
Locations(:,1,:) = permute(Loc(Sorted_Loc,:),[1,3,2]);

TotalSteps = 2 + sum(abs(Path.Step));

Frames = zeros(N,TotalSteps*FPS,3);
Frames(:,1,1:2) = Locations(:,1,:);
Frames(:,:,3) = 1;
for idx = 1:size(Path,1)
    % get AgentID and Location
    % MovingAgent_ind = find(Path.ConfigMat{idx}(:,:,1)>1);
    IDs = Path.ConfigMat{idx}(:,:,2);
    % Frames(IDs(Path.ConfigMat{idx}(:,:,1)>1),idx,3) = 10;
end
 

% Frames(:,:,3) = 1;

AgentType = WS.Space.Type(WS.Space.Status>0);
FramePerStep = linspace(0,1,FPS);
LastFrame = 2;
for Location_Idx = 2:(size(Path,1))
    MovingAgent_logical = false(N,1);
    % ds = linspace(0,1,abs(Path.Step(Step_Idx))*FPS);
    fprintf("Steps: %d\n",Location_Idx);
    % MovingAgent_logical = any(Locations(:,Location_Idx-1,:) ~= Locations(:,Location_Idx,:),3);
    IDs = Path.ConfigMat{Location_Idx}(:,:,2);
    MovingAgent = IDs(Path.ConfigMat{Location_Idx}(:,:,1)>1);
    if ~isempty(MovingAgent)
        MovingAgent_logical(MovingAgent) = true;
    end
    step = Path.Step(Location_Idx);
    dir = Path.Dir(Location_Idx);

    switch dir
        case 1
            dx = 2 * sign(step);
            dy = 0;
        case 2
            dx = sign(step);
            dy = -sign(step);
        case 3
            dx = sign(step);
            dy = sign(step);
    end
    for stepIdx = 0:abs(step)-1
        ds = permute(permute([dx;dy],[1,3,2]).*FramePerStep,[3,2,1]);
        FrameRange = LastFrame:(LastFrame-1+FPS);
        Frames(:,FrameRange,1:2) = repmat((Frames(:,LastFrame-1,1:2)),1,numel(FramePerStep),1);
        Frames(MovingAgent_logical,FrameRange,1:2) = Frames(MovingAgent_logical,LastFrame-1,1:2) + ds;
        Frames(MovingAgent_logical,FrameRange,3) = 10;
        LastFrame = LastFrame + FPS;
    end

end

Delete_Col = all(~Frames(:,:,1),1);
Frames(:,Delete_Col,:) = [];
% save("SimpleShapeAlg\Shapes\FramesFile.mat");
%%
ClipMaxFrame = 200;
Batch = 45;
video = VideoWriter(join([PathName,"_1.mp4"],""));
video.Quality = 100;
video.FrameRate = 60;


xlimit = [min(Frames(:,:,1),[],'all')-1-sqrt(3)/2, max(Frames(:,:,1),[],'all')+1+sqrt(3)/2];
ylimit = [min(Frames(:,:,2),[],'all')-1-sqrt(3)/2, max(Frames(:,:,2),[],'all')+1+sqrt(3)/2];
% axis([xlimit,ylimit])
plot([xlimit';xlimit'],[ylimit(1);ylimit(1);ylimit(2);ylimit(2)],".r");
axis equal

TargetLoc = Frames(:,end,:);
clear WS Path BasicWS
close all
% frames= uint8()
f=figure(666);
f.WindowState = 'maximized';
pause(1);
hold on

% p.T = PlotTriangle(permute(TargetLoc(:,end,1:2),[1 3 2]), AgentType, ones(N,1)*11,[],[],[],[],0.2);
p.S = PlotTriangle(permute(Frames(:,1,1:2),[1 3 2]), AgentType, Frames(:,1,3),[],[],[],[]);   
plot([xlimit';xlimit'],[ylimit(1);ylimit(1);ylimit(2);ylimit(2)]*sqrt(3),".r");
axis equal
drawnow

exportgraphics(gcf,"ArticleMovie\Plot.png","Resolution",300)

frames(:,:,:,1) = imread("ArticleMovie\Plot.png");
frames = repmat(frames,1,1,1,ClipMaxFrame);

for jj = 21001:size(Frames,2)
   % figure(666)
    % cla
    fprintf("progress: "+string(jj)+"/"+string(size(Frames,2))+"time: "+string(toc)+"\n");

figures{mod(jj-1,ClipMaxFrame)+1} = figure(jj);
figures{mod(jj-1,ClipMaxFrame)+1}.WindowState = 'maximized';
hold on
PlotTriangle(permute(Frames(:,jj,1:2),[1 3 2]), AgentType, Frames(:,jj,3),[],[],[],[]);    
plot([xlimit';xlimit'],[ylimit(1);ylimit(1);ylimit(2);ylimit(2)]*sqrt(3),".r");
axis equal
drawnow
%exportgraphics(gcf,"ArticleMovie\Plot.png","Resolution",300)

%frames(:,:,:,jj-(Batch-1)*ClipMaxFrame) = imresize(imread("ArticleMovie\Plot.png"),[size(frames,[1,2])]);

if ~mod(jj,ClipMaxFrame) || jj == size(Frames,2)
    drawnow
    parfor kk =1:ClipMaxFrame
       exportgraphics(figures{kk},join([PathName,"_",string(jj+1-ClipMaxFrame +kk),".png"],""),"Resolution",300)
fprintf("export: %d\n",kk);
    end
    close all
   % open(video);
    %writeVideo(video,frames);
   % close(video);
Batch = Batch + 1;
    %video = VideoWriter(join([PathName,"_",string(Batch),".mp4"],""));
%    video.Quality = 100;
  %  video.FrameRate = 60;
    
end

end
drawnow
pause(0.5)



% frames(:,:,:,end+1:end+video.FrameRate) = repmat(imread("ArticleMovie\Plot.png"),[1,1,1,video.FrameRate]);
% frames = cat(4,CellFrames{:});
% frames = flip(frames,4);
open(video);
writeVideo(video,frames);
close(video);
close all

end
