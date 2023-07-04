%% img to configuration
% AddDirToPath
function [WS,Node,Config,BasicWS,N] = Img2Configuration(ImgAddress,Resize,N_Requred)
% img = imread("Shapes\S.png");
img = imread(ImgAddress);
last_Diff = [];
step = 0.025;
while 1
    try
    imgGray = imresize(rgb2gray(img),Resize);
    imgBin = ~imbinarize(imgGray,"global");
    catch
        imgGray = imresize(img,Resize);
        imgBin = ~imbinarize(imgGray,"global");
    end
    
    
    % Remove zero rows
    imgBin = imgBin(any(imgBin, 2), :);
    
    % Remove zero columns
    imgBin = flip(imgBin(:, any(imgBin, 1)),1);
    % imshow(imgBin);
    N = nnz(imgBin);
    if abs(N - N_Requred)>10
        if N > N_Requred
            
            if last_Diff == -1
                step = step/2;
            end
            last_Diff = 1;
            Resize = Resize - step;
        else
            if last_Diff == 1
                step = step/2;
            end
            last_Diff = -1;
            Resize = Resize + step;
        end
    else
        break
    end
end
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
N = nnz(Config.Status);