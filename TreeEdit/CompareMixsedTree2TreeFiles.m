function [Connect, ConnectedNode,MinTime] = CompareMixsedTree2TreeFiles(Data,ds)
ConnectedNode = [];
Connect = true;

FilesSize = unique(Data{:,["ConfigRow","ConfigCol"]},'row');
FilesSize(FilesSize(:,1)==0,:)=[];

for ii = 1:size(FilesSize,1)
    
    FileNames = contains(ds.Files,join(["size",FilesSize(ii,1),FilesSize(ii,2)],"_"));
    
    Files = subset(ds,FileNames);
    if isempty(Files.Files)
        continue
    end
    FileData = readall(Files);
   StrLoc = Data.ConfigRow == FilesSize(ii,1) & Data.ConfigCol == FilesSize(ii,2);
    [FileConfigLoc, DataConfigLoc] = ismember(FileData.ConfigStr,Data.ConfigStr(StrLoc));
    FilesConnectedNode = FileData(FileConfigLoc,:);
    TreeConnectedNode = Data(StrLoc,:);
    TreeConnectedNode = TreeConnectedNode(DataConfigLoc(DataConfigLoc>0),:);

    TreeConnectedNode.time = max(FilesConnectedNode.time,TreeConnectedNode.time);
    ConnectedNode = [ConnectedNode; TreeConnectedNode];
    
end 

if isempty(ConnectedNode)
    Connect = false;
    return
end

[MinTime,MinNodeLoc] = min(ConnectedNode.time);
ConnectedNode = ConnectedNode(MinNodeLoc(1),:);

end
