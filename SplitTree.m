function SplitTree(FolderFile, TreeIndex)
    load(FolderFile,"Folders");
    NewFolder = split(Folders(TreeIndex),"_");
    NewFolder(2) = string(double(NewFolder(2))+1);
    NewFolder = join(NewFolder,"_");
    
    mkdir(NewFolder);
    
    ds = fileDatastore(Folders(TreeIndex),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    ds.Files(~contains(ds.Files,"size")) = [];
    Tree = tall(ds);
    
    MaxValue = max(Tree{:,"Cost2Target"});
    Optional = gather(Tree(Tree{:,"Cost2Target"}==MaxValue,:));
    
    FileData = Optional(randi(size(Optional,1),1),:);
    
    ConfigSize = FileData{1,["ConfigRow","ConfigCol"]};
    FileName = "size_"+string(ConfigSize(1))+"_"+ string(ConfigSize(2)+".mat"); 
    save(fullfile(NewFolder,FileName),'FileData');
    
    copyfile(fullfile(Folders(TreeIndex),"Target.mat"),NewFolder);
    info = {extractBefore(FileName,".mat"),1,1};
    save(fullfile(NewFolder,"Info.mat"),"info");
    
    
    Folders(TreeIndex) = NewFolder;
    save(FolderFile,"Folders");
end