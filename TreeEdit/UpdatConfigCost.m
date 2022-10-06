function ConfigsInOtherFile = UpdatConfigCost(FileData, FileSizes, ConfigList)

LocConfigInFile = ConfigList(:,1)==FileSizes(1) & ConfigList(:,2)==FileSizes(2);
ConfigsInOtherFile = ConfigList(~LocConfigInFile);

while any(LocConfigInFile)
    ii = find(LocConfigInFile,1);
    ConfigInfo = ConfigList(ii,:);
    ConfigList(ii,:) = [];
    
    [ConfigList, ConfigInOtherFile] = UpdatFileCost(FileData,ConfigInfo,ConfigList);
    ConfigsInOtherFile = [ConfigsInOtherFile; ConfigInOtherFile];
    LocConfigInFile = ConfigList(:,1)==FileSizes(1) & ConfigList(:,2)==FileSizes(2);
end
ConfigsInOtherFile = [ConfigsInOtherFile; ConfigList];

end

