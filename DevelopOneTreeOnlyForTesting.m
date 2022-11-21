%% Develop One Tree Only For Testing
clear

SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);

Info.MaxConfig = 10000;
Info.iteration = 1;
Info.RowNumData.function = "";
Info.RowNumData.parameter = 1;

% ""C:\Users\ShlomoOdem\triangles\RRTtree\Results\23N\uniform_IM2Axis__3\tree_1""
TreeFolder = fullfile(SoftwareLocation,"RRTtree","Results","18N","uniform_IM3AxisZone__3","tree_20");
dir(TreeFolder)
tic
Expend2Tree(TreeFolder,Info);
toc