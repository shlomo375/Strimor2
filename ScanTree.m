function ScanTree(Folder,InitConfig,mode)
Ds = fileDatastore(Folder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true) ;
TreeFile = contains(Ds.Files,"size");
ds = subset(Ds,TreeFile);
    
NumConfigScanned = Scanner(ds,InitConfig,0,mode)
end