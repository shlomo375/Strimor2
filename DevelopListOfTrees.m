clear;
% 
% close all;
  
%% Creat Tree Dir for pair of config, one from start, one from target.
ModuleRange = [16:22]; % number of modules in the tree
TreeType = ["OptimalTree"]%,"normal_1","uniform_1","uniform_3"]; %mast to be unique names  "normal_1","uniform_1","uniform_3"
TreeRange = 1:200;
%%


SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);
try
    movefile(fullfile(SoftwareLocation,"RRTtree","Results","AllTreeResulte","*"),"AllTreeResulte");
end
try   
mkdir("RRTtree\Results\TimeLog");
q=[];
Info.MaxConfig = 10000;
Info.iteration = 1;
Info.RowNumData.function = "";
Info.RowNumData.parameter = 1;
TreeFolder=[];
AllResultFolder = fullfile(SoftwareLocation,"AllTreeResulte");

 delete(gcp('nocreate'));    
 p =  parpool(maxNumCompThreads);

TreesFolder = fullfile("RRTtree","Results");
tbl = table();
save(fullfile(TreesFolder,"temp.mat"),"tbl")
ds = fileDatastore(TreesFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
TF = string(extractBefore(ds.Files(contains(ds.Files,"Target.mat")),"\Target.mat"));
TF = unique(erase(TF,["\Target","\Start"]));
for ii = TreeRange 
    Loc = contains(TF,"\"+string(ModuleRange)+"N\") & contains(TF,TreeType) & double(extractAfter(TF,"tree_"))==ii;
    TreeFolder = [TreeFolder; TF(Loc)];
end 

% TreeFolder = filterTreeFolder(TreeFolder,AllResultFolder);
% TreeFolder = flip(TreeFolder);
% Expend2Tree(FolderName, info)

if numel(TreeFolder)>1000
    gap = 1000
else
    gap = numel(TreeFolder)
end
WorkerList(1:numel(TreeFolder)) = parallel.FevalFuture;

for idx = [gap:gap:numel(TreeFolder),numel(TreeFolder)]
fprintf("send task to workers...\n");
tic
WorkerList(idx-gap+1:idx) = Taskmaster(WorkerList(idx-gap+1:idx), TreeFolder(idx-gap+1:idx), Info);
toc
fprintf("finish sending tasks...\n");


pause(2);

WorkerList(idx-gap+1:idx)
TreeFolder(idx-gap+1:idx)
%     while any(strcmp({WorkerList.State},"running"))
    for ii = 1:gap
    try 
        [CompleteIdx,NumberOfCOnfig, PathLength, Path, time, FileName] = fetchNext(WorkerList(idx-gap+1:idx));
        TimeFileName = "_TimeLog_" + string(datetime)+".mat";
        
        JobName = extractAfter(WorkerList(CompleteIdx+idx-gap).InputArguments{1},"Results\")+TimeFileName;
        JobTime = WorkerList(CompleteIdx+idx-gap).RunningDuration;
        JobName = replace(JobName,[" ","-",":","\"],"_");
        save(fullfile(SoftwareLocation,"RRTtree\Results\TimeLog",JobName),"JobName","JobTime");
    catch ME2
    ME2
    PathLength = -1;
    continue
    % fprintf("pause");
    % pause
    end
    
        if PathLength == 0 
            PathLength = -1;
        end
        if PathLength == -1
            rmdir(WorkerList(CompleteIdx+idx-gap).InputArguments{1},'s')
            copyfile(replace(WorkerList(CompleteIdx+idx-gap).InputArguments{1},"Results\","BeckupResults\"),WorkerList(CompleteIdx+idx-gap).InputArguments{1})
            
            Name = extractBetween(WorkerList(CompleteIdx+idx-gap).InputArguments{1},"N\","\tree","Boundaries","exclusive");
            info.MaxConfig = gap;
            info.iteration = 1; 
            info.RowNumData.function = extractBefore(Name,"_"); 
            info.RowNumData.parameter = double(extractAfter(Name,"_"));
            WorkerList(CompleteIdx+idx-gap) = parfeval(@Expend2Tree,5,WorkerList(CompleteIdx+idx-gap).InputArguments{1}, info);
            continue
        end
    
        Name = extractAfter(WorkerList(CompleteIdx+idx-gap).InputArguments{1},"Results");
        disp(Name);
        disp({datetime,JobTime," Total: "+NumberOfCOnfig, CompleteIdx+idx-gap+"/"+numel(WorkerList), " PL: "+PathLength});
        
    end


end
catch e
    e
    delete(p);
end

