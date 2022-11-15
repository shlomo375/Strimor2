function [LastTime,Size] = TreeLastTimeAndSize(ds)
LastTime = duration(0,0,0);
Size = 0;
TreeFileLoc = contains(ds.Files,"size");
FileLoc = find(TreeFileLoc);
for Loc = 1:numel(FileLoc)
    File = subset(ds,FileLoc(Loc));
    try
    data = read(File);
    
    Size = Size + size(data,1);
    
    LastTime = max([LastTime;data.time(:)]);
    catch e
        e
    end
end

end