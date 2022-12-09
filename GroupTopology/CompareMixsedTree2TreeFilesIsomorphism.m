function [Connect, ConnectedNode1,ConnectedNode2,MinTime] = CompareMixsedTree2TreeFilesIsomorphism(TreeData1,TreeData2,IsoAxises)
ConnectedNode1 = [];
ConnectedNode2 = [];
Connect = false;
TreeData1(TreeData1.ConfigRow == 0,:) = [];
TreeData2(TreeData2.ConfigRow == 0,:) = [];

Lable = ["IsomorphismStr1","IsoSiz1r","IsoSiz1c";"IsomorphismStr2","IsoSiz2r","IsoSiz2c";"IsomorphismStr3","IsoSiz3r","IsoSiz3c"];
MatrixLable = ["IsomorphismMatrices1","IsomorphismMatrices2","IsomorphismMatrices3"];

for Axis = 1:IsoAxises
    [FileConfigLoc, DataConfigLoc] = ismember(TreeData2(:,Lable(Axis,:)),TreeData1(:,Lable(Axis,:)));


    if any(FileConfigLoc)
        Tree2ConnectedNode = TreeData2(FileConfigLoc,:);
        Tree1ConnectedNode = TreeData1(DataConfigLoc(DataConfigLoc>0),:);
        %
        for idx = 1:size(Tree2ConnectedNode,1)
            if CompareZoneInfMatrix(Tree2ConnectedNode{idx,MatrixLable(Axis)}{1},Tree1ConnectedNode{idx,MatrixLable(Axis)}{1})
                Tree1ConnectedNode.time = max(Tree2ConnectedNode.time,Tree1ConnectedNode.time);
                ConnectedNode1 = [ConnectedNode1; Tree1ConnectedNode(idx,:)];
                ConnectedNode2 = [ConnectedNode2; Tree2ConnectedNode(idx,:)];
            end
        end
        %
        
    end

end
if isempty(ConnectedNode1)
    Connect = false;
    return
end

[MinTime,MinNodeLoc] = min(ConnectedNode1.time);
ConnectedNode2(ConnectedNode1.time>MinTime,:) = [];
ConnectedNode1(ConnectedNode1.time>MinTime,:) = [];

[MinLevel,MinLevelLoc] = min(ConnectedNode1.Level);
ConnectedNode2(ConnectedNode1.Level>MinLevel,:) = [];
ConnectedNode1(ConnectedNode1.Level>MinLevel,:) = [];

Connect = true;

end
