function UpdateCost2TargetAllTree(Folders)
for jj=1:numel(Folders)
ds = fileDatastore(Folders(jj),"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
TreeFile = contains(ds.Files,"size");
treeDs = subset(ds,TreeFile);
EndConfig = struct2cell(load(fullfile(Folders(jj),"Target.mat")));
C2T = @(Mat,Type)Cost2Target(Mat{:},Type,EndConfig{1}.ConfigMat{:},EndConfig{1}.Type);
k = 1:size(treeDs.Files);
for ii = k
    FileData = read(treeDs);
    try
        FileData.Cost2target = [];
    end
    fprintf("file num %1.0f tree num %1.0f\n",ii,jj);
    FileData.Cost2Target = arrayfun(C2T,FileData.ConfigMat,FileData.Type,'UniformOutput',true);
    save(treeDs.Files{ii},"FileData");

end

end
end
