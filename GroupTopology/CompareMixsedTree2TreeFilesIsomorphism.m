function [Connect, ConnectedNode,MinTime] = CompareMixsedTree2TreeFilesIsomorphism(Data,ds,IsoAxises)
ConnectedNode = [];
Connect = true;
Data(Data.ConfigRow == 0,:) = [];

FileNames = contains(ds.Files,"size");   
Files = subset(ds,FileNames);

FileData = readall(Files);
Lable = ["IsomorphismStr1","IsoSiz1r","IsoSiz1c";"IsomorphismStr2","IsoSiz2r","IsoSiz2c";"IsomorphismStr3","IsoSiz3r","IsoSiz3c"];
MatrixLable = ["IsomorphismMatrices1","IsomorphismMatrices2","IsomorphismMatrices3"];

for Axis = 1:IsoAxises
    [FileConfigLoc, DataConfigLoc] = ismember(FileData(:,Lable(Axis,:)),Data(:,Lable(Axis,:)));


if any(FileConfigLoc)
    FilesConnectedNode = FileData(FileConfigLoc,:);
    TreeConnectedNode = Data(DataConfigLoc(DataConfigLoc>0),:);
    %
    for idx = 1:size(FilesConnectedNode,1)
        if CompareZoneInfMatrix(FilesConnectedNode{idx,MatrixLable(Axis)}{1},TreeConnectedNode{idx,MatrixLable(Axis)}{1});
            TreeConnectedNode.time = max(FilesConnectedNode.time,TreeConnectedNode.time);
            ConnectedNode = [ConnectedNode; TreeConnectedNode];
        end
    end
    %
    
end

end
if isempty(ConnectedNode)
    Connect = false;
    return
end

[MinTime,MinNodeLoc] = min(ConnectedNode.time);
ConnectedNode(ConnectedNode.time>MinTime,:) = [];

[MinLevel,MinLevelLoc] = min(ConnectedNode.Level);
ConnectedNode = ConnectedNode(MinLevelLoc,:);



end
