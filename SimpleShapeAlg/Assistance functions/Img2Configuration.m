%% img to configuration
% AddDirToPath
function [WS,Node,Config,BasicWS] = Img2Configuration(ImgAddress,Resize)
% img = imread("Shapes\S.png");
img = imread(ImgAddress);
imgGray = imresize(rgb2gray(img),Resize);
imgBin = ~imbinarize(imgGray,"global");

% Remove zero rows
imgBin = imgBin(any(imgBin, 2), :);

% Remove zero columns
imgBin = flip(imgBin(:, any(imgBin, 1)),1);
imshow(imgBin)
N = nnz(imgBin);

BasicWS = WorkSpace([N,N*2],"RRT*");

Config.Status = imgBin;
Config.Type = 1;

WS = SetConfigurationOnSpace(BasicWS,Config);
% Config = GetConfiguration(WS);
WS = FixEqualeTypeNumberModule(WS);


Config = GetConfiguration(WS);
Node = CreateNode(1);
Node = ConfigStruct2Node(Node,Config);

figure
PlotWorkSpace(WS)
