%% obstacle avoidence, video for the article

AddDirToPath
close all
%% start config from img
ImgAddress = fullfile("Shapes","S.png");
Resize = 0.1;
[StartWS,StartNode,StartConfig,BasicWS] = Img2Configuration(ImgAddress,Resize);

%% End Rectungular config
N = nnz(StartConfig.Status);
High = ceil(0.25*StartConfig.Row);
[TargetWS,TargetNode,TargetConfig] = RectungularConfiguration(BasicWS,N,High);

%% Solver
Ploting = 1;
[Tree,Error,msg] = SimpleShapeAlgorithm(N,BasicWS,StartNode,TargetNode,Ploting,"ConfigCopyPaste",false);

