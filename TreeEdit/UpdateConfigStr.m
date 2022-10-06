function UpdateConfigStr(Folders)
for jj=1:numel(Folders)
ds = fileDatastore(Folders(jj),"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
TreeFile = contains(ds.Files,"size");
treeDs = subset(ds,TreeFile);

    for ii = 1:size(treeDs.Files)
        FileData = read(treeDs);
        for Node = 1:size(FileData,1)

            Str = NewConfigStr(FileData.ConfigMat{Node},Type);
        end
        
        fprintf("file num %1.0f tree num %1.0f\n",ii,jj);
        
        save(treeDs.Files{ii},"FileData");
    
    end

end
end
