%RRT*
% addpath 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles\RRTtree\50N';
% addpath 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles\configuration';
% addpath 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles\simulation';
% addpath 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles\RRT';
% addpath 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles'));
addpath(genpath('C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles'));
clear
close all;
clear Taskmaster
F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F);
cd 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles';
q = parallel.pool.DataQueue;
afterEach(q, @ProgressTable);

Info.MaxConfig = 10000;
Info.iteration = 3;
FolderFile = "RRTtree\36N\FolderFile.mat";
% ProgressBar(Info.MaxConfig);



flag = [];

delete(gcp('nocreate'));
p =  parpool(4);
% p.NumWorkers = 4;
WorkerList(1:p.NumWorkers) = parallel.FevalFuture;


TimeFromStart = datetime;

% Folders(1) = fullfile("RRTtree","36N","CarTree_1");
% Folders(2) = fullfile("RRTtree","36N","LineTree_1");
% Folders(3) = fullfile("RRTtree","36N","ShapeTree_1");
% Folders(4) = fullfile("RRTtree","36N","RotatedLineTree_1");
load(FolderFile,"Folders");
BeckupFolder = fullfile("RRTtree","beckup","36N");
% treeChild = TreeChild(Folders(1))
% ScanTree(Folders(1))

ProgressTable(Folders);
% WorkerList = Taskmaster(WorkerList, Folders, Info,q);



StartNumConfig = ComputeTreeSize(Folders);
for ii = 1:numel(StartNumConfig)
    if StartNumConfig(ii)>1e6
%         fprintf(join(["split tree: ",Folders(ii),"\n"]));
        SplitTree(FolderFile, ii);
        load(FolderFile,"Folders");
    end
end
ProgressTable(Folders);
ProgressTable(StartNumConfig);
% TotalConfig = sum(StartNumConfig);
% fprintf("tree %1.0f sizes: %12.0f\n",[1:4;StartNumConfig]);
% fprintf("total config: %12.0f\n",TotalConfig); 

fprintf("send task to workers...\n");
WorkerList = Taskmaster(WorkerList, Folders, Info,q);

load("RRTtree\36N\LogFile");
LogTime = [LogTime; datetime];
save("RRTtree\36N\LogFile","LogTime")

LastTime = TimeFromStart;
LastTime2 = TimeFromStart;
ConfigPerTime = 0;
% pause(60)
disp(WorkerList);
% pause(60)
while(1)
%     if (datetime-LastTime2)> duration([0 0 30])
%         drawnow
%         LastTime2 = datetime;
%     end
    pause(10)
    try
        if (datetime-LastTime)> duration([0 2 0])&& (sum(matches({WorkerList.State},"running"))<p.NumWorkers)
            disp(WorkerList);
            LastTime = datetime;
            fprintf("Config per sec: %3.4f\n",ConfigPerTime);
    
    
            if (sum(matches({WorkerList.State},"finished"))==p.NumWorkers)
                AllTime = datetime - TimeFromStart;
                for ii = 1:numel(Folders)
                    try
                        NumConfig(ii) = ComputeTreeSize(Folders(ii));
%                         ConfigPerTime = (sum(NumConfig-StartNumConfig(ii)))./seconds(AllTime);
                        
    
                        TreeName = extractAfter(Folders,"N\");
                        
                        [status,msg] = copyfile(Folders(ii),fullfile(BeckupFolder,TreeName(ii)));
                        
                    catch e
                        
                        s= rmdir(Folders(ii),'s');
                        [status,msg] = copyfile(fullfile(BeckupFolder,TreeName(ii)),Folders(ii));
                        
                    end
                end
                
                for ii = 1:numel(NumConfig)
                    if NumConfig(ii)>1e6
                        SplitTree(FolderFile, ii);
                        load(FolderFile,"Folders");
                        NumConfig(ii) = 1;
                    end
                end
                ProgressTable(Folders);

                try
                    ProgressTable(NumConfig);
                end

                if ~status
                    disp(msg)
                    break
                end
                WorkerList(1:p.NumWorkers) = parallel.FevalFuture;
                WorkerList = Taskmaster(WorkerList, Folders, Info,q);
                fprintf("Config per sec: %3.4f\n",ConfigPerTime);
            end
        end
    
    catch e
        d=5
    end
end
 



