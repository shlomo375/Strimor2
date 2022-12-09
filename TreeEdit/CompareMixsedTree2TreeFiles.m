function [Connect, ConnectedNode,MinTime] = CompareMixsedTree2TreeFiles(TreeData1,TreeData2)
ConnectedNode = [];
Connect = true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% corupt
FilesSize = unique(TreeData1{:,["ConfigRow","ConfigCol"]},'row');
FilesSize(FilesSize(:,1)==0,:)=[];

for ii = 1:size(FilesSize,1)
    
    FileNames = contains(TreeData2.Files,join(["size",FilesSize(ii,1),FilesSize(ii,2)],"_"));
    
    Files = subset(TreeData2,FileNames);
    if isempty(Files.Files)
        continue
    end
    FileData = readall(Files);
    StrLoc = TreeData1.ConfigRow == FilesSize(ii,1) & TreeData1.ConfigCol == FilesSize(ii,2);
    [FileConfigLoc, DataConfigLoc] = ismember(FileData.ConfigStr,TreeData1.ConfigStr(StrLoc));
    FilesConnectedNode = FileData(FileConfigLoc,:);
    TreeConnectedNode = TreeData1(StrLoc,:);
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
