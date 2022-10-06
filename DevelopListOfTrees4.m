clear;

close all;
clear Taskmaster
%% Creat Tree Dir for pair of config, one from start, one from target.
SoftwareLocation = 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles';
addpath(genpath(SoftwareLocation));

cd(SoftwareLocation);
q = parallel.pool.DataQueue;
afterEach(q, @ProgressTable);

Info.MaxConfig = 10000;
Info.iteration = 5;

% delete(gcp('nocreate'));
%     p =  parpool(4);
% p.NumWorkers = 4;

TreesFolder = fullfile("RRTtree","Results");
ds = fileDatastore(TreesFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
TreeFolder = string(extractBefore(ds.Files(contains(ds.Files,"Target.mat")),"\Target.mat"));
WorkerList(1:numel(TreeFolder)) = parallel.FevalFuture;


% ProgressTable(TreeFolder);
% 
% BeckupFolder = fullfile("RRTtree","beckup",ii+"N");
% 
% StartNumConfig = ComputeTreeSize(TreeName);
% 
% % ProgressTable(StartNumConfig);
% 
fprintf("send task to workers...\n");
tic
WorkerList = Taskmaster(WorkerList, TreeFolder, Info,q);
toc
fprintf("finish sending tasks...\n");
Sender = 'triangle.msr.robotics@gmail.com';
Recipients = 'triangle.msr.robotics@gmail.com';
SenderPassword = 'ezlsunyndvpnejcd';
for idx = 1:numel(WorkerList)
    [CompleteIdx, TreeName, ConfigNumber, ConfigPerSec,FileName] = fetchNext(WorkerList);
    Time = WorkerList(CompleteIdx).FinishDateTime-WorkerList(CompleteIdx).StartDateTime;
        disp({Time,TreeName," Total: "+ConfigNumber, " CPS: "+ConfigPerSec , " progress: "+idx+"/"+numel(WorkerList)});
    Massege = join(["Total config in tree:",ConfigNumber,"\n"]," ");
        SendMailWithGmail(Sender,SenderPassword,Recipients,TreeName,Massege,FileName)
end


