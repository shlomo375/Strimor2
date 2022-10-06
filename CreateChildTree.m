function TreeName = CreateChildTree(Folder,N)


load(fullfile(Folder(1),"Target.mat"),"TargetConfig");
ds = fileDatastore(Folder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
ds.Files(~contains(ds.Files,"size"))=[];

% while true
    FileNum = randi(numel(ds.Files),1);
    load(string(ds.Files(FileNum)),"FileData");
    
    ConfigNum = randi(size(FileData,1),1);
    Config = FileData(ConfigNum,:);
    TreeName = replace(string(datetime),[":","-"],"_");
    TreeName = replace(TreeName," ","__");
%     if IsTreeConnected()

DirName = "MultyTree";
TreeName = fullfile(extractBefore(Folder(1),"\tree"),"tree_"+TreeName);
mkdir(TreeName);
files = dir(TreeName);

if sum([files.isdir])<=2
    tree = TreeClass(TreeName,N, 1e5, Config);
    StartConfig = Config;
    SaveTree2Files(tree);
    save(fullfile(TreeName,"Start.mat"),"StartConfig");
    
    config = TargetConfig;
    StartConfig = config;
    tree = TreeClass(TreeName, N, 1e5, StartConfig);
    TargetConfig = tree.Data(1,:);
    save(fullfile(TreeName,"Target.mat"),"TargetConfig");
end
end
