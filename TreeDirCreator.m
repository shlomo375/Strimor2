clear;
close all;
% clear Taskmaster
%% Creat Tree Dir for pair of config, one from start, one from target.
ModuleRange = [16]; % number of modules in the tree
TreeType = ["Temp"]%,"uniform_IM2Axis__3","uniform_IM1Axis__3"]%,"uniform_IM1Axis__3","uniform_IM2Axis__3","uniform_IM3Axis__3"]%,"uniform_LineCostSam__3"]; %mast to be unique names
TreeIndexes = 3;
%%


SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);

% OriginalOrBeckUp = "Results"%"Results"%"BeckupResults","BlankTree"
for OriginalOrBeckUp = ["Results","BeckupResults","BlankTree"]%,"BlankTree"] %"Results",,"BlankTree"
% SuccessDir = fullfile(extractBefore(TreeFolder,digitsPattern+"N\"),"AllTreeResulte");
mkdir(fullfile(SoftwareLocation,"RRTtree",OriginalOrBeckUp,"AllTreeResulte"));


for NumberOfModule= ModuleRange
    for DirName = TreeType%"normal_1","normal_3"];%"TwoTree","uniform_1","uniform_3","OneTree"
        TreeFolderName = fullfile(SoftwareLocation,"RRTtree",OriginalOrBeckUp,DirName,NumberOfModule+"N");
        PairFile = fullfile("configuration","ConfigPairs","N"+NumberOfModule+".mat");
        mkdir(TreeFolderName);
        load(PairFile,'ConfigPairs');
    
        TimeFromStart = datetime;
    
%         TreeName = fullfile(SoftwareLocation,"RRTtree","Results",ii+"N",DirName,"tree_"+string(jj));
        for kk= TreeIndexes
            TreeName = fullfile(TreeFolderName,"tree_"+string(kk));
            %%
try
            mkdir(TreeName);
            
            if ~contains(DirName,"OneTree") && ~matches(DirName,"MultyTree")
                TreeDir = fullfile(TreeName,"Start")
                mkdir(TreeDir);
            end
            files = dir(TreeDir);
            if sum([files.isdir])<=2
              
                Config = ConfigPairs{kk}{1};
                StartConfig = ConfigStruct2Node(Config);
                tree = TreeClass(TreeDir, NumberOfModule, 10500, StartConfig);
                SaveTree(tree);
                save(fullfile(TreeDir,"Start.mat"),"StartConfig");
                
                %%
%                 ConfigPairs{kk}=[ConfigPairs{kk},ConfigPairs{kk+1}]
                %%
                for StartNum = 2:numel(ConfigPairs{kk})
                    Config = ConfigPairs{kk}{StartNum};
                    TargetConfig(StartNum-1,:) = ConfigStruct2Node(Config);
                end
                    save(fullfile(TreeDir,"Target.mat"),"TargetConfig");
                    clear("TargetConfig");
                
                if ~contains(DirName,"OneTree") && ~matches(DirName,"MultyTree")
                    for StartNum = 2:numel(ConfigPairs{kk})
                        TreeDir = fullfile(TreeName,"Target"+"_"+(StartNum-1));
                        mkdir(TreeDir);
                        
                        Config = ConfigPairs{kk}{StartNum};
                        StartConfig = ConfigStruct2Node(Config);
                        tree = TreeClass(TreeDir, NumberOfModule, 10500, StartConfig);
                        SaveTree(tree);
                        save(fullfile(TreeDir,"Start.mat"),"StartConfig");
                    
                    
                        Config = ConfigPairs{kk}{1};
                        TargetConfig = ConfigStruct2Node(Config);
                        save(fullfile(TreeDir,"Target.mat"),"TargetConfig");
                        clear("TargetConfig");
                    end
                end
                
         
            end
catch ME11
    ME11
end

        end

    end
end

end
% copyfile(fullfile(SoftwareLocation,"RRTtree","Results"),fullfile(SoftwareLocation,"RRTtree","BeckupResults"));


