classdef TreeClass
    properties (SetAccess = public)
        LocInMainTree
        LastCompareIndex = 1;
        FolderName
        Data
        AddDuration
        StartTime
        LastNodeTime
        NumOfIsomorphismAxis
        Total_Downwards
    end
    properties (SetAccess = private)
        
        ConfigStr
        ConfigMat
        N
        StartConfig
        EndConfig
        EndConfig_IsomorphismMetrices %[axis1,axis2,axis3]
        EndConfig_RotationMatrices
        EndConfig_IsomorphismStr
        EndConfig_IsomorphismSizes
        LastIndex = 1;
        DataLength;
        DataWidth
        
        MemorySize
        DataIndex = struct("Index" , 1, ...
                           "Parent", 2, ...
                           "Type"  , 3, ...
                           "Level" , 4, ...
                           "Cost"  , 5, ...
                           "Dir"   , 6, ...
                           "Step"  , 7, ...
                           "ConfigRow", 8, ...
                           "ConfigCol", 9, ...
                           "ParentRow", 10, ...
                           "ParentCol", 11, ...
                           "Visits"   , 12, ...
                           "Cost2Target", 13);
%         ConfigIndex = struct("ConfigStr", 1, ...
%                              "ParentStr", 2, ...
%                              "ConfigMat", 3, ...
%                              "ParentMat", 4);

    end
    
    methods (Static)
        function [Data, Config] = SetDataForTree(Parent, Config, Movment, Level, Cost)
            Data = [Config.Str, Config.Row, Config.Col,...
                            Parent, Level, Cost, Movment.dir, Movment.step, Agent];
            Config = rmfield(Config,["Dec","Row","Col"]);
        end

        function LocInMainTree = CheckLocInMainTree(MainTree, Config)
        
            Loc = strcmp(Config.Str, MainTree.Str);
            switch sum(Loc)
                case 0
                    LocInMainTree = 0;
                case 1
                    LocInMainTree = find(Loc);
                otherwise
                    NotExactMetch = cellfun(@(x) ~isequal(logical(Config.Status),logical(x))...
                                                ,MainTree.Mat(Loc));
                    LocInMainTree = find(Loc);
                    LocInMainTree(NotExactMetch) = [];
                    if isempty(LocInMainTree)
                        LocInMainTree = 0;
                    end
            end
        end
    
        function Better = CompereConfigCost(tree, ConfigLoc, Level, Cost)
            Better = false;
            if Cost < tree.Cost(ConfigLoc)
                Better = true;
                return
            end
            if Cost == tree.Data(ConfigLoc,tree.DataIndex.Cost)
                if Level < tree.Data(ConfigLoc,tree.DataIndex.Level)
                    Better = true;
                    return
                end
            end
        end
    
        function num = RandConfig(Tree,LastIndex,n)
            
            if nargin ==2
                visit = Tree.Visits(1:LastIndex);
                try
                    Cost2Target = Tree.Cost2Target(1:LastIndex);
                end
                n=1;
            else
                
                visit = Tree.Visits;
                LastIndex = numel(visit);
                try
                    Cost2Target = Tree.Cost2Target;
                end
            end
            visit(visit==0)=1;
%%
            % The obtained cost values are high when the distance is large
            % and small to zero when approaching the target. 
            % The selection percentages are inversely proportional, 
            % the closer the target, the higher the percentage.

            Cost2Target(Cost2Target==0)=100*max(Cost2Target)+1;
%             prob = (1./10.^visit);
            prob = Cost2Target.*exp(-(1-visit)); %% After selecting once the percentages of the configuration start to decrease.
            prob = max(prob) - prob + eps(0);
            prob = prob./sum(prob);
%             if ~any(prob == 1)
%                 prob = 1-prob;
%             end
 %%           
