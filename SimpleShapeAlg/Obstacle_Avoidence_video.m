%% obstacle avoidence, video for the article

AddDirToPath
close all
% %% start config from img
% ImgAddress = fullfile("Shapes","S.png");
% Resize = 0.5;
% N_requrerd = 1000;
% [StartWS,StartNode,StartConfig,BasicWS,N] = Img2Configuration(ImgAddress,Resize,N_requrerd);
% % save("SimpleShapeAlg\Shapes\S.mat","StartNode")
% %% End config
% ImgAddress = fullfile("Shapes","arrow.png");
% Resize = 0.5;
% [TargetWS,TargetNode,TargetConfig,~,TargetN] = Img2Configuration(ImgAddress,Resize,N);


%% End Rectungular config
% N = nnz(StartConfig.Status);
% High = ceil(0.25*StartConfig.Row);
% [TargetWS,TargetNode,TargetConfig] = RectungularConfiguration(BasicWS,N,High);

%% Solver
% clear
load("SimpleShapeAlg\Shapes\Arrow.mat","TargetNode")
load("SimpleShapeAlg\Shapes\S.mat","StartNode")
N = nnz(StartNode.ConfigMat{:});
% BasicWS = WorkSpace([N,N*2],"RRT*");
Ploting = 0;
[Tree,Error,msg] = SimpleShapeAlgorithm(N,BasicWS,StartNode,TargetNode,Ploting,"ConfigCopyPaste",false);
save("SimpleShapeAlg\Shapes\S2Arrow.mat","Tree","-v7.3")
