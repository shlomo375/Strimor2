function TreeFolder = filterTreeFolder(TreeFolder,AllResultFolder)
ds = fileDatastore(AllResultFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);

Solution = replace(ds.Files,"-","\");
Solution = string(extractBetween(Solution,"Results\",".mat"));

Folder = extractAfter(TreeFolder,"Results\");

Loc = ismember(Folder,Solution);
TreeFolder(Loc) = [];
end