%               num = randsrc(n,1,[1:size(prob,1);prob']);
          num = randi(LastIndex,n,1);

            
        end
    
        function CombineTrees(Data,Folder,TreeName,FileIndex)
            
            tic
%             Folder = Data.FolderName;
            ds = fileDatastore(Folder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
            DeleteRow = (Data{:,"Index"}==0);
            Data(DeleteRow,:) = [];
            StartDataSize = size(Data,1);
            disp({TreeName,FileIndex,StartDataSize})
            while ~isempty(Data)

                ConfigSize = Data{1,["ConfigRow","ConfigCol"]};
                Cost2Target = Data{1,"Cost2Target"};
                FileName = "size_"+string(ConfigSize(1))+"_"+ string(ConfigSize(2))+"_"+string(Cost2Target);

                ConfigsLocInTree = ismember(Data{:,["ConfigRow","ConfigCol","Cost2Target"]},[ConfigSize, Cost2Target]);
                ConfigsLocInTree = ConfigsLocInTree(:,1) & ConfigsLocInTree(:,2) & ConfigsLocInTree(:,3);

                data = Data(ConfigsLocInTree,:);
                Data(ConfigsLocInTree,:) = [];
                
                
                FileExist = contains(ds.Files,FileName);
                if ~any(FileExist)
                    
                    FileData = data;
                    
                    FileName = SaveFile(fullfile(Folder,FileName),FileData);
                   
                    ds.Files{end+1} = char(FileName);
                    
                else
                    File = subset(ds,FileExist);
                    FileData = readall(File);
                    
                    ConfigLocInFile = CompareStrs(data.ConfigStr, ConfigSize, FileData.ConfigStr, ConfigSize);


                    SameConfigLoc = ConfigLocInFile(ConfigLocInFile>0);
                   
                    if any(ConfigLocInFile)
                        CompareCost = any(data{ConfigLocInFile>0,["Cost","Level"]} < FileData{SameConfigLoc,["Cost","Level"]},2);
                        if any(CompareCost)
                            FileData(SameConfigLoc(CompareCost),:) = data(CompareCost,:);
                            FileData{SameConfigLoc(CompareCost),"Index"} = SameConfigLoc(CompareCost);
                        end
                        
                    end

                    NumOfNewConfig = sum(~ConfigLocInFile);
                   
                    data{~ConfigLocInFile,"Index"} = (size(FileData,1)+(1:NumOfNewConfig))';
                    FileData(end+(1:NumOfNewConfig),:) = data(~ConfigLocInFile,:);
                    
%                     SaveInfoFile(Folder,FileName,FileData);
%                     disp({TreeName,FileIndex,StartDataSize-size(Data,1),StartDataSize,toc})
                    SaveFile(fullfile(Folder,FileName),FileData);
                    
                end
                disp({TreeName,FileIndex,StartDataSize-size(Data,1),StartDataSize,toc})
            end    
        end
    end

    methods (Access=private)
        
        
        
        function ConfigIndex = FindConfig(tree, ConfigStr, ConfigRow, ConfigCol)
            
            ConfigIndex = CompareStrs(ConfigStr, [ConfigRow, ConfigCol],...
                                                tree.Data.ConfigStr(1:tree.LastIndex), ...
                                                tree.Data{(1:tree.LastIndex),["ConfigRow","ConfigCol"]});
        end
        

        function Better = CompereNode(tree, ConfigIndex, Level, Cost)
            Better = false;
            if Cost < tree.Data.Cost(ConfigIndex)
                Better = true;
                return
            end
            if Cost == tree.Data.Cost(ConfigIndex)
                if Level < tree.Data.Level(ConfigIndex)
                    Better = true;
                    return
                end
            end
        end

        
        function [tree, flag] = SaveRoutine(tree)
            flag = [];
            if tree.LastIndex == tree.DataLength
                
                [~, SystemInfo] = memory;
                if isempty(tree.MemorySize)
                    a = whos('tree');
                    tree.MemorySize = a.bytes;
                else
                    if SystemInfo.PhysicalMemory.Available/5 < tree.MemorySize
                        NewData = zeros(tree.DataLength,numel(fieldnames(tree.DataIndex)));
                        NewConfig = cell(tree.DataLength,1);
                        tree.Config.Mat = [tree.Config.Mat; NewConfig];
                        tree.Config.Str = [tree.Config.Str; NewConfig];
                        tree.Data = [tree.Data; NewData];
                    else
                        SaveTree(tree, "finish");
                        flag = "OutOfMemory";
                    end
                end
            else
                if ~mod(tree.LastIndex,10000)
                    SaveTree(tree);
                end
            end

        end
        
        function flag = WayIsFound(tree)
            flag = [];
            if ~isempty(tree.EndConfig)
                if isequal(tree.EndConfig.Status, logical(tree.Config.Mat{tree.LastIndex}))
                    flag = "Success";
                    SaveTree(tree, "finish");
                end
            end
        end
    end
        
    methods
        function tree = SetNode(tree, ...
                                index, ...
                                ConfigIndex, ...
                                Parent, ...
                                Type, ...
                                Level , ...
                                Cost  , ...
                                Dir   , ...
                                Step  , ...
                                ConfigMat, ...
                                ConfigStr, ...
                                ParentMat, ...
                                ParentStr, ...
                                ConfigRow, ...
                                ConfigCol, ...
                                ParentRow, ...
                                ParentCol, ...
                                Visits, ...
                                Cost2Target)
            if nargin<18
                tree.Data(index,1:end-2) = [ConfigIndex, Parent,Type,Level,Cost,Dir,Step,ConfigRow,ConfigCol,ParentRow,ParentCol];
            else
                tree.Data(index,:) = [ConfigIndex, Parent,Type,Level,Cost,Dir,Step,ConfigRow,ConfigCol,ParentRow,ParentCol,Visits,Cost2Target];
            end
            tree.ConfigMat{index,1} = ConfigMat;
            tree.ConfigStr(index,1) = ConfigStr;
            tree.ConfigMat{index,2} = ParentMat;
            tree.ConfigStr(index,2) = ParentStr;

        end
        
        function tree = Set(tree, index, varargin)
            for var = 1:2:length(varargin)
                switch varargin{var}
                    case "ConfigMat"
                        tree.ConfigMat{index,1} = varargin{var+1};
                    case "ConfigStr"
                        tree.ConfigStr(index,1) = varargin{var+1};
                    case "Tree"
                        Tree = varargin{var+1};
                        tree.Data(index+(0:size(Tree.data,1)-1),:) = Tree.data;
                        tree.Config.Mat(index+(0:size(Tree.data,1)-1)) = Tree.Config.Mat;
                        tree.Config.Str(index+(0:size(Tree.data,1)-1)) = Tree.Config.Str;
                        tree.LastCompareIndex = Tree.LastCompareIndex;
                    otherwise
                        pos = getfield(tree.DataIndex,varargin{var});
                        tree.Data(index,pos) = varargin{var+1};
                end
%                 if varargin{var} == "ConfigMat"
%                     tree.Config.Mat{index} = varargin{var+1};
%                 else
%                     if varargin{var} == "Tree"
%                         Tree = varargin{var+1};
%                         tree.Data(index+(0:size(Tree.data,1)-1),:) = Tree.data;
%                         tree.Config(index+(0:size(Tree.data,1)-1)) = Tree.Config;
%                     else
%                         pos = getfield(tree.DataIndex,varargin{var});
%                         tree.Data(index,pos) = varargin{var+1};
%                     end
%                 end
                
            end

        end
           
        function [tree, varargout] = Get(tree, index, varargin)
            varargout = table2cell(tree.Data(index,string(varargin)));
            if any(contains(string(varargin),"ConfigMat"))
                tree.Data.Visits(index) = tree.Data.Visits(index)+1;
            end
        end

        function tree = TreeClass(folder, n, dataLength, StartConfig,P)%StartConfig,EndConfig
           
            arguments 
                folder
                n
                dataLength
                StartConfig
                P.EndConfig
                P.ZoneMatrix = true;
            end
            

            tree.N = n;
           tree.FolderName = folder;
           tree.DataLength = dataLength;
           if ~contains(folder,"Optimal") && contains(folder,"IM3Zone","IgnoreCase",false)
                tree.NumOfIsomorphismAxis = 3;
            end
           VarName = {'time','Index','ParentIndex','Type','Level','Cost', ...
               'Dir','Step','ConfigRow','ConfigCol','ParentRow','ParentCol',...
               'Visits','Cost2Target','ConfigStr','ParentStr','ConfigMat',...
               'ParentMat','IsomorphismMatrices1','IsomorphismMatrices2','IsomorphismMatrices3'...
               'IsomorphismStr1','IsomorphismStr2','IsomorphismStr3','IsoSiz1r','IsoSiz1c','IsoSiz2r','IsoSiz2c','IsoSiz3r','IsoSiz3c'};
           VarType = {'duration','double','double','double','double',...
               'double','double','double','double','double','double','double'...
               ,'double','double','string','string','cell','cell','cell','cell'...
               ,'cell','string','string','string','double','double','double','double','double','double'};

           tree.Data = table('Size',[dataLength,numel(VarName)],'VariableTypes',VarType,'VariableNames',VarName);
           
           if numel(StartConfig)<size(tree.Data,2) %|| numel(size(StartConfig.IsomorphismMatrices1))<3
              try
                  StartConfigMat = StartConfig.ConfigMat{:};
                  Type = StartConfig.Type;
              catch
                  StartConfigMat = StartConfig.Var17{:};
                  Type = StartConfig.Var4;
              end
              ConfigFullType = GetFullType(StartConfigMat,Type);
               [StartConfigIsomorphism, StartConfigIsomorphismStr,IsomorpSizes] = CreatIsomorphismMetrices(StartConfigMat,ConfigFullType,[],"ZoneMatrix",P.ZoneMatrix);

                   StartConfig = [StartConfig(1,1:end-1), table(StartConfigIsomorphism(1)...
                       ,StartConfigIsomorphism(2),StartConfigIsomorphism(3),...
                       StartConfigIsomorphismStr(1),StartConfigIsomorphismStr(2),StartConfigIsomorphismStr(3),IsomorpSizes(1,1),IsomorpSizes(1,2),IsomorpSizes(2,1),IsomorpSizes(2,2),IsomorpSizes(3,1),IsomorpSizes(3,2),...
                       'VariableNames',{'IsomorphismMatrices1','IsomorphismMatrices2'...
                       ,'IsomorphismMatrices3','IsomorphismStr1','IsomorphismStr2','IsomorphismStr3','IsoSiz1r','IsoSiz1c','IsoSiz2r','IsoSiz2c','IsoSiz3r','IsoSiz3c'})];


           end


           tree.Data(1,:) = StartConfig; %index,ConfigDec,parent,dir,step,agent*n
           
           if isfield(P,"EndConfig")
               tree.EndConfig = P.EndConfig;
               
                   WSEndConfig = WorkSpace(size(P.EndConfig.ConfigMat{:}),"RRT*");
    
                   tree.EndConfig_RotationMatrices = {WSEndConfig.R1, WSEndConfig.R2, WSEndConfig.R3};
                    
                   FullType = GetFullType(P.EndConfig.ConfigMat{:},P.EndConfig.Type);
               if isempty(P.EndConfig{1,"IsomorphismMatrices1"})
                    [tree.EndConfig_IsomorphismMetrices,tree.EndConfig_IsomorphismStr,tree.EndConfig_IsomorphismSizes] = CreatIsomorphismMetrices(P.EndConfig.ConfigMat{:},FullType,tree.EndConfig_RotationMatrices,"ZoneMatrix",P.ZoneMatrix);
               else
                    tree.EndConfig_IsomorphismMetrices = tree.EndConfig{1,["IsomorphismMatrices1","IsomorphismMatrices2","IsomorphismMatrices3"]};
                    tree.EndConfig_IsomorphismStr = tree.EndConfig{1,["IsomorphismStr1","IsomorphismStr2","IsomorphismStr3"]};
                    tree.EndConfig_IsomorphismSizes = reshape(tree.EndConfig{1,["IsoSiz1r","IsoSiz1c";"IsoSiz2r","IsoSiz2c";"IsoSiz3r","IsoSiz3c"]},3,2);
               end
           end

           
        end
        
        function tree = SetEndConfig(tree,NewConfig,ZoneMatrix)
            arguments
                tree
                NewConfig
                ZoneMatrix = true;
            end

            tree.EndConfig = NewConfig;
            WSEndConfig = WorkSpace(size(NewConfig.ConfigMat{:}),"RRT*");

           tree.EndConfig_RotationMatrices = {WSEndConfig.R1, WSEndConfig.R2, WSEndConfig.R3};
            
           FullType = GetFullType(NewConfig.ConfigMat{:},NewConfig.Type);
           [tree.EndConfig_IsomorphismMetrices,tree.EndConfig_IsomorphismStr,tree.EndConfig_IsomorphismSizes] = CreatIsomorphismMetrices(NewConfig.ConfigMat{:},FullType,tree.EndConfig_RotationMatrices,"ZoneMatrix",ZoneMatrix);
        end

        function tree = SaveTree(tree, varargin)
            mkdir("RRTtree\" + num2str(tree.N)+"N");
            t = datetime('now','TimeZone','local','Format','d_MMM_y_HH_mm_ss');
            FullFileName = fullfile('RRTtree',strcat(num2str(tree.N),'N'),tree.FolderName);
            Tree = struct("data",{tree.Data},"Config",{tree.Config}, "LastCompareIndex",tree.LastCompareIndex);
            
            
            Tree.Config.Mat(Tree.data(:,1) == 0) = [];
            Tree.Config.Str(Tree.data(:,1) == 0) = [];
            Tree.data(Tree.data(:,1) == 0,:) = [];
            if ~isempty(varargin)

                if exist(strcat(FullFileName,'.mat'), 'file')==2
                    delete(strcat(FullFileName,'.mat'));
                end

                save(strcat(FullFileName, string(t), '.mat'),"Tree");
            
            else
                save(strcat(FullFileName,'.mat'),"Tree");

            end
   
            fprintf('%s\n\n',strcat(num2str(tree.LastIndex)," config was save in time: ", string(t)));
        end
        
        function node = GetNode(tree, index)
            [~,I, Dec, parent, Level, Cost, Dir, Step, Agent]...
                = Get(tree, index,"index","Dec","parent" ...
                ,"Level","Cost","Dir","Step","Agent");
            node.Index = I;
            node.ConfigDec.Dec = Dec;
            node.parent = parent;
            node.Config = tree.Config(index);
            node.Level = Level;
            node.Cost = Cost;
            node.Movment.dir = Dir;
            node.Movment.step = Step;
            node.Movment.agent = Agent;
            node.Movment.agent(node.Movment.agent == 0) = [];
        end

        function lastIndex = ConfigNum(tree)
            lastIndex = tree.LastIndex;
        end
        
        function [tree, flag, ConfigIndex] = UpdateTree(tree, Parent, Config, Movment, Level, Cost, CostToTarget,P)
            
            arguments
                tree
                Parent
                Config
                Movment
                Level
                Cost
                CostToTarget
                P.ZoneMatrix = true;
            end
            
            flag = [];
            
            ConfigIndex = FindConfig(tree, Config.Str, Config.Row, Config.Col);

            if isempty(ConfigIndex)
                ConfigIndex = 0;
            end
            if (~ConfigIndex)
                
                tree.LastIndex = tree.LastIndex + 1;
                ConfigIndex = tree.LastIndex;
            else
                
                if ~CompereNode(tree, ConfigIndex, Level, Cost)
                    return
                end
            end

            ParentRow = tree.Data.ConfigRow(Parent);
            ParentCol = tree.Data.ConfigCol(Parent);
            ParentStr = tree.Data.ConfigStr(Parent);
            ParentMat = tree.Data.ConfigMat(Parent);
            
           

            try
                if numel(ConfigIndex)>1
                    ConfigIndex = find(ConfigIndex,1);
                end
                NodeTime = datetime-tree.StartTime + tree.AddDuration;
                if isempty(NodeTime)
                    NodeTime = duration(0,0,0);
                end
                tree.LastNodeTime = NodeTime;
                
                %%
%                 Config = Node2ConfigStruct(Path(12,:))
%                 Config.CompleteType = GetFullType(Config.Status,Config.Type)
                [IsomorphismMetrices, IsomorphismStr,IsomorpSizes] = CreatIsomorphismMetrices(logical(Config.Status),Config.CompleteType,[],"ZoneMatrix",P.ZoneMatrix);
                %%
                tree.Data(ConfigIndex,:) = table(NodeTime,ConfigIndex,Parent,...
                    Config.Type,Level,Cost,Movment.dir,Movment.step,Config.Row,...
                    Config.Col,ParentRow,ParentCol,1,CostToTarget,string(Config.Str),...
                    ParentStr,{Config.Status},{ParentMat}, ...
                    IsomorphismMetrices(1),IsomorphismMetrices(2),IsomorphismMetrices(3)...
                    ,IsomorphismStr(1),IsomorphismStr(2),IsomorphismStr(3)...
                    ,IsomorpSizes(1,1),IsomorpSizes(1,2),IsomorpSizes(2,1)...
                    ,IsomorpSizes(2,2),IsomorpSizes(3,1),IsomorpSizes(3,2));
                
%                 [parentExist, ParentLoc] = ParentExist(ConfigIndex,Parent,tree);
% %                 disp(OK)
%                 if ~parentExist
%                     disp(parentExist)
%                     ParentLoc = ree;
%                 end
            catch ME_UpdateTree
                ME_UpdateTree
            end
        end
        
        function [tree, ConfigIndex, flag] = UpdateTreePC(tree, data, config)

            Movment.dir = data(tree.DataIndex.Dir);
            Movment.step = data(tree.DataIndex.Step);
            Movment.Agent = sum(config{1}==2,"all");
            [~, ParentCost, ParentLevel] = Get(tree,data(tree.DataIndex.Parent),"Cost","Level");
            [Level, Cost] = CostFunction(Movment, ParentCost, ParentLevel);
            
            flag = [];
            Status.Status = config{1};
            ConfigIndex = FindConfig(tree, data(tree.DataIndex.Dec), Status);
            
            
            switch numel(ConfigIndex)
                case 0
                    tree.LastIndex = tree.LastIndex + 1;
                    ConfigIndex = tree.LastIndex;
                    
                case 1
                    if ~CompereNode(tree, ConfigIndex, Level, Cost)
                        return
                    end
                otherwise
                   fprintf("ConfigTarget.Dec problem," + ...
                        " Tree.m, UpdateTree function ");
                    pause;
            end
            
            tree = Set(tree, ConfigIndex       , ...
                        "Index" , ConfigIndex  , ...
                        "Parent", data(tree.DataIndex.Parent)       , ...
                        "Config", config{1}, ...
                        "Dec"   , data(tree.DataIndex.Dec)   , ...
                        "Type"  , data(tree.DataIndex.Type)  , ...
                        "Dir"   , data(tree.DataIndex.Dir)  , ...
                        "Step"  , data(tree.DataIndex.Step) , ...
                        "Level" , Level        , ...
                        "Cost"  , Cost);
%             [data, Config] = SetDataForTree(Parent, Config, Movment, Level, Cost);
%             tree.Data(ConfigIndex,1:length(data)) = data;
%             tree.Config{Config} = Config;
            [tree, flag] = SaveRoutine(tree);
            if ~isempty(flag)
                return
            end
            flag = WayIsFound(tree);
        end
        
        function [MainTree, ConfigIndex, flag] = UpdateTreePCSerched(MainTree, data, config, LocInMainTree, SerchStartFrom)
            flag = [];
            if LocInMainTree
                ConfigIndex = LocInMainTree;
                if ~CompereNode(MainTree, LocInMainTree, data(MainTree.DataIndex.Level), data(MainTree.DataIndex.Cost))
                    return
                end
                MainTree.Data(LocInMainTree,1:end-1) = data(1:end-1);
                MainTree.Data(LocInMainTree,end) = MainTree.Data(LocInMainTree,end) + data(end);
                MainTree.Config.Str(LocInMainTree) = config.Str;
                MainTree.Config.Mat{LocInMainTree} = config.Mat;
            else
                Movment.dir = data(MainTree.DataIndex.Dir);
                Movment.step = data(MainTree.DataIndex.Step);
                config.Type = data(MainTree.DataIndex.Type);
                config.Status = config.Mat;
                [MainTree, flag, ConfigIndex] = UpdateTree(MainTree, ...
                    data(MainTree.DataIndex.Parent), ...
                    config, ...
                    Movment, ...
                    data(MainTree.DataIndex.Level), ...
                    data(MainTree.DataIndex.Cost), ...
                    [], ...
                    SerchStartFrom);
            end
        end
        
        function SaveTree2Files(tree)
            TreeSize = size(tree.Data,1);
            Folder = tree.FolderName;
            save(fullfile(Folder,"AllTree.mat"),"tree");
            try
                ds = fileDatastore(Folder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
            catch e
                if contains(e.identifier,"emptyFolderNoSuggestion")
                    DeleteRow = (tree.Data{:,"ConfigRow"}==0);
                    tree.Data(DeleteRow,:) = [];

                    TreeSize = size(tree.Data,1);
                    Folder = tree.FolderName;
                    save(fullfile(Folder,"AllTree.mat"),"tree");

                    FileData = tree.Data;
                    ConfigSize = tree.Data{1,["ConfigRow","ConfigCol"]};
                    FileName = "size_"+string(ConfigSize(1))+"_"+ string(ConfigSize(2));
                    SaveFile(fullfile(Folder,FileName),FileData);
                    ds = fileDatastore(Folder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
                end
            end
            TreeName = extractAfter(Folder,"N\");
            DeleteRow = (tree.Data{:,"ConfigRow"}==0);
            tree.Data(DeleteRow,:) = [];

            TreeSize1 = size(tree.Data,1);
            Folder = tree.FolderName;
            save(fullfile(Folder,"AllTree.mat"),"tree");

%             [~,UniqueLoc] = unique(tree.Data(:,["ConfigRow","ConfigCol","ConfigStr","Type"]));
%             tree.Data = tree.Data(UniqueLoc,:);
            StartDataSize = size(tree.Data,1);
            while ~isempty(tree.Data)

                ConfigSize = tree.Data{1,["ConfigRow","ConfigCol"]};
                FileName = "size_"+string(ConfigSize(1))+"_"+ string(ConfigSize(2));

                ConfigsLocInTree = tree.Data{:,["ConfigRow","ConfigCol"]}==ConfigSize;
                ConfigsLocInTree = ConfigsLocInTree(:,1) & ConfigsLocInTree(:,2);

                data = tree.Data(ConfigsLocInTree,:);
                tree.Data(ConfigsLocInTree,:) = [];
                
                
                FileExist = contains(ds.Files,FileName);
                if ~any(FileExist)
                    
                    FileData = data;
                    
                    NewFileName = SaveFile(fullfile(Folder,FileName),FileData);
                    SizeFile = size(FileData,1);
                    load(NewFileName,"FileData");
                    if SizeFile ~=size(FileData,1)
                        d=ffr;
                    end

                    ds.Files{end+1} = char(NewFileName);

                else
                    File = partition(ds,'Files',ds.Files{FileExist});
                    FileData = readall(File);
%                     Compare = @(str) CompareStrs(str, ConfigSize, FileData.ConfigStr, ConfigSize);
%                     ConfigLocInFile = arrayfun(Compare,data{:,'ConfigStr'});
                    [ExistConfig,ConfigLocInFile] = ismember(FileData(:,["ConfigStr","ConfigRow","ConfigCol","Type"]),data(:,["ConfigStr","ConfigRow","ConfigCol","Type"]));
                    SameConfigLoc = ConfigLocInFile(ConfigLocInFile>0);
                    
%                     if ~isempty(ConfigsInOtherFile)
%                         ConfigsInOtherFile = UpdatConfigCost(FileData, ConfigSize, ConfigsInOtherFile);
%                     end

                    if any(ExistConfig)
                        doubledConfig = data(SameConfigLoc,:);
                        CompareCost = any(doubledConfig{:,["Cost","Level"]} < FileData{ExistConfig,["Cost","Level"]},2);
                        if any(CompareCost)
                            ExistConfigLoc = find(ExistConfig);
                            try
                                FileData(ExistConfigLoc(CompareCost),:) = doubledConfig(CompareCost,:);
                            catch
                                % for table with small var, without
                                % isomorphism
                                FileData(ExistConfigLoc(CompareCost),:) = doubledConfig(CompareCost,1:size(FileData,2));
                            end
                            FileData{ExistConfigLoc(CompareCost),"Index"} = SameConfigLoc(CompareCost);
                        end
                    else
                        CompareCost = [];
                    end
                    AddedConfigIndex = unique(SameConfigLoc);
                    NotAddedConfigIndex = setdiff(1:size(data,1),AddedConfigIndex);
                    NumOfNewConfig = numel(NotAddedConfigIndex);
                    
                   
                    data{NotAddedConfigIndex,"Index"} = (size(FileData,1)+(1:NumOfNewConfig))';
                    
                    try
                        FileData(end+(1:NumOfNewConfig),:) = data(NotAddedConfigIndex,:);
                    catch
                        FileData(end+(1:NumOfNewConfig),:) = data(NotAddedConfigIndex,1:size(FileData,2));
                    end
                        
                end
                    [~,UniqueNodeIdx] = unique(FileData(:,["Type","ConfigRow","ConfigCol","ConfigStr"]));
                    SaveInfoFile(Folder,FileName,FileData(sort(UniqueNodeIdx),:));
                    
                    NewFileName =SaveFile(fullfile(Folder,FileName),FileData);
                    SizeFile = size(FileData,1);
                    load(NewFileName,"FileData");
                    if SizeFile ~=size(FileData,1)
                        d=ffr;
                    end
%                     send(TaskData{1},{TreeName,"Save",StartDataSize-size(tree.Data,1),StartDataSize});
%                     send(TaskData{1},{TaskData{2},TreeName,"Save",StartDataSize-size(tree.Data,1),StartDataSize,[]});
                
            end
%             ds.Files(~contains(ds.Files,"size")) = [];
%             reset(ds);
%             AllData = readall(ds);
%             if size(AllData,1)~=TreeSize1
%                 d = TTree;
%             end
        end 
            
        

        function tree = LoadTree(tree, FileName)
            load(FileName,"Tree");
            tree = Set(tree,tree.LastIndex,"Tree",Tree);
           
            tree.LastIndex = sum(tree.Data(:,1)~=0);
        end
        

    end


end