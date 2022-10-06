function ScanTree(Folder,InitConfig)
ds = fileDatastore(Folder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true) ;
TallTree = tall(ds);

if InitConfig.Parent == 0
    cost = 0;
    level = 0;
else
    cost = InitConfig.Cost;
    level = InitConfig.Level;
end
