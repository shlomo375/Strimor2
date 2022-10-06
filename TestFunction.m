clear
%%
% This is a test that everything works
% and installed on the computer all the necessary libraries
%%
SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);
mkdir("RRTtree\Results\TimeLog");
q=[];
Info.MaxConfig = 10000;
Info.iteration = 1;
Info.RowNumData.function = "";
Info.RowNumData.parameter = 1;
TreeFolder=[];
% 
%  delete(gcp('nocreate'));    
%  p =  parpool(maxNumCompThreads);

TreesFolder = fullfile("RRTtree","Results");
tbl = table();
save(fullfile(TreesFolder,"temp.mat"),"tbl")
ds = fileDatastore(TreesFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
TF = string(extractBefore(ds.Files(contains(ds.Files,"Target.mat")),"\Target.mat"));
TF = unique(erase(TF,["\Target","\Start"]));
for ii = 17
    Loc = contains(TF,"\"+string(ii)+"N\")& contains(TF,"TwoTree");
    TreeFolder = [TreeFolder; TF(Loc)];
end

%% tree building!
Expend2Tree(TreeFolder(1), Info)

