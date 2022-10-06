clear;
close all;
% clear Taskmaster
%% Creat Tree Dir for pair of config, one from start, one from target.
ModuleRange = 10:20; % number of modules in the tree
TreeType = ["uniform_IM1Axis__3","uniform_IM2Axis__3","uniform_IM3Axis__3"]%"normal_1","uniform_1","uniform_3"]%,"uniform_IM1Axis__3","uniform_IM2Axis__3","uniform_IM3Axis__3"]%,"uniform_LineCostSam__3"]; %mast to be unique names
TreeIndexes = 1:200;
%%


SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);

% OriginalOrBeckUp = "Results"%"Results"%"BeckupResults","BlankTree"
for OriginalOrBeckUp = ["Results","BeckupResults","BlankTree"] %"Results",,"BlankTree"
% SuccessDir = fullfile(extractBefore(TreeFolder,digitsPattern+"N\"),"AllTreeResulte");
mkdir(fullfile(SoftwareLocation,"RRTtree",OriginalOrBeckUp,"AllTreeResulte"));


for ii= ModuleRange
    for DirName = TreeType%"normal_1","normal_3"];%"TwoTree","uniform_1","uniform_3","OneTree"

        PairFile = fullfile("configuration","ConfigPairs","N"+ii+".mat");
        mkdir(fullfile(SoftwareLocation,"RRTtree",OriginalOrBeckUp,ii+"N",DirName));
        load(PairFile,'ConfigPairs');
    
        TimeFromStart = datetime;
    
%         TreeName = fullfile(SoftwareLocation,"RRTtree","Results",ii+"N",DirName,"tree_"+string(jj));
        for kk= TreeIndexes
            TreeName = fullfile(SoftwareLocation,"RRTtree",OriginalOrBeckUp,ii+"N",DirName,"tree_"+string(kk));
            %%
% % % % % %             if exist(TreeName,'dir')
% % % % % %                 rmdir(TreeName,'s');
% % % % % %                 continue
% % % % % %             else
% % % % % %                 continue
% % % % % %             end
%%
try
            mkdir(TreeName);
            files = dir(TreeName);
            if sum([files.isdir])<=2
                TreeDir = TreeName
                if ~contains(DirName,"OneTree") && ~matches(DirName,"MultyTree")
                    TreeDir = fullfile(TreeName,"Start");
                    mkdir(TreeDir);
                end
                
                config = ConfigPairs{kk}{1};
                StartConfig = table(duration(0,0,0),1,0,config.Type,0,0,0,0,config.Row,config.Col,0,0,1,0,string(config.Str),"",{config.Status},{[]},{[]});
                tree = TreeClass(TreeDir, kk, 1e5, StartConfig);
                StartConfig = tree.Data(1,:);
                SaveTree2Files(tree);
                save(fullfile(TreeDir,"Start.mat"),"StartConfig");
                
                config = ConfigPairs{kk}{2};
                StartConfig = table(duration(0,0,0),-1,0,config.Type,0,0,0,0,config.Row,config.Col,0,0,1,0,string(config.Str),"",{config.Status},{[]},{[]});
                tree = TreeClass(TreeDir, kk, 1e5, StartConfig);
                TargetConfig = tree.Data(1,:);
                save(fullfile(TreeDir,"Target.mat"),"TargetConfig");
        
                if ~contains(DirName,"OneTree") && ~matches(DirName,"MultyTree")
                    TreeDir = fullfile(TreeName,"Target");
                    mkdir(TreeDir);
                    
                    config = ConfigPairs{kk}{2};
                    StartConfig = table(duration(0,0,0),1,0,config.Type,0,0,0,0,config.Row,config.Col,0,0,1,0,string(config.Str),"",{config.Status},{[]},{[]});
                    tree = TreeClass(TreeDir, kk, 1e5, StartConfig);
                    StartConfig = tree.Data(1,:);
                    SaveTree2Files(tree);
                    save(fullfile(TreeDir,"Start.mat"),"StartConfig");
                
    
                    config = ConfigPairs{kk}{1};
                    StartConfig = table(duration(0,0,0),-1,0,config.Type,0,0,0,0,config.Row,config.Col,0,0,1,0,string(config.Str),"",{config.Status},{[]},{[]});
                    tree = TreeClass(TreeDir, kk, 1e5, StartConfig);
                    TargetConfig = tree.Data(1,:);
                    save(fullfile(TreeDir,"Target.mat"),"TargetConfig");
                end
                
            end
end
        end
    end
end
end
% copyfile(fullfile(SoftwareLocation,"RRTtree","Results"),fullfile(SoftwareLocation,"RRTtree","BeckupResults"));


