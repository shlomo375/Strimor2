function NumConfig = ComputeTreeSize(Folder)
NumConfig = zeros(1,numel(Folder));
for ii = 1:numel(Folder)
    ds = fileDatastore(Folder(ii),"IncludeSubfolders",false,"ReadFcn" ...
        ,@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    TreeFile = contains(ds.Files,"size");
    Ds = subset(ds,TreeFile);
    T = tall(Ds);
    NumConfig(ii) = gather(size(T,1));
end


end
